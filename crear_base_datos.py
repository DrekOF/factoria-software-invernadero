"""
Script para crear automáticamente una base de datos PostgreSQL
basándose en un archivo JSON de configuración.

Autor: Sistema de Gestión de Invernadero Hidropónico
Fecha: 2026
"""

import json
import psycopg2
from psycopg2 import sql
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

# ============================================================================
# FUNCIÓN 1: CARGAR CONFIGURACIÓN DESDE JSON
# ============================================================================
def cargar_configuracion(ruta_json):
    """
    Lee el archivo JSON que contiene la configuración de la base de datos.
    Intenta múltiples codificaciones para manejar caracteres especiales.
    
    Args:
        ruta_json (str): Ruta al archivo JSON de configuración
        
    Returns:
        dict: Diccionario con toda la configuración
    """
    # Lista de codificaciones a intentar
    codificaciones = ['utf-8-sig', 'utf-8', 'latin-1', 'cp1252', 'iso-8859-1']
    
    for encoding in codificaciones:
        try:
            with open(ruta_json, 'r', encoding=encoding) as archivo:
                configuracion = json.load(archivo)
            print(f"[OK] Configuracion cargada exitosamente desde {ruta_json} (encoding: {encoding})")
            return configuracion
        except (UnicodeDecodeError, UnicodeError):
            continue  # Intentar con la siguiente codificación
        except FileNotFoundError:
            print(f"[ERROR] No se encontro el archivo {ruta_json}")
            return None
        except json.JSONDecodeError as e:
            print(f"[ERROR] El archivo {ruta_json} no tiene formato JSON valido")
            print(f"   Detalles: {e}")
            return None
    
    print(f"[ERROR] No se pudo leer el archivo con ninguna codificacion")
    return None


# ============================================================================
# FUNCIÓN 2: CREAR BASE DE DATOS
# ============================================================================
def crear_base_datos(config):
    """
    Crea la base de datos si no existe.
    Primero se conecta a la base de datos por defecto 'postgres' para crear
    la nueva base de datos.
    
    Args:
        config (dict): Diccionario con la configuración
        
    Returns:
        bool: True si se creó o ya existe, False si hubo error
    """
    try:
        # Conexión a la base de datos por defecto 'postgres'
        conexion = psycopg2.connect(
            host=config.get('host', 'localhost'),
            port=config.get('port', 5432),
            user=config['user'],
            password=config['password'],
            database='postgres',  # Base de datos por defecto de PostgreSQL
            client_encoding='UTF8'
        )
        
        # Configurar para ejecutar comandos de creación de BD
        conexion.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = conexion.cursor()
        
        # Verificar si la base de datos ya existe
        cursor.execute(
            "SELECT 1 FROM pg_database WHERE datname = %s",
            (config['db'],)
        )
        existe = cursor.fetchone()
        
        if existe:
            print(f"[INFO] La base de datos '{config['db']}' ya existe")
        else:
            # Crear la base de datos
            cursor.execute(
                sql.SQL("CREATE DATABASE {}").format(
                    sql.Identifier(config['db'])
                )
            )
            print(f"[OK] Base de datos '{config['db']}' creada exitosamente")
        
        cursor.close()
        conexion.close()
        return True
        
    except psycopg2.Error as e:
        print(f"[ERROR] Al crear la base de datos: {e}")
        return False


# ============================================================================
# FUNCIÓN 3: MAPEAR TIPOS DE DATOS
# ============================================================================
def mapear_tipo_dato(atributo):
    """
    Convierte los tipos de datos del JSON a tipos de PostgreSQL.
    Maneja también longitud, precisión y valores por defecto.
    
    Args:
        atributo (dict): Diccionario con información del atributo
        
    Returns:
        str: Tipo de dato en formato PostgreSQL
    """
    tipo = atributo['tipo_dato'].lower()
    
    # Tipos numéricos seriales (autoincrement)
    if tipo in ['serial', 'bigserial']:
        return tipo.upper()
    
    # Tipos de cadena con longitud
    if tipo == 'varchar':
        longitud = atributo.get('longitud', 255)
        return f"VARCHAR({longitud})"
    
    # Tipo texto sin límite
    if tipo == 'text':
        return "TEXT"
    
    # Tipos numéricos con precisión
    if tipo == 'decimal' or tipo == 'numeric':
        longitud = atributo.get('longitud', 10)
        precision = atributo.get('precision', 2)
        return f"DECIMAL({longitud},{precision})"
    
    # Tipos enteros
    if tipo == 'integer' or tipo == 'int':
        return "INTEGER"
    
    if tipo == 'bigint':
        return "BIGINT"
    
    # Tipos de fecha y hora
    if tipo == 'date':
        return "DATE"
    
    if tipo == 'timestamp':
        return "TIMESTAMP"
    
    if tipo == 'time':
        return "TIME"
    
    # Tipo booleano
    if tipo == 'boolean' or tipo == 'bool':
        return "BOOLEAN"
    
    # Por defecto, retornar el tipo tal cual
    return tipo.upper()


# ============================================================================
# FUNCIÓN 4: GENERAR DEFINICIÓN DE COLUMNA
# ============================================================================
def generar_definicion_columna(atributo):
    """
    Genera la definición SQL completa de una columna.
    Incluye: nombre, tipo, constraints (NOT NULL, PRIMARY KEY, UNIQUE, DEFAULT)
    
    Args:
        atributo (dict): Diccionario con información del atributo
        
    Returns:
        str: Definición SQL de la columna
    """
    nombre = atributo['nombre']
    tipo_dato = mapear_tipo_dato(atributo)
    
    # Construir la definición de la columna
    definicion = f"{nombre} {tipo_dato}"
    
    # Agregar constraint PRIMARY KEY
    if atributo.get('pk', False):
        definicion += " PRIMARY KEY"
    
    # Agregar constraint NOT NULL (si no es PK, porque PK ya implica NOT NULL)
    if not atributo.get('nulo', True) and not atributo.get('pk', False):
        definicion += " NOT NULL"
    
    # Agregar constraint UNIQUE
    if atributo.get('unique', False):
        definicion += " UNIQUE"
    
    # Agregar valor por defecto
    if 'default' in atributo:
        default_value = atributo['default']
        # Si es CURRENT_TIMESTAMP o función, no usar comillas
        if default_value in ['CURRENT_TIMESTAMP', 'NOW()']:
            definicion += f" DEFAULT {default_value}"
        # Si es booleano
        elif isinstance(default_value, bool):
            definicion += f" DEFAULT {str(default_value).upper()}"
        # Si es string, usar comillas simples
        elif isinstance(default_value, str):
            definicion += f" DEFAULT '{default_value}'"
        # Si es número
        else:
            definicion += f" DEFAULT {default_value}"
    
    return definicion


# ============================================================================
# FUNCIÓN 5: CREAR TABLAS
# ============================================================================
def crear_tablas(config):
    """
    Crea todas las tablas definidas en el JSON.
    Primero crea las tablas sin foreign keys, luego agrega las FK.
    
    Args:
        config (dict): Diccionario con la configuración
        
    Returns:
        bool: True si todo se creó correctamente
    """
    try:
        # Conectar a la base de datos recién creada
        conexion = psycopg2.connect(
            host=config.get('host', 'localhost'),
            port=config.get('port', 5432),
            user=config['user'],
            password=config['password'],
            database=config['db'],
            client_encoding='UTF8'
        )
        
        cursor = conexion.cursor()
        
        # Lista para almacenar las foreign keys que se agregarán después
        foreign_keys = []
        
        # PASO 1: Crear todas las tablas (sin foreign keys)
        print("\n" + "="*60)
        print("CREANDO TABLAS")
        print("="*60)
        
        for entidad in config['entidades']:
            nombre_tabla = entidad['nombre']
            descripcion = entidad.get('descripcion', '')
            
            # Iniciar la sentencia CREATE TABLE
            columnas_sql = []
            
            for atributo in entidad['atributos']:
                # Generar definición de cada columna
                columnas_sql.append(generar_definicion_columna(atributo))
                
                # Guardar las foreign keys para agregarlas después
                if atributo.get('fk', False):
                    foreign_keys.append({
                        'tabla': nombre_tabla,
                        'columna': atributo['nombre'],
                        'referencia': atributo['referencia']
                    })
            
            # Construir la sentencia CREATE TABLE completa
            sql_crear_tabla = f"""
            CREATE TABLE IF NOT EXISTS {nombre_tabla} (
                {', '.join(columnas_sql)}
            );
            """
            
            # Ejecutar la creación de la tabla
            cursor.execute(sql_crear_tabla)
            print(f"[OK] Tabla '{nombre_tabla}' creada")
            
            # Agregar comentario a la tabla (documentación)
            if descripcion:
                sql_comentario = f"""
                COMMENT ON TABLE {nombre_tabla} IS '{descripcion}';
                """
                cursor.execute(sql_comentario)
        
        # PASO 2: Agregar las foreign keys
        print("\n" + "="*60)
        print("AGREGANDO FOREIGN KEYS")
        print("="*60)
        
        for fk in foreign_keys:
            sql_foreign_key = f"""
            ALTER TABLE {fk['tabla']}
            ADD CONSTRAINT fk_{fk['tabla']}_{fk['columna']}
            FOREIGN KEY ({fk['columna']})
            REFERENCES {fk['referencia']}
            ON DELETE CASCADE
            ON UPDATE CASCADE;
            """
            
            cursor.execute(sql_foreign_key)
            print(f"[OK] Foreign key agregada: {fk['tabla']}.{fk['columna']} -> {fk['referencia']}")
        
        # Confirmar todos los cambios
        conexion.commit()
        
        print("\n" + "="*60)
        print("[OK] TODAS LAS TABLAS CREADAS EXITOSAMENTE")
        print("="*60)
        
        cursor.close()
        conexion.close()
        return True
        
    except psycopg2.Error as e:
        print(f"\n[ERROR] Al crear las tablas: {e}")
        if 'conexion' in locals():
            conexion.rollback()
        return False


# ============================================================================
# FUNCIÓN 6: VERIFICAR TABLAS CREADAS
# ============================================================================
def verificar_tablas(config):
    """
    Verifica y lista todas las tablas creadas en la base de datos.
    
    Args:
        config (dict): Diccionario con la configuración
    """
    try:
        conexion = psycopg2.connect(
            host=config.get('host', 'localhost'),
            port=config.get('port', 5432),
            user=config['user'],
            password=config['password'],
            database=config['db'],
            client_encoding='UTF8'
        )
        
        cursor = conexion.cursor()
        
        # Consultar todas las tablas creadas
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public'
            ORDER BY table_name;
        """)
        
        tablas = cursor.fetchall()
        
        print("\n" + "="*60)
        print("TABLAS EN LA BASE DE DATOS")
        print("="*60)
        
        for i, tabla in enumerate(tablas, 1):
            print(f"{i}. {tabla[0]}")
        
        cursor.close()
        conexion.close()
        
    except psycopg2.Error as e:
        print(f"[ERROR] Al verificar tablas: {e}")


# ============================================================================
# FUNCIÓN PRINCIPAL
# ============================================================================
def main():
    """
    Función principal que orquesta todo el proceso de creación de la BD.
    """
    print("\n" + "="*60)
    print("SISTEMA DE CREACION AUTOMATICA DE BASE DE DATOS")
    print("Invernadero Hidroponico")
    print("="*60 + "\n")
    
    # Ruta al archivo JSON de configuración
    RUTA_JSON = r'C:\Users\creds\Desktop\Universidad\Factoria de software\modelo_invernadero.json'
    
    # 1. Cargar configuración
    config = cargar_configuracion(RUTA_JSON)
    if not config:
        return
    
    # 2. Crear base de datos
    if not crear_base_datos(config):
        return
    
    # 3. Crear tablas
    if not crear_tablas(config):
        return
    
    # 4. Verificar tablas creadas
    verificar_tablas(config)
    
    print("\n" + "="*60)
    print("[OK] PROCESO COMPLETADO EXITOSAMENTE")
    print("="*60 + "\n")


# ============================================================================
# EJECUTAR EL SCRIPT
# ============================================================================
if __name__ == "__main__":
    main()