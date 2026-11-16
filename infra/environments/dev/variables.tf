# Variables para el entorno de desarrollo
# Este archivo define todas las variables necesarias para configurar
# la infraestructura del entorno de desarrollo de la aplicación

# ============================================
# VARIABLES DE CONFIGURACIÓN GENERAL
# ============================================

variable "aws_region" {
  description = "Región de AWS donde se crearán los recursos"
  type        = string
  default     = "us-east-1"

  # Validación de región válida
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[1-9]$", var.aws_region))
    error_message = "La región de AWS debe tener el formato correcto (ej: us-east-1, eu-west-1)."
  }
}

variable "environment" {
  description = "Nombre del entorno (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El entorno debe ser uno de: dev, staging, prod."
  }
}

variable "app_name" {
  description = "Nombre base de la aplicación"
  type        = string
  default     = "orders-management"

  validation {
    condition     = length(var.app_name) >= 3 && length(var.app_name) <= 50
    error_message = "El nombre de la aplicación debe tener entre 3 y 50 caracteres."
  }
}

# ============================================
# VARIABLES DE DYNAMODB
# ============================================

variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB para almacenar órdenes"
  type        = string
  default     = "orders-dev-table"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.dynamodb_table_name))
    error_message = "El nombre de la tabla solo puede contener letras, números, guiones y puntos."
  }
}

variable "dynamodb_billing_mode" {
  description = "Modo de facturación de DynamoDB (PAY_PER_REQUEST o PROVISIONED)"
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.dynamodb_billing_mode)
    error_message = "El modo de facturación debe ser PAY_PER_REQUEST o PROVISIONED."
  }
}

variable "dynamodb_read_capacity" {
  description = "Capacidad de lectura provisionada (solo para PROVISIONED)"
  type        = number
  default     = 5

  validation {
    condition     = var.dynamodb_read_capacity >= 1 && var.dynamodb_read_capacity <= 10000
    error_message = "La capacidad de lectura debe estar entre 1 y 10000."
  }
}

variable "dynamodb_write_capacity" {
  description = "Capacidad de escritura provisionada (solo para PROVISIONED)"
  type        = number
  default     = 5

  validation {
    condition     = var.dynamodb_write_capacity >= 1 && var.dynamodb_write_capacity <= 10000
    error_message = "La capacidad de escritura debe estar entre 1 y 10000."
  }
}

variable "dynamodb_enable_stream" {
  description = "Habilitar streams de DynamoDB para capturar cambios en la tabla"
  type        = bool
  default     = true
}

variable "dynamodb_stream_view_type" {
  description = "Tipo de vista del stream de DynamoDB"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"

  validation {
    condition     = contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.dynamodb_stream_view_type)
    error_message = "El tipo de vista debe ser KEYS_ONLY, NEW_IMAGE, OLD_IMAGE o NEW_AND_OLD_IMAGES."
  }
}

variable "dynamodb_gsi_read_capacity" {
  description = "Capacidad de lectura para índices secundarios globales"
  type        = number
  default     = 5
}

variable "dynamodb_gsi_write_capacity" {
  description = "Capacidad de escritura para índices secundarios globales"
  type        = number
  default     = 5
}

# ============================================
# VARIABLES DE API GATEWAY
# ============================================

variable "api_gateway_name" {
  description = "Nombre del API Gateway"
  type        = string
  default     = "orders-api-dev"
}

variable "api_gateway_stage" {
  description = "Nombre del stage del API Gateway"
  type        = string
  default     = "dev"
}

variable "api_gateway_enable_logging" {
  description = "Habilitar logging en API Gateway para desarrollo"
  type        = bool
  default     = true
}

# ============================================
# VARIABLES DE TAGS Y CONFIGURACIÓN
# ============================================

variable "common_tags" {
  description = "Tags comunes que se aplicarán a todos los recursos"
  type        = map(string)
  default = {
    Environment = "dev"
    Application = "orders-management"
    ManagedBy   = "Terraform"
  }
}

variable "enable_deletion_protection" {
  description = "Habilitar protección contra eliminación de recursos"
  type        = bool
  default     = false
}

variable "enable_cross_region_replication" {
  description = "Habilitar replicación entre regiones"
  type        = bool
  default     = false
}

variable "enable_logs_bucket" {
  description = "Crear bucket S3 para almacenar logs"
  type        = bool
  default     = false
}

variable "terraform_timeout_minutes" {
  description = "Timeout para operaciones de Terraform en minutos"
  type        = number
  default     = 30

  validation {
    condition     = var.terraform_timeout_minutes >= 5 && var.terraform_timeout_minutes <= 120
    error_message = "El timeout debe estar entre 5 y 120 minutos."
  }
}