# PROJECT_CONTEXT.md

## ¿Qué es este proyecto?

**RapidExpress** es un sistema académico de backend, operado exclusivamente
por **CLI (línea de comandos)**, para gestionar la flota de vehículos,
los conductores, los paquetes y las rutas de una empresa de logística
y mensajería. Reemplaza un proceso manual basado en hojas de cálculo.

Este documento es el punto de entrada para cualquier desarrollador (o
cualquier nueva conversación con Claude) que retome el proyecto. Léelo
primero, junto con `HANDOFF.md`.

## Tecnologías

- Java 17
- Maven
- MySQL 8.x (alojado en la nube — AWS RDS / Google Cloud SQL / Azure / PlanetScale)
- JDBC (`mysql-connector-j`)
- JUnit 5 (pruebas)
- Arquitectura MVC
- Git / GitHub

## Requisitos obligatorios del enunciado (resumen)

1. Interfaz **exclusivamente CLI** (sin GUI).
2. Persistencia en **MySQL**, base de datos **alojada en la nube**.
3. Arquitectura **MVC** aplicada rigurosamente.
4. Módulos funcionales:
   - Gestión de flota de vehículos (registro, estados, mantenimientos).
   - Gestión de conductores (registro, estados, asignación a vehículo).
   - Gestión de paquetes y envíos (registro, ciclo de vida de estados).
   - Planificación y seguimiento de rutas (hoja de ruta diaria, control
     de capacidad de carga, cambios de estado en cascada, consultas
     concurrentes consistentes).
   - Reportes y auditoría (reportes operativos + log de auditoría en
     archivo de texto centralizado).
5. Entregables de base de datos: ERD, `1_schema_ddl.sql`, `2_data_dml.sql`
   (mínimo 20 registros significativos por entidad principal).
6. Estructura de proyecto Maven, `README.md` profesional.
7. Git: mínimo 10 commits significativos, mínimo 2 ramas adicionales
   (`develop`, `feature/*`), `main` protegida y actualizada solo por merge.

El enunciado completo se encuentra en el mensaje original del usuario
que dio inicio a este proyecto (Fase 1) y no se repite aquí para evitar
duplicación; este documento resume únicamente lo indispensable para
retomar el trabajo.

## Estado actual (ver detalle en PROGRESS.md)

**Fase 1 — Análisis, arquitectura y base de datos: COMPLETADA.**

Se realizó:
- Análisis de requisitos funcionales, técnicos, entidades y reglas de negocio.
- Diseño de la arquitectura MVC y estructura de paquetes Java.
- Diseño completo de la base de datos (8 tablas).
- Scripts `1_schema_ddl.sql` y `2_data_dml.sql`, validados ejecutándolos
  contra un servidor MySQL/MariaDB real (sin errores, con los conteos
  de registros esperados).
- Diagrama ERD (`database/diagrama_entidad_relacion.png`), coincidente
  exactamente con el DDL.
- `pom.xml` con las dependencias mínimas necesarias.
- Estructura de paquetes Java vacía (solo carpetas, sin clases todavía).
- Documentación de continuidad (`docs/*.md`).

**NO se implementó todavía** (por instrucción explícita del alcance de
esta fase): clases de modelo, DAOs, servicios, controladores, vistas
CLI, lógica de reportes, lógica de auditoría ni lógica de rutas. Ver
`docs/HANDOFF.md` para la siguiente fase.

## Convenciones del proyecto

- Nombres de tablas y columnas en `snake_case`, en español, singular
  (`vehiculo`, no `vehiculos`).
- Nombres de clases Java en `PascalCase`, en español para entidades de
  dominio (`Vehiculo`, `Conductor`), en inglés para patrones técnicos
  genéricos (`Repository`, `Service` como sufijos).
- Los estados de negocio (`estado` de vehículo, conductor, paquete,
  ruta) se representan como `ENUM` tanto en SQL como en Java, para
  mantener la validación en ambas capas.
- El archivo `application.properties` con credenciales reales **no se
  versiona**; solo se versiona `application.properties.example`.
