# Prompt para Mejorar el Codigo Base

Copia y pega el contenido del bloque de abajo en un asistente de IA (Claude, ChatGPT)
para obtener el proyecto completo y arrancable. Guarda los archivos que te devuelva en la
carpeta del repo, respetando exactamente las rutas.

Si preferis trabajar en tu editor con un agente local (Claude Code, Cursor, Copilot), usa `AGENTS.md` en vez de este archivo: dice lo mismo pero para que escriba los archivos en disco.

## Las dos reglas que no se negocian

1. **Completa el boilerplate.** Todo lo que el proyecto necesita para compilar y arrancar: manifiesto de dependencias, punto de entrada, configuracion, capa de interfaz, y las capas del patron arquitectonico declarado. Eso es andamiaje y es tu trabajo.
2. **NO resuelvas el reto.** Los entregables de las fases son el trabajo de la persona. El hueco pedagogico se deja como esta: el proyecto arranca, pero lo que el reto pide implementar NO esta implementado.

Dicho de otra forma: si algo impide compilar, arreglalo. Si algo es logica de negocio incompleta, validaciones ausentes, un secreto hardcodeado o un patron mejorable, dejalo exactamente como esta — es lo que la persona tiene que encontrar.

## Superficie de practica — NO resuelvas

Estos archivos SON el ejercicio de la persona. No los implementes; deja stubs.

- `api/src/application/services/order.service.ts` — La fase "Configuración del entorno y creación de la API" se implementa aqui: este archivo es el ejercicio.
- `api/src/infrastructure/repositories/order.repository.ts` — La fase "Implementación de la lógica de negocio" se implementa aqui: este archivo es el ejercicio.

## Mapa de componentes

El repo tiene una carpeta por componente. Cada uno se instala y verifica dentro de la suya.

| Componente | Carpeta | Rol | Capa | Track | Tecnologias |
|---|---|---|---|---|---|
| `api` | `api/` | practice | server | Node | DynamoDB |
| `client` | `client/` | chapter, support | client | React | React |
| `infra` | `infra/` | support | infra | Terraform (AWS) | Terraform |
| `infra-local` | (raiz) | support | infra | Compose local | DynamoDB |

## Orden de arranque

1. `docker compose up -d` (en la raiz) — levanta la infraestructura local.
2. `cd infra && terraform init -backend=false && terraform -chdir=environments/dev init -backend=false && terraform -chdir=modules/api-gateway init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=environments/dev validate && terraform -chdir=modules/api-gateway validate && terraform -chdir=modules/dynamodb validate` — componente `infra` (support).
3. `cd api && npm install --no-audit --no-fund && npm run build` — componente `api` (practice).
4. `cd client && npm install --no-audit --no-fund && npm run build` — componente `client` (chapter, support).

### Contratos entre componentes

- `api` expone http (api: http://localhost:3000):
  - `POST /orders`
  - `GET /orders/:id`
  - `PUT /orders/:id`
  - `DELETE /orders/:id`

## Como saber que terminaste

```bash
(cd api && npm install --no-audit --no-fund && npm run build) && (cd client && npm install --no-audit --no-fund && npm run build) && (cd infra && terraform init -backend=false && terraform -chdir=environments/dev init -backend=false && terraform -chdir=modules/api-gateway init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=environments/dev validate && terraform -chdir=modules/api-gateway validate && terraform -chdir=modules/dynamodb validate) && docker compose config -q
```

Ese comando corriendo sin errores es la definicion de "listo".

---

```
## Briefing del reto (autoridad)
Este bloque manda sobre los archivos adjuntos. El stack y el rol salen de AQUÍ, no de un topic genérico ni de markdown placeholder.

### Perfil
Chapter Frontend, Especialidad Desarrollador, Tecnología React, Advanced L2

### Brecha de conocimiento
CRUD de ordenes en DynamoDB desde la interfaz

### Misión / candidato
Gestionar ordenes

### Reto
- Tema: Persistir ordenes en DynamoDB desde la interfaz
- Seniority: advanced-l2
- Tipo: practical
- Título: Implementación de operaciones CRUD de ordenes en DynamoDB
- Tiempo estimado: 10 horas

### Fases (trabajo del HUMANO — PROHIBIDO completarlas)
No implementes estos entregables. Dejalos como hueco pedagógico. El asistente solo materializa el proyecto arrancable para que el participante pueda trabajar.
- Fase 1: Configuración del entorno y creación de la API — objetivo: Configurar el entorno de desarrollo y crear la API para gestionar ordenes en DynamoDB. — entregable (NO resolver): API funcional para crear y leer ordenes en DynamoDB.
- Fase 2: Implementación de la lógica de negocio — objetivo: Implementar la lógica de negocio para las operaciones CRUD de ordenes. — entregable (NO resolver): Lógica de negocio completa para las operaciones CRUD de ordenes en DynamoDB.
- Fase 3: Versionado de la infraestructura — objetivo: Versionar la infraestructura utilizando Terraform. — entregable (NO resolver): Infraestructura versionada y documentada para la API y DynamoDB.

Eres un asistente experto en análisis, corrección y generación de archivos de cualquier tipo:
código fuente, documentación, hojas de cálculo, documentos Word, configuraciones, entre otros.
Voy a enviarte una cadena de texto que contiene uno o más archivos. Cada archivo está delimitado por un marcador con el siguiente formato:
// === ARCHIVO: ruta/del/archivo.extension ===
o también puede aparecer como:
## === ARCHIVO: ruta/del/archivo.extension ===
Lo que sigue al marcador puede ser:

El contenido real del archivo (código, texto, YAML, etc.)
Una descripción en lenguaje natural de lo que debe contener el archivo


TU TAREA
PASO 0 — ¿Esto es un proyecto o una carcasa?
Antes de extraer archivos, leé el Briefing (si está) y diagnosticá el adjunto.

Es CARCASA si ocurre CUALQUIERA de estas:
- No hay manifiesto de dependencias del stack del briefing (manifest.json de VTEX IO / package.json / pom.xml / build.gradle / requirements.txt / go.mod / *.tf / *.csproj, según corresponda)
- Hay un "binario" que en realidad es un comentario ("no puede ser mostrado como texto plano", placeholder .fig/.docx vacío)
- Los markdowns ya completan entregables de fases posteriores ("se implementó fade-in", lista de áreas ya resuelta)

Si es CARCASA:
- MATERIALIZÁ un proyecto que arranca en el stack del briefing (VTEX IO Store Framework, Angular, Terraform, pytest, Nest, etc.). Incluí manifiesto, punto de entrada y capa de interfaz reales.
- NO copies los markdowns de "solución" como si fueran el producto. Son ruido de generación.
- NO resuelvas las fases del briefing (están marcadas PROHIBIDO). Dejá el hueco pedagógico: el flujo existe, las microinteracciones/calidad/infra que el reto pide NO están hechas.
- Después seguí al PASO 5 (entrega de archivos).

Si es un proyecto REAL (manifiesto + código que compila o arranca):
- Seguí PASO 1 en adelante. 🔴 compilación sí. 🟡 pedagógico no.

PASO 1 — Detección y extracción
Identifica todos los archivos presentes en la cadena. Para cada archivo extrae:

Su ruta completa (ej: src/main/java/com/pragma/Service.java)
Su contenido o descripción

PASO 2 — Clasificación por tipo
Clasifica cada archivo en una de estas categorías:
A) Código fuente (Java, Python, TypeScript, JavaScript, Kotlin, etc.)
B) Configuración / documentación (YAML, properties, Markdown, JSON, txt, etc.)
C) Excel (.xlsx, .xls, .csv)
D) Word (.docx, .doc)
E) Otro tipo de archivo binario o especial
PASO 3 — Clasificación de errores en código fuente

Objetivo prioritario: que el proyecto compile. No corrijas flujo de negocio ni lógica funcional.

Antes de modificar cualquier archivo de código fuente, clasifica cada problema encontrado en una de estas dos categorías:
🔴 ERROR DE COMPILACIÓN — corregir siempre
Son errores que impiden que el proyecto arranque, sin valor pedagógico:

Import faltante o incorrecto
Clase, método o variable referenciada que no existe en ningún archivo del proyecto
Error de sintaxis
Anotación con atributos inválidos
Dependencia ausente en pom.xml, package.json, etc.
Archivo referenciado que no existe y debe ser creado con implementación mínima

→ CORREGIR estos errores.
🟡 PROBLEMA FUNCIONAL O DE CALIDAD — preservar siempre
Son problemas que no impiden compilar. Pueden ser intencionales para el aprendizaje:

Clave secreta hardcodeada ("secret", "password123")
API deprecada que funciona pero tiene reemplazo moderno
Lógica de negocio incorrecta o incompleta
Código redundante o de baja legibilidad
Falta de validaciones en flujo de negocio
Patrones de diseño incorrectos pero funcionales
Concurrencia no segura
Configuración funcional pero no óptima

→ PRESERVAR tal cual. No corregir, no mejorar, no comentar.
PASO 4 — Procesamiento según tipo de archivo
Tipo A — Código fuente
Aplica únicamente las correcciones clasificadas como 🔴 ERROR DE COMPILACIÓN.
No alteres ningún elemento clasificado como 🟡 PROBLEMA FUNCIONAL O DE CALIDAD.
Si falta un archivo referenciado, créalo con la implementación mínima necesaria para compilar.
Tipo B — Configuración / documentación
Extrae el contenido tal cual, sin modificaciones salvo errores evidentes de sintaxis
(ej: YAML mal indentado).
Tipo C — Excel (.xlsx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un archivo Excel funcional con:

Fila de encabezados en negrita con color de fondo distintivo
Columnas con ancho ajustado al contenido
Tipos de dato correctos por columna
Validaciones si la descripción lo indica
Hojas nombradas descriptivamente si hay más de una
Filas de ejemplo si no hay datos reales

Tipo D — Word (.docx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un documento Word funcional con:

Estilos de título (Título 1, Título 2) para jerarquía de secciones
Fuente legible (Calibri o equivalente), tamaño 11-12pt para cuerpo
Márgenes estándar
Tabla de contenido si tiene múltiples secciones
Tablas con encabezados en negrita si aplica

Tipo E — Otro
Genera el archivo con el contenido o estructura más apropiada según la descripción.
PASO 5 — Entrega de archivos
Entregá cada archivo con su ruta completa, respetando exactamente la estructura de rutas
indicada por los marcadores: un bloque por archivo, precedido por su ruta. No generes ZIPs
ni archivos adjuntos.
La entrega debe incluir:

Archivos de código con únicamente los errores de compilación corregidos
Archivos de configuración y documentación sin cambios
Archivos nuevos creados para resolver dependencias de compilación faltantes
Archivos Excel y Word generados desde descripción

IMPORTANTE: Entregá los archivos completos al finalizar. No preguntes si el usuario
quiere recibirlos. Simplemente entregalos; No debes desplegar en el chat el resumen de lo que arreglaste, solo entregá los archivos.

REGLAS IMPORTANTES

No omitas ningún archivo aunque no tenga errores ni modificaciones
Respeta los nombres y rutas exactas indicadas por los marcadores
Si un archivo no tiene marcador claro, infiere el nombre desde su contenido
Si la cadena contiene solo documentación, placeholders o binarios fake, NO la reproduzcas:
aplicá PASO 0 (materializar el proyecto del briefing). Reproducir la carcasa es un fallo.
No agregues texto después del último archivo entregado
No preguntes si el usuario quiere los archivos: simplemente entregalos siempre
Si detectas que falta un archivo de configuración necesario para compilar
(pom.xml, package.json, requirements.txt, build.gradle, etc.), créalo e inclúyelo
inferiendo su contenido desde los imports y frameworks detectados en el código
Nunca corrijas problemas 🟡 aunque parezcan obvios o fáciles de mejorar.
El participante que recibirá este proyecto los debe encontrar y resolver él mismo.


INPUT
Aquí está la cadena con los archivos:

// === ARCHIVO: api/package.json ===
{
  "name": "reto-nest",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "build": "tsc -p tsconfig.json"
  },
  "dependencies": {
    "@aws-sdk/client-dynamodb": "3.1170.0",
    "@aws-sdk/lib-dynamodb": "3.1170.0",
    "@nestjs/common": "10.4.22",
    "@nestjs/core": "10.4.22",
    "@nestjs/platform-express": "10.4.22",
    "@nestjs/swagger": "8.1.1",
    "class-transformer": "0.5.1",
    "class-validator": "0.15.1",
    "reflect-metadata": "0.2.2",
    "rxjs": "7.8.2"
  },
  "devDependencies": {
    "@types/express": "4.17.25",
    "@types/node": "22.20.5",
    "typescript": "5.7.3"
  }
}

// === ARCHIVO: api/tsconfig.json ===
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "moduleResolution": "node",
    "outDir": "dist",
    "strict": true,
    "strictPropertyInitialization": false,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "forceConsistentCasingInFileNames": true,
    "types": [
      "node"
    ]
  },
  "include": [
    "src"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "_pendiente",
    "tests",
    "test",
    "src/**/*.spec.ts",
    "src/**/*.test.ts"
  ]
}

// === ARCHIVO: api/src/domain/models/order.model.ts ===
import { OrderStatus } from '../types/order-status.type';

export class OrderItem {
  constructor(
    public readonly productId: string,
    public readonly quantity: number,
    public readonly price: number,
  ) {
    if (quantity <= 0) {
      throw new Error('Quantity must be greater than 0');
    }
    if (price <= 0) {
      throw new Error('Price must be greater than 0');
    }
  }

  getTotalPrice(): number {
    return this.quantity * this.price;
  }

  toJSON(): { productId: string; quantity: number; price: number } {
    return {
      productId: this.productId,
      quantity: this.quantity,
      price: this.price,
    };
  }
}

export class Order {
  constructor(
    public readonly id: string,
    public readonly customerId: string,
    public readonly items: OrderItem[],
    public status: OrderStatus,
    public readonly createdAt: string,
    public updatedAt: string,
  ) {
    if (!id || !customerId) {
      throw new Error('Id and customerId are required');
    }
    if (items.length === 0) {
      throw new Error('Order must have at least one item');
    }
  }

  updateStatus(newStatus: OrderStatus): void {
    this.status = newStatus;
    this.updatedAt = new Date().toISOString();
  }

  getTotalAmount(): number {
    return this.items.reduce((total, item) => total + item.getTotalPrice(), 0);
  }

  canTransitionTo(newStatus: OrderStatus): boolean {
    const allowedTransitions: Record<OrderStatus, OrderStatus[]> = {
      [OrderStatus.PENDING]: [OrderStatus.PROCESSING, OrderStatus.CANCELLED],
      [OrderStatus.PROCESSING]: [OrderStatus.SHIPPED, OrderStatus.CANCELLED],
      [OrderStatus.SHIPPED]: [OrderStatus.DELIVERED, OrderStatus.CANCELLED],
      [OrderStatus.DELIVERED]: [],
      [OrderStatus.CANCELLED]: [],
    };
    return allowedTransitions[this.status].includes(newStatus);
  }

  toJSON(): {
    id: string;
    customerId: string;
    items: { productId: string; quantity: number; price: number }[];
    status: OrderStatus;
    createdAt: string;
    updatedAt: string;
  } {
    return {
      id: this.id,
      customerId: this.customerId,
      items: this.items.map((item) => item.toJSON()),
      status: this.status,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}

// === ARCHIVO: api/src/domain/ports/order.repository.port.ts ===
import { Order, OrderItem } from '../models/order.model';
import { OrderStatus } from '../types/order-status.type';

export interface OrderRepositoryPort {
  create(order: Order): Promise<Order>;
  findById(id: string): Promise<Order | null>;
  update(id: string, order: Partial<Order>): Promise<Order>;
  delete(id: string): Promise<void>;
  findByCustomerId(customerId: string): Promise<Order[]>;
  findByStatus(status: OrderStatus): Promise<Order[]>;
}

export interface OrderItemRepositoryPort {
  findByOrderId(orderId: string): Promise<OrderItem[]>;
  create(orderId: string, item: OrderItem): Promise<OrderItem>;
  deleteByOrderId(orderId: string): Promise<void>;
}

// === ARCHIVO: api/src/application/services/order.service.ts ===
import { Injectable, Inject } from '@nestjs/common';
import { Order } from '../../domain/models/order.model';
import { OrderRepositoryPort } from '../../domain/ports/order.repository.port';
import { OrderStatus } from '../../domain/types/order-status.type';
import { CreateOrderDto } from '../../infrastructure/controllers/dto/create-order.dto';
import { UpdateOrderDto } from '../../infrastructure/controllers/dto/update-order.dto';

@Injectable()
export class OrderService {
  constructor(@Inject('OrderRepositoryPort') private readonly orderRepository: OrderRepositoryPort) {}

  async createOrder(createOrderDto: CreateOrderDto): Promise<Order> {
    // TODO(reto): Implementar la lógica para crear una orden
    // - Validar que los items no estén vacíos
    // - Calcular el precio total de la orden
    // - Crear la orden con estado PENDING
    // - Persistir la orden usando el repositorio
    throw new Error('Method not implemented');
  }

  async getOrder(id: string): Promise<Order> {
    // TODO(reto): Implementar la lógica para obtener una orden por ID
    // - Usar el repositorio para buscar la orden
    // - Lanzar excepción si no existe
    throw new Error('Method not implemented');
  }

  async updateOrder(id: string, updateOrderDto: UpdateOrderDto): Promise<Order> {
    // TODO(reto): Implementar la lógica para actualizar una orden
    // - Validar que el nuevo estado sea válido
    // - Actualizar la orden usando el repositorio
    throw new Error('Method not implemented');
  }

  async deleteOrder(id: string): Promise<void> {
    // TODO(reto): Implementar la lógica para eliminar una orden
    // - Usar el repositorio para eliminar la orden
    throw new Error('Method not implemented');
  }
}

// === ARCHIVO: api/src/infrastructure/repositories/order.repository.ts ===
import { Injectable } from '@nestjs/common';
import { OrderRepositoryPort } from '../../domain/ports/order.repository.port';
import { Order } from '../../domain/models/order.model';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, GetCommand, UpdateCommand, DeleteCommand, QueryCommand } from '@aws-sdk/lib-dynamodb';
import { OrderStatus } from '../../domain/types/order-status.type';

@Injectable()
export class OrderRepository implements OrderRepositoryPort {
  private readonly client: DynamoDBDocumentClient;

  constructor() {
    const dynamoDBClient = new DynamoDBClient({ region: process.env.AWS_REGION });
    this.client = DynamoDBDocumentClient.from(dynamoDBClient);
  }

  async create(order: Order): Promise<Order> {
    // TODO(reto): Implementar la persistencia en DynamoDB
    // - Mapear la entidad Order a un formato compatible con DynamoDB
    // - Usar PutCommand para guardar la orden
    // - Manejar errores de persistencia
    throw new Error('Method not implemented');
  }

  async findById(id: string): Promise<Order | null> {
    // TODO(reto): Implementar la búsqueda en DynamoDB
    // - Usar GetCommand para obtener la orden
    // - Mapear el resultado de DynamoDB a la entidad Order
    // - Manejar el caso cuando la orden no existe
    throw new Error('Method not implemented');
  }

  async update(id: string, order: Partial<Order>): Promise<Order> {
    // TODO(reto): Implementar la actualización en DynamoDB
    // - Usar UpdateCommand para actualizar la orden
    // - Mapear el resultado a la entidad Order
    // - Manejar errores de actualización
    throw new Error('Method not implemented');
  }

  async delete(id: string): Promise<void> {
    // TODO(reto): Implementar la eliminación en DynamoDB
    // - Usar DeleteCommand para eliminar la orden
    // - Manejar errores de eliminación
    throw new Error('Method not implemented');
  }

  async findByCustomerId(customerId: string): Promise<Order[]> {
    // TODO(reto): Implementar la búsqueda por customerId en DynamoDB
    // - Usar QueryCommand con GSI o Scan filtrado por customerId
    // - Mapear los resultados a entidades Order
    // - Manejar el caso cuando no hay órdenes
    throw new Error('Method not implemented');
  }

  async findByStatus(status: OrderStatus): Promise<Order[]> {
    // TODO(reto): Implementar la búsqueda por status en DynamoDB
    // - Usar QueryCommand con GSI o Scan filtrado por status
    // - Mapear los resultados a entidades Order
    // - Manejar el caso cuando no hay órdenes
    throw new Error('Method not implemented');
  }
}

// === ARCHIVO: api/src/infrastructure/controllers/dto/create-order.dto.ts ===
import { IsArray, IsNotEmpty, IsNumber, IsPositive, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { OrderStatus } from '../../../domain/types/order-status.type';

class OrderItemDto {
  @IsString()
  @IsNotEmpty()
  productId: string;

  @IsNumber()
  @IsPositive()
  quantity: number;

  @IsNumber()
  @IsPositive()
  price: number;
}

export class CreateOrderDto {
  @IsString()
  @IsNotEmpty()
  customerId: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => OrderItemDto)
  items: OrderItemDto[];

  constructor(customerId: string, items: OrderItemDto[]) {
    this.customerId = customerId;
    this.items = items;
    this.validateInvariants();
  }

  private validateInvariants(): void {
    if (!this.customerId) {
      throw new Error('CustomerId is required');
    }
    if (!this.items || this.items.length === 0) {
      throw new Error('Order must have at least one item');
    }
    this.items.forEach(item => {
      if (item.quantity <= 0) {
        throw new Error('Quantity must be greater than 0');
      }
      if (item.price <= 0) {
        throw new Error('Price must be greater than 0');
      }
    });
  }
}

// === ARCHIVO: api/src/infrastructure/controllers/dto/update-order.dto.ts ===
import { IsEnum, IsNotEmpty } from 'class-validator';
import { OrderStatus } from '../../../domain/types/order-status.type';

export class UpdateOrderDto {
  @IsEnum(OrderStatus)
  @IsNotEmpty()
  status: OrderStatus;

  constructor(status: OrderStatus) {
    this.status = status;
    this.validateInvariants();
  }

  private validateInvariants(): void {
    if (!this.status) {
      throw new Error('Status is required');
    }
    const validStatuses = Object.values(OrderStatus);
    if (!validStatuses.includes(this.status)) {
      throw new Error('Invalid order status');
    }
  }
}

// === ARCHIVO: api/src/app.module.ts ===
import { Module } from '@nestjs/common';
import { OrderController } from './infrastructure/controllers/order.controller';
import { OrderService } from './application/services/order.service';
import { OrderRepository } from './infrastructure/repositories/order.repository';

@Module({
  controllers: [OrderController],
  providers: [
    OrderService,
    {
      provide: 'OrderRepositoryPort',
      useClass: OrderRepository,
    },
  ],
})
export class AppModule {}

// === ARCHIVO: api/src/main.ts ===
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: true,
      forbidNonWhitelisted: true,
    }),
  );

  const config = new DocumentBuilder()
    .setTitle('Order API')
    .setDescription('API for managing orders')
    .setVersion('1.0')
    .addTag('orders')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  await app.listen(3000);
}
bootstrap();

// === ARCHIVO: api/src/infrastructure/controllers/order.controller.ts ===
import { Controller, Get, Post, Put, Delete, Body, Param, HttpCode, HttpStatus } from '@nestjs/common';
import { OrderService } from '../../application/services/order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order } from '../../domain/models/order.model';
import { ApiTags, ApiOperation, ApiResponse, ApiParam } from '@nestjs/swagger';

@ApiTags('orders')
@Controller('orders')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new order' })
  @ApiResponse({ status: 201, description: 'Order created', type: Order })
  @ApiResponse({ status: 400, description: 'Bad request' })
  async createOrder(@Body() createOrderDto: CreateOrderDto): Promise<Order> {
    return this.orderService.createOrder(createOrderDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get an order by ID' })
  @ApiParam({ name: 'id', type: String })
  @ApiResponse({ status: 200, description: 'Order found', type: Order })
  @ApiResponse({ status: 404, description: 'Order not found' })
  async getOrder(@Param('id') id: string): Promise<Order> {
    return this.orderService.getOrder(id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update an order status' })
  @ApiParam({ name: 'id', type: String })
  @ApiResponse({ status: 200, description: 'Order updated', type: Order })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @ApiResponse({ status: 404, description: 'Order not found' })
  async updateOrder(
    @Param('id') id: string,
    @Body() updateOrderDto: UpdateOrderDto,
  ): Promise<Order> {
    return this.orderService.updateOrder(id, updateOrderDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete an order' })
  @ApiParam({ name: 'id', type: String })
  @ApiResponse({ status: 204, description: 'Order deleted' })
  @ApiResponse({ status: 404, description: 'Order not found' })
  async deleteOrder(@Param('id') id: string): Promise<void> {
    return this.orderService.deleteOrder(id);
  }
}

// === ARCHIVO: api/src/domain/types/order-status.type.ts ===
export enum OrderStatus {
  PENDING = 'PENDING',
  PROCESSING = 'PROCESSING',
  SHIPPED = 'SHIPPED',
  DELIVERED = 'DELIVERED',
  CANCELLED = 'CANCELLED',
}

// === ARCHIVO: client/src/main.tsx ===
import React from 'react';
import ReactDOM from 'react-dom/client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { CssBaseline, ThemeProvider } from '@mui/material';
import { theme } from './theme';
import App from './App';

const queryClient = new QueryClient();

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <App />
      </ThemeProvider>
    </QueryClientProvider>
  </React.StrictMode>
);

// === ARCHIVO: client/package.json ===
{
  "name": "reto-react",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "build": "tsc --noEmit && vite build"
  },
  "dependencies": {
    "@mui/icons-material": "5.18.0",
    "@mui/material": "5.18.0",
    "@tanstack/react-query": "5.107.1",
    "axios": "1.21.1",
    "react": "18.3.1",
    "react-dom": "18.3.1"
  },
  "devDependencies": {
    "@types/react": "18.3.31",
    "@types/react-dom": "18.3.7",
    "@vitejs/plugin-react": "4.7.0",
    "typescript": "5.7.3",
    "vite": "5.4.21"
  }
}

// === ARCHIVO: client/tsconfig.json ===
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": [
      "ES2020",
      "DOM",
      "DOM.Iterable"
    ],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "strict": true,
    "strictPropertyInitialization": false,
    "noEmit": true,
    "isolatedModules": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "allowImportingTsExtensions": true,
    "useDefineForClassFields": true,
    "types": [
      "vite/client"
    ]
  },
  "include": [
    "src"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "_pendiente",
    "tests",
    "src/**/*.test.ts",
    "src/**/*.test.tsx",
    "src/**/*.spec.ts",
    "src/**/*.spec.tsx"
  ]
}

// === ARCHIVO: client/vite.config.ts ===
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({ plugins: [react()] });

// === ARCHIVO: client/index.html ===
<!doctype html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reto</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>

// === ARCHIVO: client/src/vite-env.d.ts ===
/// <reference types="vite/client" />

// === ARCHIVO: client/src/types/order.ts ===
export type OrderStatus = 'PENDING' | 'PROCESSING' | 'SHIPPED' | 'DELIVERED' | 'CANCELLED';

export interface OrderItem {
  productId: string;
  quantity: number;
  price: number;
}

export interface OrderItemDto {
  productId: string;
  quantity: number;
}

export interface Order {
  id: string;
  customerId: string;
  items: OrderItem[];
  status: OrderStatus;
  createdAt: string;
  updatedAt: string;
}

export interface CreateOrderDto {
  customerId: string;
  items: OrderItemDto[];
}

export interface UpdateOrderDto {
  status: OrderStatus;
}

// === ARCHIVO: client/src/services/OrderService.ts ===
import axios from 'axios';
import { CreateOrderDto, Order, UpdateOrderDto } from '../types/order';

const API_BASE_URL = 'http://localhost:3000';

export class OrderService {
  static async createOrder(orderData: CreateOrderDto): Promise<Order> {
    const response = await axios.post(`${API_BASE_URL}/orders`, orderData);
    return response.data;
  }

  static async getOrder(orderId: string): Promise<Order> {
    const response = await axios.get(`${API_BASE_URL}/orders/${orderId}`);
    return response.data;
  }

  static async updateOrder(orderId: string, updateData: UpdateOrderDto): Promise<Order> {
    const response = await axios.put(`${API_BASE_URL}/orders/${orderId}`, updateData);
    return response.data;
  }

  static async deleteOrder(orderId: string): Promise<void> {
    await axios.delete(`${API_BASE_URL}/orders/${orderId}`);
  }
}

// === ARCHIVO: client/src/hooks/useOrder.ts ===
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { OrderService } from '../services/OrderService';
import { CreateOrderDto, Order, UpdateOrderDto } from '../types/order';

export const useOrder = () => {
  const queryClient = useQueryClient();

  const getOrderQuery = (orderId: string) =>
    useQuery<Order, Error>({
      queryKey: ['order', orderId],
      queryFn: () => OrderService.getOrder(orderId),
      enabled: !!orderId,
    });

  const createOrderMutation = useMutation<Order, Error, CreateOrderDto>({
    mutationFn: (orderData) => OrderService.createOrder(orderData),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['orders'] });
    },
  });

  const updateOrderMutation = useMutation<Order, Error, { orderId: string; updateData: UpdateOrderDto }>({
    mutationFn: ({ orderId, updateData }) => OrderService.updateOrder(orderId, updateData),
    onSuccess: (_, { orderId }) => {
      queryClient.invalidateQueries({ queryKey: ['order', orderId] });
      queryClient.invalidateQueries({ queryKey: ['orders'] });
    },
  });

  const deleteOrderMutation = useMutation<void, Error, string>({
    mutationFn: (orderId) => OrderService.deleteOrder(orderId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['orders'] });
    },
  });

  return {
    getOrderQuery,
    createOrderMutation,
    updateOrderMutation,
    deleteOrderMutation,
  };
};

// === ARCHIVO: client/src/components/OrderStatusSelector.tsx ===
import React from 'react';
import { FormControl, InputLabel, Select, MenuItem, SelectChangeEvent } from '@mui/material';
import { OrderStatus } from '../types/order';

interface OrderStatusSelectorProps {
  status: OrderStatus;
  onStatusChange: (status: OrderStatus) => void;
  disabled?: boolean;
}

const OrderStatusSelector: React.FC<OrderStatusSelectorProps> = ({
  status,
  onStatusChange,
  disabled = false,
}) => {
  const handleChange = (event: SelectChangeEvent<OrderStatus>) => {
    onStatusChange(event.target.value as OrderStatus);
  };

  return (
    <FormControl fullWidth disabled={disabled}>
      <InputLabel id="order-status-label">Estado</InputLabel>
      <Select
        labelId="order-status-label"
        value={status}
        label="Estado"
        onChange={handleChange}
      >
        <MenuItem value="PENDING">Pendiente</MenuItem>
        <MenuItem value="PROCESSING">En proceso</MenuItem>
        <MenuItem value="SHIPPED">Enviado</MenuItem>
        <MenuItem value="DELIVERED">Entregado</MenuItem>
        <MenuItem value="CANCELLED">Cancelado</MenuItem>
      </Select>
    </FormControl>
  );
};

export default OrderStatusSelector;

// === ARCHIVO: client/src/components/OrderForm.tsx ===
import React, { useState } from 'react';
import { Button, TextField, Box, Typography, Paper } from '@mui/material';
import { CreateOrderDto, OrderItemDto } from '../types/order';

interface OrderFormProps {
  onSubmit: (orderData: CreateOrderDto) => void;
  isPending?: boolean;
}

const OrderForm: React.FC<OrderFormProps> = ({ onSubmit, isPending = false }) => {
  const [customerId, setCustomerId] = useState('');
  const [items, setItems] = useState<OrderItemDto[]>([{ productId: '', quantity: 1 }]);

  const handleItemChange = (index: number, field: keyof OrderItemDto, value: string | number) => {
    const newItems = [...items];
    newItems[index] = { ...newItems[index], [field]: value };
    setItems(newItems);
  };

  const addItem = () => {
    setItems([...items, { productId: '', quantity: 1 }]);
  };

  const removeItem = (index: number) => {
    if (items.length > 1) {
      const newItems = items.filter((_, i) => i !== index);
      setItems(newItems);
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit({ customerId, items });
  };

  return (
    <Paper elevation={3} sx={{ padding: 3 }}>
      <Typography variant="h6" gutterBottom>
        Crear Nueva Orden
      </Typography>
      <Box component="form" onSubmit={handleSubmit} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
        <TextField
          label="ID del Cliente"
          value={customerId}
          onChange={(e) => setCustomerId(e.target.value)}
          required
          fullWidth
        />

        <Typography variant="subtitle1">Items</Typography>
        {items.map((item, index) => (
          <Box key={index} sx={{ display: 'flex', gap: 2, alignItems: 'center' }}>
            <TextField
              label="ID del Producto"
              value={item.productId}
              onChange={(e) => handleItemChange(index, 'productId', e.target.value)}
              required
              sx={{ flex: 1 }}
            />
            <TextField
              label="Cantidad"
              type="number"
              value={item.quantity}
              onChange={(e) => handleItemChange(index, 'quantity', Number(e.target.value))}
              required
              inputProps={{ min: 1 }}
              sx={{ width: 100 }}
            />
            {items.length > 1 && (
              <Button
                variant="outlined"
                color="error"
                onClick={() => removeItem(index)}
                sx={{ height: '56px' }}
              >
                Eliminar
              </Button>
            )}
          </Box>
        ))}

        <Box sx={{ display: 'flex', gap: 2 }}>
          <Button
            variant="outlined"
            onClick={addItem}
            disabled={items.some(item => !item.productId)}
          >
            Añadir Item
          </Button>
          <Button
            type="submit"
            variant="contained"
            color="primary"
            disabled={isPending || !customerId || items.some(item => !item.productId)}
          >
            {isPending ? 'Creando...' : 'Crear Orden'}
          </Button>
        </Box>
      </Box>
    </Paper>
  );
};

export default OrderForm;

// === ARCHIVO: client/src/pages/OrderPage.tsx ===
import { useState, useEffect } from 'react';
import { Container, Typography, Box, Paper, Divider, Alert, CircularProgress } from '@mui/material';
import OrderForm from '../components/OrderForm';
import OrderStatusSelector from '../components/OrderStatusSelector';
import { useOrder } from '../hooks/useOrder';
import { Order, OrderStatus, CreateOrderDto } from '../types/order';

export function OrderPage() {
  const [selectedOrderId, setSelectedOrderId] = useState<string | null>(null);
  const [currentOrder, setCurrentOrder] = useState<Order | null>(null);
  const [notification, setNotification] = useState<{ type: 'success' | 'error'; message: string } | null>(null);
  
  const { 
    getOrderQuery,
    createOrderMutation,
    updateOrderMutation,
    deleteOrderMutation
  } = useOrder();

  const isPending = createOrderMutation.isPending || updateOrderMutation.isPending || deleteOrderMutation.isPending;
  const error = createOrderMutation.error || updateOrderMutation.error || deleteOrderMutation.error;

  useEffect(() => {
    if (selectedOrderId) {
      loadOrder(selectedOrderId);
    }
  }, [selectedOrderId]);

  const loadOrder = async (orderId: string) => {
    try {
      const queryResult = getOrderQuery(orderId);
      if (queryResult.data) {
        setCurrentOrder(queryResult.data);
      } else if (queryResult.error) {
        setNotification({ type: 'error', message: 'Error al cargar la orden' });
        setCurrentOrder(null);
      }
    } catch (err) {
      setNotification({ type: 'error', message: 'Error al cargar la orden' });
      setCurrentOrder(null);
    }
  };

  const handleCreateOrder = async (orderData: CreateOrderDto) => {
    try {
      const newOrder = await createOrderMutation.mutateAsync(orderData);
      setCurrentOrder(newOrder);
      setSelectedOrderId(newOrder.id);
      setNotification({ type: 'success', message: 'Orden creada exitosamente' });
    } catch (err) {
      setNotification({ type: 'error', message: 'Error al crear la orden' });
    }
  };

  const handleStatusChange = async (newStatus: OrderStatus) => {
    if (!currentOrder) return;
    
    try {
      const updatedOrder = await updateOrderMutation.mutateAsync({ 
        orderId: currentOrder.id, 
        updateData: { status: newStatus } 
      });
      setCurrentOrder(updatedOrder);
      setNotification({ type: 'success', message: 'Estado actualizado exitosamente' });
    } catch (err) {
      setNotification({ type: 'error', message: 'Error al actualizar el estado' });
    }
  };

  const handleDeleteOrder = async () => {
    if (!currentOrder) return;
    
    try {
      await deleteOrderMutation.mutateAsync(currentOrder.id);
      setCurrentOrder(null);
      setSelectedOrderId(null);
      setNotification({ type: 'success', message: 'Orden eliminada exitosamente' });
    } catch (err) {
      setNotification({ type: 'error', message: 'Error al eliminar la orden' });
    }
  };

  const handleOrderIdSubmit = (orderId: string) => {
    setSelectedOrderId(orderId.trim());
  };

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Typography variant="h4" component="h1" gutterBottom sx={{ fontWeight: 'bold', mb: 3 }}>
        Gestión de Órdenes
      </Typography>

      {notification && (
        <Alert 
          severity={notification.type} 
          onClose={() => setNotification(null)}
          sx={{ mb: 3 }}
        >
          {notification.message}
        </Alert>
      )}

      <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
        <Paper elevation={2} sx={{ p: 3 }}>
          <Typography variant="h6" component="h2" gutterBottom>
            Crear Nueva Orden
          </Typography>
          <OrderForm 
            onSubmit={handleCreateOrder} 
            isPending={isPending} 
          />
        </Paper>

        <Divider />

        <Paper elevation={2} sx={{ p: 3 }}>
          <Typography variant="h6" component="h2" gutterBottom>
            Consultar Orden
          </Typography>
          <Box sx={{ display: 'flex', gap: 2, alignItems: 'center', mb: 2 }}>
            <input
              type="text"
              placeholder="Ingrese ID de orden"
              onKeyDown={(e) => {
                if (e.key === 'Enter') {
                  handleOrderIdSubmit((e.target as HTMLInputElement).value);
                }
              }}
              style={{
                padding: '10px',
                fontSize: '14px',
                borderRadius: '4px',
                border: '1px solid #ccc',
                flex: 1
              }}
            />
          </Box>

          {isPending && (
            <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}>
              <CircularProgress />
            </Box>
          )}

          {currentOrder && !isPending && (
            <Box sx={{ mt: 2 }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 'bold' }}>
                Orden: {currentOrder.id}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Cliente: {currentOrder.customerId}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Creada: {new Date(currentOrder.createdAt).toLocaleString()}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Actualizada: {new Date(currentOrder.updatedAt).toLocaleString()}
              </Typography>

              <Box sx={{ mt: 2, mb: 2 }}>
                <Typography variant="subtitle2" gutterBottom>
                  Items:
                </Typography>
                {currentOrder.items.map((item, index) => (
                  <Box key={index} sx={{ ml: 2, mb: 1 }}>
                    <Typography variant="body2">
                      Producto: {item.productId} | Cantidad: {item.quantity} | Precio: ${item.price}
                    </Typography>
                  </Box>
                ))}
              </Box>

              <Divider sx={{ my: 2 }} />

              <Typography variant="subtitle2" gutterBottom>
                Cambiar Estado:
              </Typography>
              <OrderStatusSelector
                status={currentOrder.status}
                onStatusChange={handleStatusChange}
                disabled={isPending}
              />

              <Box sx={{ mt: 3, display: 'flex', gap: 2 }}>
                <button
                  onClick={handleDeleteOrder}
                  disabled={isPending}
                  style={{
                    padding: '10px 20px',
                    backgroundColor: '#d32f2f',
                    color: 'white',
                    border: 'none',
                    borderRadius: '4px',
                    cursor: isPending ? 'not-allowed' : 'pointer',
                    opacity: isPending ? 0.6 : 1
                  }}
                >
                  Eliminar Orden
                </button>
              </Box>
            </Box>
          )}

          {error && !isPending && (
            <Alert severity="error" sx={{ mt: 2 }}>
              {error.message}
            </Alert>
          )}
        </Paper>
      </Box>
    </Container>
  );
}

// === ARCHIVO: client/src/theme.ts ===
import { createTheme } from '@mui/material/styles';

export const theme = createTheme({
  palette: {
    primary: {
      main: '#1976d2',
      light: '#42a5f5',
      dark: '#1565c0',
    },
    secondary: {
      main: '#9c27b0',
      light: '#ba68c8',
      dark: '#7b1fa2',
    },
    background: {
      default: '#f5f5f5',
      paper: '#ffffff',
    },
    error: {
      main: '#d32f2f',
    },
    warning: {
      main: '#ed6c02',
    },
    success: {
      main: '#2e7d32',
    },
    info: {
      main: '#0288d1',
    },
  },
  typography: {
    fontFamily: '"Roboto", "Helvetica", "Arial", sans-serif',
    h1: {
      fontSize: '2.5rem',
      fontWeight: 500,
    },
    h2: {
      fontSize: '2rem',
      fontWeight: 500,
    },
    h3: {
      fontSize: '1.75rem',
      fontWeight: 500,
    },
    h4: {
      fontSize: '1.5rem',
      fontWeight: 500,
    },
    h5: {
      fontSize: '1.25rem',
      fontWeight: 500,
    },
    h6: {
      fontSize: '1rem',
      fontWeight: 500,
    },
    body1: {
      fontSize: '1rem',
    },
    body2: {
      fontSize: '0.875rem',
    },
    button: {
      textTransform: 'none',
    },
  },
  shape: {
    borderRadius: 8,
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: 8,
          padding: '8px 16px',
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          padding: '16px',
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          marginBottom: '16px',
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          marginBottom: '16px',
        },
      },
    },
    MuiAppBar: {
      styleOverrides: {
        root: {
          boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
        },
      },
    },
  },
});

// === ARCHIVO: client/src/App.tsx ===
import React from 'react';
import { Box, AppBar, Toolbar, Typography, Container, CssBaseline } from '@mui/material';
import ShoppingCartIcon from '@mui/icons-material/ShoppingCart';
import { OrderPage } from './pages/OrderPage';

const App: React.FC = () => {
  return (
    <React.Fragment>
      <CssBaseline />
      <Box sx={{ flexGrow: 1 }}>
        <AppBar position="static">
          <Toolbar>
            <ShoppingCartIcon sx={{ mr: 2 }} />
            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
              Gestión de Órdenes
            </Typography>
          </Toolbar>
        </AppBar>
      </Box>
      <Container 
        maxWidth="lg" 
        sx={{ 
          mt: 4, 
          mb: 4,
          minHeight: 'calc(100vh - 64px - 48px)',
        }}
      >
        <OrderPage />
      </Container>
      <Box 
        component="footer" 
        sx={{ 
          py: 3, 
          px: 2, 
          mt: 'auto',
          backgroundColor: (theme) => theme.palette.grey[200],
        }}
      >
        <Container maxWidth="lg">
          <Typography variant="body2" color="text.secondary" align="center">
            © {new Date().getFullYear()} Sistema de Gestión de Órdenes
          </Typography>
        </Container>
      </Box>
    </React.Fragment>
  );
};

export default App;

// === ARCHIVO: infra/versions.tf ===
terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.100.0"
    }
  }
}

// === ARCHIVO: infra/providers.tf ===
provider "aws" {
  region = "us-east-1"
}

// === ARCHIVO: infra/modules/dynamodb/variables.tf ===
# Variables para el módulo DynamoDB
# Este módulo crea una tabla DynamoDB para almacenar órdenes con los atributos necesarios
# para soportar las operaciones CRUD requeridas por la aplicación.

variable "table_name" {
  description = "Nombre de la tabla DynamoDB para órdenes"
  type        = string
  default     = "orders-table"
}

variable "billing_mode" {
  description = "Modo de facturación para la tabla DynamoDB (PROVISIONED o PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Capacidad de lectura provisionada (solo aplica si billing_mode es PROVISIONED)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Capacidad de escritura provisionada (solo aplica si billing_mode es PROVISIONED)"
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "Clave hash (partition key) para la tabla DynamoDB"
  type        = string
  default     = "orderId"
}

variable "range_key" {
  description = "Clave de rango (sort key) para la tabla DynamoDB (opcional)"
  type        = string
  default     = null
}

variable "attributes" {
  description = "Lista de atributos para la tabla DynamoDB"
  type = list(object({
    name = string
    type = string
  }))
  default = [
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
    }
  ]
}

variable "global_secondary_indexes" {
  description = "Lista de índices secundarios globales para la tabla DynamoDB"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
    read_capacity   = number
    write_capacity  = number
  }))
  default = [
    {
      name            = "status-index"
      hash_key        = "status"
      range_key       = "createdAt"
      projection_type = "ALL"
      read_capacity   = 5
      write_capacity  = 5
    }
  ]
}

variable "tags" {
  description = "Tags para la tabla DynamoDB"
  type        = map(string)
  default = {
    Environment = "dev"
    Application = "orders-management"
    Terraform   = "true"
  }
}

variable "enable_stream" {
  description = "Habilitar stream para la tabla DynamoDB"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Tipo de vista del stream (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "ttl_attribute_name" {
  description = "Nombre del atributo para TTL (opcional)"
  type        = string
  default     = null
}

// === ARCHIVO: infra/modules/dynamodb/outputs.tf ===
# Outputs del módulo DynamoDB
# Estos outputs exponen los atributos necesarios para que otros módulos
# puedan referenciar la tabla DynamoDB creada.

output "table_arn" {
  description = "ARN de la tabla DynamoDB"
  value       = aws_dynamodb_table.orders_table.arn
}

output "table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.orders_table.name
}

output "table_id" {
  description = "ID de la tabla DynamoDB"
  value       = aws_dynamodb_table.orders_table.id
}

output "stream_arn" {
  description = "ARN del stream de la tabla DynamoDB (si está habilitado)"
  value       = var.enable_stream ? aws_dynamodb_table.orders_table.stream_arn : null
}

output "stream_label" {
  description = "Etiqueta del stream de la tabla DynamoDB (si está habilitado)"
  value       = var.enable_stream ? aws_dynamodb_table.orders_table.stream_label : null
}

output "global_secondary_index_names" {
  description = "Nombres de los índices secundarios globales"
  value       = [for idx in aws_dynamodb_table.orders_table.global_secondary_index : idx.name]
}

// === ARCHIVO: infra/environments/dev/terraform.tfvars ===
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

// === ARCHIVO: infra/environments/dev/main.tf ===
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

// === ARCHIVO: infra/environments/dev/variables.tf ===
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

// === ARCHIVO: infra/README.md ===
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

// === ARCHIVO: infra/modules/dynamodb/main.tf ===
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

// === ARCHIVO: infra/modules/api-gateway/main.tf ===
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

// === ARCHIVO: infra/modules/api-gateway/variables.tf ===
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

// === ARCHIVO: docker-compose.yml ===
# Infraestructura local del reto. SOLO desarrollo: credenciales de ejemplo (local-dev-only), puertos en loopback.
# Levantar: docker compose up -d --wait
name: infra-local
services:
  dynamodb-local:
    image: "amazon/dynamodb-local:2.5.2"
    command: ["-jar","DynamoDBLocal.jar","-sharedDb","-inMemory"]
    ports:
      - "127.0.0.1:8000:8000"
    healthcheck:
      test: ["CMD-SHELL","bash -c ':> /dev/tcp/127.0.0.1/8000' || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 5s


// === ARCHIVO: infra-local/README.md ===
# Infraestructura local

Servicios de soporte para el reto, definidos en `docker-compose.yml` (raiz del repo).

```bash
docker compose up -d --wait
```

| Servicio | Imagen | Puertos (host) |
|---|---|---|
| DynamoDB Local | `amazon/dynamodb-local:2.5.2` | 8000 |

Credenciales: solo de desarrollo local (`local-dev-only`, `local`). No son secretos ni deben reutilizarse.
Los scripts de `infra-local/` (tablas, topics) se ejecutan con el compose en estado healthy.


// === ARCHIVO: infra-local/dynamodb/create-tables.sh ===
#!/usr/bin/env bash
# Crea las tablas en DynamoDB Local (idempotente). Credenciales dummy: DynamoDB Local no valida firmas.
set -euo pipefail

export AWS_ACCESS_KEY_ID=local
export AWS_SECRET_ACCESS_KEY=local
export AWS_REGION=us-east-1
ENDPOINT="${DYNAMODB_ENDPOINT:-http://localhost:8000}"

create_table() {
  local name="$1" pk="$2" sk="${3:-}"
  if aws dynamodb describe-table --table-name "$name" --endpoint-url "$ENDPOINT" >/dev/null 2>&1; then
    echo "Tabla $name ya existe"
    return
  fi
  local attrs="AttributeName=$pk,AttributeType=S"
  local keys="AttributeName=$pk,KeyType=HASH"
  if [ -n "$sk" ]; then
    attrs="$attrs AttributeName=$sk,AttributeType=S"
    keys="$keys AttributeName=$sk,KeyType=RANGE"
  fi
  # shellcheck disable=SC2086
  aws dynamodb create-table --table-name "$name" --attribute-definitions $attrs --key-schema $keys \
    --billing-mode PAY_PER_REQUEST --endpoint-url "$ENDPOINT" >/dev/null
  echo "Tabla $name creada"
}

create_table "app-items" "id"

```
