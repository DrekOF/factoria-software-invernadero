"""
Script para generar automáticamente las clases Entity de Java
desde el modelo JSON del invernadero hidropónico.

Autor: Sistema de Gestión de Invernadero Hidropónico
Fecha: 2026
"""

import json
import os

# ============================================================================
# CONFIGURACIÓN
# ============================================================================
MODEL_FILENAME = r"C:\Users\creds\Desktop\Universidad\Factoria de software\er-model.json"
TEMPLATE_FILENAME = r"C:\Users\creds\Desktop\Universidad\Factoria de software\EntityTemplate.java"
OUTPUT_DIR = r"C:\Users\creds\Desktop\Universidad\Factoria de software\generated\entities"

# ============================================================================
# FUNCIÓN: CARGAR MODELO JSON
# ============================================================================
def cargar_modelo():
    """Carga el modelo JSON con las entidades."""
    try:
        with open(MODEL_FILENAME, "r", encoding="utf-8") as f:
            data = json.load(f)
        print(f"[OK] Modelo cargado: {len(data['entities'])} entidades encontradas\n")
        return data["entities"]
    except FileNotFoundError:
        print(f"[ERROR] No se encontro el archivo: {MODEL_FILENAME}")
        return None
    except json.JSONDecodeError as e:
        print(f"[ERROR] Error al leer JSON: {e}")
        return None


# ============================================================================
# FUNCIÓN: CARGAR PLANTILLA
# ============================================================================
def cargar_plantilla():
    """Carga la plantilla de Entity."""
    try:
        with open(TEMPLATE_FILENAME, "r", encoding="utf-8") as f:
            template = f.read()
        print("[OK] Plantilla cargada\n")
        return template
    except FileNotFoundError:
        print(f"[ERROR] No se encontro la plantilla: {TEMPLATE_FILENAME}")
        return None


# ============================================================================
# FUNCIÓN: MAPEAR TIPOS DE DATOS
# ============================================================================
def mapear_tipo_java(attribute):
    """Mapea el tipo de dato a las anotaciones JPA correctas."""
    java_type = attribute["javaType"]
    
    # Construcción de anotaciones
    annotations = []
    
    # Primary Key
    if attribute.get("isPrimaryKey", False):
        annotations.append("    @Id")
        if attribute.get("isAutoIncrement", False):
            annotations.append("    @GeneratedValue(strategy = GenerationType.IDENTITY)")
    
    # Column definition
    column_def = "    @Column("
    params = []
    
    if "length" in attribute:
        params.append(f'length = {attribute["length"]}')
    
    if not attribute.get("isNullable", True):
        params.append("nullable = false")
    
    if attribute.get("isUnique", False):
        params.append("unique = true")
    
    if "columnType" in attribute and attribute["columnType"] == "TEXT":
        params.append('columnDefinition = "TEXT"')
    
    if params:
        column_def += ", ".join(params)
    
    column_def += ")"
    annotations.append(column_def)
    
    return "\n".join(annotations), java_type


# ============================================================================
# FUNCIÓN: GENERAR ATRIBUTOS
# ============================================================================
def generar_atributos(attributes):
    """Genera el código de los atributos de la clase."""
    atributos_code = []
    
    for attr in attributes:
        # Skip id si ya está en la plantilla
        if attr.get("isPrimaryKey", False):
            continue
            
        annotations, java_type = mapear_tipo_java(attr)
        name = attr["name"]
        
        codigo_atributo = f"""
{annotations}
    private {java_type} {name};
"""
        atributos_code.append(codigo_atributo)
    
    return "\n".join(atributos_code)


# ============================================================================
# FUNCIÓN: GENERAR RELACIONES
# ============================================================================
def generar_relaciones(relationships):
    """Genera el código de las relaciones entre entidades."""
    if not relationships:
        return ""
    
    relaciones_code = []
    
    for rel in relationships:
        rel_type = rel["type"]
        target = rel["targetEntity"]
        
        if rel_type == "ManyToOne":
            join_column = rel["joinColumn"]
            opcional = rel.get("optional", False)
            
            codigo_relacion = f"""
    @ManyToOne
    @JoinColumn(name = "{join_column}", nullable = {str(not opcional).lower()})
    private {target} {target[0].lower() + target[1:]};
"""
            relaciones_code.append(codigo_relacion)
        
        elif rel_type == "OneToMany":
            mapped_by = rel["mappedBy"]
            
            codigo_relacion = f"""
    @OneToMany(mappedBy = "{mapped_by}")
    private List<{target}> {target[0].lower() + target[1:]}s;
"""
            relaciones_code.append(codigo_relacion)
    
    return "\n".join(relaciones_code)


# ============================================================================
# FUNCIÓN: GENERAR GETTERS Y SETTERS
# ============================================================================
def generar_getters_setters(attributes, relationships):
    """Genera getters y setters para todos los atributos."""
    getters_setters = []
    
    # Para atributos normales
    for attr in attributes:
        name = attr["name"]
        java_type = attr["javaType"]
        name_capitalized = name[0].upper() + name[1:]
        
        getter_setter = f"""
    public {java_type} get{name_capitalized}() {{
        return {name};
    }}

    public void set{name_capitalized}({java_type} {name}) {{
        this.{name} = {name};
    }}
"""
        getters_setters.append(getter_setter)
    
    # Para relaciones
    if relationships:
        for rel in relationships:
            target = rel["targetEntity"]
            field_name = target[0].lower() + target[1:]
            
            if rel["type"] == "OneToMany":
                field_name += "s"
                java_type = f"List<{target}>"
            else:
                java_type = target
            
            name_capitalized = field_name[0].upper() + field_name[1:]
            
            getter_setter = f"""
    public {java_type} get{name_capitalized}() {{
        return {field_name};
    }}

    public void set{name_capitalized}({java_type} {field_name}) {{
        this.{field_name} = {field_name};
    }}
"""
            getters_setters.append(getter_setter)
    
    return "\n".join(getters_setters)


# ============================================================================
# FUNCIÓN: GENERAR IMPORTS
# ============================================================================
def generar_imports(attributes, relationships):
    """Genera los imports necesarios según los tipos de datos usados."""
    imports = set()
    
    # Imports básicos
    imports.add("import javax.persistence.*;")
    
    # Imports según tipos de datos
    for attr in attributes:
        java_type = attr["javaType"]
        
        if java_type == "LocalDate":
            imports.add("import java.time.LocalDate;")
        elif java_type == "LocalDateTime":
            imports.add("import java.time.LocalDateTime;")
        elif java_type == "BigDecimal":
            imports.add("import java.math.BigDecimal;")
    
    # Import para relaciones OneToMany
    if relationships:
        for rel in relationships:
            if rel["type"] == "OneToMany":
                imports.add("import java.util.List;")
                break
    
    return "\n".join(sorted(imports))


# ============================================================================
# FUNCIÓN: GENERAR ENTITY COMPLETA
# ============================================================================
def generar_entity(entity, template):
    """Genera una clase Entity completa."""
    class_name = entity["name"]
    table_name = entity["tableName"]
    attributes = entity["attributes"]
    relationships = entity.get("relationships", [])
    
    print(f"Generando: {class_name}.java")
    
    # Generar código
    imports = generar_imports(attributes, relationships)
    atributos = generar_atributos(attributes)
    relaciones = generar_relaciones(relationships)
    getters_setters = generar_getters_setters(attributes, relationships)
    
    # Reemplazar en plantilla
    codigo = template.replace("$IMPORTS$", imports)
    codigo = codigo.replace("$CLASS_NAME$", class_name)
    codigo = codigo.replace("$TABLE_NAME$", table_name)
    codigo = codigo.replace("$ATRIBUTOS$", atributos)
    codigo = codigo.replace("$RELACIONES$", relaciones)
    codigo = codigo.replace("$GETTERS_SETTERS$", getters_setters)
    
    return codigo


# ============================================================================
# FUNCIÓN: GUARDAR ENTITY
# ============================================================================
def guardar_entity(class_name, codigo):
    """Guarda la Entity generada en un archivo .java"""
    # Crear directorio si no existe
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    filename = os.path.join(OUTPUT_DIR, f"{class_name}.java")
    
    with open(filename, "w", encoding="utf-8") as f:
        f.write(codigo)
    
    print(f"  [OK] Guardado en: {filename}")


# ============================================================================
# FUNCIÓN PRINCIPAL
# ============================================================================
def main():
    """Función principal."""
    print("\n" + "="*70)
    print("GENERADOR DE ENTITIES JAVA")
    print("Sistema de Gestion de Invernadero Hidroponico")
    print("="*70 + "\n")
    
    # Cargar modelo y plantilla
    entities = cargar_modelo()
    if not entities:
        return
    
    template = cargar_plantilla()
    if not template:
        return
    
    print("="*70)
    print("GENERANDO ENTITIES")
    print("="*70 + "\n")
    
    # Generar cada entity
    for entity in entities:
        codigo = generar_entity(entity, template)
        guardar_entity(entity["name"], codigo)
        print()
    
    print("="*70)
    print(f"[OK] {len(entities)} entities generadas exitosamente")
    print(f"[OK] Ubicacion: {OUTPUT_DIR}")
    print("="*70 + "\n")


# ============================================================================
# EJECUTAR
# ============================================================================
if __name__ == "__main__":
    main()