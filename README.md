<!--h2 without bottom border-->
<div id="user-content-toc">
  <ul align="center">
    <summary><h2 style="display: inline-block"> Proyecto: Spirit Liquors - El capital Oculto</h2></summary>
  </ul>
</div>

<!--horizontal divider(gradiant)-->
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

# ¡Hola! 👋 DAS - Data Analytics Solution 👨‍💻 Un Equipo de 4 Analistas de Datos | 📊 Gonzalo – Diego – German – Angela.

<!--Intro start-->

## 📚 Objetivo del análisis: 

### Descubriendo el capital oculto de la empresa Spirit Liquors.

El propósito principal de este proyecto es identificar los desafíos en la administración y gestión del inventario a través del análisis de datos históricos. Este enfoque busca comprender los factores determinantes que contribuyen al sobrestock en ciertas categorías de productos, a los costos innecesarios de almacenamiento que pueden afectar la liquidez del negocio, y proporcionar información valiosa para decisiones estratégicas futuras que lleven a un control eficiente del inventario.

**Análisis del stock del inventario de licores:** El estudio se centra en las ventas y compras de licores, explorando patrones consistentes en su desempeño. Para ello, se trabajará con un conjunto de datos detallado, aplicando filtros hasta una fecha previamente definida. Esto garantiza un análisis preciso y relevante, enfocado en las dinámicas que definen el éxito.

## 🛠 Tecnologías Usadas:
- SQL Server: Restricciones y validaciones para garantizar la integridad de datos.
- Python: Limpieza y análisis exploratorio de datos.
  - Pandas
  - NumPy
  - Matplotlib / Seaborn
  - pyodbc
  - sqlalchemy
  - os
  - shutil
  - time
  - zipfile
  - kaggle
- Jupyter Notebook
- drawio

## 👨‍💻 Metodologías:
- Modelado Relacional (ER)
- conexión con API a Kaggle
- Creación instancia con GCP
- Creación base de datos en GCP
- Análisis Exploratorio de Datos (EDA) “tratamiento de la base de datos en Python”
- Extracción, Transformación y Carga de datos (ETL) “carga de datos en GCP”
- Automatización de ingesta de datos
- Mockup


**Datos: Origen y Descripción**
- **Fuente:** Conjunto de datos "Inventory" obtenido de Kaggle.
- **Contenido:** Precios de compra 2017, inventario inicial 2016, inventario final 2016, facturas de compras 2016, ventas 2016 y compras 2016.
- **Métricas clave:** Precio, marca, precio de compra, tamaño, almacenar, en la mano, cantidad.
- **Enfoque:** Año 2016 – 2017.
- **Recolección de Datos:** Dataset descargado de Kaggle en formato CSV.

### Diseño del Modelo Entidad-Relación:
- **Tabla de hechos:** facts_purchase, facts_sales.
- **Tablas dimensionales:** dim_products, dim_store, dim_vendors, dim_invoice_purchase, inventory, inventory_log.
- **Relaciones:** 1:N
- **Llaves:** Llaves primarias (PK) y foráneas (FK) garantizan consistencia.

### Limpieza y Análisis Exploratorio (EDA):
- Eliminación de valores nulos, duplicados y outliers.
 
### Extracción, Transformación y Carga de datos (ETL):
- **Validación de Datos Python:** Eliminación de inconsistencias y valores atípicos.

### Automatización:
- Extracción automática de datos actualizados. 
- Optimización para análisis en tiempo real.
- Importancia del Proceso Integración continua: Datos confiables y listos para análisis estratégico.
- Escalabilidad: Infraestructura sólida para futuras expansiones.

### Mockup:
- Visualizar y entender los datos de manera más efectiva, facilitando la identificación de oportunidades de mejora y la implementación de estrategias más eficientes para la gestión del inventario de licores.
- Dar un panorama detallado de cómo va ser el resultado final de la propuesta.
 ### Extracción transformación y carga de datos (ETL):
- Validación de Datos Python: Eliminación de inconsistencias y valores atípicos.

### Modelado de datos en DAX:
- Crear de columnas calculadas. 
- Definir medidas
- Gestionar Relaciones 

### Dashboards
- Insights accionables: Permite visualizar patrones de ventas y compras óptimas que ayuden a mantener un stock de inventario rentable.
- Incorporar formato personalizado en las visualizaciones como el tema, etiquetas, títulos  y otros elementos de formato para que se requieran
- Creación de gráficos, tablas, mapas y otros elementos visuales.
-  Establecer la interactividad, filtros y segmentadores idóneos.

### Modelo de regresión de Random Forest: 
- Obtener un modelo de predicción que se ajustará con el comportamiento de los datos de la tabla ventas, el cual entiende un comportamiento no lineal y valores atípicos acercándose al comportamiento real de los registros históricos.

## 🚀Conclusiones:

### Los datos pueden revelar patrones clave proporcionando información valiosa para decisiones estratégicas del inventario de licores que permitan:
 - Determinar los niveles óptimos de inventario para los productos.
- Identificar oportunidades para reducir las faltantes de existencias y el exceso de inventario.
- Analizar la rotación de inventario y los costos de almacenamiento para optimizar el capital de trabajo.
- Agilizar los procesos de adquisición y distribución para mejorar la eficiencia.
- Desarrollar una estrategia de gestión de inventario sostenible y confiable para el crecimiento futuro.

 <!--Intro end-->




<!--Intro end-->
