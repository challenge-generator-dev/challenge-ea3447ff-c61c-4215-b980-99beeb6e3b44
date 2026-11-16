# Variables específicas del entorno de desarrollo
# Estas variables personalizan la infraestructura para el ambiente de desarrollo
# y son cargadas automáticamente por Terraform al ejecutar plan o apply

# Configuración regional de AWS
aws_region = "us-east-1"

# Nombre del entorno para identificar recursos
environment = "dev"

# Nombre base para los recursos de la aplicación
# Se utiliza como prefijo para tablas, funciones, API Gateway, etc.
app_name = "orders-management"

# Configuración de la tabla DynamoDB para órdenes
# Modo de facturación: PAY_PER_REQUEST es ideal para desarrollo
# ya que no requiere capacidad provisionada y se adapta automáticamente
dynamodb_table_name = "orders-dev-table"
dynamodb_billing_mode = "PAY_PER_REQUEST"

# Habilitar stream para capturar cambios en la tabla
# Útil para desarrollo y debugging de eventos de tabla
dynamodb_enable_stream = true
dynamodb_stream_view_type = "NEW_AND_OLD_IMAGES"

# Configuración de capacidad para entornos de desarrollo
# Valores bajos para optimizar costos en desarrollo
dynamodb_read_capacity = 5
dynamodb_write_capacity = 5

# Configuración de índices secundarios globales
# El índice status-index permite consultas por estado de orden
# con ordenamiento por fecha de creación
dynamodb_gsi_read_capacity = 5
dynamodb_gsi_write_capacity = 5

# Configuración de API Gateway
# Nombre del API Gateway para el entorno de desarrollo
api_gateway_name = "orders-api-dev"
api_gateway_stage = "dev"

# Habilitar logging detallado en API Gateway para desarrollo
# Esto facilita la depuración de requests
api_gateway_enable_logging = true

# Configuración de tags para todos los recursos
# Tags estándar que se aplican a todos los recursos creados
common_tags = {
  Environment = "dev"
  Application = "orders-management"
  ManagedBy   = "Terraform"
  Project     = "orders-management-system"
  CostCenter  = "engineering"
  Owner       = "platform-team"
}

# Habilitar características adicionales para desarrollo
enable_deletion_protection = false
enable_cross_region_replication = false

# Timeout para operaciones de Terraform
# Valor en minutos para el timeout de operaciones largas
terraform_timeout_minutes = 30