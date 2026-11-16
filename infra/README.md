# Módulo de Infraestructura - Terraform

## Descripción General

Este componente contiene la definición de infraestructura como código utilizando Terraform para desplegar los recursos necesarios en AWS que soportan la aplicación de gestión de órdenes.

## Recursos Definidos

### Módulos Incluidos

1. **DynamoDB** (`modules/dynamodb/`)
   - Tabla de DynamoDB para almacenar órdenes
   - Índices secundarios globales para consultas por estado
   - Streams habilitados para captura de cambios
   - TTL configurable para limpieza automática de registros

2. **API Gateway** (`modules/api-gateway/`)
   - API REST para exponer los endpoints de la aplicación
   - Integración con Lambda para procesamiento de solicitudes

## Estructura de Archivos

```
infra/
├── modules/
│   ├── dynamodb/
│   │   ├── main.tf         # Definición de recursos DynamoDB
│   │   ├── variables.tf    # Variables de configuración
│   │   └── outputs.tf      # Outputs expuestos
│   └── api-gateway/
│       ├── main.tf         # Definición de API Gateway
│       ├── variables.tf    # Variables de configuración
│       └── outputs.tf      # Outputs expuestos
├── environments/
│   └── dev/
│       ├── main.tf         # Configuración del entorno dev
│       ├── variables.tf    # Variables del entorno
│       └── terraform.tfvars # Valores de variables
├── versions.tf             # Versiones de Terraform y providers
├── providers.tf            # Configuración de providers
└── README.md               # Este archivo
```

## Validación Local

### Prerrequisitos

- Terraform >= 1.9.0
- AWS CLI configurado con credenciales válidas
- Acceso a la región us-east-1

### Comandos de Validación

1. **Inicializar Terraform:**
   ```bash
   cd infra
   terraform init
   ```

2. **Validar sintaxis de configuración:**
   ```bash
   terraform validate
   ```

3. **Planificar cambios (ver qué recursos se crearán):**
   ```bash
   terraform plan -out=tfplan
   ```

4. **Aplicar cambios (crear recursos en AWS):**
   ```bash
   terraform apply tfplan
   ```

5. **Destruir recursos (limpieza):**
   ```bash
   terraform destroy
   ```

## Configuración de Variables

### Tabla DynamoDB

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `table_name` | Nombre de la tabla | orders-table |
| `billing_mode` | Modo de facturación | PAY_PER_REQUEST |
| `hash_key` | Clave de partición | orderId |
| `range_key` | Clave de ordenación | null |
| `enable_stream` | Habilitar stream | false |

### Tags Estándar

Todos los recursos incluyen los siguientes tags:
- `Environment`: dev/staging/production
- `Application`: orders-management
- `Terraform`: true

## Integración con Otros Componentes

### Salidas del Módulo DynamoDB

El módulo expone los siguientes outputs para consumo por otros componentes:

- `table_arn`: ARN de la tabla creada
- `table_name`: Nombre de la tabla
- `table_id`: ID de la tabla
- `stream_arn`: ARN del stream (si está habilitado)
- `global_secondary_index_names`: Lista de nombres de GSI

### Consumo en Aplicación

La aplicación React consume estos recursos a través de:
- Variables de entorno configuradas en el entorno de despliegue
- Endpoints de API Gateway definidos en este módulo

## Consideraciones de Seguridad

- Los recursos se crean con encryption habilitada por defecto
- El acceso a la tabla DynamoDB se configura mediante IAM policies
- Las credenciales de AWS no se almacenan en el código
- Se recomienda usar AWS Secrets Manager para datos sensibles

## Limpieza de Recursos

Para eliminar todos los recursos creados:

```bash
cd infra/environments/dev
terraform destroy
```

**Nota:** El comando destroy eliminará todos los recursos de AWS creados por esta configuración. Asegúrate de tener backups si es necesario.

## Referencias

- [Documentación de Terraform](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Dynamodb Table Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)