-- =========================================================================
-- RapidExpress - Sistema de Gestion de Flotas y Rutas
-- Script DML: datos iniciales (minimo 20 registros por entidad principal)
-- =========================================================================

USE rapidexpress_db;

-- -------------------------------------------------------------------------
-- vehiculo (20 registros)
-- -------------------------------------------------------------------------
INSERT INTO vehiculo (placa, marca, modelo, anio_fabricacion, capacidad_carga_kg, estado) VALUES
('PTS100', 'Chevrolet', 'NPR', 2020, 1500.00, 'EN_MANTENIMIENTO'),
('LGW101', 'Chevrolet', 'NHR', 2016, 3000.00, 'DISPONIBLE'),
('JDY102', 'Hino', '300', 2019, 1000.00, 'EN_RUTA'),
('CCW103', 'Hino', '500', 2023, 2000.00, 'DISPONIBLE'),
('VTN104', 'Isuzu', 'ELF', 2020, 1000.00, 'DISPONIBLE'),
('PVQ105', 'Isuzu', 'NPR', 2019, 1500.00, 'DISPONIBLE'),
('SBF106', 'Ford', 'Transit', 2018, 1000.00, 'EN_RUTA'),
('WWK107', 'Renault', 'Master', 2021, 2500.00, 'EN_MANTENIMIENTO'),
('DJS108', 'Nissan', 'NP300', 2024, 1000.00, 'DISPONIBLE'),
('QET109', 'Toyota', 'Hiace', 2016, 3500.00, 'DISPONIBLE'),
('KZR110', 'Mercedes-Benz', 'Sprinter', 2022, 1500.00, 'EN_RUTA'),
('SWU111', 'Volkswagen', 'Delivery', 2017, 800.00, 'DISPONIBLE'),
('VKB112', 'Kia', 'Bongo', 2023, 2500.00, 'DISPONIBLE'),
('FMX113', 'Foton', 'Aumark', 2024, 3500.00, 'DISPONIBLE'),
('DDT114', 'JAC', 'N-Series', 2022, 2000.00, 'DISPONIBLE'),
('TLQ115', 'Dongfeng', 'Duolika', 2019, 1500.00, 'EN_RUTA'),
('ZDM116', 'Fuso', 'Canter', 2014, 1000.00, 'DISPONIBLE'),
('DDS117', 'Iveco', 'Daily', 2023, 1000.00, 'DISPONIBLE'),
('KQM118', 'Hyundai', 'Porter', 2018, 800.00, 'DISPONIBLE'),
('SCX119', 'Mazda', 'Titan', 2018, 2500.00, 'DISPONIBLE');

-- -------------------------------------------------------------------------
-- conductor (20 registros)
-- -------------------------------------------------------------------------
INSERT INTO conductor (numero_identificacion, nombre_completo, tipo_licencia, numero_contacto, estado) VALUES
('1020000000', 'Carlos Ramirez', 'B2', '3001000000', 'ACTIVO'),
('1020000137', 'Maria Fernandez', 'C2', '3001000731', 'INACTIVO'),
('1020000274', 'Jose Gomez', 'C2', '3001001462', 'DE_VACACIONES'),
('1020000411', 'Laura Torres', 'B1', '3001002193', 'ACTIVO'),
('1020000548', 'Andres Diaz', 'C2', '3001002924', 'INACTIVO'),
('1020000685', 'Camila Rojas', 'B3', '3001003655', 'DE_VACACIONES'),
('1020000822', 'Luis Martinez', 'C1', '3001004386', 'ACTIVO'),
('1020000959', 'Paula Sanchez', 'B1', '3001005117', 'ACTIVO'),
('1020001096', 'Diego Herrera', 'B1', '3001005848', 'ACTIVO'),
('1020001233', 'Valentina Castro', 'B3', '3001006579', 'ACTIVO'),
('1020001370', 'Sergio Morales', 'B3', '3001007310', 'ACTIVO'),
('1020001507', 'Daniela Ortiz', 'B2', '3001008041', 'ACTIVO'),
('1020001644', 'Felipe Vargas', 'B1', '3001008772', 'DE_VACACIONES'),
('1020001781', 'Natalia Rios', 'B2', '3001009503', 'ACTIVO'),
('1020001918', 'Julian Pena', 'C2', '3001010234', 'ACTIVO'),
('1020002055', 'Sofia Mendoza', 'B1', '3001010965', 'ACTIVO'),
('1020002192', 'Ricardo Gil', 'B1', '3001011696', 'ACTIVO'),
('1020002329', 'Alejandra Nunez', 'C1', '3001012427', 'ACTIVO'),
('1020002466', 'Manuel Cardenas', 'B1', '3001013158', 'ACTIVO'),
('1020002603', 'Isabella Suarez', 'C2', '3001013889', 'ACTIVO');

-- -------------------------------------------------------------------------
-- mantenimiento (24 registros, asociados a vehiculo)
-- -------------------------------------------------------------------------
INSERT INTO mantenimiento (id_vehiculo, tipo_mantenimiento, descripcion, fecha_programada, fecha_realizado, costo, taller) VALUES
(1, 'Preventivo', 'Preventivo programado para vehiculo PTS100', '2026-03-05', '2026-03-09', 539076.2, 'Frenos y Suspension SAS'),
(2, 'Correctivo', 'Correctivo programado para vehiculo LGW101', '2026-07-07', NULL, NULL, NULL),
(3, 'Cambio de aceite', 'Cambio de aceite programado para vehiculo JDY102', '2026-04-23', '2026-06-15', 862664.25, 'Taller Diesel Plus'),
(4, 'Revision de frenos', 'Revision de frenos programado para vehiculo CCW103', '2026-02-08', '2026-06-01', 591828.59, 'Lubricentro Express'),
(5, 'Alineacion y balanceo', 'Alineacion y balanceo programado para vehiculo VTN104', '2026-04-01', '2026-01-08', 138638.29, 'Taller Central Motor'),
(6, 'Cambio de llantas', 'Cambio de llantas programado para vehiculo PVQ105', '2026-06-03', '2026-05-22', 502310.61, 'Frenos y Suspension SAS'),
(7, 'Preventivo', 'Preventivo programado para vehiculo SBF106', '2026-03-24', NULL, NULL, NULL),
(8, 'Correctivo', 'Correctivo programado para vehiculo WWK107', '2026-08-08', NULL, NULL, NULL),
(9, 'Cambio de aceite', 'Cambio de aceite programado para vehiculo DJS108', '2026-07-07', '2026-07-12', 448513.4, 'Taller Diesel Plus'),
(10, 'Revision de frenos', 'Revision de frenos programado para vehiculo QET109', '2026-01-22', '2026-02-02', 430280.52, 'AutoServicio Nacional'),
(11, 'Alineacion y balanceo', 'Alineacion y balanceo programado para vehiculo KZR110', '2026-02-08', '2026-08-05', 447037.03, 'AutoServicio Nacional'),
(12, 'Cambio de llantas', 'Cambio de llantas programado para vehiculo SWU111', '2026-08-08', NULL, NULL, NULL),
(13, 'Preventivo', 'Preventivo programado para vehiculo VKB112', '2026-02-15', NULL, NULL, NULL),
(14, 'Correctivo', 'Correctivo programado para vehiculo FMX113', '2026-02-02', '2026-01-03', 885939.28, 'Lubricentro Express'),
(15, 'Cambio de aceite', 'Cambio de aceite programado para vehiculo DDT114', '2026-03-14', '2026-04-28', 428905.05, 'Taller Central Motor'),
(16, 'Revision de frenos', 'Revision de frenos programado para vehiculo TLQ115', '2026-03-13', '2026-07-09', 886070.72, 'Taller Diesel Plus'),
(17, 'Alineacion y balanceo', 'Alineacion y balanceo programado para vehiculo ZDM116', '2026-05-14', '2026-08-05', 245211.14, 'Lubricentro Express'),
(18, 'Cambio de llantas', 'Cambio de llantas programado para vehiculo DDS117', '2026-01-19', NULL, NULL, NULL),
(19, 'Preventivo', 'Preventivo programado para vehiculo KQM118', '2026-01-24', '2026-01-19', 494806.01, 'Frenos y Suspension SAS'),
(20, 'Correctivo', 'Correctivo programado para vehiculo SCX119', '2026-03-02', NULL, NULL, NULL),
(1, 'Cambio de aceite', 'Cambio de aceite programado para vehiculo PTS100', '2026-02-28', '2026-02-22', 829782.71, 'Taller Diesel Plus'),
(2, 'Revision de frenos', 'Revision de frenos programado para vehiculo LGW101', '2026-02-19', '2026-01-20', 151325.56, 'Frenos y Suspension SAS'),
(3, 'Alineacion y balanceo', 'Alineacion y balanceo programado para vehiculo JDY102', '2026-06-09', '2026-06-08', 311084.63, 'Lubricentro Express'),
(4, 'Cambio de llantas', 'Cambio de llantas programado para vehiculo CCW103', '2026-05-15', '2026-02-01', 478708.4, 'Frenos y Suspension SAS');

-- -------------------------------------------------------------------------
-- remitente (20 registros)
-- -------------------------------------------------------------------------
INSERT INTO remitente (nombre_completo, direccion, telefono, email) VALUES
('Camila Rojas', 'Calle 45 #12-30', '3102000000', 'camila.rojas@correo.com'),
('Luis Martinez', 'Carrera 7 #85-20', '3102000611', 'luis.martinez@correo.com'),
('Paula Sanchez', 'Avenida 68 #23-11', '3102001222', 'paula.sanchez@correo.com'),
('Diego Herrera', 'Calle 100 #15-45', '3102001833', 'diego.herrera@correo.com'),
('Valentina Castro', 'Carrera 15 #98-30', '3102002444', 'valentina.castro@correo.com'),
('Sergio Morales', 'Avenida Boyaca #34-12', '3102003055', 'sergio.morales@correo.com'),
('Daniela Ortiz', 'Calle 26 #68-90', '3102003666', 'daniela.ortiz@correo.com'),
('Felipe Vargas', 'Carrera 50 #22-15', '3102004277', 'felipe.vargas@correo.com'),
('Natalia Rios', 'Avenida Suba #120-45', '3102004888', 'natalia.rios@correo.com'),
('Julian Pena', 'Calle 72 #10-25', '3102005499', 'julian.pena@correo.com'),
('Sofia Mendoza', 'Carrera 30 #45-60', '3102006110', 'sofia.mendoza@correo.com'),
('Ricardo Gil', 'Avenida Caracas #33-21', '3102006721', 'ricardo.gil@correo.com'),
('Alejandra Nunez', 'Calle 13 #58-14', '3102007332', 'alejandra.nunez@correo.com'),
('Manuel Cardenas', 'Carrera 9 #74-33', '3102007943', 'manuel.cardenas@correo.com'),
('Isabella Suarez', 'Avenida El Dorado #90-12', '3102008554', 'isabella.suarez@correo.com'),
('Oscar Guzman', 'Calle 63 #40-18', '3102009165', 'oscar.guzman@correo.com'),
('Catalina Beltran', 'Carrera 24 #63-55', '3102009776', 'catalina.beltran@correo.com'),
('David Salazar', 'Avenida Ciudad de Cali #40-20', '3102010387', 'david.salazar@correo.com'),
('Juliana Cortes', 'Calle 80 #90-40', '3102010998', 'juliana.cortes@correo.com'),
('Miguel Pardo', 'Carrera 11 #93-27', '3102011609', 'miguel.pardo@correo.com');

-- -------------------------------------------------------------------------
-- destinatario (20 registros)
-- -------------------------------------------------------------------------
INSERT INTO destinatario (nombre_completo, direccion, telefono, email) VALUES
('Sofia Mendoza', 'Carrera 50 #22-15', '3203000000', 'sofia.mendoza@cliente.com'),
('Ricardo Gil', 'Avenida Suba #120-45', '3203000823', 'ricardo.gil@cliente.com'),
('Alejandra Nunez', 'Calle 72 #10-25', '3203001646', 'alejandra.nunez@cliente.com'),
('Manuel Cardenas', 'Carrera 30 #45-60', '3203002469', 'manuel.cardenas@cliente.com'),
('Isabella Suarez', 'Avenida Caracas #33-21', '3203003292', 'isabella.suarez@cliente.com'),
('Oscar Guzman', 'Calle 13 #58-14', '3203004115', 'oscar.guzman@cliente.com'),
('Catalina Beltran', 'Carrera 9 #74-33', '3203004938', 'catalina.beltran@cliente.com'),
('David Salazar', 'Avenida El Dorado #90-12', '3203005761', 'david.salazar@cliente.com'),
('Juliana Cortes', 'Calle 63 #40-18', '3203006584', 'juliana.cortes@cliente.com'),
('Miguel Pardo', 'Carrera 24 #63-55', '3203007407', 'miguel.pardo@cliente.com'),
('Gabriela Reyes', 'Avenida Ciudad de Cali #40-20', '3203008230', 'gabriela.reyes@cliente.com'),
('Esteban Duarte', 'Calle 80 #90-40', '3203009053', 'esteban.duarte@cliente.com'),
('Melissa Aguilar', 'Carrera 11 #93-27', '3203009876', 'melissa.aguilar@cliente.com'),
('Nicolas Vega', 'Calle 45 #12-30', '3203010699', 'nicolas.vega@cliente.com'),
('Tatiana Molina', 'Carrera 7 #85-20', '3203011522', 'tatiana.molina@cliente.com'),
('Mauricio Leon', 'Avenida 68 #23-11', '3203012345', 'mauricio.leon@cliente.com'),
('Adriana Prieto', 'Calle 100 #15-45', '3203013168', 'adriana.prieto@cliente.com'),
('Cristian Navarro', 'Carrera 15 #98-30', '3203013991', 'cristian.navarro@cliente.com'),
('Fernanda Bonilla', 'Avenida Boyaca #34-12', '3203014814', 'fernanda.bonilla@cliente.com'),
('Hector Delgado', 'Calle 26 #68-90', '3203015637', 'hector.delgado@cliente.com');

-- -------------------------------------------------------------------------
-- paquete (25 registros)
-- -------------------------------------------------------------------------
INSERT INTO paquete (codigo_seguimiento, descripcion, peso_kg, largo_cm, ancho_cm, alto_cm, direccion_origen, direccion_destino, id_remitente, id_destinatario, estado) VALUES
('RE-2026-1000', 'Ropa y calzado', 5.64, 21.77, 54.26, 25.43, 'Calle 45 #12-30', 'Calle 72 #10-25', 1, 10, 'ENTREGADO'),
('RE-2026-1001', 'Equipos electronicos', 27.41, 88.94, 26.29, 52.57, 'Carrera 7 #85-20', 'Carrera 30 #45-60', 2, 11, 'EN_BODEGA'),
('RE-2026-1002', 'Repuestos automotrices', 12.25, 63.74, 82.43, 68.46, 'Avenida 68 #23-11', 'Avenida Caracas #33-21', 3, 12, 'DEVUELTO'),
('RE-2026-1003', 'Libros y utiles escolares', 4.61, 56.59, 32.13, 5.27, 'Calle 100 #15-45', 'Calle 13 #58-14', 4, 13, 'ENTREGADO'),
('RE-2026-1004', 'Articulos de hogar', 34.81, 80.08, 30.96, 60.59, 'Carrera 15 #98-30', 'Carrera 9 #74-33', 5, 14, 'ASIGNADO_A_RUTA'),
('RE-2026-1005', 'Medicamentos', 25.05, 57.05, 10.77, 10.64, 'Avenida Boyaca #34-12', 'Avenida El Dorado #90-12', 6, 15, 'EN_BODEGA'),
('RE-2026-1006', 'Alimentos no perecederos', 39.8, 109.43, 53.65, 67.59, 'Calle 26 #68-90', 'Calle 63 #40-18', 7, 16, 'EN_TRANSITO'),
('RE-2026-1007', 'Herramientas industriales', 26.42, 26.29, 20.2, 28.12, 'Carrera 50 #22-15', 'Carrera 24 #63-55', 8, 17, 'EN_BODEGA'),
('RE-2026-1008', 'Juguetes', 40.5, 97.57, 78.86, 72.42, 'Avenida Suba #120-45', 'Avenida Ciudad de Cali #40-20', 9, 18, 'ASIGNADO_A_RUTA'),
('RE-2026-1009', 'Material de construccion', 9.85, 37.45, 18.22, 63.51, 'Calle 72 #10-25', 'Calle 80 #90-40', 10, 19, 'EN_TRANSITO'),
('RE-2026-1010', 'Accesorios de computo', 39.84, 54.7, 59.65, 16.59, 'Carrera 30 #45-60', 'Carrera 11 #93-27', 11, 20, 'ENTREGADO'),
('RE-2026-1011', 'Instrumentos musicales', 41.88, 105.11, 88.1, 65.81, 'Avenida Caracas #33-21', 'Calle 45 #12-30', 12, 1, 'EN_TRANSITO'),
('RE-2026-1012', 'Productos de aseo', 39.72, 12.73, 68.93, 29.91, 'Calle 13 #58-14', 'Carrera 7 #85-20', 13, 2, 'ENTREGADO'),
('RE-2026-1013', 'Piezas de maquinaria', 41.92, 98.25, 79.13, 65.81, 'Carrera 9 #74-33', 'Avenida 68 #23-11', 14, 3, 'ENTREGADO'),
('RE-2026-1014', 'Documentos legales', 12.37, 96.61, 18.65, 70.41, 'Avenida El Dorado #90-12', 'Calle 100 #15-45', 15, 4, 'EN_BODEGA'),
('RE-2026-1015', 'Muebles pequenos', 38.71, 34.47, 75.33, 39.52, 'Calle 63 #40-18', 'Carrera 15 #98-30', 16, 5, 'EN_BODEGA'),
('RE-2026-1016', 'Electrodomesticos pequenos', 14.08, 97.49, 28.21, 6.77, 'Carrera 24 #63-55', 'Avenida Boyaca #34-12', 17, 6, 'DEVUELTO'),
('RE-2026-1017', 'Articulos deportivos', 9.09, 46.11, 79.15, 77.52, 'Avenida Ciudad de Cali #40-20', 'Calle 26 #68-90', 18, 7, 'ASIGNADO_A_RUTA'),
('RE-2026-1018', 'Insumos medicos', 12.92, 80.56, 41.97, 78.59, 'Calle 80 #90-40', 'Carrera 50 #22-15', 19, 8, 'EN_BODEGA'),
('RE-2026-1019', 'Productos de belleza', 24.36, 113.32, 19.23, 77.78, 'Carrera 11 #93-27', 'Avenida Suba #120-45', 20, 9, 'EN_BODEGA'),
('RE-2026-1020', 'Repuestos electronicos', 8.45, 115.88, 31.24, 13.13, 'Calle 45 #12-30', 'Calle 72 #10-25', 1, 10, 'EN_TRANSITO'),
('RE-2026-1021', 'Textiles', 19.84, 90.14, 35.09, 50.47, 'Carrera 7 #85-20', 'Carrera 30 #45-60', 2, 11, 'EN_BODEGA'),
('RE-2026-1022', 'Autopartes', 23.26, 52.37, 56.13, 24.1, 'Avenida 68 #23-11', 'Avenida Caracas #33-21', 3, 12, 'EN_TRANSITO'),
('RE-2026-1023', 'Papeleria corporativa', 32.04, 10.19, 84.05, 45.38, 'Calle 100 #15-45', 'Calle 13 #58-14', 4, 13, 'EN_BODEGA'),
('RE-2026-1024', 'Equipos de oficina', 32.51, 91.61, 63.65, 32.32, 'Carrera 15 #98-30', 'Carrera 9 #74-33', 5, 14, 'EN_BODEGA');

-- -------------------------------------------------------------------------
-- ruta (20 registros)
-- -------------------------------------------------------------------------
INSERT INTO ruta (id_vehiculo, id_conductor, fecha_ruta, estado, hora_inicio, hora_fin, observaciones) VALUES
(1, 4, '2026-07-18', 'PLANIFICADA', NULL, NULL, NULL),
(2, 5, '2026-01-10', 'FINALIZADA', '2026-01-10 07:28:00', '2026-01-10 16:23:00', NULL),
(3, 6, '2026-07-26', 'EN_CURSO', '2026-07-26 07:47:00', NULL, NULL),
(4, 7, '2026-06-15', 'FINALIZADA', '2026-06-15 07:38:00', '2026-06-15 16:38:00', NULL),
(5, 8, '2026-04-17', 'FINALIZADA', '2026-04-17 07:40:00', '2026-04-17 16:57:00', NULL),
(6, 9, '2026-03-22', 'FINALIZADA', '2026-03-22 07:15:00', '2026-03-22 16:28:00', NULL),
(7, 10, '2026-09-22', 'PLANIFICADA', NULL, NULL, NULL),
(8, 11, '2026-06-03', 'CANCELADA', NULL, NULL, NULL),
(9, 12, '2026-04-22', 'FINALIZADA', '2026-04-22 07:29:00', '2026-04-22 16:24:00', NULL),
(10, 13, '2026-04-05', 'FINALIZADA', '2026-04-05 07:11:00', '2026-04-05 16:12:00', NULL),
(11, 14, '2026-04-16', 'EN_CURSO', '2026-04-16 07:49:00', NULL, NULL),
(12, 15, '2026-02-15', 'EN_CURSO', '2026-02-15 07:36:00', NULL, NULL),
(13, 16, '2026-04-23', 'FINALIZADA', '2026-04-23 07:54:00', '2026-04-23 16:34:00', NULL),
(14, 17, '2026-08-13', 'PLANIFICADA', NULL, NULL, NULL),
(15, 18, '2026-04-05', 'EN_CURSO', '2026-04-05 07:51:00', NULL, NULL),
(16, 19, '2026-01-25', 'FINALIZADA', '2026-01-25 07:59:00', '2026-01-25 16:16:00', NULL),
(17, 20, '2026-07-08', 'PLANIFICADA', NULL, NULL, NULL),
(18, 1, '2026-03-26', 'CANCELADA', NULL, NULL, NULL),
(19, 2, '2026-09-15', 'FINALIZADA', '2026-09-15 07:13:00', '2026-09-15 16:45:00', NULL),
(20, 3, '2026-04-28', 'PLANIFICADA', NULL, NULL, NULL);

-- -------------------------------------------------------------------------
-- ruta_paquete (asociacion ruta-paquete)
-- -------------------------------------------------------------------------
INSERT INTO ruta_paquete (id_ruta, id_paquete, orden_entrega, estado_entrega, fecha_entrega_real, observaciones_entrega) VALUES
(1, 1, 1, 'ENTREGADO', '2026-08-15 14:30:00', 'Entregado sin novedad'),
(2, 3, 1, 'DEVUELTO', '2026-08-10 11:00:00', 'Destinatario no encontrado en direccion'),
(3, 4, 1, 'ENTREGADO', '2026-08-15 14:30:00', 'Entregado sin novedad'),
(4, 5, 1, 'PENDIENTE', NULL, NULL),
(5, 7, 1, 'PENDIENTE', NULL, NULL),
(6, 9, 1, 'PENDIENTE', NULL, NULL),
(7, 10, 1, 'PENDIENTE', NULL, NULL),
(8, 11, 1, 'ENTREGADO', '2026-08-15 14:30:00', 'Entregado sin novedad'),
(9, 12, 1, 'PENDIENTE', NULL, NULL),
(10, 13, 1, 'ENTREGADO', '2026-08-15 14:30:00', 'Entregado sin novedad'),
(11, 14, 1, 'ENTREGADO', '2026-08-15 14:30:00', 'Entregado sin novedad'),
(12, 17, 1, 'DEVUELTO', '2026-08-10 11:00:00', 'Destinatario no encontrado en direccion'),
(13, 18, 1, 'PENDIENTE', NULL, NULL),
(14, 21, 1, 'PENDIENTE', NULL, NULL),
(15, 23, 1, 'PENDIENTE', NULL, NULL);

