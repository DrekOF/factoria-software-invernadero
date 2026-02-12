-- ============================================================================
-- QUERIES DE INSERT PARA SISTEMA DE GESTION DE INVERNADERO HIDROPONICO
-- Autor: Sistema de Gestion de Invernadero Hidroponico
-- Fecha: 2026
-- ============================================================================

-- ============================================================================
-- CASO 1: INSERTAR USUARIOS
-- ============================================================================

-- 1.1 Insertar un usuario administrador
INSERT INTO usuario (nombre_completo, email, password_hash, rol, activo)
VALUES ('Admin Principal', 'admin@invernadero.com', 'hash_admin_123', 'administrador', true);

-- 1.2 Insertar múltiples usuarios de diferentes roles
INSERT INTO usuario (nombre_completo, email, password_hash, rol, activo)
VALUES 
    ('Jorge Méndez', 'jorge.mendez@invernadero.com', 'hash_pass_001', 'operador', true),
    ('Sofia Vargas', 'sofia.vargas@invernadero.com', 'hash_pass_002', 'operador', true),
    ('Ricardo Lara', 'ricardo.lara@invernadero.com', 'hash_pass_003', 'observador', true),
    ('Diana Castro', 'diana.castro@invernadero.com', 'hash_pass_004', 'administrador', true),
    ('Andrés Salazar', 'andres.salazar@invernadero.com', 'hash_pass_005', 'observador', false);

-- 1.3 Insertar usuario con fecha específica
INSERT INTO usuario (nombre_completo, email, password_hash, rol, fecha_registro, activo)
VALUES ('Usuario Antiguo', 'antiguo@invernadero.com', 'hash_old_123', 'operador', '2023-01-15 10:30:00', true);

-- 1.4 Insertar usuario inactivo
INSERT INTO usuario (nombre_completo, email, password_hash, rol, activo)
VALUES ('Usuario Suspendido', 'suspendido@invernadero.com', 'hash_susp_456', 'operador', false);


-- ============================================================================
-- CASO 2: INSERTAR INVERNADEROS
-- ============================================================================

-- 2.1 Insertar un invernadero básico
INSERT INTO invernadero (nombre, ubicacion, latitud, longitud, area_m2, fecha_instalacion, estado)
VALUES ('Invernadero Demo', 'Calle Principal #123, Neiva', 2.9273, -75.2819, 450.00, '2024-01-15', 'activo');

-- 2.2 Insertar múltiples invernaderos
INSERT INTO invernadero (nombre, ubicacion, latitud, longitud, area_m2, fecha_instalacion, estado)
VALUES 
    ('Invernadero Alpha', 'Zona Norte, Neiva, Huila', 2.9350, -75.2750, 800.00, '2023-03-20', 'activo'),
    ('Invernadero Beta', 'Zona Sur, Neiva, Huila', 2.9180, -75.2900, 650.00, '2023-06-10', 'activo'),
    ('Invernadero Gamma', 'Zona Este, Neiva, Huila', 2.9250, -75.2700, 500.00, '2023-09-05', 'activo'),
    ('Invernadero Delta', 'Zona Oeste, Neiva, Huila', 2.9150, -75.2950, 400.00, '2024-02-01', 'mantenimiento');

-- 2.3 Invernadero con coordenadas específicas
INSERT INTO invernadero (nombre, ubicacion, latitud, longitud, area_m2, fecha_instalacion, estado)
VALUES ('Invernadero GPS', 'Vereda San Luis', 2.931234, -75.278945, 350.00, CURRENT_DATE - INTERVAL '6 months', 'activo');

-- 2.4 Invernadero pequeño experimental
INSERT INTO invernadero (nombre, ubicacion, latitud, longitud, area_m2, fecha_instalacion, estado)
VALUES ('Invernadero Mini Lab', 'Campus Universitario', 2.9280, -75.2830, 150.00, CURRENT_DATE - INTERVAL '3 months', 'activo');


-- ============================================================================
-- CASO 3: INSERTAR CULTIVOS
-- ============================================================================

-- 3.1 Insertar un cultivo básico
INSERT INTO cultivo (nombre_comun, nombre_cientifico, ph_optimo_min, ph_optimo_max, temp_optima_min, temp_optima_max, dias_cosecha)
VALUES ('Lechuga Batavia', 'Lactuca sativa var. capitata', 5.8, 6.5, 16.0, 24.0, 45);

-- 3.2 Insertar múltiples cultivos comunes
INSERT INTO cultivo (nombre_comun, nombre_cientifico, ph_optimo_min, ph_optimo_max, temp_optima_min, temp_optima_max, dias_cosecha)
VALUES 
    ('Tomate Italiano', 'Solanum lycopersicum', 5.5, 6.8, 18.0, 28.0, 80),
    ('Pimiento Rojo', 'Capsicum annuum', 5.8, 6.5, 20.0, 30.0, 75),
    ('Berenjena', 'Solanum melongena', 5.5, 6.5, 22.0, 30.0, 85),
    ('Calabacín', 'Cucurbita pepo', 6.0, 7.0, 18.0, 28.0, 50);

-- 3.3 Insertar cultivos de ciclo corto
INSERT INTO cultivo (nombre_comun, nombre_cientifico, ph_optimo_min, ph_optimo_max, temp_optima_min, temp_optima_max, dias_cosecha)
VALUES 
    ('Rábano', 'Raphanus sativus', 6.0, 7.0, 10.0, 20.0, 25),
    ('Mostaza', 'Brassica juncea', 6.0, 7.5, 15.0, 25.0, 30),
    ('Pak Choi', 'Brassica rapa subsp. chinensis', 6.0, 7.0, 15.0, 22.0, 40);

-- 3.4 Insertar hierbas aromáticas
INSERT INTO cultivo (nombre_comun, nombre_cientifico, ph_optimo_min, ph_optimo_max, temp_optima_min, temp_optima_max, dias_cosecha)
VALUES 
    ('Tomillo', 'Thymus vulgaris', 6.0, 7.0, 18.0, 28.0, 90),
    ('Orégano', 'Origanum vulgare', 6.0, 8.0, 20.0, 30.0, 85),
    ('Romero', 'Rosmarinus officinalis', 6.0, 7.5, 20.0, 30.0, 100);


-- ============================================================================
-- CASO 4: INSERTAR CICLOS DE CULTIVO
-- ============================================================================

-- 4.1 Insertar ciclo de cultivo activo (en curso)
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES (1, 1, CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE + INTERVAL '15 days', NULL, 500, 'en_curso');

-- 4.2 Insertar múltiples ciclos activos
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES 
    (1, 2, CURRENT_DATE - INTERVAL '25 days', CURRENT_DATE + INTERVAL '55 days', NULL, 400, 'en_curso'),
    (2, 3, CURRENT_DATE - INTERVAL '20 days', CURRENT_DATE + INTERVAL '30 days', NULL, 350, 'en_curso'),
    (3, 4, CURRENT_DATE - INTERVAL '15 days', CURRENT_DATE + INTERVAL '70 days', NULL, 300, 'en_curso'),
    (2, 1, CURRENT_DATE - INTERVAL '35 days', CURRENT_DATE + INTERVAL '10 days', NULL, 450, 'en_curso');

-- 4.3 Insertar ciclo cosechado (completado)
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES (1, 1, CURRENT_DATE - INTERVAL '90 days', CURRENT_DATE - INTERVAL '45 days', CURRENT_DATE - INTERVAL '43 days', 500, 'cosechado');

-- 4.4 Insertar múltiples ciclos cosechados (historial)
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES 
    (1, 2, CURRENT_DATE - INTERVAL '120 days', CURRENT_DATE - INTERVAL '40 days', CURRENT_DATE - INTERVAL '38 days', 450, 'cosechado'),
    (2, 3, CURRENT_DATE - INTERVAL '150 days', CURRENT_DATE - INTERVAL '75 days', CURRENT_DATE - INTERVAL '72 days', 400, 'cosechado'),
    (3, 4, CURRENT_DATE - INTERVAL '100 days', CURRENT_DATE - INTERVAL '15 days', CURRENT_DATE - INTERVAL '14 days', 380, 'cosechado'),
    (2, 1, CURRENT_DATE - INTERVAL '80 days', CURRENT_DATE - INTERVAL '35 days', CURRENT_DATE - INTERVAL '36 days', 520, 'cosechado');

-- 4.5 Insertar ciclos planificados (futuros)
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES 
    (1, 3, CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '85 days', NULL, 300, 'planificado'),
    (3, 2, CURRENT_DATE + INTERVAL '15 days', CURRENT_DATE + INTERVAL '95 days', NULL, 350, 'planificado'),
    (2, 4, CURRENT_DATE + INTERVAL '20 days', CURRENT_DATE + INTERVAL '105 days', NULL, 280, 'planificado');

-- 4.6 Insertar ciclo abandonado
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES (3, 1, CURRENT_DATE - INTERVAL '40 days', CURRENT_DATE + INTERVAL '5 days', NULL, 200, 'abandonado');

-- 4.7 Insertar ciclo con cosecha adelantada
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES (1, 4, CURRENT_DATE - INTERVAL '70 days', CURRENT_DATE - INTERVAL '20 days', CURRENT_DATE - INTERVAL '25 days', 380, 'cosechado');

-- 4.8 Insertar ciclo con cosecha retrasada
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES (2, 3, CURRENT_DATE - INTERVAL '95 days', CURRENT_DATE - INTERVAL '20 days', CURRENT_DATE - INTERVAL '15 days', 420, 'cosechado');


-- ============================================================================
-- CASO 5: INSERTAR SENSORES
-- ============================================================================

-- 5.1 Insertar sensor de temperatura
INSERT INTO sensor (invernadero_id, tipo_sensor, marca, modelo, ubicacion_sensor, fecha_instalacion, estado)
VALUES (1, 'temperatura', 'DHT22', 'DHT22-AM2302', 'Zona Norte - Centro', CURRENT_DATE - INTERVAL '60 days', 'activo');

-- 5.2 Insertar conjunto completo de sensores para un invernadero
INSERT INTO sensor (invernadero_id, tipo_sensor, marca, modelo, ubicacion_sensor, fecha_instalacion, estado)
VALUES 
    (1, 'temperatura', 'DHT22', 'DHT22-AM2302', 'Zona Norte', CURRENT_DATE - INTERVAL '60 days', 'activo'),
    (1, 'humedad', 'DHT22', 'DHT22-AM2302', 'Zona Norte', CURRENT_DATE - INTERVAL '60 days', 'activo'),
    (1, 'ph', 'Atlas Scientific', 'pH-EZO', 'Sistema Riego Principal', CURRENT_DATE - INTERVAL '60 days', 'activo'),
    (1, 'ec', 'Atlas Scientific', 'EC-EZO', 'Sistema Riego Principal', CURRENT_DATE - INTERVAL '60 days', 'activo'),
    (1, 'luz', 'BH1750', 'BH1750FVI', 'Techo Central', CURRENT_DATE - INTERVAL '60 days', 'activo');

-- 5.3 Insertar sensores en múltiples invernaderos
INSERT INTO sensor (invernadero_id, tipo_sensor, marca, modelo, ubicacion_sensor, fecha_instalacion, estado)
VALUES 
    (2, 'temperatura', 'DS18B20', 'DS18B20', 'Entrada', CURRENT_DATE - INTERVAL '90 days', 'activo'),
    (2, 'humedad', 'SHT31', 'SHT31-DIS', 'Centro', CURRENT_DATE - INTERVAL '90 days', 'activo'),
    (3, 'temperatura', 'DHT22', 'DHT22-AM2302', 'Pared Este', CURRENT_DATE - INTERVAL '45 days', 'activo'),
    (3, 'ph', 'Atlas Scientific', 'pH-EZO', 'Tanque Nutrientes', CURRENT_DATE - INTERVAL '45 days', 'activo'),
    (3, 'co2', 'MH-Z19', 'MH-Z19B', 'Centro - Altura Media', CURRENT_DATE - INTERVAL '45 days', 'activo');

-- 5.4 Insertar sensor en mantenimiento
INSERT INTO sensor (invernadero_id, tipo_sensor, marca, modelo, ubicacion_sensor, fecha_instalacion, estado)
VALUES (1, 'temperatura', 'DHT22', 'DHT22-AM2302', 'Zona Sur', CURRENT_DATE - INTERVAL '180 days', 'mantenimiento');

-- 5.5 Insertar sensor inactivo
INSERT INTO sensor (invernadero_id, tipo_sensor, marca, modelo, ubicacion_sensor, fecha_instalacion, estado)
VALUES (2, 'luz', 'BH1750', 'BH1750FVI', 'Techo Norte', CURRENT_DATE - INTERVAL '200 days', 'inactivo');

-- 5.6 Insertar sensores de CO2
INSERT INTO sensor (invernadero_id, tipo_sensor, marca, modelo, ubicacion_sensor, fecha_instalacion, estado)
VALUES 
    (1, 'co2', 'SCD30', 'SCD30', 'Centro - 2m altura', CURRENT_DATE - INTERVAL '30 days', 'activo'),
    (2, 'co2', 'MH-Z19', 'MH-Z19B', 'Zona Ventilación', CURRENT_DATE - INTERVAL '30 days', 'activo');


-- ============================================================================
-- CASO 6: INSERTAR LECTURAS DE SENSORES
-- ============================================================================

-- 6.1 Insertar lectura de temperatura actual
INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
VALUES (1, NOW(), 24.5, '°C');

-- 6.2 Insertar múltiples lecturas recientes de un sensor
INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
VALUES 
    (1, NOW() - INTERVAL '1 hour', 24.8, '°C'),
    (1, NOW() - INTERVAL '2 hours', 25.2, '°C'),
    (1, NOW() - INTERVAL '3 hours', 25.6, '°C'),
    (1, NOW() - INTERVAL '4 hours', 24.9, '°C'),
    (1, NOW() - INTERVAL '5 hours', 24.3, '°C');

-- 6.3 Insertar lecturas de diferentes tipos de sensores
INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
VALUES 
    (1, NOW(), 23.5, '°C'),         -- Temperatura
    (2, NOW(), 68.5, '%'),          -- Humedad
    (3, NOW(), 6.2, 'pH'),          -- pH
    (4, NOW(), 1.8, 'mS/cm'),       -- Conductividad Eléctrica
    (5, NOW(), 25000.0, 'lux');     -- Luz

-- 6.4 Insertar lecturas históricas (último día, cada hora)
INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
VALUES 
    -- Sensor de temperatura - últimas 24 horas
    (1, NOW() - INTERVAL '1 hour', 24.2, '°C'),
    (1, NOW() - INTERVAL '2 hours', 24.5, '°C'),
    (1, NOW() - INTERVAL '3 hours', 24.8, '°C'),
    (1, NOW() - INTERVAL '4 hours', 25.1, '°C'),
    (1, NOW() - INTERVAL '5 hours', 25.4, '°C'),
    (1, NOW() - INTERVAL '6 hours', 25.8, '°C'),
    (1, NOW() - INTERVAL '7 hours', 26.2, '°C'),
    (1, NOW() - INTERVAL '8 hours', 26.5, '°C'),
    (1, NOW() - INTERVAL '9 hours', 26.8, '°C'),
    (1, NOW() - INTERVAL '10 hours', 27.0, '°C'),
    (1, NOW() - INTERVAL '11 hours', 27.2, '°C'),
    (1, NOW() - INTERVAL '12 hours', 27.5, '°C'),
    (1, NOW() - INTERVAL '13 hours', 27.3, '°C'),
    (1, NOW() - INTERVAL '14 hours', 27.0, '°C'),
    (1, NOW() - INTERVAL '15 hours', 26.5, '°C'),
    (1, NOW() - INTERVAL '16 hours', 26.0, '°C'),
    (1, NOW() - INTERVAL '17 hours', 25.5, '°C'),
    (1, NOW() - INTERVAL '18 hours', 25.0, '°C'),
    (1, NOW() - INTERVAL '19 hours', 24.5, '°C'),
    (1, NOW() - INTERVAL '20 hours', 24.0, '°C'),
    (1, NOW() - INTERVAL '21 hours', 23.5, '°C'),
    (1, NOW() - INTERVAL '22 hours', 23.2, '°C'),
    (1, NOW() - INTERVAL '23 hours', 23.0, '°C'),
    (1, NOW() - INTERVAL '24 hours', 22.8, '°C');

-- 6.5 Insertar lecturas de pH variadas
INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
VALUES 
    (3, NOW(), 6.5, 'pH'),
    (3, NOW() - INTERVAL '30 minutes', 6.4, 'pH'),
    (3, NOW() - INTERVAL '1 hour', 6.6, 'pH'),
    (3, NOW() - INTERVAL '2 hours', 6.5, 'pH'),
    (3, NOW() - INTERVAL '3 hours', 6.3, 'pH');

-- 6.6 Insertar lecturas fuera de rango (para alertas)
INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
VALUES 
    (1, NOW() - INTERVAL '10 minutes', 32.5, '°C'),  -- Temperatura alta
    (2, NOW() - INTERVAL '15 minutes', 92.0, '%'),   -- Humedad alta
    (3, NOW() - INTERVAL '20 minutes', 4.8, 'pH');   -- pH bajo

-- 6.7 Insertar lecturas de CO2
INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
VALUES 
    (10, NOW(), 850.0, 'ppm'),
    (10, NOW() - INTERVAL '1 hour', 920.0, 'ppm'),
    (10, NOW() - INTERVAL '2 hours', 780.0, 'ppm'),
    (10, NOW() - INTERVAL '3 hours', 1100.0, 'ppm');  -- Alto


-- ============================================================================
-- CASO 7: INSERTAR ALERTAS
-- ============================================================================

-- 7.1 Insertar alerta activa crítica
INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, descripcion, timestamp_inicio, timestamp_fin, estado)
VALUES (1, 3, 'ph_fuera_rango', 'critica', 'pH detectado en 4.5, nivel crítico bajo. Requiere atención inmediata.', NOW() - INTERVAL '30 minutes', NULL, 'activa');

-- 7.2 Insertar múltiples alertas activas
INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, descripcion, timestamp_inicio, timestamp_fin, estado)
VALUES 
    (1, 1, 'temperatura_alta', 'alta', 'Temperatura superior a 30°C en zona norte', NOW() - INTERVAL '2 hours', NULL, 'activa'),
    (2, 6, 'humedad_alta', 'media', 'Humedad superior al 85% detectada', NOW() - INTERVAL '1 hour', NULL, 'activa'),
    (3, 12, 'ph_alto', 'media', 'pH detectado en 7.8, ligeramente alto', NOW() - INTERVAL '45 minutes', NULL, 'activa'),
    (1, 5, 'luz_baja', 'baja', 'Nivel de luz bajo durante horas diurnas', NOW() - INTERVAL '3 hours', NULL, 'activa');

-- 7.3 Insertar alerta resuelta
INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, descripcion, timestamp_inicio, timestamp_fin, estado)
VALUES (1, 1, 'temperatura_alta', 'alta', 'Temperatura superior a 32°C - Sistema de ventilación activado', 
        NOW() - INTERVAL '5 hours', NOW() - INTERVAL '3 hours', 'resuelta');

-- 7.4 Insertar múltiples alertas resueltas (historial)
INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, descripcion, timestamp_inicio, timestamp_fin, estado)
VALUES 
    (2, 8, 'ph_bajo', 'alta', 'pH en 5.0 - Ajuste de nutrientes realizado', 
     NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days' + INTERVAL '4 hours', 'resuelta'),
    (3, 14, 'co2_alto', 'media', 'CO2 superior a 1200 ppm - Ventilación aumentada', 
     NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day' + INTERVAL '2 hours', 'resuelta'),
    (1, 2, 'humedad_baja', 'baja', 'Humedad inferior al 50% - Sistema de nebulización activado', 
     NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days' + INTERVAL '1 hour', 'resuelta');

-- 7.5 Insertar alertas de sistema (sin sensor específico)
INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, descripcion, timestamp_inicio, timestamp_fin, estado)
VALUES 
    (1, NULL, 'sistema', 'media', 'Sensor de temperatura sin reportar datos desde hace 2 horas', NOW() - INTERVAL '2 hours', NULL, 'activa'),
    (2, NULL, 'conectividad', 'alta', 'Pérdida de conexión con gateway IoT', NOW() - INTERVAL '1 hour', NULL, 'activa'),
    (3, NULL, 'sistema', 'baja', 'Mantenimiento programado completado', NOW() - INTERVAL '6 hours', NOW() - INTERVAL '4 hours', 'resuelta');

-- 7.6 Insertar alerta ignorada
INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, descripcion, timestamp_inicio, timestamp_fin, estado)
VALUES (1, 5, 'luz_baja', 'baja', 'Nivel de luz bajo durante horas nocturnas (condición normal)', 
        NOW() - INTERVAL '12 hours', NULL, 'ignorada');

-- 7.7 Insertar alertas de diferentes severidades
INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, descripcion, timestamp_inicio, timestamp_fin, estado)
VALUES 
    (1, 3, 'ph_fuera_rango', 'critica', 'pH en 4.2 - CRÍTICO', NOW() - INTERVAL '10 minutes', NULL, 'activa'),
    (2, 7, 'temperatura_baja', 'alta', 'Temperatura en 12°C - Riesgo para cultivo', NOW() - INTERVAL '30 minutes', NULL, 'activa'),
    (3, 11, 'ec_alta', 'media', 'Conductividad eléctrica elevada', NOW() - INTERVAL '1 hour', NULL, 'activa'),
    (1, 2, 'humedad_baja', 'baja', 'Humedad ligeramente baja', NOW() - INTERVAL '2 hours', NULL, 'activa');

-- 7.8 Insertar alertas con duración corta (rápidamente resueltas)
INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, descripcion, timestamp_inicio, timestamp_fin, estado)
VALUES 
    (1, 1, 'temperatura_alta', 'media', 'Spike temporal de temperatura', 
     NOW() - INTERVAL '4 hours', NOW() - INTERVAL '4 hours' + INTERVAL '15 minutes', 'resuelta'),
    (2, 6, 'humedad_alta', 'baja', 'Humedad alta post-riego', 
     NOW() - INTERVAL '3 hours', NOW() - INTERVAL '3 hours' + INTERVAL '30 minutes', 'resuelta');

-- 7.9 Insertar alertas recurrentes (mismo tipo, diferentes momentos)
INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, descripcion, timestamp_inicio, timestamp_fin, estado)
VALUES 
    (1, 1, 'temperatura_alta', 'alta', 'Temperatura alta - Ocurrencia 1', 
     NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days' + INTERVAL '3 hours', 'resuelta'),
    (1, 1, 'temperatura_alta', 'alta', 'Temperatura alta - Ocurrencia 2', 
     NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days' + INTERVAL '2 hours', 'resuelta'),
    (1, 1, 'temperatura_alta', 'alta', 'Temperatura alta - Ocurrencia 3', 
     NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days' + INTERVAL '4 hours', 'resuelta'),
    (1, 1, 'temperatura_alta', 'alta', 'Temperatura alta - Ocurrencia 4', 
     NOW() - INTERVAL '1 hour', NULL, 'activa');


-- ============================================================================
-- CASO 8: INSERTS PARA CASOS DE USO ESPECÍFICOS
-- ============================================================================

-- 8.1 Datos para probar "Próximos a cosechar"
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES 
    (1, 1, CURRENT_DATE - INTERVAL '40 days', CURRENT_DATE + INTERVAL '5 days', NULL, 450, 'en_curso'),
    (2, 2, CURRENT_DATE - INTERVAL '50 days', CURRENT_DATE + INTERVAL '30 days', NULL, 380, 'en_curso'),
    (1, 3, CURRENT_DATE - INTERVAL '60 days', CURRENT_DATE + INTERVAL '15 days', NULL, 520, 'en_curso'),
    (3, 4, CURRENT_DATE - INTERVAL '70 days', CURRENT_DATE + INTERVAL '10 days', NULL, 400, 'en_curso');

-- 8.2 Datos para probar "Rendimiento vs Tiempo estimado"
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES 
    -- Cosecha adelantada
    (1, 1, CURRENT_DATE - INTERVAL '52 days', CURRENT_DATE - INTERVAL '7 days', CURRENT_DATE - INTERVAL '10 days', 500, 'cosechado'),
    -- Cosecha a tiempo
    (2, 2, CURRENT_DATE - INTERVAL '85 days', CURRENT_DATE - INTERVAL '5 days', CURRENT_DATE - INTERVAL '5 days', 450, 'cosechado'),
    -- Cosecha retrasada
    (3, 3, CURRENT_DATE - INTERVAL '80 days', CURRENT_DATE - INTERVAL '5 days', CURRENT_DATE, 420, 'cosechado');

-- 8.3 Datos para probar "Condiciones fuera de rango"
INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
VALUES 
    -- Temperaturas fuera de rango
    (1, NOW() - INTERVAL '5 minutes', 35.5, '°C'),   -- Muy alta
    (1, NOW() - INTERVAL '10 minutes', 12.0, '°C'),  -- Muy baja
    -- pH fuera de rango
    (3, NOW() - INTERVAL '5 minutes', 8.2, 'pH'),    -- Muy alto
    (3, NOW() - INTERVAL '15 minutes', 4.5, 'pH'),   -- Muy bajo
    -- Humedad extrema
    (2, NOW() - INTERVAL '8 minutes', 95.0, '%'),    -- Muy alta
    (2, NOW() - INTERVAL '20 minutes', 35.0, '%');   -- Muy baja

-- 8.4 Datos para probar "Sensores sin respuesta"
-- (Insertar sensor activo pero sin lecturas recientes)
INSERT INTO sensor (invernadero_id, tipo_sensor, marca, modelo, ubicacion_sensor, fecha_instalacion, estado)
VALUES (1, 'temperatura', 'DHT22', 'DHT22-AM2302', 'Zona Problema', CURRENT_DATE - INTERVAL '30 days', 'activo');
-- No insertar lecturas para este sensor

-- 8.5 Datos para probar "Calendario de producción mensual"
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES 
    -- Enero
    (1, 1, CURRENT_DATE - INTERVAL '5 months', CURRENT_DATE - INTERVAL '4 months' - INTERVAL '15 days', CURRENT_DATE - INTERVAL '4 months' - INTERVAL '13 days', 500, 'cosechado'),
    -- Febrero
    (2, 2, CURRENT_DATE - INTERVAL '4 months', CURRENT_DATE - INTERVAL '3 months' - INTERVAL '10 days', CURRENT_DATE - INTERVAL '3 months' - INTERVAL '12 days', 450, 'cosechado'),
    -- Marzo
    (1, 3, CURRENT_DATE - INTERVAL '3 months', CURRENT_DATE - INTERVAL '2 months' - INTERVAL '5 days', CURRENT_DATE - INTERVAL '2 months' - INTERVAL '6 days', 520, 'cosechado'),
    -- Abril
    (3, 4, CURRENT_DATE - INTERVAL '2 months', CURRENT_DATE - INTERVAL '1 month' - INTERVAL '15 days', CURRENT_DATE - INTERVAL '1 month' - INTERVAL '14 days', 480, 'cosechado'),
    -- Mayo
    (2, 1, CURRENT_DATE - INTERVAL '1 month' - INTERVAL '20 days', CURRENT_DATE - INTERVAL '15 days', CURRENT_DATE - INTERVAL '16 days', 510, 'cosechado');

-- 8.6 Datos para probar "Eficiencia por invernadero"
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES 
    -- Invernadero 1 - Alta producción
    (1, 1, CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE + INTERVAL '15 days', NULL, 600, 'en_curso'),
    (1, 2, CURRENT_DATE - INTERVAL '25 days', CURRENT_DATE + INTERVAL '55 days', NULL, 500, 'en_curso'),
    -- Invernadero 2 - Producción media
    (2, 3, CURRENT_DATE - INTERVAL '20 days', CURRENT_DATE + INTERVAL '30 days', NULL, 350, 'en_curso'),
    -- Invernadero 3 - Alta densidad
    (3, 4, CURRENT_DATE - INTERVAL '15 days', CURRENT_DATE + INTERVAL '70 days', NULL, 800, 'en_curso');


-- ============================================================================
-- CASO 9: INSERTS PARA ANÁLISIS Y REPORTES
-- ============================================================================

-- 9.1 Múltiples ciclos del mismo cultivo para análisis de tendencias
INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada, fecha_cosecha_real, cantidad_plantas, estado)
VALUES 
    -- Lechuga en invernadero 1 - histórico
    (1, 1, CURRENT_DATE - INTERVAL '180 days', CURRENT_DATE - INTERVAL '135 days', CURRENT_DATE - INTERVAL '133 days', 500, 'cosechado'),
    (1, 1, CURRENT_DATE - INTERVAL '130 days', CURRENT_DATE - INTERVAL '85 days', CURRENT_DATE - INTERVAL '84 days', 520, 'cosechado'),
    (1, 1, CURRENT_DATE - INTERVAL '80 days', CURRENT_DATE - INTERVAL '35 days', CURRENT_DATE - INTERVAL '36 days', 480, 'cosechado'),
    (1, 1, CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE + INTERVAL '15 days', NULL, 500, 'en_curso');

-- 9.2 Datos para análisis de estabilidad ambiental
INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
VALUES 
    -- Sensor estable (poca variación)
    (1, NOW() - INTERVAL '1 hour', 23.8, '°C'),
    (1, NOW() - INTERVAL '2 hours', 23.9, '°C'),
    (1, NOW() - INTERVAL '3 hours', 24.0, '°C'),
    (1, NOW() - INTERVAL '4 hours', 24.1, '°C'),
    (1, NOW() - INTERVAL '5 hours', 23.9, '°C'),
    -- Sensor inestable (mucha variación)
    (6, NOW() - INTERVAL '1 hour', 20.0, '°C'),
    (6, NOW() - INTERVAL '2 hours', 28.0, '°C'),
    (6, NOW() - INTERVAL '3 hours', 22.0, '°C'),
    (6, NOW() - INTERVAL '4 hours', 30.0, '°C'),
    (6, NOW() - INTERVAL '5 hours', 19.0, '°C');

-- 9.3 Usuarios con diferentes fechas de registro para análisis temporal
INSERT INTO usuario (nombre_completo, email, password_hash, rol, fecha_registro, activo)
VALUES 
    ('Usuario Mes Actual', 'actual@invernadero.com', 'hash_001', 'operador', CURRENT_DATE - INTERVAL '5 days', true),
    ('Usuario Mes Pasado', 'pasado@invernadero.com', 'hash_002', 'operador', CURRENT_DATE - INTERVAL '35 days', true),
    ('Usuario Antiguos', 'antiguo@invernadero.com', 'hash_003', 'operador', CURRENT_DATE - INTERVAL '150 days', true);


-- ============================================================================
-- NOTAS Y RECOMENDACIONES
-- ============================================================================

/*
IMPORTANTE:
1. Ajusta los IDs (invernadero_id, cultivo_id, sensor_id) según tu base de datos
2. Usa NOW() o CURRENT_DATE para fechas relativas
3. Las queries usan INTERVAL para fechas dinámicas
4. Verifica que existan las referencias (FK) antes de insertar

PARA PROBAR:
- Ejecuta las queries en orden (respetando foreign keys)
- Puedes ejecutar secciones individualmente
- Modifica los valores según tus necesidades

QUERIES ÚTILES PARA VERIFICAR:
SELECT * FROM usuario;
SELECT * FROM invernadero;
SELECT * FROM cultivo;
SELECT * FROM ciclo_cultivo ORDER BY fecha_siembra DESC;
SELECT * FROM sensor WHERE estado = 'activo';
SELECT * FROM lectura_sensor ORDER BY timestamp DESC LIMIT 20;
SELECT * FROM alerta WHERE estado = 'activa';
*/