# Configuración principal del entorno de desarrollo
# Este archivo define los recursos de infraestructura necesarios
# para el entorno de desarrollo de la aplicación de gestión de órdenes

# ============================================
# MÓDULO DYNAMODB - Tabla de Órdenes
# ============================================

# Creación de la tabla DynamoDB para almacenar órdenes
# La tabla utiliza el modo de facturación bajo demanda (PAY_PER_REQUEST)
# que es ideal para entornos de desarrollo donde el tráfico es variable
# y no se quiere pagar por capacidad provisionada no utilizada

module "dynamodb_orders" {
  # Se referencia el módulo local de DynamoDB
  source = "../../modules/dynamodb"

  # Nombre de la tabla - usa el nombre del entorno para diferenciación
  table_name = var.dynamodb_table_name

  # Modo de facturación - PAY_PER_REQUEST para desarrollo
  billing_mode = var.dynamodb_billing_mode

  # Capacidad provisionada (solo aplica si billing_mode es PROVISIONED)
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity

  # Clave primaria: orderId como clave de partición
  hash_key = "orderId"

  # Clave de ordenamiento: createdAt para mantener orden cronológico
  range_key = "createdAt"

  # Definición de atributos de la tabla
  # Cada atributo debe declararse con su tipo (S=String, N=Number, B=Binary)
  attributes = [
    {
      name = "orderId"
      type = "S"
    },
    {
      name = "createdAt"
      type = "S"
    },
    {
      name = "status"
      type = "S"
    },
    {
      name = "customerId"
      type = "S"
    }
  ]

  # Índice secundario global para consultas por estado
  # Permite consultar todas las órdenes por su estado (PENDING, COMPLETED, CANCELLED)
  # con ordenamiento por fecha de creación
  global_secondary_indexes = [
    {
      name            = "status-created-index"
      hash_key        = "status"
      range_key       = "createdAt"
      projection_type = "ALL"
      read_capacity   = var.dynamodb_gsi_read_capacity
      write_capacity  = var.dynamodb_gsi_write_capacity
    }
  ]

  # Habilitar stream de DynamoDB para capturar cambios
  # Útil para arquitecturas basadas en eventos y sincronización
  enable_stream    = var.dynamodb_enable_stream
  stream_view_type = var.dynamodb_stream_view_type

  # TTL para limpieza automática de datos (opcional)
  # Descomenta si necesitas TTL automático para órdenes antiguas
  # ttl_attribute_name = "expiresAt"

  # Tags aplicados a todos los recursos del módulo
  tags = merge(
    var.common_tags,
    {
      Module = "dynamodb"
      Purpose = "orders-storage"
    }
  )
}

# ============================================
# CONFIGURACIÓN DE OUTPUTS LOCALES
# ============================================

# Outputs locales para facilitar referencias en otros archivos
# Proporciona acceso a los valores de los recursos creados

locals {
  # Nombre de la tabla DynamoDB creada
  orders_table_name = module.dynamodb_orders.table_name

  # ARN de la tabla DynamoDB para permisos IAM
  orders_table_arn = module.dynamodb_orders.table_arn

  # Nombre del índice secundario global
  orders_gsi_names = module.dynamodb_orders.global_secondary_index_names

  # Tags comunes para todos los recursos
  all_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Terraform   = "true"
    }
  )
}

# ============================================
# RECURSOS ADICIONALES DE DESARROLLO
# ============================================

# Resource: AWS S3 Bucket para logs (opcional en desarrollo)
# Descomenta si necesitas almacenamiento de logs persistente

resource "aws_s3_bucket" "logs" {
  count = var.enable_logs_bucket ? 1 : 0

  bucket = "${var.app_name}-${var.environment}-logs-${data.aws_caller_identity.current.account_id}"

  tags = local.all_tags
}

# Data: Obtener información de la cuenta actual
data "aws_caller_identity" "current" {}

# Data: Obtener la región actual de AWS
data "aws_region" "current" {}

# Output: Información del entorno
output "environment_info" {
  description = "Información del entorno de desarrollo"
  value = {
    environment       = var.environment
    aws_region        = data.aws_region.current.name
    account_id        = data.aws_caller_identity.current.account_id
    app_name          = var.app_name
    dynamodb_table    = local.orders_table_name
    dynamodb_arn      = local.orders_table_arn
    dynamodb_gsi      = local.orders_gsi_names
  }
}