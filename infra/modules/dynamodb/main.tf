# Módulo de Terraform para crear y configurar una tabla DynamoDB
# Este módulo crea una tabla DynamoDB para almacenar órdenes con soporte
# para operaciones CRUD, índices secundarios globales y streams para
# captura de cambios en tiempo real.

resource "aws_dynamodb_table" "orders_table" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  range_key      = var.range_key

  # Configuración de capacidad provisionada si aplica
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = try(global_secondary_index.value.range_key, null)
      projection_type = global_secondary_index.value.projection_type
      read_capacity   = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.read_capacity : null
      write_capacity  = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.write_capacity : null
    }
  }

  # Habilitar stream si está configurado - argumentos directos, no bloque
  stream_enabled   = var.enable_stream
  stream_view_type = var.enable_stream ? var.stream_view_type : null

  # Configuración de TTL si está especificado
  dynamic "ttl" {
    for_each = var.ttl_attribute_name != null ? [var.ttl_attribute_name] : []
    content {
      attribute_name = var.ttl_attribute_name
      enabled        = true
    }
  }

  # Configuración de réplicas para modo PAY_PER_REQUEST (Global Tables)
  # Las réplicas requieren region_name para cada región adicional
  dynamic "replica" {
    for_each = var.billing_mode == "PAY_PER_REQUEST" ? ["us-east-1"] : []
    content {
      region_name = "us-east-1"
    }
  }

  # Etiquetas estándar para todos los recursos
  tags = var.tags

  # Configuración de cifrado del lado del servidor
  server_side_encryption {
    enabled     = true
    kms_key_arn = "alias/aws/dynamodb"
  }

  # Configuración de punto de recuperación
  point_in_time_recovery {
    enabled = true
  }

  # Timeouts para operaciones de creación, actualización y eliminación
  timeouts {
    create = "10m"
    update = "60m"
    delete = "60m"
  }
}

# Recurso para configurar auto scaling de la tabla
resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  count = var.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = var.read_capacity * 10
  min_capacity       = var.read_capacity
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  count = var.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = var.write_capacity * 10
  min_capacity       = var.write_capacity
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

# Política de auto scaling para lectura
resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  count = var.billing_mode == "PROVISIONED" ? 1 : 0
  name             = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target[0].resource_id}"
  policy_type      = "TargetTrackingScaling"
  resource_id      = aws_appautoscaling_target.dynamodb_table_read_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target[0].scalable_dimension
  service_namespace = aws_appautoscaling_target.dynamodb_table_read_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70.0
  }
}

# Política de auto scaling para escritura
resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  count = var.billing_mode == "PROVISIONED" ? 1 : 0
  name             = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target[0].resource_id}"
  policy_type      = "TargetTrackingScaling"
  resource_id      = aws_appautoscaling_target.dynamodb_table_write_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target[0].scalable_dimension
  service_namespace = aws_appautoscaling_target.dynamodb_table_write_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70.0
  }
}

# Recurso para configurar auto scaling en índices secundarios globales
resource "aws_appautoscaling_target" "dynamodb_gsi_read_target" {
  count = var.billing_mode == "PROVISIONED" && length(var.global_secondary_indexes) > 0 ? length(var.global_secondary_indexes) : 0
  max_capacity       = var.global_secondary_indexes[count.index].read_capacity * 10
  min_capacity       = var.global_secondary_indexes[count.index].read_capacity
  resource_id        = "table/${var.table_name}/index/${var.global_secondary_indexes[count.index].name}"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "dynamodb_gsi_write_target" {
  count = var.billing_mode == "PROVISIONED" && length(var.global_secondary_indexes) > 0 ? length(var.global_secondary_indexes) : 0
  max_capacity       = var.global_secondary_indexes[count.index].write_capacity * 10
  min_capacity       = var.global_secondary_indexes[count.index].write_capacity
  resource_id        = "table/${var.table_name}/index/${var.global_secondary_indexes[count.index].name}"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

# Políticas de auto scaling para GSI
resource "aws_appautoscaling_policy" "dynamodb_gsi_read_policy" {
  count = var.billing_mode == "PROVISIONED" && length(var.global_secondary_indexes) > 0 ? length(var.global_secondary_indexes) : 0
  name             = "DynamoDBGSIReadCapacityUtilization:${var.global_secondary_indexes[count.index].name}"
  policy_type      = "TargetTrackingScaling"
  resource_id      = aws_appautoscaling_target.dynamodb_gsi_read_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_gsi_read_target[count.index].scalable_dimension
  service_namespace = aws_appautoscaling_target.dynamodb_gsi_read_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_policy" "dynamodb_gsi_write_policy" {
  count = var.billing_mode == "PROVISIONED" && length(var.global_secondary_indexes) > 0 ? length(var.global_secondary_indexes) : 0
  name             = "DynamoDBGSIWriteCapacityUtilization:${var.global_secondary_indexes[count.index].name}"
  policy_type      = "TargetTrackingScaling"
  resource_id      = aws_appautoscaling_target.dynamodb_gsi_write_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_gsi_write_target[count.index].scalable_dimension
  service_namespace = aws_appautoscaling_target.dynamodb_gsi_write_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70.0
  }
}

# Recurso para configurar backup bajo demanda - recurso correcto es aws_dynamodb_backup
resource "aws_dynamodb_backup" "orders_backup" {
  count = false ? 1 : 0
  table_name = aws_dynamodb_table.orders_table.name
  backup_name = "${var.table_name}-backup-${timestamp()}"
}

# Recurso para configurar exportación de tabla a S3
resource "aws_dynamodb_table_export" "orders_export" {
  count = false ? 1 : 0
  table_arn      = aws_dynamodb_table.orders_table.arn
  export_format  = "DYNAMODB_JSON"
  s3_bucket      = "dynamodb-exports-bucket"
  export_name    = "${var.table_name}-export-${formatdate("YYYYMMDD", timestamp())}"
}