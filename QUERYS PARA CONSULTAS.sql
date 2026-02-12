-- ============================================================================
-- QUERIES PARA SISTEMA DE GESTION DE INVERNADERO HIDROPONICO
-- Autor: Cristhian Sanchez
-- Fecha: 2026
-- ============================================================================

-- ============================================================================
-- CASO 1: GESTION DE USUARIOS
-- ============================================================================

-- 1.1 Listar todos los usuarios activos
SELECT 
    id,
    nombre_completo,
    email,
    rol,
    fecha_registro,
    activo
FROM usuario
WHERE activo = true
ORDER BY fecha_registro DESC;

-- 1.2 Contar usuarios por rol
SELECT 
    rol,
    COUNT(*) as total_usuarios
FROM usuario
WHERE activo = true
GROUP BY rol
ORDER BY total_usuarios DESC;

-- 1.3 Buscar usuario por email
SELECT 
    id,
    nombre_completo,
    email,
    rol,
    fecha_registro
FROM usuario
WHERE email = 'juan.perez@invernadero.com';

-- 1.4 Usuarios registrados en el último mes
SELECT 
    nombre_completo,
    email,
    rol,
    fecha_registro
FROM usuario
WHERE fecha_registro >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY fecha_registro DESC;


-- ============================================================================
-- CASO 2: GESTION DE INVERNADEROS
-- ============================================================================

-- 2.1 Listar todos los invernaderos con su información completa
SELECT 
    id,
    nombre,
    ubicacion,
    latitud,
    longitud,
    area_m2,
    fecha_instalacion,
    estado,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_instalacion)) as años_operacion
FROM invernadero
ORDER BY fecha_instalacion;

-- 2.2 Invernaderos activos ordenados por área
SELECT 
    nombre,
    ubicacion,
    area_m2,
    estado
FROM invernadero
WHERE estado = 'activo'
ORDER BY area_m2 DESC;

-- 2.3 Calcular área total de invernaderos por estado
SELECT 
    estado,
    COUNT(*) as cantidad_invernaderos,
    SUM(area_m2) as area_total_m2,
    ROUND(AVG(area_m2), 2) as area_promedio_m2
FROM invernadero
GROUP BY estado
ORDER BY area_total_m2 DESC;

-- 2.4 Invernadero más cercano a una ubicación específica
-- (Ejemplo: buscar cerca de coordenadas 2.9273, -75.2819)
SELECT 
    nombre,
    ubicacion,
    latitud,
    longitud,
    SQRT(
        POWER(latitud - 2.9273, 2) + 
        POWER(longitud - (-75.2819), 2)
    ) as distancia_aproximada
FROM invernadero
WHERE estado = 'activo'
ORDER BY distancia_aproximada
LIMIT 1;


-- ============================================================================
-- CASO 3: GESTION DE CULTIVOS
-- ============================================================================

-- 3.1 Listar todos los tipos de cultivos disponibles
SELECT 
    id,
    nombre_comun,
    nombre_cientifico,
    ph_optimo_min,
    ph_optimo_max,
    temp_optima_min,
    temp_optima_max,
    dias_cosecha
FROM cultivo
ORDER BY nombre_comun;

-- 3.2 Cultivos con tiempo de cosecha más rápido
SELECT 
    nombre_comun,
    nombre_cientifico,
    dias_cosecha,
    CONCAT(ph_optimo_min, ' - ', ph_optimo_max) as rango_ph,
    CONCAT(temp_optima_min, '°C - ', temp_optima_max, '°C') as rango_temperatura
FROM cultivo
ORDER BY dias_cosecha ASC
LIMIT 5;

-- 3.3 Cultivos por rango de pH
SELECT 
    nombre_comun,
    CONCAT(ph_optimo_min, ' - ', ph_optimo_max) as rango_ph_optimo,
    dias_cosecha
FROM cultivo
WHERE ph_optimo_min >= 5.5 AND ph_optimo_max <= 6.8
ORDER BY ph_optimo_min;

-- 3.4 Cultivos por rango de temperatura
SELECT 
    nombre_comun,
    CONCAT(temp_optima_min, '°C - ', temp_optima_max, '°C') as temperatura_optima,
    dias_cosecha
FROM cultivo
WHERE temp_optima_min >= 15.0 AND temp_optima_max <= 25.0
ORDER BY nombre_comun;


-- ============================================================================
-- CASO 4: CICLOS DE CULTIVO ACTIVOS
-- ============================================================================

-- 4.1 Todos los ciclos de cultivo activos con información completa
SELECT 
    cc.id,
    i.nombre as invernadero,
    c.nombre_comun as cultivo,
    cc.fecha_siembra,
    cc.fecha_cosecha_estimada,
    cc.cantidad_plantas,
    cc.estado,
    CURRENT_DATE - cc.fecha_siembra as dias_desde_siembra,
    cc.fecha_cosecha_estimada - CURRENT_DATE as dias_para_cosecha
FROM ciclo_cultivo cc
JOIN invernadero i ON cc.invernadero_id = i.id
JOIN cultivo c ON cc.cultivo_id = c.id
WHERE cc.estado = 'en_curso'
ORDER BY cc.fecha_cosecha_estimada;

-- 4.2 Ciclos próximos a cosechar (en los próximos 15 días)
SELECT 
    i.nombre as invernadero,
    c.nombre_comun as cultivo,
    cc.fecha_siembra,
    cc.fecha_cosecha_estimada,
    cc.cantidad_plantas,
    cc.fecha_cosecha_estimada - CURRENT_DATE as dias_para_cosecha
FROM ciclo_cultivo cc
JOIN invernadero i ON cc.invernadero_id = i.id
JOIN cultivo c ON cc.cultivo_id = c.id
WHERE cc.estado = 'en_curso'
    AND cc.fecha_cosecha_estimada BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '15 days'
ORDER BY cc.fecha_cosecha_estimada;

-- 4.3 Resumen de producción por invernadero
SELECT 
    i.nombre as invernadero,
    COUNT(cc.id) as total_ciclos_activos,
    SUM(cc.cantidad_plantas) as total_plantas,
    STRING_AGG(DISTINCT c.nombre_comun, ', ') as cultivos_actuales
FROM invernadero i
LEFT JOIN ciclo_cultivo cc ON i.id = cc.invernadero_id AND cc.estado = 'en_curso'
LEFT JOIN cultivo c ON cc.cultivo_id = c.id
WHERE i.estado = 'activo'
GROUP BY i.id, i.nombre
ORDER BY total_plantas DESC NULLS LAST;

-- 4.4 Historial de cultivos cosechados
SELECT 
    i.nombre as invernadero,
    c.nombre_comun as cultivo,
    cc.fecha_siembra,
    cc.fecha_cosecha_real,
    cc.cantidad_plantas,
    cc.fecha_cosecha_real - cc.fecha_siembra as dias_reales_cultivo,
    cc.fecha_cosecha_estimada - cc.fecha_siembra as dias_estimados,
    cc.fecha_cosecha_real - cc.fecha_cosecha_estimada as diferencia_dias
FROM ciclo_cultivo cc
JOIN invernadero i ON cc.invernadero_id = i.id
JOIN cultivo c ON cc.cultivo_id = c.id
WHERE cc.estado = 'cosechado'
ORDER BY cc.fecha_cosecha_real DESC;

-- 4.5 Rendimiento de cultivos (comparar tiempo estimado vs real)
SELECT 
    c.nombre_comun as cultivo,
    COUNT(cc.id) as veces_cosechado,
    ROUND(AVG(cc.fecha_cosecha_real - cc.fecha_siembra), 0) as promedio_dias_reales,
    c.dias_cosecha as dias_estimados,
    ROUND(AVG(cc.fecha_cosecha_real - cc.fecha_siembra) - c.dias_cosecha, 1) as diferencia_promedio
FROM ciclo_cultivo cc
JOIN cultivo c ON cc.cultivo_id = c.id
WHERE cc.estado = 'cosechado'
GROUP BY c.id, c.nombre_comun, c.dias_cosecha
ORDER BY veces_cosechado DESC;


-- ============================================================================
-- CASO 5: GESTION DE SENSORES
-- ============================================================================

-- 5.1 Listar todos los sensores con su ubicación
SELECT 
    s.id,
    i.nombre as invernadero,
    s.tipo_sensor,
    s.marca,
    s.modelo,
    s.ubicacion_sensor,
    s.fecha_instalacion,
    s.estado,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, s.fecha_instalacion)) as años_uso
FROM sensor s
JOIN invernadero i ON s.invernadero_id = i.id
ORDER BY i.nombre, s.tipo_sensor;

-- 5.2 Sensores activos por invernadero
SELECT 
    i.nombre as invernadero,
    COUNT(s.id) as total_sensores,
    STRING_AGG(DISTINCT s.tipo_sensor, ', ') as tipos_sensores
FROM invernadero i
LEFT JOIN sensor s ON i.id = s.invernadero_id AND s.estado = 'activo'
GROUP BY i.id, i.nombre
ORDER BY total_sensores DESC;

-- 5.3 Contar sensores por tipo
SELECT 
    tipo_sensor,
    COUNT(*) as cantidad,
    COUNT(CASE WHEN estado = 'activo' THEN 1 END) as activos,
    COUNT(CASE WHEN estado = 'mantenimiento' THEN 1 END) as en_mantenimiento,
    COUNT(CASE WHEN estado = 'inactivo' THEN 1 END) as inactivos
FROM sensor
GROUP BY tipo_sensor
ORDER BY cantidad DESC;

-- 5.4 Sensores que requieren mantenimiento
SELECT 
    s.id,
    i.nombre as invernadero,
    s.tipo_sensor,
    s.marca,
    s.modelo,
    s.ubicacion_sensor,
    s.fecha_instalacion,
    CURRENT_DATE - s.fecha_instalacion as dias_uso,
    s.estado
FROM sensor s
JOIN invernadero i ON s.invernadero_id = i.id
WHERE s.estado = 'mantenimiento' OR 
      (CURRENT_DATE - s.fecha_instalacion) > 365
ORDER BY dias_uso DESC;


-- ============================================================================
-- CASO 6: LECTURAS DE SENSORES Y MONITOREO
-- ============================================================================

-- 6.1 Últimas lecturas de cada sensor
SELECT DISTINCT ON (s.id)
    i.nombre as invernadero,
    s.tipo_sensor,
    s.ubicacion_sensor,
    ls.valor,
    ls.unidad,
    ls.timestamp,
    NOW() - ls.timestamp as tiempo_desde_lectura
FROM sensor s
JOIN invernadero i ON s.invernadero_id = i.id
LEFT JOIN lectura_sensor ls ON s.id = ls.sensor_id
WHERE s.estado = 'activo'
ORDER BY s.id, ls.timestamp DESC;

-- 6.2 Promedio de temperatura por invernadero (últimas 24 horas)
SELECT 
    i.nombre as invernadero,
    ROUND(AVG(ls.valor), 2) as temperatura_promedio,
    ROUND(MIN(ls.valor), 2) as temperatura_minima,
    ROUND(MAX(ls.valor), 2) as temperatura_maxima,
    ls.unidad
FROM sensor s
JOIN invernadero i ON s.invernadero_id = i.id
JOIN lectura_sensor ls ON s.id = ls.sensor_id
WHERE s.tipo_sensor = 'temperatura'
    AND ls.timestamp >= NOW() - INTERVAL '24 hours'
GROUP BY i.id, i.nombre, ls.unidad
ORDER BY temperatura_promedio DESC;

-- 6.3 Promedio de pH por invernadero (últimas 24 horas)
SELECT 
    i.nombre as invernadero,
    ROUND(AVG(ls.valor), 2) as ph_promedio,
    ROUND(MIN(ls.valor), 2) as ph_minimo,
    ROUND(MAX(ls.valor), 2) as ph_maximo,
    COUNT(ls.id) as total_lecturas
FROM sensor s
JOIN invernadero i ON s.invernadero_id = i.id
JOIN lectura_sensor ls ON s.id = ls.sensor_id
WHERE s.tipo_sensor = 'ph'
    AND ls.timestamp >= NOW() - INTERVAL '24 hours'
GROUP BY i.id, i.nombre
ORDER BY ph_promedio;

-- 6.4 Tendencia de humedad por hora (últimas 24 horas)
SELECT 
    DATE_TRUNC('hour', ls.timestamp) as hora,
    i.nombre as invernadero,
    ROUND(AVG(ls.valor), 2) as humedad_promedio,
    ls.unidad
FROM sensor s
JOIN invernadero i ON s.invernadero_id = i.id
JOIN lectura_sensor ls ON s.id = ls.sensor_id
WHERE s.tipo_sensor = 'humedad'
    AND ls.timestamp >= NOW() - INTERVAL '24 hours'
GROUP BY DATE_TRUNC('hour', ls.timestamp), i.id, i.nombre, ls.unidad
ORDER BY hora DESC, i.nombre;

-- 6.5 Detección de valores fuera de rango (temperatura)
SELECT 
    i.nombre as invernadero,
    s.tipo_sensor,
    s.ubicacion_sensor,
    ls.valor,
    ls.unidad,
    ls.timestamp,
    CASE 
        WHEN ls.valor > 30 THEN 'ALTA'
        WHEN ls.valor < 15 THEN 'BAJA'
        ELSE 'NORMAL'
    END as estado_valor
FROM sensor s
JOIN invernadero i ON s.invernadero_id = i.id
JOIN lectura_sensor ls ON s.id = ls.sensor_id
WHERE s.tipo_sensor = 'temperatura'
    AND ls.timestamp >= NOW() - INTERVAL '24 hours'
    AND (ls.valor > 30 OR ls.valor < 15)
ORDER BY ls.timestamp DESC;

-- 6.6 Comparar condiciones actuales con rangos óptimos de cultivos
SELECT 
    i.nombre as invernadero,
    c.nombre_comun as cultivo,
    ROUND(AVG(CASE WHEN s.tipo_sensor = 'temperatura' THEN ls.valor END), 2) as temp_actual,
    CONCAT(c.temp_optima_min, ' - ', c.temp_optima_max) as temp_optima,
    ROUND(AVG(CASE WHEN s.tipo_sensor = 'ph' THEN ls.valor END), 2) as ph_actual,
    CONCAT(c.ph_optimo_min, ' - ', c.ph_optimo_max) as ph_optimo,
    CASE 
        WHEN AVG(CASE WHEN s.tipo_sensor = 'temperatura' THEN ls.valor END) 
             BETWEEN c.temp_optima_min AND c.temp_optima_max
             AND AVG(CASE WHEN s.tipo_sensor = 'ph' THEN ls.valor END) 
             BETWEEN c.ph_optimo_min AND c.ph_optimo_max
        THEN 'OPTIMAS'
        ELSE 'FUERA DE RANGO'
    END as estado_condiciones
FROM ciclo_cultivo cc
JOIN invernadero i ON cc.invernadero_id = i.id
JOIN cultivo c ON cc.cultivo_id = c.id
JOIN sensor s ON s.invernadero_id = i.id
JOIN lectura_sensor ls ON s.id = ls.sensor_id
WHERE cc.estado = 'en_curso'
    AND s.tipo_sensor IN ('temperatura', 'ph')
    AND ls.timestamp >= NOW() - INTERVAL '1 hour'
GROUP BY i.id, i.nombre, c.id, c.nombre_comun, c.temp_optima_min, 
         c.temp_optima_max, c.ph_optimo_min, c.ph_optimo_max;


-- ============================================================================
-- CASO 7: SISTEMA DE ALERTAS
-- ============================================================================

-- 7.1 Alertas activas ordenadas por severidad
SELECT 
    a.id,
    i.nombre as invernadero,
    a.tipo_alerta,
    a.nivel_severidad,
    a.descripcion,
    a.timestamp_inicio,
    NOW() - a.timestamp_inicio as tiempo_activa,
    s.tipo_sensor,
    s.ubicacion_sensor
FROM alerta a
JOIN invernadero i ON a.invernadero_id = i.id
LEFT JOIN sensor s ON a.sensor_id = s.id
WHERE a.estado = 'activa'
ORDER BY 
    CASE a.nivel_severidad
        WHEN 'critica' THEN 1
        WHEN 'alta' THEN 2
        WHEN 'media' THEN 3
        WHEN 'baja' THEN 4
    END,
    a.timestamp_inicio DESC;

-- 7.2 Resumen de alertas por invernadero
SELECT 
    i.nombre as invernadero,
    COUNT(a.id) as total_alertas,
    COUNT(CASE WHEN a.estado = 'activa' THEN 1 END) as alertas_activas,
    COUNT(CASE WHEN a.estado = 'resuelta' THEN 1 END) as alertas_resueltas,
    COUNT(CASE WHEN a.nivel_severidad = 'critica' THEN 1 END) as alertas_criticas
FROM invernadero i
LEFT JOIN alerta a ON i.id = a.invernadero_id
    AND a.timestamp_inicio >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY i.id, i.nombre
ORDER BY alertas_activas DESC, alertas_criticas DESC;

-- 7.3 Historial de alertas (últimos 7 días)
SELECT 
    DATE(a.timestamp_inicio) as fecha,
    i.nombre as invernadero,
    a.tipo_alerta,
    a.nivel_severidad,
    a.descripcion,
    a.estado,
    CASE 
        WHEN a.timestamp_fin IS NOT NULL 
        THEN EXTRACT(EPOCH FROM (a.timestamp_fin - a.timestamp_inicio))/3600
        ELSE NULL
    END as horas_duracion
FROM alerta a
JOIN invernadero i ON a.invernadero_id = i.id
WHERE a.timestamp_inicio >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY a.timestamp_inicio DESC;

-- 7.4 Alertas por tipo y frecuencia
SELECT 
    tipo_alerta,
    COUNT(*) as total_ocurrencias,
    COUNT(CASE WHEN estado = 'activa' THEN 1 END) as activas,
    COUNT(CASE WHEN estado = 'resuelta' THEN 1 END) as resueltas,
    ROUND(AVG(
        CASE 
            WHEN timestamp_fin IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (timestamp_fin - timestamp_inicio))/3600
            ELSE NULL
        END
    ), 2) as promedio_horas_resolucion
FROM alerta
WHERE timestamp_inicio >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY tipo_alerta
ORDER BY total_ocurrencias DESC;

-- 7.5 Tiempo promedio de resolución de alertas por severidad
SELECT 
    nivel_severidad,
    COUNT(*) as total_alertas,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (timestamp_fin - timestamp_inicio))/3600
    ), 2) as promedio_horas_resolucion,
    ROUND(MIN(
        EXTRACT(EPOCH FROM (timestamp_fin - timestamp_inicio))/3600
    ), 2) as minimo_horas,
    ROUND(MAX(
        EXTRACT(EPOCH FROM (timestamp_fin - timestamp_inicio))/3600
    ), 2) as maximo_horas
FROM alerta
WHERE estado = 'resuelta'
    AND timestamp_fin IS NOT NULL
GROUP BY nivel_severidad
ORDER BY 
    CASE nivel_severidad
        WHEN 'critica' THEN 1
        WHEN 'alta' THEN 2
        WHEN 'media' THEN 3
        WHEN 'baja' THEN 4
    END;


-- ============================================================================
-- CASO 8: REPORTES Y ESTADISTICAS AVANZADAS
-- ============================================================================

-- 8.1 Dashboard general del sistema
SELECT 
    (SELECT COUNT(*) FROM invernadero WHERE estado = 'activo') as invernaderos_activos,
    (SELECT COUNT(*) FROM ciclo_cultivo WHERE estado = 'en_curso') as ciclos_activos,
    (SELECT SUM(cantidad_plantas) FROM ciclo_cultivo WHERE estado = 'en_curso') as plantas_activas,
    (SELECT COUNT(*) FROM sensor WHERE estado = 'activo') as sensores_activos,
    (SELECT COUNT(*) FROM alerta WHERE estado = 'activa') as alertas_activas,
    (SELECT COUNT(*) FROM alerta WHERE estado = 'activa' AND nivel_severidad = 'critica') as alertas_criticas;

-- 8.2 Producción total por tipo de cultivo
SELECT 
    c.nombre_comun as cultivo,
    COUNT(cc.id) as total_ciclos,
    SUM(CASE WHEN cc.estado = 'cosechado' THEN cc.cantidad_plantas ELSE 0 END) as plantas_cosechadas,
    SUM(CASE WHEN cc.estado = 'en_curso' THEN cc.cantidad_plantas ELSE 0 END) as plantas_en_cultivo,
    SUM(cc.cantidad_plantas) as total_plantas
FROM cultivo c
LEFT JOIN ciclo_cultivo cc ON c.id = cc.cultivo_id
GROUP BY c.id, c.nombre_comun
ORDER BY total_plantas DESC;

-- 8.3 Eficiencia de invernaderos (utilización de espacio)
SELECT 
    i.nombre as invernadero,
    i.area_m2,
    COUNT(cc.id) as ciclos_activos,
    SUM(cc.cantidad_plantas) as plantas_actuales,
    ROUND(SUM(cc.cantidad_plantas)::numeric / i.area_m2, 2) as plantas_por_m2,
    CASE 
        WHEN SUM(cc.cantidad_plantas)::numeric / i.area_m2 > 2 THEN 'ALTA'
        WHEN SUM(cc.cantidad_plantas)::numeric / i.area_m2 > 1 THEN 'MEDIA'
        ELSE 'BAJA'
    END as nivel_utilizacion
FROM invernadero i
LEFT JOIN ciclo_cultivo cc ON i.id = cc.invernadero_id AND cc.estado = 'en_curso'
WHERE i.estado = 'activo'
GROUP BY i.id, i.nombre, i.area_m2
ORDER BY plantas_por_m2 DESC;

-- 8.4 Análisis de estabilidad de condiciones ambientales
SELECT 
    i.nombre as invernadero,
    s.tipo_sensor,
    COUNT(ls.id) as total_lecturas,
    ROUND(AVG(ls.valor), 2) as promedio,
    ROUND(STDDEV(ls.valor), 2) as desviacion_estandar,
    ROUND(MIN(ls.valor), 2) as minimo,
    ROUND(MAX(ls.valor), 2) as maximo,
    ROUND(MAX(ls.valor) - MIN(ls.valor), 2) as rango,
    CASE 
        WHEN STDDEV(ls.valor) < 2 THEN 'MUY ESTABLE'
        WHEN STDDEV(ls.valor) < 5 THEN 'ESTABLE'
        WHEN STDDEV(ls.valor) < 10 THEN 'VARIABLE'
        ELSE 'MUY VARIABLE'
    END as estabilidad
FROM sensor s
JOIN invernadero i ON s.invernadero_id = i.id
JOIN lectura_sensor ls ON s.id = ls.sensor_id
WHERE s.estado = 'activo'
    AND ls.timestamp >= NOW() - INTERVAL '7 days'
GROUP BY i.id, i.nombre, s.tipo_sensor
ORDER BY i.nombre, s.tipo_sensor;

-- 8.5 Calendario de cosechas proyectadas (próximos 60 días)
SELECT 
    DATE(cc.fecha_cosecha_estimada) as fecha_cosecha,
    i.nombre as invernadero,
    c.nombre_comun as cultivo,
    cc.cantidad_plantas,
    cc.fecha_siembra,
    cc.fecha_cosecha_estimada - CURRENT_DATE as dias_restantes,
    CASE 
        WHEN cc.fecha_cosecha_estimada - CURRENT_DATE <= 7 THEN 'URGENTE'
        WHEN cc.fecha_cosecha_estimada - CURRENT_DATE <= 15 THEN 'PROXIMO'
        ELSE 'PLANIFICADO'
    END as prioridad
FROM ciclo_cultivo cc
JOIN invernadero i ON cc.invernadero_id = i.id
JOIN cultivo c ON cc.cultivo_id = c.id
WHERE cc.estado = 'en_curso'
    AND cc.fecha_cosecha_estimada BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '60 days'
ORDER BY cc.fecha_cosecha_estimada;


-- ============================================================================
-- CASO 9: CONSULTAS DE OPTIMIZACION Y RECOMENDACIONES
-- ============================================================================

-- 9.1 Mejores cultivos por rendimiento histórico
SELECT 
    c.nombre_comun as cultivo,
    COUNT(cc.id) as veces_cultivado,
    ROUND(AVG(cc.fecha_cosecha_real - cc.fecha_siembra)::numeric, 1) as dias_promedio_real,
    c.dias_cosecha as dias_estimados,
    ROUND((AVG(cc.fecha_cosecha_real - cc.fecha_siembra)::numeric / c.dias_cosecha - 1) * 100, 1) as porcentaje_diferencia,
    SUM(cc.cantidad_plantas) as total_plantas_cosechadas
FROM cultivo c
JOIN ciclo_cultivo cc ON c.id = cc.cultivo_id
WHERE cc.estado = 'cosechado'
GROUP BY c.id, c.nombre_comun, c.dias_cosecha
HAVING COUNT(cc.id) >= 1
ORDER BY porcentaje_diferencia ASC;

-- 9.2 Identificar invernaderos con condiciones subóptimas
SELECT DISTINCT
    i.nombre as invernadero,
    c.nombre_comun as cultivo_actual,
    STRING_AGG(DISTINCT 
        CASE 
            WHEN s.tipo_sensor = 'temperatura' AND 
                 (ls.valor < c.temp_optima_min OR ls.valor > c.temp_optima_max)
            THEN 'Temperatura fuera de rango'
            WHEN s.tipo_sensor = 'ph' AND 
                 (ls.valor < c.ph_optimo_min OR ls.valor > c.ph_optimo_max)
            THEN 'pH fuera de rango'
            ELSE NULL
        END, ', '
    ) as problemas_detectados
FROM ciclo_cultivo cc
JOIN invernadero i ON cc.invernadero_id = i.id
JOIN cultivo c ON cc.cultivo_id = c.id
JOIN sensor s ON s.invernadero_id = i.id
JOIN lectura_sensor ls ON s.id = ls.sensor_id
WHERE cc.estado = 'en_curso'
    AND s.tipo_sensor IN ('temperatura', 'ph')
    AND ls.timestamp >= NOW() - INTERVAL '1 hour'
    AND (
        (s.tipo_sensor = 'temperatura' AND 
         (ls.valor < c.temp_optima_min OR ls.valor > c.temp_optima_max))
        OR
        (s.tipo_sensor = 'ph' AND 
         (ls.valor < c.ph_optimo_min OR ls.valor > c.ph_optimo_max))
    )
GROUP BY i.id, i.nombre, c.nombre_comun
HAVING STRING_AGG(DISTINCT 
    CASE 
        WHEN s.tipo_sensor = 'temperatura' AND 
             (ls.valor < c.temp_optima_min OR ls.valor > c.temp_optima_max)
        THEN 'Temperatura fuera de rango'
        WHEN s.tipo_sensor = 'ph' AND 
             (ls.valor < c.ph_optimo_min OR ls.valor > c.ph_optimo_max)
        THEN 'pH fuera de rango'
        ELSE NULL
    END, ', ') IS NOT NULL;

-- 9.3 Recomendación de próximos cultivos por invernadero
-- (Basado en condiciones actuales y cultivos previos exitosos)
SELECT 
    i.nombre as invernadero,
    c.nombre_comun as cultivo_recomendado,
    c.dias_cosecha,
    CONCAT(c.temp_optima_min, '°C - ', c.temp_optima_max, '°C') as temp_requerida,
    CONCAT(c.ph_optimo_min, ' - ', c.ph_optimo_max) as ph_requerido,
    COUNT(cc_hist.id) as veces_cultivado_antes,
    CASE 
        WHEN COUNT(cc_hist.id) > 0 THEN 'EXPERIENCIA PREVIA'
        ELSE 'NUEVO CULTIVO'
    END as experiencia
FROM invernadero i
CROSS JOIN cultivo c
LEFT JOIN ciclo_cultivo cc_hist ON i.id = cc_hist.invernadero_id 
    AND c.id = cc_hist.cultivo_id
    AND cc_hist.estado = 'cosechado'
WHERE i.estado = 'activo'
    AND i.id NOT IN (
        SELECT invernadero_id 
        FROM ciclo_cultivo 
        WHERE estado = 'en_curso'
    )
GROUP BY i.id, i.nombre, c.id, c.nombre_comun, c.dias_cosecha, 
         c.temp_optima_min, c.temp_optima_max, c.ph_optimo_min, c.ph_optimo_max
ORDER BY i.nombre, veces_cultivado_antes DESC, c.dias_cosecha;


-- ============================================================================
-- CASO 10: CONSULTAS PARA EXPORTAR/REPORTES
-- ============================================================================

-- 10.1 Reporte completo de estado del sistema (para exportar)
SELECT 
    NOW() as fecha_reporte,
    i.nombre as invernadero,
    i.ubicacion,
    i.area_m2,
    i.estado as estado_invernadero,
    COUNT(DISTINCT cc.id) FILTER (WHERE cc.estado = 'en_curso') as ciclos_activos,
    STRING_AGG(DISTINCT c.nombre_comun, ', ') FILTER (WHERE cc.estado = 'en_curso') as cultivos_actuales,
    SUM(cc.cantidad_plantas) FILTER (WHERE cc.estado = 'en_curso') as plantas_activas,
    COUNT(DISTINCT s.id) FILTER (WHERE s.estado = 'activo') as sensores_activos,
    COUNT(DISTINCT a.id) FILTER (WHERE a.estado = 'activa') as alertas_activas
FROM invernadero i
LEFT JOIN ciclo_cultivo cc ON i.id = cc.invernadero_id
LEFT JOIN cultivo c ON cc.cultivo_id = c.id
LEFT JOIN sensor s ON i.id = s.invernadero_id
LEFT JOIN alerta a ON i.id = a.invernadero_id
GROUP BY i.id, i.nombre, i.ubicacion, i.area_m2, i.estado
ORDER BY i.nombre;

-- 10.2 Reporte de producción mensual
SELECT 
    TO_CHAR(cc.fecha_cosecha_real, 'YYYY-MM') as mes,
    c.nombre_comun as cultivo,
    COUNT(cc.id) as ciclos_cosechados,
    SUM(cc.cantidad_plantas) as total_plantas_cosechadas,
    ROUND(AVG(cc.cantidad_plantas), 0) as promedio_plantas_por_ciclo
FROM ciclo_cultivo cc
JOIN cultivo c ON cc.cultivo_id = c.id
WHERE cc.estado = 'cosechado'
    AND cc.fecha_cosecha_real >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '6 months')
GROUP BY TO_CHAR(cc.fecha_cosecha_real, 'YYYY-MM'), c.nombre_comun
ORDER BY mes DESC, total_plantas_cosechadas DESC;

-- 10.3 Reporte de alertas para auditoría
SELECT 
    a.id,
    a.timestamp_inicio,
    i.nombre as invernadero,
    a.tipo_alerta,
    a.nivel_severidad,
    a.descripcion,
    s.tipo_sensor,
    s.ubicacion_sensor,
    a.estado,
    a.timestamp_fin,
    CASE 
        WHEN a.timestamp_fin IS NOT NULL 
        THEN ROUND(EXTRACT(EPOCH FROM (a.timestamp_fin - a.timestamp_inicio))/60, 0)
        ELSE NULL
    END as minutos_duracion
FROM alerta a
JOIN invernadero i ON a.invernadero_id = i.id
LEFT JOIN sensor s ON a.sensor_id = s.id
WHERE a.timestamp_inicio >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY a.timestamp_inicio DESC;