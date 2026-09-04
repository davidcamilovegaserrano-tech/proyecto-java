# DECISIONS.md

Registro de decisiones importantes tomadas durante el proyecto, en
orden cronológico. Cada entrada incluye el contexto, la decisión y la
razón, para que futuras conversaciones/desarrolladores entiendan el
"por qué" sin tener que releer todo el enunciado.

---

## D-001 — Subdivisión del Modelo en `model` / `dao` / `service`

**Contexto:** MVC estricto agrupa toda la lógica no-Vista/no-Controlador
en un único "Modelo".
**Decisión:** dividir el Modelo en tres paquetes Java (`model`, `dao`,
`service`) sin dejar de considerarlos conceptualmente parte del Modelo.
**Razón:** separar entidades, acceso a datos y reglas de negocio hace
el código más fácil de mantener y de explicar en una exposición, sin
añadir capas de arquitectura extra (no se rompe MVC).

## D-002 — `remitente` y `destinatario` como tablas separadas

**Contexto:** ambos comparten los mismos atributos (nombre, dirección,
teléfono, email).
**Decisión:** modelarlos como tablas independientes en vez de una tabla
`persona` compartida con un campo de rol.
**Razón:** simplifica las consultas de reportes y evita una tabla y una
columna de "tipo" adicionales que no aportan valor al alcance del
proyecto. Ver detalle en `DATABASE.md`.

## D-003 — Auditoría en archivo de texto, no en base de datos

**Contexto:** el enunciado exige explícitamente que la auditoría se
registre en "un archivo de texto centralizado".
**Decisión:** implementar `AuditLogger` como clase de aplicación que
escribe a un archivo plano, y **no** crear una tabla `auditoria` en MySQL.
**Razón:** seguir el enunciado literalmente; agregar una tabla habría
sido una funcionalidad no pedida en ese punto específico.

## D-004 — `ruta_paquete` como tabla de asociación N:M

**Contexto:** una ruta agrupa varios paquetes; en principio podría
pensarse en una FK `id_ruta` directamente en `paquete`.
**Decisión:** crear una tabla de asociación `ruta_paquete` en vez de una
FK directa en `paquete`.
**Razón:** un paquete puede pasar por más de una ruta a lo largo de su
ciclo de vida (ej. devuelto y reasignado), y la tabla de asociación
permite además registrar el estado de entrega específico de ese
paquete **en esa ruta** (necesario para reportes de entregas por
conductor/fecha) sin duplicar esa información en `paquete`.

## D-005 — Estados de negocio como `ENUM` en SQL (no tablas de catálogo)

**Contexto:** el enunciado define catálogos cerrados y pequeños de
estados para vehículo, conductor, paquete y ruta.
**Decisión:** usar `ENUM` de MySQL en vez de tablas de catálogo
(`estado_vehiculo`, etc.) con FK.
**Razón:** los catálogos son fijos, pequeños y definidos explícitamente
en el enunciado; usar tablas de catálogo añadiría joins innecesarios
para un proyecto académico de alcance acotado, sin beneficio real dado
que no se espera que estos catálogos cambien dinámicamente.

## D-006 — Sin frameworks adicionales (Spring, Hibernate, etc.)

**Contexto:** el proyecto debe ser "comprensible para un estudiante y
fácil de defender en una exposición".
**Decisión:** usar JDBC puro (`mysql-connector-j`) y MVC implementado
a mano, sin frameworks de inyección de dependencias ni ORM.
**Razón:** minimiza la curva de configuración y hace que cada capa sea
explicable línea por línea en una defensa oral.

## D-007 — Estado `PLANIFICADA` y `CANCELADA` agregados a `ruta`

**Contexto:** el enunciado menciona que "al iniciar una ruta" cambian
los estados de vehículo/conductor/paquetes, lo cual implica que existe
un momento previo (la ruta creada pero no iniciada).
**Decisión:** el `ENUM` de `ruta.estado` incluye `PLANIFICADA` (creada,
no iniciada), `EN_CURSO` (iniciada), `FINALIZADA` y `CANCELADA`.
**Razón:** `PLANIFICADA` es necesaria para distinguir "hoja de ruta
creada" de "ruta iniciada", ambos mencionados por separado en el
enunciado. `CANCELADA` se agregó como estado operativo razonable y
mínimo (una ruta planificada puede no llegar a ejecutarse); no se
agregaron más estados que los estrictamente justificables por el
enunciado o su operación básica.

## D-008 — Transacciones JDBC para consistencia de concurrencia

**Contexto:** el enunciado exige que las consultas concurrentes desde
la terminal reflejen los cambios de estado de forma consistente.
**Decisión:** las operaciones que modifican varias tablas relacionadas
(iniciar ruta, actualizar estado de paquete en ruta) se ejecutarán
dentro de una transacción JDBC explícita.
**Razón:** es la herramienta estándar y suficiente para garantizar
consistencia en una aplicación CLI de un solo proceso, sin necesidad de
mecanismos de concurrencia más complejos (locks manuales, colas, etc.)
que excederían el alcance académico del proyecto.
