# Módulo de API Gateway para la API de órdenes
# Este módulo crea un API Gateway REST para exponer los endpoints de gestión de órdenes
# Se integra directamente con DynamoDB usando AWS Service Integration

# ============================================
# API Gateway REST API
# ============================================

resource "aws_api_gateway_rest_api" "orders_api" {
  name        = var.api_name
  description = var.api_description
  endpoint_configuration {
    types = var.endpoint_types
  }
  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================
# Recurso raíz (/orders)
# ============================================

resource "aws_api_gateway_resource" "orders_root" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  parent_id   = aws_api_gateway_rest_api.orders_api.root_resource_id
  path_part   = "orders"
}

# ============================================
# Recurso para orden específica (/orders/{orderId})
# ============================================

resource "aws_api_gateway_resource" "order_by_id" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  parent_id   = aws_api_gateway_resource.orders_root.id
  path_part   = "{orderId}"
}

# ============================================
# Recurso para estado (/orders/{orderId}/status)
# ============================================

resource "aws_api_gateway_resource" "order_status" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  parent_id   = aws_api_gateway_resource.order_by_id.id
  path_part   = "status"
}

# ============================================
# Método GET para listar todas las órdenes
# ============================================

resource "aws_api_gateway_method" "get_orders" {
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  resource_id   = aws_api_gateway_resource.orders_root.id
  http_method   = "GET"
  authorization = var.authorization_type

  request_parameters = {
    "method.request.querystring.limit"  = false
    "method.request.querystring.next"   = false
  }
}

# ============================================
# Método POST para crear una orden
# ============================================

resource "aws_api_gateway_method" "create_order" {
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  resource_id   = aws_api_gateway_resource.orders_root.id
  http_method   = "POST"
  authorization = var.authorization_type

  request_models = {
    "application/json" = "OrderInput"
  }

  request_parameters = {}
}

# ============================================
# Método GET para obtener una orden específica
# ============================================

resource "aws_api_gateway_method" "get_order" {
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  resource_id   = aws_api_gateway_resource.order_by_id.id
  http_method   = "GET"
  authorization = var.authorization_type

  request_parameters = {
    "method.request.path.orderId" = true
  }
}

# ============================================
# Método PUT para actualizar una orden
# ============================================

resource "aws_api_gateway_method" "update_order" {
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  resource_id   = aws_api_gateway_resource.order_by_id.id
  http_method   = "PUT"
  authorization = var.authorization_type

  request_models = {
    "application/json" = "OrderInput"
  }

  request_parameters = {
    "method.request.path.orderId" = true
  }
}

# ============================================
# Método DELETE para eliminar una orden
# ============================================

resource "aws_api_gateway_method" "delete_order" {
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  resource_id   = aws_api_gateway_resource.order_by_id.id
  http_method   = "DELETE"
  authorization = var.authorization_type

  request_parameters = {
    "method.request.path.orderId" = true
  }
}

# ============================================
# Método PATCH para actualizar el estado
# ============================================

resource "aws_api_gateway_method" "update_order_status" {
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  resource_id   = aws_api_gateway_resource.order_status.id
  http_method   = "PATCH"
  authorization = var.authorization_type

  request_models = {
    "application/json" = "StatusUpdateInput"
  }

  request_parameters = {
    "method.request.path.orderId" = true
  }
}

# ============================================
# Integración GET /orders con DynamoDB
# ============================================

resource "aws_api_gateway_integration" "get_orders_integration" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.orders_root.id
  http_method = aws_api_gateway_method.get_orders.http_method

  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:dynamodb:action/Scan"
  integration_http_method = "POST"
  credentials             = var.lambda_execution_role_arn

  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${var.dynamodb_table_name}",
  "Limit": "$input.params('limit')"
}
EOF
  }

  response_parameters {
    method_response_header_mapping = {
      "Access-Control-Allow-Origin" = "'*'"
    }
  }
}

# ============================================
# Integración POST /orders con DynamoDB
# ============================================

resource "aws_api_gateway_integration" "create_order_integration" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.orders_root.id
  http_method = aws_api_gateway_method.create_order.http_method

  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:dynamodb:action/PutItem"
  integration_http_method = "POST"
  credentials             = var.lambda_execution_role_arn

  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${var.dynamodb_table_name}",
  "Item": {
    "orderId": {"S": "$input.json('$.orderId')"},
    "customerId": {"S": "$input.json('$.customerId')"},
    "items": {"S": "$input.json('$.items')"},
    "totalAmount": {"N": "$input.json('$.totalAmount')"},
    "status": {"S": "$input.json('$.status')"},
    "createdAt": {"S": "$input.json('$.createdAt')"},
    "updatedAt": {"S": "$input.json('$.updatedAt')"}
  }
}
EOF
  }
}

# ============================================
# Integración GET /orders/{orderId} con DynamoDB
# ============================================

resource "aws_api_gateway_integration" "get_order_integration" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.get_order.http_method

  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:dynamodb:action/GetItem"
  integration_http_method = "POST"
  credentials             = var.lambda_execution_role_arn

  request_parameters = {
    "integration.request.path.orderId" = "method.request.path.orderId"
  }

  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${var.dynamodb_table_name}",
  "Key": {
    "orderId": {"S": "$input.params('orderId')"}
  }
}
EOF
  }
}

# ============================================
# Integración PUT /orders/{orderId} con DynamoDB
# ============================================

resource "aws_api_gateway_integration" "update_order_integration" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.update_order.http_method

  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:dynamodb:action/PutItem"
  integration_http_method = "POST"
  credentials             = var.lambda_execution_role_arn

  request_parameters = {
    "integration.request.path.orderId" = "method.request.path.orderId"
  }

  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${var.dynamodb_table_name}",
  "Item": {
    "orderId": {"S": "$input.params('orderId')"},
    "customerId": {"S": "$input.json('$.customerId')"},
    "items": {"S": "$input.json('$.items')"},
    "totalAmount": {"N": "$input.json('$.totalAmount')"},
    "status": {"S": "$input.json('$.status')"},
    "createdAt": {"S": "$input.json('$.createdAt')"},
    "updatedAt": {"S": "$input.json('$.updatedAt')"}
  },
  "ConditionExpression": "attribute_exists(orderId)"
}
EOF
  }
}

# ============================================
# Integración DELETE /orders/{orderId} con DynamoDB
# ============================================

resource "aws_api_gateway_integration" "delete_order_integration" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.delete_order.http_method

  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:dynamodb:action/DeleteItem"
  integration_http_method = "POST"
  credentials             = var.lambda_execution_role_arn

  request_parameters = {
    "integration.request.path.orderId" = "method.request.path.orderId"
  }

  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${var.dynamodb_table_name}",
  "Key": {
    "orderId": {"S": "$input.params('orderId')"}
  }
}
EOF
  }
}

# ============================================
# Integración PATCH /orders/{orderId}/status con DynamoDB
# ============================================

resource "aws_api_gateway_integration" "update_status_integration" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_status.id
  http_method = aws_api_gateway_method.update_order_status.http_method

  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:dynamodb:action/UpdateItem"
  integration_http_method = "POST"
  credentials             = var.lambda_execution_role_arn

  request_parameters = {
    "integration.request.path.orderId" = "method.request.path.orderId"
  }

  request_templates = {
    "application/json" = <<EOF
{
  "TableName": "${var.dynamodb_table_name}",
  "Key": {
    "orderId": {"S": "$input.params('orderId')"}
  },
  "UpdateExpression": "SET #status = :status, updatedAt = :updatedAt",
  "ExpressionAttributeNames": {
    "#status": "status"
  },
  "ExpressionAttributeValues": {
    ":status": {"S": "$input.json('$.status')"},
    ":updatedAt": {"S": "$input.json('$.updatedAt')"}
  },
  "ConditionExpression": "attribute_exists(orderId)"
}
EOF
  }
}

# ============================================
# Respuestas de método para GET /orders
# ============================================

resource "aws_api_gateway_method_response" "get_orders_200" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.orders_root.id
  http_method = aws_api_gateway_method.get_orders.http_method
  status_code = "200"

  response_models = {
    "application/json" = "OrdersList"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# ============================================
# Respuestas de método para POST /orders
# ============================================

resource "aws_api_gateway_method_response" "create_order_201" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.orders_root.id
  http_method = aws_api_gateway_method.create_order.http_method
  status_code = "201"

  response_models = {
    "application/json" = "Order"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "create_order_400" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.orders_root.id
  http_method = aws_api_gateway_method.create_order.http_method
  status_code = "400"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# ============================================
# Respuestas de método para GET /orders/{orderId}
# ============================================

resource "aws_api_gateway_method_response" "get_order_200" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.get_order.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Order"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "get_order_404" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.get_order.http_method
  status_code = "404"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# ============================================
# Respuestas de método para PUT /orders/{orderId}
# ============================================

resource "aws_api_gateway_method_response" "update_order_200" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.update_order.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Order"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "update_order_400" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.update_order.http_method
  status_code = "400"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "update_order_404" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.update_order.http_method
  status_code = "404"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# ============================================
# Respuestas de método para DELETE /orders/{orderId}
# ============================================

resource "aws_api_gateway_method_response" "delete_order_200" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.delete_order.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "delete_order_404" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_method.delete_order.http_method
  status_code = "404"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# ============================================
# Respuestas de método para PATCH /orders/{orderId}/status
# ============================================

resource "aws_api_gateway_method_response" "update_status_200" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_status.id
  http_method = aws_api_gateway_method.update_order_status.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Order"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "update_status_400" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_status.id
  http_method = aws_api_gateway_method.update_order_status.http_method
  status_code = "400"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "update_status_404" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_status.id
  http_method = aws_api_gateway_method.update_order_status.http_method
  status_code = "404"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# ============================================
# Respuestas de integración
# ============================================

resource "aws_api_gateway_integration_response" "get_orders_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.orders_root.id
  http_method = aws_api_gateway_integration.get_orders_integration.http_method
  status_code = aws_api_gateway_method_response.get_orders_200.status_code

  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{
  "orders": $inputRoot.Items,
  "count": $inputRoot.Count,
  "scannedCount": $inputRoot.ScannedCount
}
EOF
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "create_order_integration_response_201" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.orders_root.id
  http_method = aws_api_gateway_integration.create_order_integration.http_method
  status_code = aws_api_gateway_method_response.create_order_201.status_code

  response_templates = {
    "application/json" = "$input.json('$.Attributes')"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "get_order_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_by_id.id
  http_method = aws_api_gateway_integration.get_order_integration.http_method
  status_code = aws_api_gateway_method_response.get_order_200.status_code

  response_templates = {
    "application/json" = "$input.json('$.Item')"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "update_status_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order_status.id
  http_method = aws_api_gateway_integration.update_status_integration.http_method
  status_code = aws_api_gateway_method_response.update_status_200.status_code

  response_templates = {
    "application/json" = "$input.json('$.Attributes')"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# ============================================
# Deployment del API Gateway
# ============================================

resource "aws_api_gateway_deployment" "orders_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.get_orders_integration,
    aws_api_gateway_integration.create_order_integration,
    aws_api_gateway_integration.get_order_integration,
    aws_api_gateway_integration.update_order_integration,
    aws_api_gateway_integration.delete_order_integration,
    aws_api_gateway_integration.update_status_integration,
  ]
}

# ============================================
# Stage del API Gateway
# ============================================

resource "aws_api_gateway_stage" "orders_api_stage" {
  deployment_id = aws_api_gateway_deployment.orders_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  stage_name    = var.stage_name

  access_log_settings {
    destination_arn = var.cloudwatch_log_group_arn
    format         = var.access_log_format
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================
# Usage Plan para rate limiting
# ============================================

resource "aws_api_gateway_usage_plan" "orders_usage_plan" {
  name = var.usage_plan_name

  api_stages {
    api_id = aws_api_gateway_rest_api.orders_api.id
    stage  = aws_api_gateway_stage.orders_api_stage.stage_name
  }

  quota_settings {
    limit  = var.quota_limit
    period = var.quota_period
  }

  throttle_settings {
    burst_limit = var.throttle_burst_limit
    rate_limit  = var.throttle_rate_limit
  }

  tags = var.tags
}

# ============================================
# API Key (opcional)
# ============================================

resource "aws_api_gateway_api_key" "orders_api_key" {
  count = var.enable_api_key ? 1 : 0
  name  = "${var.api_name}-api-key"

  tags = var.tags
}

resource "aws_api_gateway_usage_plan_key" "orders_usage_plan_key" {
  count = var.enable_api_key ? 1 : 0

  key_id        = aws_api_gateway_api_key.orders_api_key[0].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.orders_usage_plan.id
}