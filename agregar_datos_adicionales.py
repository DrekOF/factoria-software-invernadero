"""
Script para agregar datos adicionales de prueba
optimizados para probar todas las queries de consulta.

Autor: Sistema de Gestión de Invernadero Hidropónico
Fecha: 2026
"""

import psycopg2
from datetime import datetime, timedelta
import random

# ============================================================================
# CONFIGURACIÓN DE CONEXIÓN
# ============================================================================
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'user': 'admin_invernadero',
    'password': 'invernadero2026',
    'database': 'invernadero_hidroponico',
    'client_encoding': 'UTF8'
}

# ============================================================================
# FUNCIÓN: CONECTAR A LA BASE DE DATOS
# ============================================================================
def conectar():
    """
    Establece conexión con la base de datos.
    
    Returns:
        conexion: Objeto de conexión a PostgreSQL
    """
    try:
        conexion = psycopg2.connect(**DB_CONFIG)
        print("[OK] Conexion exitosa a la base de datos\n")
        return conexion
    except psycopg2.Error as e:
        print(f"[ERROR] No se pudo conectar a la base de datos: {e}")
        return None


# ============================================================================
# AGREGAR MÁS USUARIOS
# ============================================================================
def agregar_usuarios(conexion):
    """
    Agrega más usuarios de diferentes roles.
    """
    cursor = conexion.cursor()
    
    print("Agregando usuarios adicionales...")
    
    usuarios = [
        ('Pedro Sánchez Ortiz', 'pedro.sanchez@invernadero.com', 'hash_password_ghi', 'operador'),
        ('Laura Fernández Cruz', 'laura.fernandez@invernadero.com', 'hash_password_jkl', 'administrador'),
        ('Roberto Díaz Luna', 'roberto.diaz@invernadero.com', 'hash_password_mno', 'observador'),
        ('Carmen Ruiz Vega', 'carmen.ruiz@invernadero.com', 'hash_password_pqr', 'operador'),
        ('Miguel Torres Paredes', 'miguel.torres@invernadero.com', 'hash_password_stu', 'observador'),
        ('Patricia Mendoza Silva', 'patricia.mendoza@invernadero.com', 'hash_password_vwx', 'operador'),
        ('Fernando Castro Rojas', 'fernando.castro@invernadero.com', 'hash_password_yz1', 'observador'),
        ('Sandra Jiménez Mejía', 'sandra.jimenez@invernadero.com', 'hash_password_234', 'administrador')
    ]
    
    contador = 0
    for usuario in usuarios:
        try:
            cursor.execute("""
                INSERT INTO usuario (nombre_completo, email, password_hash, rol)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (email) DO NOTHING
            """, usuario)
            if cursor.rowcount > 0:
                contador += 1
        except psycopg2.Error:
            pass
    
    conexion.commit()
    print(f"[OK] {contador} usuarios adicionales agregados\n")


# ============================================================================
# AGREGAR MÁS INVERNADEROS
# ============================================================================
def agregar_invernaderos(conexion):
    """
    Agrega más invernaderos en diferentes estados.
    """
    cursor = conexion.cursor()
    
    print("Agregando invernaderos adicionales...")
    
    invernaderos = [
        ('Invernadero Centro - Alta Producción', 'Carrera 5 #20-30, Neiva, Huila', 2.9200, -75.2850, 600.00, '2023-06-15', 'activo'),
        ('Invernadero Piloto - Tecnología Avanzada', 'Avenida La Toma #50-10, Neiva, Huila', 2.9320, -75.2780, 400.00, '2024-01-10', 'activo'),
        ('Invernadero Rural - Comunitario', 'Vereda El Caguán, Neiva, Huila', 2.9050, -75.3100, 300.00, '2022-08-20', 'activo'),
        ('Invernadero Experimental 2', 'Zona Industrial, Neiva, Huila', 2.9180, -75.2920, 200.00, '2024-03-05', 'mantenimiento'),
        ('Invernadero Norte Plus', 'Calle 40 Norte #15-25, Neiva, Huila', 2.9380, -75.2750, 550.00, '2023-09-12', 'activo')
    ]
    
    contador = 0
    for invernadero in invernaderos:
        cursor.execute("""
            INSERT INTO invernadero (nombre, ubicacion, latitud, longitud, area_m2, fecha_instalacion, estado)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, invernadero)
        contador += 1
    
    conexion.commit()
    print(f"[OK] {contador} invernaderos adicionales agregados\n")


# ============================================================================
# AGREGAR MÁS CULTIVOS
# ============================================================================
def agregar_cultivos(conexion):
    """
    Agrega más variedades de cultivos.
    """
    cursor = conexion.cursor()
    
    print("Agregando cultivos adicionales...")
    
    cultivos = [
        ('Rúcula', 'Eruca vesicaria', 6.0, 7.0, 15.0, 22.0, 30),
        ('Acelga', 'Beta vulgaris var. cicla', 6.0, 7.5, 12.0, 24.0, 55),
        ('Col Rizada (Kale)', 'Brassica oleracea var. sabellica', 6.0, 7.5, 10.0, 25.0, 60),
        ('Pimiento', 'Capsicum annuum', 5.5, 6.8, 20.0, 30.0, 80),
        ('Menta', 'Mentha', 6.0, 7.0, 15.0, 25.0, 40),
        ('Perejil', 'Petroselinum crispum', 5.5, 6.7, 15.0, 25.0, 35),
        ('Berro', 'Nasturtium officinale', 6.5, 7.5, 10.0, 20.0, 25),
        ('Apio', 'Apium graveolens', 6.0, 7.0, 15.0, 22.0, 85),
        ('Cebollín', 'Allium schoenoprasum', 6.0, 7.0, 15.0, 25.0, 50),
        ('Brócoli', 'Brassica oleracea var. italica', 6.0, 7.0, 15.0, 23.0, 70)
    ]
    
    contador = 0
    for cultivo in cultivos:
        try:
            cursor.execute("""
                INSERT INTO cultivo (nombre_comun, nombre_cientifico, ph_optimo_min, ph_optimo_max, 
                                   temp_optima_min, temp_optima_max, dias_cosecha)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, cultivo)
            contador += 1
        except psycopg2.Error:
            pass
    
    conexion.commit()
    print(f"[OK] {contador} cultivos adicionales agregados\n")


# ============================================================================
# AGREGAR MÁS CICLOS DE CULTIVO (VARIADOS)
# ============================================================================
def agregar_ciclos_cultivo(conexion):
    """
    Agrega más ciclos de cultivo en diferentes estados y fechas.
    """
    cursor = conexion.cursor()
    
    print("Agregando ciclos de cultivo adicionales...")
    
    fecha_actual = datetime.now().date()
    
    # Obtener IDs de invernaderos y cultivos disponibles
    cursor.execute("SELECT id FROM invernadero WHERE estado = 'activo'")
    invernaderos = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT id FROM cultivo")
    cultivos = [row[0] for row in cursor.fetchall()]
    
    ciclos = []
    
    # Ciclos en curso adicionales (próximos a cosechar)
    for i in range(10):
        inv_id = random.choice(invernaderos)
        cult_id = random.choice(cultivos)
        dias_atras = random.randint(40, 70)
        dias_adelante = random.randint(5, 20)
        plantas = random.randint(200, 800)
        
        ciclos.append((
            inv_id,
            cult_id,
            fecha_actual - timedelta(days=dias_atras),
            fecha_actual + timedelta(days=dias_adelante),
            None,
            plantas,
            'en_curso'
        ))
    
    # Ciclos cosechados recientes (último mes)
    for i in range(15):
        inv_id = random.choice(invernaderos)
        cult_id = random.choice(cultivos)
        dias_siembra = random.randint(60, 120)
        dias_cosecha = random.randint(50, 80)
        plantas = random.randint(200, 700)
        
        fecha_siembra = fecha_actual - timedelta(days=dias_siembra)
        fecha_cosecha_est = fecha_siembra + timedelta(days=dias_cosecha)
        fecha_cosecha_real = fecha_cosecha_est + timedelta(days=random.randint(-5, 5))
        
        ciclos.append((
            inv_id,
            cult_id,
            fecha_siembra,
            fecha_cosecha_est,
            fecha_cosecha_real,
            plantas,
            'cosechado'
        ))
    
    # Ciclos cosechados históricos (últimos 6 meses)
    for i in range(20):
        inv_id = random.choice(invernaderos)
        cult_id = random.choice(cultivos)
        dias_siembra = random.randint(120, 200)
        dias_cosecha = random.randint(50, 90)
        plantas = random.randint(150, 600)
        
        fecha_siembra = fecha_actual - timedelta(days=dias_siembra)
        fecha_cosecha_est = fecha_siembra + timedelta(days=dias_cosecha)
        fecha_cosecha_real = fecha_cosecha_est + timedelta(days=random.randint(-7, 7))
        
        ciclos.append((
            inv_id,
            cult_id,
            fecha_siembra,
            fecha_cosecha_est,
            fecha_cosecha_real,
            plantas,
            'cosechado'
        ))
    
    # Ciclos planificados
    for i in range(8):
        inv_id = random.choice(invernaderos)
        cult_id = random.choice(cultivos)
        dias_adelante_inicio = random.randint(5, 30)
        dias_cultivo = random.randint(40, 90)
        plantas = random.randint(200, 500)
        
        fecha_siembra = fecha_actual + timedelta(days=dias_adelante_inicio)
        fecha_cosecha_est = fecha_siembra + timedelta(days=dias_cultivo)
        
        ciclos.append((
            inv_id,
            cult_id,
            fecha_siembra,
            fecha_cosecha_est,
            None,
            plantas,
            'planificado'
        ))
    
    # Algunos ciclos abandonados
    for i in range(3):
        inv_id = random.choice(invernaderos)
        cult_id = random.choice(cultivos)
        dias_atras = random.randint(30, 60)
        dias_adelante = random.randint(20, 40)
        plantas = random.randint(100, 400)
        
        ciclos.append((
            inv_id,
            cult_id,
            fecha_actual - timedelta(days=dias_atras),
            fecha_actual + timedelta(days=dias_adelante),
            None,
            plantas,
            'abandonado'
        ))
    
    # Insertar todos los ciclos
    contador = 0
    for ciclo in ciclos:
        try:
            cursor.execute("""
                INSERT INTO ciclo_cultivo (invernadero_id, cultivo_id, fecha_siembra, fecha_cosecha_estimada,
                                          fecha_cosecha_real, cantidad_plantas, estado)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, ciclo)
            contador += 1
        except psycopg2.Error as e:
            print(f"[WARN] Error al insertar ciclo: {e}")
            pass
    
    conexion.commit()
    print(f"[OK] {contador} ciclos de cultivo adicionales agregados\n")


# ============================================================================
# AGREGAR MÁS SENSORES
# ============================================================================
def agregar_sensores(conexion):
    """
    Agrega más sensores en todos los invernaderos.
    """
    cursor = conexion.cursor()
    
    print("Agregando sensores adicionales...")
    
    fecha_instalacion = datetime.now().date() - timedelta(days=random.randint(30, 180))
    
    # Obtener todos los invernaderos
    cursor.execute("SELECT id, nombre FROM invernadero")
    invernaderos = cursor.fetchall()
    
    tipos_sensor = [
        ('temperatura', 'DHT22', 'DHT22-AM2302'),
        ('temperatura', 'DS18B20', 'DS18B20'),
        ('humedad', 'DHT22', 'DHT22-AM2302'),
        ('humedad', 'SHT31', 'SHT31-DIS'),
        ('ph', 'Atlas Scientific', 'pH-EZO'),
        ('ec', 'Atlas Scientific', 'EC-EZO'),
        ('luz', 'BH1750', 'BH1750FVI'),
        ('luz', 'TSL2561', 'TSL2561'),
        ('co2', 'MH-Z19', 'MH-Z19B'),
        ('co2', 'SCD30', 'SCD30')
    ]
    
    ubicaciones = [
        'Zona Norte', 'Zona Sur', 'Zona Este', 'Zona Oeste', 'Zona Central',
        'Entrada Principal', 'Zona de Riego', 'Techo', 'Pared Norte', 'Pared Sur'
    ]
    
    sensores = []
    contador = 0
    
    for inv_id, inv_nombre in invernaderos:
        # Agregar 2-4 sensores aleatorios por invernadero
        num_sensores = random.randint(2, 4)
        sensores_seleccionados = random.sample(tipos_sensor, num_sensores)
        
        for tipo, marca, modelo in sensores_seleccionados:
            ubicacion = random.choice(ubicaciones)
            estado = random.choice(['activo', 'activo', 'activo', 'mantenimiento'])  # 75% activo
            
            try:
                cursor.execute("""
                    INSERT INTO sensor (invernadero_id, tipo_sensor, marca, modelo, ubicacion_sensor, 
                                      fecha_instalacion, estado)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (inv_id, tipo, marca, modelo, ubicacion, fecha_instalacion, estado))
                contador += 1
            except psycopg2.Error:
                pass
    
    conexion.commit()
    print(f"[OK] {contador} sensores adicionales agregados\n")


# ============================================================================
# AGREGAR MÁS LECTURAS DE SENSORES
# ============================================================================
def agregar_lecturas_sensores(conexion):
    """
    Agrega más lecturas de sensores para los últimos 14 días.
    """
    cursor = conexion.cursor()
    
    print("Agregando lecturas de sensores adicionales (puede tomar tiempo)...")
    
    # Obtener todos los sensores activos
    cursor.execute("SELECT id, tipo_sensor FROM sensor WHERE estado = 'activo'")
    sensores = cursor.fetchall()
    
    # Configuración de rangos por tipo de sensor
    rangos_sensores = {
        'temperatura': {'min': 12.0, 'max': 35.0, 'unidad': '°C'},
        'humedad': {'min': 45.0, 'max': 90.0, 'unidad': '%'},
        'ph': {'min': 4.8, 'max': 7.8, 'unidad': 'pH'},
        'ec': {'min': 0.8, 'max': 3.2, 'unidad': 'mS/cm'},
        'luz': {'min': 3000.0, 'max': 60000.0, 'unidad': 'lux'},
        'co2': {'min': 350.0, 'max': 1500.0, 'unidad': 'ppm'}
    }
    
    # Generar lecturas para los últimos 14 días
    dias_historial = 14
    lecturas_por_dia = 24  # Una lectura por hora
    
    fecha_actual = datetime.now()
    total_lecturas = 0
    
    print(f"Generando lecturas para {len(sensores)} sensores...")
    
    for sensor_id, tipo_sensor in sensores:
        if tipo_sensor in rangos_sensores:
            config = rangos_sensores[tipo_sensor]
            
            # Generar un valor base para este sensor
            valor_base = random.uniform(config['min'], config['max'])
            
            for dia in range(dias_historial):
                for hora in range(lecturas_por_dia):
                    # Calcular timestamp
                    timestamp = fecha_actual - timedelta(days=dia, hours=hora, minutes=random.randint(0, 59))
                    
                    # Generar valor con variación alrededor del valor base
                    variacion = random.uniform(-2, 2)
                    valor = round(max(config['min'], min(config['max'], valor_base + variacion)), 2)
                    
                    try:
                        cursor.execute("""
                            INSERT INTO lectura_sensor (sensor_id, timestamp, valor, unidad)
                            VALUES (%s, %s, %s, %s)
                        """, (sensor_id, timestamp, valor, config['unidad']))
                        total_lecturas += 1
                    except psycopg2.Error:
                        pass
        
        # Commit cada 100 sensores para no sobrecargar
        if total_lecturas % 1000 == 0:
            conexion.commit()
            print(f"  Progreso: {total_lecturas} lecturas insertadas...")
    
    conexion.commit()
    print(f"[OK] {total_lecturas} lecturas de sensores adicionales agregadas\n")


# ============================================================================
# AGREGAR MÁS ALERTAS
# ============================================================================
def agregar_alertas(conexion):
    """
    Agrega más alertas en diferentes estados y severidades.
    """
    cursor = conexion.cursor()
    
    print("Agregando alertas adicionales...")
    
    fecha_actual = datetime.now()
    
    # Obtener invernaderos y sensores
    cursor.execute("SELECT id FROM invernadero WHERE estado = 'activo'")
    invernaderos = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT id, tipo_sensor FROM sensor WHERE estado = 'activo'")
    sensores = cursor.fetchall()
    
    tipos_alerta = [
        'temperatura_alta', 'temperatura_baja', 'humedad_alta', 'humedad_baja',
        'ph_alto', 'ph_bajo', 'ph_fuera_rango', 'ec_alta', 'ec_baja',
        'luz_baja', 'luz_alta', 'co2_alto', 'co2_bajo', 'sensor_sin_respuesta',
        'sistema', 'conectividad'
    ]
    
    severidades = ['baja', 'media', 'alta', 'critica']
    
    alertas = []
    
    # Alertas activas
    for i in range(15):
        inv_id = random.choice(invernaderos)
        sensor_id = random.choice(sensores)[0] if random.random() > 0.3 else None
        tipo = random.choice(tipos_alerta)
        severidad = random.choice(severidades)
        horas_atras = random.randint(1, 48)
        
        descripcion = f"Alerta de {tipo} detectada - Nivel {severidad}"
        
        alertas.append((
            inv_id,
            sensor_id,
            tipo,
            severidad,
            descripcion,
            fecha_actual - timedelta(hours=horas_atras),
            None,
            'activa'
        ))
    
    # Alertas resueltas recientes
    for i in range(25):
        inv_id = random.choice(invernaderos)
        sensor_id = random.choice(sensores)[0] if random.random() > 0.2 else None
        tipo = random.choice(tipos_alerta)
        severidad = random.choice(severidades)
        dias_atras_inicio = random.randint(1, 14)
        horas_duracion = random.randint(1, 48)
        
        descripcion = f"Alerta de {tipo} - Resuelto"
        timestamp_inicio = fecha_actual - timedelta(days=dias_atras_inicio, hours=random.randint(0, 23))
        timestamp_fin = timestamp_inicio + timedelta(hours=horas_duracion)
        
        alertas.append((
            inv_id,
            sensor_id,
            tipo,
            severidad,
            descripcion,
            timestamp_inicio,
            timestamp_fin,
            'resuelta'
        ))
    
    # Alertas ignoradas
    for i in range(8):
        inv_id = random.choice(invernaderos)
        sensor_id = random.choice(sensores)[0] if random.random() > 0.4 else None
        tipo = random.choice(['luz_baja', 'humedad_baja', 'temperatura_baja'])
        severidad = 'baja'
        dias_atras = random.randint(1, 7)
        
        descripcion = f"Alerta de {tipo} - Ignorada (condición normal)"
        
        alertas.append((
            inv_id,
            sensor_id,
            tipo,
            severidad,
            descripcion,
            fecha_actual - timedelta(days=dias_atras, hours=random.randint(0, 23)),
            None,
            'ignorada'
        ))
    
    # Insertar alertas
    contador = 0
    for alerta in alertas:
        try:
            cursor.execute("""
                INSERT INTO alerta (invernadero_id, sensor_id, tipo_alerta, nivel_severidad, 
                                  descripcion, timestamp_inicio, timestamp_fin, estado)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, alerta)
            contador += 1
        except psycopg2.Error:
            pass
    
    conexion.commit()
    print(f"[OK] {contador} alertas adicionales agregadas\n")


# ============================================================================
# FUNCIÓN PRINCIPAL
# ============================================================================
def main():
    """
    Función principal que ejecuta todos los procesos de inserción adicional.
    """
    print("\n" + "="*80)
    print("AGREGAR DATOS ADICIONALES DE PRUEBA")
    print("Sistema de Gestion de Invernadero Hidroponico")
    print("="*80 + "\n")
    
    # Conectar a la base de datos
    conexion = conectar()
    if not conexion:
        return
    
    try:
        print("Este script agregara datos adicionales sin eliminar los existentes.\n")
        
        respuesta = input("¿Desea continuar? (s/n): ")
        if respuesta.lower() != 's':
            print("\n[INFO] Operacion cancelada por el usuario")
            return
        
        print("\n")
        
        # Agregar datos adicionales
        agregar_usuarios(conexion)
        agregar_invernaderos(conexion)
        agregar_cultivos(conexion)
        agregar_ciclos_cultivo(conexion)
        agregar_sensores(conexion)
        agregar_lecturas_sensores(conexion)
        agregar_alertas(conexion)
        
        print("="*80)
        print("[OK] TODOS LOS DATOS ADICIONALES INSERTADOS EXITOSAMENTE")
        print("="*80)
        
        # Mostrar resumen actualizado
        print("\n" + "="*80)
        print("RESUMEN ACTUALIZADO DE LA BASE DE DATOS")
        print("="*80)
        
        cursor = conexion.cursor()
        
        tablas = [
            'usuario',
            'invernadero',
            'cultivo',
            'ciclo_cultivo',
            'sensor',
            'lectura_sensor',
            'alerta'
        ]
        
        for tabla in tablas:
            cursor.execute(f"SELECT COUNT(*) FROM {tabla}")
            count = cursor.fetchone()[0]
            print(f"{tabla.ljust(25)}: {count} registros")
        
        print("="*80 + "\n")
        
        print("[INFO] Ahora puedes ejecutar las queries de consulta con datos suficientes")
        print("[INFO] para probar todos los casos de uso.\n")
        
    except Exception as e:
        print(f"\n[ERROR] Ocurrio un error durante la insercion: {e}")
        conexion.rollback()
    
    finally:
        conexion.close()
        print("[INFO] Conexion cerrada\n")


# ============================================================================
# EJECUTAR EL SCRIPT
# ============================================================================
if __name__ == "__main__":
    main()