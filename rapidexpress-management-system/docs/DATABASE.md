# DATABASE.md

## Motor y base de datos

MySQL 8.x, base de datos `rapidexpress_db`, charset `utf8mb4`. Alojada
en un servicio en la nube a elección (AWS RDS, Google Cloud SQL, Azure
Database for MySQL, PlanetScale, etc.) — ver `README.md` para la guía
de configuración.

## Diagrama ERD

`database/diagrama_entidad_relacion.png` — generado a partir del mismo
modelo que `1_schema_ddl.sql`; ambos deben mantenerse sincronizados si
se modifica el esquema.

## Entidades

### `vehiculo`
Representa cada unidad de la flota. `estado` es un `ENUM('DISPONIBLE',
'EN_RUTA', 'EN_MANTENIMIENTO')` porque el enunciado define exactamente
esos tres valores como catálogo cerrado. `placa` es `UNIQUE`.

### `conductor`
Personal de conducción. `estado` es `ENUM('ACTIVO', 'DE_VACACIONES',
'INACTIVO')`. `numero_identificacion` es `UNIQUE`. La regla de negocio
"un conductor no puede estar asignado a más de un vehículo
simultáneamente" **no se modela con una FK directa** en `conductor`
(eso limitaría el historial); se controla a nivel de aplicación
(`RutaService`) verificando que el conductor no tenga ya una `ruta` con
`estado IN ('PLANIFICADA','EN_CURSO')` antes de asignarlo a una nueva.

### `mantenimiento`
Historial de mantenimientos de un vehículo. Relación **1 (vehiculo) : N
(mantenimiento)** vía `id_vehiculo`. Se persiste de forma individual
por vehículo, tal como exige el enunciado, permitiendo consultar el
historial completo de cualquier vehículo.

### `remitente` / `destinatario`
Se modelan como **dos tablas separadas** (en vez de una única tabla
`persona` compartida) porque:
- Sus roles y su ciclo de vida en el sistema son distintos (uno origina
  el envío, el otro lo recibe).
- Evita una tabla intermedia de "rol" innecesaria para el alcance del
  proyecto.
- Simplifica las consultas de reportes ("paquetes enviados por X",
  "paquetes recibidos por Y") al no requerir filtrar por rol.

### `paquete`
Núcleo de la operación. Relación **N:1** con `remitente` y **N:1** con
`destinatario`. `codigo_seguimiento` es el identificador único de
seguimiento exigido por el enunciado (`UNIQUE`, formato aplicativo
`RE-AAAA-NNNN`). `estado` es `ENUM('EN_BODEGA', 'ASIGNADO_A_RUTA',
'EN_TRANSITO', 'ENTREGADO', 'DEVUELTO')`, reflejando exactamente el
ciclo de vida descrito en el enunciado.

### `ruta`
Representa la "hoja de ruta" diaria: un `vehiculo` + un `conductor` +
una `fecha_ruta`. Relación **N:1** con `vehiculo` y **N:1** con
`conductor` (un vehículo/conductor puede tener muchas rutas a lo largo
del tiempo, pero cada ruta tiene exactamente un vehículo y un
conductor). `estado` incluye `CANCELADA` además de los tres estados
explícitos del enunciado (`PLANIFICADA` se agregó como estado inicial
antes de `EN_CURSO`, ya que el enunciado distingue "creación de la hoja
de ruta" de "inicio de la ruta").

### `ruta_paquete` (tabla de asociación N:M)
Una ruta agrupa varios paquetes, y a lo largo del tiempo un paquete
puede pertenecer a más de una ruta (por ejemplo, si es devuelto y
reasignado a una ruta posterior), por lo que la relación entre `ruta`
y `paquete` es **N:M**, resuelta con esta tabla de asociación con
clave primaria compuesta (`id_ruta`, `id_paquete`). Además de resolver
la relación N:M, esta tabla registra el **estado de entrega de ese
paquete específico dentro de esa ruta específica**
(`estado_entrega`, `fecha_entrega_real`), lo cual es necesario para los
reportes de "entregas realizadas por un conductor en un rango de
fechas" sin tener que inferirlo de otra tabla.

## Por qué NO hay tabla de auditoría en la base de datos

El enunciado especifica explícitamente: *"Esta información debe ser
registrada en un archivo de texto centralizado"*. Por lo tanto, la
auditoría se implementa en la capa de aplicación (`com.rapidexpress.audit.AuditLogger`)
escribiendo a un archivo de texto plano (ver `ARCHITECTURE.md`), no
como tabla SQL. Crear una tabla `auditoria` habría sido una
funcionalidad no solicitada por el enunciado en ese punto específico.

## Restricciones y reglas de negocio reflejadas en el esquema

| Regla de negocio                                             | Cómo se refleja en SQL                                             |
|----------------------------------------------------------------|----------------------------------------------------------------------|
| Estados válidos cerrados por entidad                            | `ENUM` en cada columna `estado`                                      |
| Placa de vehículo única                                         | `UNIQUE (placa)`                                                     |
| Identificación de conductor única                                | `UNIQUE (numero_identificacion)`                                     |
| Código de seguimiento de paquete único                           | `UNIQUE (codigo_seguimiento)`                                        |
| Capacidad de carga no puede ser negativa/cero                    | `CHECK (capacidad_carga_kg > 0)`                                     |
| Peso de paquete debe ser positivo                                | `CHECK (peso_kg > 0)`                                                |
| No exceder la capacidad de carga del vehículo en una ruta         | **No se puede expresar declarativamente en SQL estándar**; se valida en `RutaService` sumando `peso_kg` de los paquetes candidatos antes de confirmar la asignación |
| Un conductor no en más de un vehículo a la vez                    | Se valida en `RutaService` (ver sección `conductor` arriba)          |
| Historial de mantenimiento por vehículo                          | FK `mantenimiento.id_vehiculo → vehiculo.id_vehiculo`, `ON DELETE CASCADE` |

## Índices adicionales

Se agregaron índices sobre las columnas `estado` de `vehiculo`,
`conductor`, `paquete` y `ruta`, sobre `ruta.fecha_ruta` y sobre
`mantenimiento(id_vehiculo, fecha_programada)`, ya que son los filtros
más frecuentes esperados en los reportes operativos (listar vehículos
disponibles, paquetes en tránsito, rutas de una fecha, historial de un
vehículo).

## Datos de ejemplo (`2_data_dml.sql`)

Poblado con datos coherentes entre sí y respetando las llaves foráneas:

| Tabla           | Registros |
|-----------------|-----------|
| `vehiculo`       | 20        |
| `conductor`      | 20        |
| `mantenimiento`  | 24        |
| `remitente`      | 20        |
| `destinatario`   | 20        |
| `paquete`        | 25        |
| `ruta`           | 20        |
| `ruta_paquete`   | 15        |

Los estados de cada entidad se distribuyeron de forma variada (no todos
`DISPONIBLE` / `ACTIVO` / `EN_BODEGA`) para que los reportes y consultas
de la Fase 2 tengan datos realistas con los que trabajar desde el
primer momento.

**Validación realizada:** ambos scripts (`1_schema_ddl.sql` y
`2_data_dml.sql`) se ejecutaron contra un servidor MySQL/MariaDB real
en el entorno de desarrollo, sin errores, confirmando los conteos de
registros anteriores y la integridad referencial completa.
