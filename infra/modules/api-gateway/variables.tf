variable "api_name" {
  type        = string
  description = "Nombre del API Gateway REST API"
  default     = "orders-api"
}

variable "api_description" {
  type        = string
  description = "Descripción del API Gateway"
  default     = "API para gestión de órdenes"
}

variable "endpoint_types" {
  type        = list(string)
  description = "Tipos de endpoint del API Gateway (EDGE, REGIONAL, PRIVATE)"
  default     = ["REGIONAL"]
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicados a todos los recursos del módulo"
  default     = {}
}

variable "authorization_type" {
  type        = string
  description = "Tipo de autorización para los métodos del API (NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLS)"
  default     = "AWS_IAM"
}

variable "region" {
  type        = string
  description = "Región de AWS donde se desplegará el API Gateway"
  default     = "us-east-1"
}

variable "lambda_execution_role_arn" {
  type        = string
  description = "ARN del rol de ejecución de Lambda para la integración"
  default     = ""
}

variable "dynamodb_table_name" {
  type        = string
  description = "Nombre de la tabla DynamoDB para integración"
  default     = "orders-table"
}

variable "stage_name" {
  type        = string
  description = "Nombre del stage de despliegue del API Gateway"
  default     = "prod"
}

variable "cloudwatch_log_group_arn" {
  type        = string
  description = "ARN del grupo de logs de CloudWatch para acceso logs"
  default     = ""
}

variable "access_log_format" {
  type        = string
  description = "Formato de logs de acceso del API Gateway"
  default     = "$context.requestId: $context.endpoint $context.httpMethod $context.status $context.responseLatency $context.requestTime"
}

variable "usage_plan_name" {
  type        = string
  description = "Nombre del plan de uso del API Gateway"
  default     = "orders-usage-plan"
}

variable "quota_limit" {
  type        = number
  description = "Límite de solicitudes por período en el plan de uso"
  default     = 10000
}

variable "quota_period" {
  type        = string
  description = "Período de cuota (DAY, WEEK, MONTH)"
  default     = "DAY"
}

variable "throttle_burst_limit" {
  type        = number
  description = "Límite de ráfaga para throttling"
  default     = 500
}

variable "throttle_rate_limit" {
  type        = number
  description = "Límite de tasa de solicitudes por segundo"
  default     = 100
}

variable "enable_api_key" {
  type        = bool
  description = "Habilitar generación de API key para el usage plan"
  default     = false
}