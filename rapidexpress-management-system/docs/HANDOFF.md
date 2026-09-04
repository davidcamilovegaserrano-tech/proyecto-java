# HANDOFF.md

Instrucciones para continuar el proyecto RapidExpress en una nueva
conversación (con Claude u otro desarrollador), a partir del estado
dejado por la Fase 1.

## 1. Leer primero, en este orden

1. `docs/PROJECT_CONTEXT.md` — qué es el proyecto y qué exige el enunciado.
2. `docs/PROGRESS.md` — qué está hecho y qué falta exactamente.
3. `docs/ARCHITECTURE.md` — estructura de paquetes y por qué.
4. `docs/DATABASE.md` — modelo de datos y decisiones de diseño.
5. `docs/DECISIONS.md` — decisiones puntuales tomadas y su justificación.

No es necesario releer el enunciado original completo si estos
documentos ya están claros; están escritos para ser autosuficientes.

## 2. Reglas que se deben seguir respetando

- Mantener MVC como arquitectura (no introducir Spring/Hibernate).
- No modificar `1_schema_ddl.sql` sin actualizar también
  `diagrama_entidad_relacion.png` y `docs/DATABASE.md` para que sigan
  coincidiendo.
- No modificar `2_data_dml.sql` de forma que se rompan las llaves
  foráneas o se baje de 20 registros por entidad principal.
- Todo archivo de configuración con credenciales reales
  (`application.properties`) nunca debe commitearse (ya está en
  `.gitignore`).
- El registro de auditoría debe seguir siendo un archivo de texto, no
  una tabla SQL (ver decisión D-003 en `DECISIONS.md`).
- Seguir la convención de nombres ya establecida (`snake_case` en SQL,
  `PascalCase` en Java, entidades en español).

## 3. Cómo continuar el desarrollo (orden sugerido)

### Paso 1 — Configuración base
- Implementar `com.rapidexpress.config.DatabaseConfig` (lee
  `application.properties` desde el classpath).
- Implementar `com.rapidexpress.config.ConnectionFactory` (entrega
  `java.sql.Connection` usando `mysql-connector-j`).
- Implementar `com.rapidexpress.audit.AuditLogger` (escribe líneas con
  timestamp + operación + detalle al archivo indicado en
  `audit.file.path`).

### Paso 2 — Módulo Vehículo (referencia para los demás módulos)
- `model.Vehiculo` + `model.enums.EstadoVehiculo`.
- `dao.VehiculoDao` (interfaz) + `dao.impl.VehiculoDaoJdbc`.
- `service.VehiculoService` (registrar, actualizar estado, listar,
  registrar mantenimiento vía `MantenimientoDao`).
- `controller.VehiculoController` + `view.VehiculoView`.
- Usar este módulo como plantilla de estilo/estructura para los
  siguientes (los patrones de nombres de métodos, manejo de
  excepciones, etc. deben ser consistentes entre módulos).

### Paso 3 — Módulo Conductor
- Igual patrón que Vehículo.
- Regla de negocio clave a implementar en `ConductorService` o
  `RutaService` (a decidir en esa fase): un conductor no puede
  asignarse a una ruta si ya tiene una ruta `PLANIFICADA` o `EN_CURSO`.

### Paso 4 — Módulo Paquete
- Igual patrón. Generar `codigo_seguimiento` único en la capa de
  aplicación (ej. `RE-<año>-<secuencial>`), validando unicidad antes
  del `INSERT` (la restricción `UNIQUE` en SQL es el respaldo final).

### Paso 5 — Módulo Ruta (el más complejo)
- `RutaService.crearHojaDeRuta(...)`: valida que la suma de `peso_kg`
  de los paquetes candidatos no exceda `capacidad_carga_kg` del
  vehículo, y que todos los paquetes estén en estado `EN_BODEGA`.
- `RutaService.iniciarRuta(...)`: dentro de una transacción JDBC,
  cambia `vehiculo.estado = EN_RUTA`, `conductor.estado` (definir si se
  agrega un estado operativo o se controla solo por la ruta activa —
  documentar la decisión en `DECISIONS.md` si se toma), y
  `paquete.estado = EN_TRANSITO` para todos los paquetes de esa ruta.
- `RutaService.registrarEntregaPaquete(...)`: actualiza
  `ruta_paquete.estado_entrega` y `paquete.estado` de forma consistente
  mientras la ruta está en curso.
- Todas las operaciones anteriores deben registrar auditoría.

### Paso 6 — Reportes
- `ReporteService`: consultas de "entregas por conductor en un rango de
  fechas" (join `ruta` + `ruta_paquete` + `paquete` filtrando por
  `id_conductor` y `fecha_ruta`), e "historial de rutas de un
  vehículo".

### Paso 7 — `Main.java` y menú principal
- Ensambla todas las capas, crea el menú principal de la CLI que
  navega a los sub-menús de cada módulo.

### Paso 8 — Pruebas
- JUnit 5 sobre `service` (reglas de negocio), no es necesario probar
  DAOs contra la base real en el mismo alcance académico salvo que se
  quiera profundizar.

## 4. Git — pendiente de esta fase

Este entorno preparó el contenido como archivos locales, no como
historial Git real. Al incorporar este contenido al repositorio de
trabajo:

1. `git init` (si no existe) y primer commit con la estructura de la
   Fase 1 completa (este es un commit significativo válido).
2. Crear rama `develop` a partir de `main`.
3. Por cada módulo del Paso 2 al Paso 7, trabajar en una rama
   `feature/nombre-del-modulo` desde `develop`, y hacer merge a
   `develop` al terminarlo.
4. Al cerrar cada fase estable, merge de `develop` a `main`.
5. Asegurar mínimo 10 commits significativos en total y mínimo 2 ramas
   adicionales — esto se cumple naturalmente si se sigue un commit por
   paso/capa en vez de un único commit gigante por módulo.

## 5. Checklist antes de dar por cerrado el proyecto completo

- [ ] Todos los módulos del enunciado implementados y probados
      manualmente desde la CLI.
- [ ] `README.md` actualizado (quitar la nota de "Fase 1 completada" y
      completar la "Guía de Uso" con el flujo real de menús).
- [ ] `docs/PROGRESS.md` actualizado reflejando el 100% de avance.
- [ ] Auditoría verificada: cada operación crítica queda registrada en
      el archivo de texto.
- [ ] Reportes verificados con los datos de `2_data_dml.sql` (o datos
      adicionales insertados durante las pruebas).
- [ ] Al menos 20 registros por entidad principal siguen presentes
      (no se deben haber eliminado durante las pruebas manuales sin
      volver a poblar).
- [ ] Git: mínimo 10 commits, mínimo 2 ramas adicionales, `main` limpia.
