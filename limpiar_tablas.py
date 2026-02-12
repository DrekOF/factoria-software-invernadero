"""
Script para limpiar (vaciar) todas las tablas de la base de datos
del sistema de gestión de invernadero hidropónico.

ADVERTENCIA: Este script eliminará TODOS los datos de TODAS las tablas.
Use con precaución.

Autor: Sistema de Gestión de Invernadero Hidropónico
Fecha: 2026
"""

import psycopg2
from psycopg2 import sql

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
# FUNCIÓN: MOSTRAR ESTADÍSTICAS ACTUALES
# ============================================================================
def mostrar_estadisticas(conexion):
    """
    Muestra la cantidad de registros en cada tabla antes de limpiar.
    
    Args:
        conexion: Objeto de conexión a PostgreSQL
    """
    cursor = conexion.cursor()
    
    print("="*80)
    print("ESTADISTICAS ACTUALES DE LA BASE DE DATOS")
    print("="*80)
    
    tablas = [
        'usuario',
        'invernadero',
        'cultivo',
        'ciclo_cultivo',
        'sensor',
        'lectura_sensor',
        'alerta'
    ]
    
    total_registros = 0
    
    for tabla in tablas:
        try:
            cursor.execute(f"SELECT COUNT(*) FROM {tabla}")
            count = cursor.fetchone()[0]
            total_registros += count
            print(f"{tabla.ljust(25)}: {count:,} registros")
        except psycopg2.Error as e:
            print(f"{tabla.ljust(25)}: ERROR - {e}")
    
    print("-"*80)
    print(f"{'TOTAL'.ljust(25)}: {total_registros:,} registros")
    print("="*80 + "\n")
    
    return total_registros


# ============================================================================
# FUNCIÓN: LIMPIAR TODAS LAS TABLAS
# ============================================================================
def limpiar_todas_las_tablas(conexion):
    """
    Limpia (vacía) todas las tablas de la base de datos.
    Respeta el orden de las foreign keys para evitar errores.
    
    Args:
        conexion: Objeto de conexión a PostgreSQL
    """
    cursor = conexion.cursor()
    
    print("="*80)
    print("LIMPIANDO TABLAS")
    print("="*80)
    
    # Orden importante: primero las tablas que tienen FK, luego las referenciadas
    tablas = [
        'lectura_sensor',    # Depende de sensor
        'alerta',            # Depende de invernadero y sensor
        'sensor',            # Depende de invernadero
        'ciclo_cultivo',     # Depende de invernadero y cultivo
        'cultivo',           # Tabla independiente
        'invernadero',       # Tabla independiente
        'usuario'            # Tabla independiente
    ]
    
    try:
        for tabla in tablas:
            # TRUNCATE es más rápido que DELETE y reinicia los contadores
            cursor.execute(f"TRUNCATE TABLE {tabla} RESTART IDENTITY CASCADE;")
            print(f"[OK] Tabla '{tabla}' limpiada")
        
        conexion.commit()
        
        print("="*80)
        print("[OK] TODAS LAS TABLAS LIMPIADAS EXITOSAMENTE")
        print("="*80 + "\n")
        
        return True
        
    except psycopg2.Error as e:
        print(f"\n[ERROR] Al limpiar las tablas: {e}")
        conexion.rollback()
        return False


# ============================================================================
# FUNCIÓN: LIMPIAR TABLAS ESPECÍFICAS
# ============================================================================
def limpiar_tablas_especificas(conexion, tablas_a_limpiar):
    """
    Limpia solo las tablas especificadas.
    
    Args:
        conexion: Objeto de conexión a PostgreSQL
        tablas_a_limpiar: Lista de nombres de tablas a limpiar
    """
    cursor = conexion.cursor()
    
    print("="*80)
    print("LIMPIANDO TABLAS ESPECIFICAS")
    print("="*80)
    
    try:
        for tabla in tablas_a_limpiar:
            cursor.execute(f"TRUNCATE TABLE {tabla} RESTART IDENTITY CASCADE;")
            print(f"[OK] Tabla '{tabla}' limpiada")
        
        conexion.commit()
        
        print("="*80)
        print("[OK] TABLAS ESPECIFICADAS LIMPIADAS EXITOSAMENTE")
        print("="*80 + "\n")
        
        return True
        
    except psycopg2.Error as e:
        print(f"\n[ERROR] Al limpiar las tablas: {e}")
        conexion.rollback()
        return False


# ============================================================================
# FUNCIÓN: LIMPIAR SOLO DATOS DE PRUEBA (MANTENER ESTRUCTURA)
# ============================================================================
def limpiar_datos_prueba(conexion):
    """
    Limpia solo los datos de sensores y alertas, manteniendo
    la estructura básica (invernaderos, cultivos, usuarios).
    
    Args:
        conexion: Objeto de conexión a PostgreSQL
    """
    cursor = conexion.cursor()
    
    print("="*80)
    print("LIMPIANDO SOLO DATOS DE PRUEBA")
    print("="*80)
    
    # Solo limpiar datos temporales/generados
    tablas = [
        'lectura_sensor',    # Datos generados automáticamente
        'alerta',            # Datos generados automáticamente
    ]
    
    try:
        for tabla in tablas:
            cursor.execute(f"TRUNCATE TABLE {tabla} RESTART IDENTITY CASCADE;")
            print(f"[OK] Tabla '{tabla}' limpiada")
        
        conexion.commit()
        
        print("="*80)
        print("[OK] DATOS DE PRUEBA LIMPIADOS EXITOSAMENTE")
        print("[INFO] Se mantuvieron: usuarios, invernaderos, cultivos, ciclos, sensores")
        print("="*80 + "\n")
        
        return True
        
    except psycopg2.Error as e:
        print(f"\n[ERROR] Al limpiar datos de prueba: {e}")
        conexion.rollback()
        return False


# ============================================================================
# FUNCIÓN: MENÚ INTERACTIVO
# ============================================================================
def menu_interactivo(conexion):
    """
    Muestra un menú interactivo para elegir qué limpiar.
    
    Args:
        conexion: Objeto de conexión a PostgreSQL
    """
    while True:
        print("\n" + "="*80)
        print("MENU DE LIMPIEZA DE TABLAS")
        print("="*80)
        print("1. Ver estadisticas actuales")
        print("2. Limpiar TODAS las tablas (elimina todo)")
        print("3. Limpiar solo datos de prueba (mantiene estructura basica)")
        print("4. Limpiar tablas especificas")
        print("5. Salir")
        print("="*80)
        
        opcion = input("\nSeleccione una opcion (1-5): ").strip()
        
        if opcion == '1':
            mostrar_estadisticas(conexion)
            input("\nPresione ENTER para continuar...")
        
        elif opcion == '2':
            print("\n" + "!"*80)
            print("ADVERTENCIA: Esta opcion eliminara TODOS los datos de TODAS las tablas")
            print("!"*80)
            mostrar_estadisticas(conexion)
            
            confirmacion = input("\n¿Esta SEGURO que desea continuar? Escriba 'SI CONFIRMO' para proceder: ").strip()
            
            if confirmacion == 'SI CONFIRMO':
                if limpiar_todas_las_tablas(conexion):
                    mostrar_estadisticas(conexion)
                    input("\nPresione ENTER para continuar...")
            else:
                print("\n[INFO] Operacion cancelada por el usuario\n")
        
        elif opcion == '3':
            print("\n[INFO] Esta opcion limpiara solo lecturas de sensores y alertas")
            print("[INFO] Se mantendran: usuarios, invernaderos, cultivos, ciclos, sensores")
            
            confirmacion = input("\n¿Desea continuar? (s/n): ").strip().lower()
            
            if confirmacion == 's':
                if limpiar_datos_prueba(conexion):
                    mostrar_estadisticas(conexion)
                    input("\nPresione ENTER para continuar...")
            else:
                print("\n[INFO] Operacion cancelada por el usuario\n")
        
        elif opcion == '4':
            print("\n" + "="*80)
            print("TABLAS DISPONIBLES:")
            print("="*80)
            print("1. usuario")
            print("2. invernadero")
            print("3. cultivo")
            print("4. ciclo_cultivo")
            print("5. sensor")
            print("6. lectura_sensor")
            print("7. alerta")
            print("="*80)
            
            seleccion = input("\nIngrese los numeros de las tablas a limpiar (separados por comas): ").strip()
            
            try:
                indices = [int(x.strip()) for x in seleccion.split(',')]
                tablas_disponibles = ['usuario', 'invernadero', 'cultivo', 'ciclo_cultivo', 
                                    'sensor', 'lectura_sensor', 'alerta']
                
                tablas_seleccionadas = [tablas_disponibles[i-1] for i in indices if 1 <= i <= 7]
                
                if tablas_seleccionadas:
                    print(f"\nTablas seleccionadas: {', '.join(tablas_seleccionadas)}")
                    confirmacion = input("¿Desea continuar? (s/n): ").strip().lower()
                    
                    if confirmacion == 's':
                        if limpiar_tablas_especificas(conexion, tablas_seleccionadas):
                            mostrar_estadisticas(conexion)
                            input("\nPresione ENTER para continuar...")
                    else:
                        print("\n[INFO] Operacion cancelada por el usuario\n")
                else:
                    print("\n[ERROR] No se seleccionaron tablas validas\n")
            
            except (ValueError, IndexError) as e:
                print(f"\n[ERROR] Seleccion invalida: {e}\n")
        
        elif opcion == '5':
            print("\n[INFO] Saliendo del programa...\n")
            break
        
        else:
            print("\n[ERROR] Opcion invalida. Por favor seleccione 1-5\n")


# ============================================================================
# FUNCIÓN: MODO RÁPIDO (SIN MENÚ)
# ============================================================================
def modo_rapido():
    """
    Modo rápido que limpia todo sin menú interactivo.
    Requiere confirmación explícita.
    """
    print("\n" + "="*80)
    print("MODO RAPIDO - LIMPIEZA TOTAL")
    print("="*80 + "\n")
    
    conexion = conectar()
    if not conexion:
        return
    
    try:
        # Mostrar estadísticas
        total = mostrar_estadisticas(conexion)
        
        if total == 0:
            print("[INFO] No hay datos para limpiar. La base de datos ya esta vacia.\n")
            return
        
        # Pedir confirmación
        print("!"*80)
        print("ADVERTENCIA: Esta operacion eliminara TODOS los datos")
        print("!"*80)
        
        confirmacion = input("\n¿Esta SEGURO? Escriba 'SI CONFIRMO' para proceder: ").strip()
        
        if confirmacion == 'SI CONFIRMO':
            if limpiar_todas_las_tablas(conexion):
                print("\n[INFO] Verificando limpieza...")
                mostrar_estadisticas(conexion)
        else:
            print("\n[INFO] Operacion cancelada por el usuario\n")
    
    finally:
        conexion.close()
        print("[INFO] Conexion cerrada\n")


# ============================================================================
# FUNCIÓN PRINCIPAL
# ============================================================================
def main():
    """
    Función principal del script.
    """
    print("\n" + "="*80)
    print("SCRIPT DE LIMPIEZA DE TABLAS")
    print("Sistema de Gestion de Invernadero Hidroponico")
    print("="*80 + "\n")
    
    # Conectar a la base de datos
    conexion = conectar()
    if not conexion:
        return
    
    try:
        # Preguntar modo de operación
        print("Seleccione el modo de operacion:")
        print("1. Modo interactivo (menu con opciones)")
        print("2. Modo rapido (limpieza total directa)")
        
        modo = input("\nSeleccione (1 o 2): ").strip()
        
        if modo == '1':
            menu_interactivo(conexion)
        elif modo == '2':
            conexion.close()
            modo_rapido()
            return
        else:
            print("\n[ERROR] Opcion invalida\n")
    
    except KeyboardInterrupt:
        print("\n\n[INFO] Operacion interrumpida por el usuario\n")
    
    except Exception as e:
        print(f"\n[ERROR] Error inesperado: {e}\n")
    
    finally:
        if conexion and not conexion.closed:
            conexion.close()
            print("[INFO] Conexion cerrada\n")


# ============================================================================
# EJECUTAR EL SCRIPT
# ============================================================================
if __name__ == "__main__":
    main()