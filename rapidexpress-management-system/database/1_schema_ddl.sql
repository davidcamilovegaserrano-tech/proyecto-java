-- =========================================================================
-- RapidExpress - Sistema de Gestion de Flotas y Rutas
-- Script DDL: creacion de esquema y tablas
-- Motor: MySQL 8.x
-- =========================================================================
--
-- Notas de diseno:
--  - Los "estados" de negocio (vehiculo, conductor, paquete, ruta) se
--    modelan con ENUM porque son catalogos cerrados y pequenos, definidos
--    explicitamente en el enunciado. No se crean tablas de catalogo
--    separadas para evitar joins innecesarios en un proyecto academico
--    de alcance acotado.
--  - El registro de auditoria NO se modela en la base de datos: el
--    enunciado pide explicitamente que se centralice en un archivo de
--    texto ("Esta informacion debe ser registrada en un archivo de texto
--    centralizado"), por lo que se implementara en la capa de aplicacion
--    (paquete com.rapidexpress.audit), no como tabla SQL.
--  - RUTA_PAQUETE es una tabla de asociacion (N:M) entre RUTA y PAQUETE,
--    ya que una hoja de ruta agrupa varios paquetes y, en el modelo,
--    un paquete pertenece a una unica ruta activa a la vez; se usa una
--    tabla de asociacion (en vez de una FK directa en PAQUETE) para dejar
--    explicito el historial de que paquetes viajaron en que ruta, y para
--    poder registrar el estado de entrega de cada paquete dentro de esa
--    ruta especifica (fecha_entrega_real, observaciones).
--
-- =========================================================================

DROP DATABASE IF EXISTS rapidexpress_db;
CREATE DATABASE rapidexpress_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE rapidexpress_db;

-- -------------------------------------------------------------------------
-- Tabla: vehiculo
-- -------------------------------------------------------------------------
CREATE TABLE vehiculo (
    id_vehiculo         INT AUTO_INCREMENT PRIMARY KEY,
    placa               VARCHAR(10)     NOT NULL,
    marca               VARCHAR(50)     NOT NULL,
    modelo              VARCHAR(50)     NOT NULL,
    anio_fabricacion    SMALLINT        NOT NULL,
    capacidad_carga_kg  DECIMAL(8,2)    NOT NULL,
    estado              ENUM('DISPONIBLE', 'EN_RUTA', 'EN_MANTENIMIENTO')
                                        NOT NULL DEFAULT 'DISPONIBLE',
    fecha_registro      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_vehiculo_placa UNIQUE (placa),
    CONSTRAINT chk_vehiculo_anio CHECK (anio_fabricacion >= 1980),
    CONSTRAINT chk_vehiculo_capacidad CHECK (capacidad_carga_kg > 0)
) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Tabla: conductor
-- -------------------------------------------------------------------------
CREATE TABLE conductor (
    id_conductor            INT AUTO_INCREMENT PRIMARY KEY,
    numero_identificacion   VARCHAR(20)     NOT NULL,
    nombre_completo         VARCHAR(120)    NOT NULL,
    tipo_licencia           VARCHAR(10)     NOT NULL,
    numero_contacto         VARCHAR(20)     NOT NULL,
    estado                  ENUM('ACTIVO', 'DE_VACACIONES', 'INACTIVO')
                                             NOT NULL DEFAULT 'ACTIVO',
    fecha_registro          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_conductor_identificacion UNIQUE (numero_identificacion)
) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Tabla: mantenimiento
-- Historial de mantenimientos por vehiculo (1 vehiculo : N mantenimientos)
-- -------------------------------------------------------------------------
CREATE TABLE mantenimiento (
    id_mantenimiento    INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo         INT             NOT NULL,
    tipo_mantenimiento  VARCHAR(50)     NOT NULL,
    descripcion         VARCHAR(255)    NOT NULL,
    fecha_programada    DATE            NOT NULL,
    fecha_realizado     DATE            NULL,
    costo               DECIMAL(10,2)   NULL,
    taller               VARCHAR(100)   NULL,

    CONSTRAINT fk_mantenimiento_vehiculo
        FOREIGN KEY (id_vehiculo) REFERENCES vehiculo (id_vehiculo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Tabla: remitente
-- -------------------------------------------------------------------------
CREATE TABLE remitente (
    id_remitente    INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(120)    NOT NULL,
    direccion       VARCHAR(200)    NOT NULL,
    telefono        VARCHAR(20)     NOT NULL,
    email           VARCHAR(120)    NULL
) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Tabla: destinatario
-- -------------------------------------------------------------------------
CREATE TABLE destinatario (
    id_destinatario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(120)    NOT NULL,
    direccion       VARCHAR(200)    NOT NULL,
    telefono        VARCHAR(20)     NOT NULL,
    email           VARCHAR(120)    NULL
) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Tabla: paquete
-- -------------------------------------------------------------------------
CREATE TABLE paquete (
    id_paquete          INT AUTO_INCREMENT PRIMARY KEY,
    codigo_seguimiento  VARCHAR(20)     NOT NULL,
    descripcion         VARCHAR(255)    NOT NULL,
    peso_kg             DECIMAL(8,2)    NOT NULL,
    largo_cm            DECIMAL(6,2)    NOT NULL,
    ancho_cm            DECIMAL(6,2)    NOT NULL,
    alto_cm             DECIMAL(6,2)    NOT NULL,
    direccion_origen    VARCHAR(200)    NOT NULL,
    direccion_destino   VARCHAR(200)    NOT NULL,
    id_remitente        INT             NOT NULL,
    id_destinatario     INT             NOT NULL,
    estado              ENUM('EN_BODEGA', 'ASIGNADO_A_RUTA', 'EN_TRANSITO',
                              'ENTREGADO', 'DEVUELTO')
                                         NOT NULL DEFAULT 'EN_BODEGA',
    fecha_registro      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_paquete_codigo UNIQUE (codigo_seguimiento),
    CONSTRAINT chk_paquete_peso CHECK (peso_kg > 0),

    CONSTRAINT fk_paquete_remitente
        FOREIGN KEY (id_remitente) REFERENCES remitente (id_remitente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_paquete_destinatario
        FOREIGN KEY (id_destinatario) REFERENCES destinatario (id_destinatario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Tabla: ruta
-- Hoja de ruta diaria: un vehiculo + un conductor + una fecha
-- -------------------------------------------------------------------------
CREATE TABLE ruta (
    id_ruta         INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo     INT             NOT NULL,
    id_conductor    INT             NOT NULL,
    fecha_ruta      DATE            NOT NULL,
    estado          ENUM('PLANIFICADA', 'EN_CURSO', 'FINALIZADA', 'CANCELADA')
                                     NOT NULL DEFAULT 'PLANIFICADA',
    hora_inicio     DATETIME        NULL,
    hora_fin        DATETIME        NULL,
    observaciones   VARCHAR(255)    NULL,

    CONSTRAINT fk_ruta_vehiculo
        FOREIGN KEY (id_vehiculo) REFERENCES vehiculo (id_vehiculo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_ruta_conductor
        FOREIGN KEY (id_conductor) REFERENCES conductor (id_conductor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Tabla: ruta_paquete
-- Asociacion N:M entre ruta y paquete (que paquetes viajan en cada ruta)
-- -------------------------------------------------------------------------
CREATE TABLE ruta_paquete (
    id_ruta                 INT             NOT NULL,
    id_paquete              INT             NOT NULL,
    orden_entrega           SMALLINT        NULL,
    estado_entrega          ENUM('PENDIENTE', 'ENTREGADO', 'DEVUELTO')
                                             NOT NULL DEFAULT 'PENDIENTE',
    fecha_entrega_real      DATETIME        NULL,
    observaciones_entrega   VARCHAR(255)    NULL,

    PRIMARY KEY (id_ruta, id_paquete),

    CONSTRAINT fk_rutapaquete_ruta
        FOREIGN KEY (id_ruta) REFERENCES ruta (id_ruta)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_rutapaquete_paquete
        FOREIGN KEY (id_paquete) REFERENCES paquete (id_paquete)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Indices adicionales para consultas frecuentes de reportes
-- -------------------------------------------------------------------------
CREATE INDEX idx_paquete_estado       ON paquete (estado);
CREATE INDEX idx_vehiculo_estado      ON vehiculo (estado);
CREATE INDEX idx_conductor_estado     ON conductor (estado);
CREATE INDEX idx_ruta_fecha           ON ruta (fecha_ruta);
CREATE INDEX idx_ruta_estado          ON ruta (estado);
CREATE INDEX idx_mantenimiento_vehiculo_fecha
    ON mantenimiento (id_vehiculo, fecha_programada);
