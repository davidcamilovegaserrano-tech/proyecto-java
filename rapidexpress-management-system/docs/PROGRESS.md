# PROGRESS.md

## Fase 1 — Análisis, arquitectura y base de datos: ✅ COMPLETADA

### Terminado

- [x] Análisis completo del enunciado (requisitos funcionales, técnicos,
      entidades, relaciones, reglas de negocio, estados, restricciones,
      operaciones críticas, concurrencia, auditoría, reportes, Git, README).
- [x] Diseño de arquitectura MVC + estructura de paquetes Java, documentada
      y justificada (`docs/ARCHITECTURE.md`).
- [x] Diseño completo de la base de datos MySQL: 8 tablas, relaciones,
      claves primarias/foráneas, restricciones (`UNIQUE`, `CHECK`), índices.
- [x] `database/1_schema_ddl.sql` — creado y **validado ejecutándolo contra
      un servidor MySQL/MariaDB real** (sin errores).
- [x] `database/2_data_dml.sql` — creado y **validado** (sin errores de
      integridad referencial). Registros: 20 vehículos, 20 conductores,
      24 mantenimientos, 20 remitentes, 20 destinatarios, 25 paquetes,
      20 rutas, 15 asociaciones ruta-paquete.
- [x] `database/diagrama_entidad_relacion.png` — generado, coincide
      exactamente con el DDL (mismas entidades, atributos, PK, FK).
- [x] `pom.xml` — configurado con Java 17, `mysql-connector-j`,
      `junit-jupiter` (test), `maven-shade-plugin` para empaquetar un jar
      ejecutable.
- [x] Estructura de carpetas Maven completa, incluyendo los paquetes Java
      vacíos (`model`, `dao`, `service`, `controller`, `view`, `audit`,
      `config`, `exception`, `util`) listos para la Fase 2.
- [x] `.gitignore` (excluye `target/`, credenciales locales, logs de
      auditoría en tiempo de ejecución, artefactos de IDE).
- [x] `src/main/resources/application.properties.example` — plantilla de
      configuración de conexión a la nube.
- [x] `README.md` completo (descripción, tecnologías, base de datos,
      instalación/ejecución, guía de uso preliminar, estructura, autores).
- [x] Documentación de continuidad: `PROJECT_CONTEXT.md`, `ARCHITECTURE.md`,
      `DATABASE.md`, `DECISIONS.md`, `PROGRESS.md` (este archivo),
      `HANDOFF.md`.

### Explícitamente fuera de alcance de esta fase (por instrucción)

- [ ] Clases Java de `model` (entidades + enums).
- [ ] Implementación de `dao` (JDBC real, `ConnectionFactory`).
- [ ] Implementación de `service` (reglas de negocio: capacidad de
      carga, unicidad de asignación de conductor, transiciones de estado).
- [ ] Implementación de `controller` y `view` (menús CLI).
- [ ] Módulo de reportes (`ReporteService` / `ReporteController` / `ReporteView`).
- [ ] Módulo de auditoría (`AuditLogger` real escribiendo a archivo).
- [ ] Módulo de rutas (creación de hoja de ruta, inicio de ruta, control
      de concurrencia con transacciones JDBC).
- [ ] Pruebas unitarias (JUnit 5).
- [ ] Clase `Main.java` (punto de entrada).
- [ ] Commits reales en Git con la estrategia de ramas (`develop`,
      `feature/*`) — la Fase 1 se preparó como archivos locales; la
      inicialización del repositorio Git y los commits reales deben
      hacerse al incorporar este contenido al repositorio de trabajo.

## Problemas pendientes / puntos de atención para la Fase 2

1. **Repositorio Git:** este entorno no crea el repositorio Git remoto
   ni realiza los commits reales sobre GitHub. Al continuar el proyecto,
   inicializar el repo (si no existe), crear las ramas `develop` y al
   menos una `feature/*`, y hacer commits significativos por cada
   módulo implementado (mínimo 10 en total).
2. **Credenciales de la nube:** `application.properties` no existe
   todavía (solo el `.example`); debe crearse localmente con las
   credenciales reales del servicio en la nube elegido antes de poder
   ejecutar la aplicación contra la base de datos remota.
3. **Validación end-to-end:** los scripts SQL se validaron contra un
   MySQL/MariaDB local en este entorno de desarrollo, no contra el
   servicio en la nube definitivo. Se recomienda re-ejecutar
   `1_schema_ddl.sql` y `2_data_dml.sql` contra la instancia en la nube
   real antes de empezar la Fase 2, para confirmar compatibilidad de
   versión/configuración del proveedor elegido.
4. **`Main.java` no existe:** `mvn clean package` compilará el
   proyecto (sin código fuente aún, solo `pom.xml`), pero no hay jar
   ejecutable funcional hasta que se implemente al menos `Main.java` y
   un flujo mínimo de CLI.

## Siguiente fase (Fase 2 sugerida)

Implementación de:
1. `model` (entidades + enums de estado).
2. `config` (`DatabaseConfig`, `ConnectionFactory`).
3. `dao` (interfaces + implementación JDBC) para `vehiculo` y `conductor`
   primero (son las entidades base, sin dependencias de otras).
4. `service` y `controller`/`view` para vehículos y conductores
   (CRUD completo + cambios de estado).
5. Repetir el patrón para `paquete`, y luego para `ruta`/`ruta_paquete`
   (el módulo más complejo, con control de capacidad y transacciones).
6. `audit` (`AuditLogger`) integrado desde el primer módulo funcional.
7. `service`/`controller`/`view` de reportes, al final, una vez existan
   datos reales generados por los módulos anteriores.

Ver `docs/HANDOFF.md` para instrucciones detalladas de cómo retomar
el desarrollo en una nueva conversación.
