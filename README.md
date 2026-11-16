# Implementación de operaciones CRUD de ordenes en DynamoDB

El sistema debe permitir la gestión de ordenes en DynamoDB a través de una interfaz de usuario construida con React. La UI debe permitir crear una orden y cambiar su estado. Se utilizará Vite como herramienta de build y se manejará el estado local con hooks, sin Redux Toolkit.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | Persistir ordenes en DynamoDB desde la interfaz |
| **Nivel** | advanced-l2 |
| **Tipo** | practical |
| **Tiempo estimado** | 10 horas |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Obtener el proyecto base funcional enviando el Código Base a un asistente de IA, que lo analizará, corregirá errores y entregará cada archivo con su ruta.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Asegúrate de tener instalado para ejecutar el proyecto: Node.js 18+, npm, VS Code o similar.
- Copia todo el contenido del campo **Código Base** de este reto — incluyendo el texto de instrucciones que aparece al inicio.
- Abre un asistente de IA (Claude en claude.ai, ChatGPT o Gemini — se recomienda Claude), pega el contenido copiado en el chat y envíalo.
- El asistente analizará los archivos, corregirá errores y entregará cada archivo con su ruta. Guárdalos en la carpeta donde quieras trabajar, respetando las rutas.
- Ejecuta `npm install && npm run build` (o `npm start`). Si no hay errores, estás listo.

**Entregable:** El proyecto compila/arranca sin errores.

<details>
<summary>Pistas de conocimiento</summary>

- Copia el Código Base completo incluyendo el texto de instrucciones al inicio — esas instrucciones le indican al asistente exactamente qué hacer con los archivos.
- Si el asistente no entrega todos los archivos al terminar el análisis, escríbele: "entrégame todos los archivos con su ruta".
- Si el proyecto tiene errores al arrancar, comparte el mensaje de error con el mismo asistente para que lo corrija.

</details>

### Fase 1: Configuración del entorno y creación de la API

**Objetivo:** Configurar el entorno de desarrollo y crear la API para gestionar ordenes en DynamoDB.

**Tiempo estimado:** 3 horas

**Instrucciones:**

- Configurar el proyecto con Vite y React.
- Crear la estructura básica de la API para las operaciones CRUD de ordenes.
- Asegurar que la API pueda comunicarse con DynamoDB.

**Entregable:** API funcional para crear y leer ordenes en DynamoDB.

<details>
<summary>Pistas de conocimiento</summary>

- Uso de Vite para configurar el proyecto React.
- Creación de endpoints REST en la API para las operaciones CRUD.

</details>

### Fase 2: Implementación de la lógica de negocio

**Objetivo:** Implementar la lógica de negocio para las operaciones CRUD de ordenes.

**Tiempo estimado:** 4 horas

**Instrucciones:**

- Desarrollar la lógica de negocio para crear, leer, actualizar y eliminar ordenes en DynamoDB.
- Asegurar que la lógica de negocio maneje correctamente los errores y las validaciones.
- Implementar la funcionalidad para cambiar el estado de una orden.

**Entregable:** Lógica de negocio completa para las operaciones CRUD de ordenes en DynamoDB.

<details>
<summary>Pistas de conocimiento</summary>

- Manejo de errores y validaciones en la lógica de negocio.
- Uso de hooks para gestionar el estado local en React.

</details>

### Fase 3: Versionado de la infraestructura

**Objetivo:** Versionar la infraestructura utilizando Terraform.

**Tiempo estimado:** 3 horas

**Instrucciones:**

- Configurar Terraform para versionar la infraestructura de la API y DynamoDB.
- Asegurar que la infraestructura versionada pueda desplegarse y funcionar correctamente.
- Documentar el proceso de versionado y despliegue.

**Entregable:** Infraestructura versionada y documentada para la API y DynamoDB.

<details>
<summary>Pistas de conocimiento</summary>

- Uso de Terraform para versionar la infraestructura.
- Documentación del proceso de versionado y despliegue.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es una operación CRUD en el contexto de este reto?
- **paraQueSirve**: ¿Para qué sirve la lógica de negocio implementada en este reto?
- **comoSeUsa**: ¿Cómo se usa Terraform para versionar la infraestructura en este reto?
- **erroresComunes**: ¿Cuáles son los errores comunes que pueden ocurrir al implementar la lógica de negocio para las operaciones CRUD de ordenes?
- **queDecisionesImplica**: ¿Qué decisiones implica el versionado de la infraestructura utilizando Terraform en este reto?

## Criterios de Evaluacion

- Configuración correcta del entorno de desarrollo con Vite y React.
- Creación de una API funcional para las operaciones CRUD de ordenes en DynamoDB.
- Implementación de la lógica de negocio para las operaciones CRUD de ordenes, incluyendo el manejo de errores y validaciones.
- Implementación de la funcionalidad para cambiar el estado de una orden.
- Versionado correcto de la infraestructura utilizando Terraform.
- Documentación clara y concisa del proceso de versionado y despliegue.

## Como trabajar con un asistente de IA

Hay dos caminos, elegi uno:

- **AGENTS.md** (recomendado) — instrucciones nativas del repo. Abri esta carpeta con tu agente local (Claude Code, Cursor, Codex, Copilot, Gemini) y las carga solo. Sabe que archivos faltan y con que comando se verifica, y completa el scaffold escribiendo en disco.
- **PROMPT_MEJORA.md** — para copiar y pegar en un chat (claude.ai, ChatGPT) si no tenes un agente en el IDE. Declara lo mismo que AGENTS.md; los archivos que te devuelva el chat los guardas en esta carpeta respetando las rutas.

Ninguno de los dos resuelve las fases del reto: eso es tu trabajo.

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

## Verificacion

El proyecto esta listo para trabajar cuando este comando corre sin errores:

```bash
(cd api && npm install --no-audit --no-fund && npm run build) && (cd client && npm install --no-audit --no-fund && npm run build) && (cd infra && terraform init -backend=false && terraform -chdir=environments/dev init -backend=false && terraform -chdir=modules/api-gateway init -backend=false && terraform -chdir=modules/dynamodb init -backend=false && terraform validate && terraform -chdir=environments/dev validate && terraform -chdir=modules/api-gateway validate && terraform -chdir=modules/dynamodb validate) && docker compose config -q
```

---

*Reto generado automaticamente por Challenge Generator - Pragma*
