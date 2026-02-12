from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet
import json

ruta = r"C:\Users\creds\Desktop\Universidad\Factoria de software\diccionario_datos\tabla_con_parrafo.pdf"

doc = SimpleDocTemplate(ruta, pagesize=letter)
styles = getSampleStyleSheet()

def getModel ():
    # Abrir y leer el archivo JSON
    with open(r"C:\Users\creds\Desktop\Universidad\Factoria de software\modelo_invernadero.json", "r", encoding="utf-8") as f:
        modelo = json.load(f)

    # Acceder a los datos
    print(modelo["motor"])          # postgresql
    print(modelo["db"])             # invernadero_hidroponico
    print(modelo["entidades"][0])   # primera entidad (invernadero)
    return modelo

def getAtributos (atributos):
    
    story.append(Paragraph("Atributos", styles['Title']))
    story.append(Spacer(1, 12))
    
    datos = [
        ["Nombre", "tipo_dato", "longitud"]
    ]
    
    for atributo in atributos:
        nombre = atributo["nombre"]
        tipo_dato = atributo["tipo_dato"]
        longitud = atributo["longitud"]
        datos.append([nombre,tipo_dato,longitud])
        
        
    tabla = Table(datos, colWidths=[150, 80, 120])
    tabla.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.green),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
        ('TOPPADDING', (0, 0), (-1, -1), 6),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
    ]))

    story.append(tabla)
    story.append(Spacer(1, 20))

def getConstrains (constrains):
        # Tabla

    story.append(Paragraph("Constrains", styles['Title']))
    story.append(Spacer(1, 12))        

    datos = [
        ["Nombre", "tipo", "atributo", "descripcion"]
    ]
    
    for constrain in constrains:
        nombre = constrain["nombre"]
        tipo = constrain["tipo"]
        atributo = constrain["atributo"]
        descripcion = constrain["descripcion"]
        datos.append([nombre,tipo, atributo, descripcion])
        
        
    tabla = Table(datos, colWidths=[150, 80, 120])
    tabla.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.green),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
        ('TOPPADDING', (0, 0), (-1, -1), 6),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
    ]))

    story.append(tabla)
    story.append(Spacer(1, 20))
    
def getRelaciones (relaciones):
        # Tabla
        
    story.append(Paragraph("Relaciones", styles['Title']))
    story.append(Spacer(1, 12))
        
    datos = [
        ["tabla_referenciada", "campo_referenciado", "campo_local", "descripcion"]
    ]
    
    for relacion in relaciones:
        tabla_referenciada = relacion["tabla_referenciada"]
        campo_referenciado = relacion["campo_referenciado"]
        campo_local = relacion["campo_local"]
        descripcion = relacion["descripcion"]
        datos.append([tabla_referenciada,campo_referenciado, campo_local, descripcion])
        
        
    tabla = Table(datos, colWidths=[150, 80, 120])
    tabla.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.green),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
        ('TOPPADDING', (0, 0), (-1, -1), 6),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
    ]))

    story.append(tabla)
    story.append(Spacer(1, 20))

def getEntidades (modelo,story):
    entidades = modelo["entidades"]
    for entidad in entidades:
        nombre = entidad["nombre"]
        descripcion = entidad["descripcion"]
        atributos = entidad["atributos"]
        constrains = entidad["constrains"]
        relaciones = entidad["relaciones"]
        print(nombre,descripcion)
        
        # Párrafo antes de la tabla
        story.append(Paragraph(
        "<b>"+nombre+":</b>"+descripcion,
        styles['Normal']
        ))
        story.append(Spacer(1, 20))

        getAtributos(atributos)
        getConstrains(constrains)
        getRelaciones(relaciones)

modelo = getModel()
print(modelo)

story = []

# Título
story.append(Paragraph("Diccionario de datos", styles['Title']))
story.append(Spacer(1, 12))

getEntidades(modelo, story)

# Párrafo antes de la tabla
story.append(Paragraph(
    "A continuación se presenta una tabla con la información registrada "
    "de las personas en el sistema. Los datos incluyen <b>nombre</b>, "
    "<b>edad</b> y <b>ciudad</b> de residencia.",
    styles['Normal']
))
story.append(Spacer(1, 20))

# Tabla
datos = [
    ["Nombre", "Edad", "Ciudad"],
    ["Ana", "28", "Bogotá"],
    ["Luis", "35", "Medellín"],
    ["María", "22", "Neiva"],
]

tabla = Table(datos, colWidths=[150, 80, 120])
tabla.setStyle(TableStyle([
    ('BACKGROUND', (0, 0), (-1, 0), colors.green),
    ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
    ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
    ('FONTSIZE', (0, 0), (-1, -1), 10),
    ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
    ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
    ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ('TOPPADDING', (0, 0), (-1, -1), 6),
    ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
]))

story.append(tabla)
story.append(Spacer(1, 20))

# Párrafo después de la tabla
story.append(Paragraph(
    "Esta tabla fue generada automáticamente con <i>ReportLab</i> en Python. "
    "Se pueden agregar tantos párrafos y tablas como se necesiten al documento.",
    styles['Normal']
))

# Generar PDF
doc.build(story)
print("PDF generado exitosamente")