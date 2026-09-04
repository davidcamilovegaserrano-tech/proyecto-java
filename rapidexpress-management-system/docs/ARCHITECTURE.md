# ARCHITECTURE.md

## Patrón de arquitectura: MVC

El sistema aplica **Modelo–Vista–Controlador** de forma directa y
comprensible, adecuada para un proyecto Java + Maven + CLI defendible
en una exposición académica (sin frameworks de inyección de
dependencias ni capas adicionales innecesarias).

```
Usuario (terminal)
      │
      ▼
   VIEW  ──────────────►  CONTROLLER  ──────────────►  SERVICE  ──────────────►  DAO  ──────►  MySQL
 (menús CLI,          (recibe la acción del        (reglas de negocio,      (acceso a
  lectura de           usuario, invoca al           validaciones,            datos, SQL
  entrada,              servicio correspondiente     orquestación entre       vía JDBC)
  impresión de          y decide qué vista           varias entidades)
  resultados)           mostrar a continuación)
      ▲                                                    │
      └──────────────── AUDIT (registro en archivo de texto, invocado desde SERVICE) ◄────┘
```

### ¿Por qué se agregan `service` y `dao` si el enunciado solo pide MVC?

El patrón MVC clásico agrupa "todo lo que no es Vista ni Controlador"
en el **Modelo**. En este proyecto, el **Modelo** se organiza en tres
paquetes para mantener el código ordenado y testeable, pero
conceptualmente los tres siguen siendo "el Modelo" de MVC:

| Paquete Java  | Rol dentro del Modelo (MVC)                                   |
|---------------|-----------------------------------------------------------------|
| `model`       | Entidades del dominio (POJOs) que representan las tablas.       |
| `dao`         | Acceso a datos: traduce entidades a SQL y viceversa (JDBC).     |
| `service`     | Reglas de negocio (ej. no exceder capacidad de un vehículo).    |

Esta subdivisión **no rompe MVC**: sigue habiendo exactamente tres
capas de responsabilidad (Vista, Controlador, Modelo); simplemente el
Modelo está internamente organizado en sub-paquetes para separar
"cómo se guardan los datos" (`dao`) de "qué reglas de negocio aplican"
(`service`), lo cual es una práctica estándar y fácil de explicar: es
más simple defender "el Modelo tiene 3 responsabilidades internas
claras" que meter reglas de negocio, SQL y estructuras de datos en una
sola clase gigante por entidad.

### Estructura de paquetes

```
com.rapidexpress
├── Main.java              # Punto de entrada; inicializa conexión y arranca la CLI
│
├── model/                 # Entidades del dominio (POJOs + enums de estado)
│   ├── Vehiculo, Conductor, Mantenimiento
│   ├── Remitente, Destinatario, Paquete
│   ├── Ruta, RutaPaquete
│   └── enums: EstadoVehiculo, EstadoConductor, EstadoPaquete, EstadoRuta...
│
├── dao/                   # Acceso a datos (JDBC), un DAO por entidad principal
│   ├── VehiculoDao, ConductorDao, MantenimientoDao
│   ├── PaqueteDao, RutaDao, RemitenteDao, DestinatarioDao
│   └── impl/ (implementaciones JDBC de las interfaces anteriores)
│
├── service/                # Lógica de negocio y orquestación entre DAOs
│   ├── VehiculoService, ConductorService
│   ├── PaqueteService, RutaService
│   └── ReporteService
│
├── controller/             # Reciben la acción elegida en el menú CLI
│   ├── VehiculoController, ConductorController
│   ├── PaqueteController, RutaController
│   └── ReporteController
│
├── view/                   # Menús e interacción por consola (System.in/out)
│   ├── MenuPrincipal
│   ├── VehiculoView, ConductorView
│   ├── PaqueteView, RutaView
│   └── ReporteView
│
├── audit/                  # Registro de auditoría en archivo de texto plano
│   └── AuditLogger
│
├── config/                 # Configuración y conexión a la base de datos
│   ├── DatabaseConfig      # Lee application.properties
│   └── ConnectionFactory   # Provee conexiones JDBC (patrón singleton simple)
│
├── exception/               # Excepciones propias del dominio
│   ├── CapacidadExcedidaException
│   ├── ConductorNoDisponibleException
│   ├── RecursoNoEncontradoException
│   └── PersistenciaException
│
└── util/                   # Utilidades transversales
    ├── InputReader          # Lectura y validación de entrada de consola
    └── Validador             # Validaciones comunes (formato, rangos, etc.)
```

### Flujo típico (ejemplo: iniciar una ruta)

1. `RutaView` muestra el menú y captura la selección de vehículo,
   conductor y paquetes a asignar.
2. `RutaController` recibe esos datos y llama a `RutaService.iniciarRuta(...)`.
3. `RutaService` valida las reglas de negocio (capacidad de carga no
   excedida, vehículo `DISPONIBLE`, conductor `ACTIVO` y sin otra ruta
   activa) y, si son válidas, orquesta los cambios usando `RutaDao`,
   `VehiculoDao`, `ConductorDao` y `PaqueteDao` dentro de una
   transacción JDBC (para mantener consistencia si varias operaciones
   concurrentes consultan el estado desde la terminal).
4. `RutaService` invoca a `AuditLogger` para registrar el evento en el
   archivo de auditoría.
5. El resultado sube de vuelta por `RutaController` a `RutaView`, que
   lo imprime en consola.

### Concurrencia

El enunciado pide que las consultas concurrentes desde la terminal
reflejen los cambios de estado de forma consistente. Dado que la
aplicación es CLI de un solo proceso, esto se resuelve principalmente
a nivel de base de datos: cada operación que modifica varias tablas
relacionadas (iniciar ruta, actualizar estado de paquete en ruta) se
ejecuta dentro de una **transacción JDBC** (`Connection.setAutoCommit(false)`
+ `commit()`/`rollback()`), garantizando que ninguna lectura vea un
estado a medio actualizar. No se requiere un pool de hilos ni
sincronización explícita en Java para el alcance de este proyecto.

### Por qué NO se usa un framework (Spring, Hibernate, etc.)

El enunciado pide un proyecto defendible por un estudiante, con JDBC
puro y MVC manual. Añadir Spring/Hibernate incrementaría la
complejidad de configuración sin aportar valor pedagógico adicional
para el alcance definido, y dificultaría explicar "a mano" cómo
funciona cada capa. Por eso `pom.xml` solo incluye `mysql-connector-j`
(persistencia) y `junit-jupiter` (pruebas).
