'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'
-- Base de datos para SpiritLiquors

-- Creamos la base de datos
CREATE DATABASE SpiritLiquors;
USE SpiritLiquors;


'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'


-- SECTOR CREACION DE TABLAS



-- Tabla de tiendas
-- Esta tabla almacena información sobre las diferentes tiendas
CREATE TABLE dim_store (
    id_store INT PRIMARY KEY NOT NULL, -- Identificador único de la tienda
    city VARCHAR(100) -- Ciudad donde se encuentra la tienda
);
GO

-- Tabla de proveedores
-- Esta tabla almacena información sobre los proveedores
CREATE TABLE dim_vendors (
    id_vendors_number INT PRIMARY KEY NOT NULL, -- Identificador único del proveedor
    vendors_name VARCHAR(100) UNIQUE -- Nombre del proveedor
);
GO

-- Tabla de productos
-- Esta tabla almacena información sobre los productos disponibles
CREATE TABLE dim_products (
    id_brand INT PRIMARY KEY NOT NULL, -- Identificador único de la marca del producto
    description VARCHAR(100) UNIQUE, -- Descripción del producto
    size VARCHAR(100), -- Tamaño del producto
    volume INT, -- Volumen del producto en mililitros
    purchase_price DECIMAL(15, 2), -- Precio de compra del producto
    sales_price DECIMAL(15, 2), -- Precio de venta del producto
    classification VARCHAR(500), -- Clasificación del producto
    id_vendors_number INT, -- Identificador del proveedor del producto
    FOREIGN KEY (id_vendors_number) REFERENCES dim_vendors(id_vendors_number) -- Clave foránea referenciando a dim_vendors
);
GO

-- Tabla de facturas de compra
-- Esta tabla almacena información sobre las facturas de compra
CREATE TABLE dim_invoice_purchase (
    id_po_number INT PRIMARY KEY NOT NULL, -- Identificador único de la orden de compra
    id_vendors_number INT, -- Identificador del proveedor
    po_date DATE, -- Fecha de la orden de compra
    pay_date DATE, -- Fecha de pago
    total_quantity DECIMAL(15, 2), -- Cantidad total de productos
    total_amount DECIMAL(15, 2), -- Monto total de la compra
    freight DECIMAL(15, 2), -- Costo de transporte
    approval VARCHAR(100), -- Aprobación de la compra
    FOREIGN KEY (id_vendors_number) REFERENCES dim_vendors(id_vendors_number) -- Clave foránea referenciando a dim_vendors
);
GO

-- Tabla de inventario
-- Esta tabla almacena información sobre el inventario de productos
CREATE TABLE facts_inventario (
    id_inventario INT PRIMARY KEY NOT NULL IDENTITY(1,1), -- Identificador único del inventario
    id_store INT, -- Identificador de la tienda
    id_brand INT, -- Identificador de la marca del producto
    on_hands INT CHECK (on_hands >= 0), -- Cantidad de productos en inventario (no negativo)
    sales_price DECIMAL(15, 2), -- Precio de venta del producto
    dates DATE DEFAULT GETDATE(), -- Fecha de la entrada en inventario
    id_purchases INT, -- Identificador de las compras
    id_sales INT, -- Identificador de las ventas
    FOREIGN KEY (id_store) REFERENCES dim_store(id_store), -- Clave foránea referenciando a dim_store
    FOREIGN KEY (id_brand) REFERENCES dim_products(id_brand) -- Clave foránea referenciando a dim_products
);
GO

-- Tabla de ventas
-- Esta tabla almacena información sobre las ventas realizadas
CREATE TABLE sales (
    id_sales INT PRIMARY KEY NOT NULL IDENTITY(1,1), -- Identificador único de la venta
    id_inventario INT, -- Identificador del inventario
    id_store INT, -- Identificador de la tienda
    id_vendors_number INT, -- Identificador del proveedor
    id_brand INT, -- Identificador de la marca del producto
    sales_date DATE, -- Fecha de la venta
    quantity_sales INT, -- Cantidad de productos vendidos
    sales_price DECIMAL(15, 2), -- Precio de venta del producto
    total_amount DECIMAL(15, 2), -- Monto total de la venta
    excise_tax DECIMAL(15, 2), -- Impuesto especial sobre la venta
    FOREIGN KEY (id_inventario) REFERENCES facts_inventario(id_inventario), -- Clave foránea referenciando a inventario
    FOREIGN KEY (id_store) REFERENCES dim_store(id_store), -- Clave foránea referenciando a dim_store
    FOREIGN KEY (id_vendors_number) REFERENCES dim_vendors(id_vendors_number), -- Clave foránea referenciando a dim_vendors
    FOREIGN KEY (id_brand) REFERENCES dim_products(id_brand)
);
GO

-- Tabla de compras
-- Esta tabla almacena información sobre las compras realizadas
CREATE TABLE purchase (
    id_purchases INT PRIMARY KEY NOT NULL IDENTITY(1,1), -- Identificador único de la compra
    id_inventario INT, -- Identificador del inventario
    id_store INT, -- Identificador de la tienda
    id_brand INT, -- Identificador de la marca del producto
    id_vendor_number INT, -- Identificador del proveedor
    id_po_number INT, -- Identificador de la orden de compra
    receiving_date DATE, -- Fecha de recepción de la compra
    purchase_price DECIMAL(15, 2), -- Precio de compra del producto
    quantity_purchases INT, -- Cantidad de productos comprados
    total_price DECIMAL(15, 2), -- Precio total de la compra
    FOREIGN KEY (id_inventario) REFERENCES facts_inventario(id_inventario), -- Clave foránea referenciando a inventario
    FOREIGN KEY (id_store) REFERENCES dim_store(id_store), -- Clave foránea referenciando a dim_store
    FOREIGN KEY (id_brand) REFERENCES dim_products(id_brand), -- Clave foránea referenciando a dim_products
    FOREIGN KEY (id_vendor_number) REFERENCES dim_vendors(id_vendors_number) -- Clave foránea referenciando a dim_vendors
);
GO


'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'


-- TRIGGER PARA LA ACTUALIZACION DE onHands EN INVENTARIO



-- Crear el trigger para actualizar la tabla facts_inventario cuando se inserte un nuevo registro de compras
-- Este trigger actualiza la cantidad de productos en inventario sumando la cantidad comprada
CREATE TRIGGER trg_update_inventory_on_purchase
ON purchase
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar la cantidad en facts_inventario sumando la cantidad de compras
    UPDATE facts_inventario
    SET on_hands = on_hands + inserted.quantity_purchases
    FROM inserted
    WHERE facts_inventario.id_inventario = inserted.id_inventario;
END;
GO


-- Crear el trigger para actualizar la tabla facts_inventario cuando se inserte un nuevo registro de ventas
-- Este trigger actualiza la cantidad de productos en inventario restando la cantidad vendida
CREATE TRIGGER trg_update_inventory_on_sales
ON sales
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar la cantidad en facts_inventario restando la cantidad de ventas
    UPDATE facts_inventario
    SET on_hands = on_hands - inserted.quantity_sales
    FROM inserted
    WHERE facts_inventario.id_inventario = inserted.id_inventario;
END;
GO





'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'

-- MODIFICACIONES A TABLAS 



'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'
--- INDICES Y VISTAS PARA VISUALIZACIONES RAPIDAS

-- Índice en la columna id_vendors_number de dim_products
CREATE INDEX idx_dim_products_id_vendors_number ON dim_products(id_vendors_number);

-- Índice en la columna id_store y id_brand de facts_inventario
CREATE INDEX idx_facts_inventario_id_store ON facts_inventario(id_store);
CREATE INDEX idx_facts_inventario_id_brand ON facts_inventario(id_brand);

-- Índice en la columna id_store y id_brand de sales
CREATE INDEX idx_sales_id_store ON sales(id_store);
CREATE INDEX idx_sales_id_brand ON sales(id_brand);





-- Crear una vista para obtener la cantidad total de productos en inventario por tienda
CREATE VIEW vw_total_productos_inventario AS
SELECT 
    s.city,
    p.description,
    i.on_hands
FROM 
    facts_inventario i
JOIN 
    dim_store s ON i.id_store = s.id_store
JOIN 
    dim_products p ON i.id_brand = p.id_brand;


'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'


-- SEGURIDAD NO ACTIVO PERO POR SI SE NECESITA


'
-- Crear un rol y asignar permisos
CREATE ROLE db_datareader;
GRANT SELECT ON dim_products TO db_datareader;
'

'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'



-- PROCEDIMIENTOS ALMACENADOS PARA CARGA DE DATOS

-- Procedimiento para insertar datos en dim_store
CREATE PROCEDURE insert_dim_store
    @id_store INT,
    @city VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        INSERT INTO dim_store (id_store, city)
        VALUES (@id_store, @city);
    END TRY
    BEGIN CATCH
        DECLARE @error_message NVARCHAR(4000);
        DECLARE @error_severity INT;
        DECLARE @error_state INT;
        SELECT @error_message = ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@error_message, @error_severity, @error_state);
    END CATCH
END;
GO


-- Procedimiento para insertar datos en dim_vendors
CREATE PROCEDURE insert_dim_vendors
    @id_vendors_number INT,
    @vendors_name VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        INSERT INTO dim_vendors (id_vendors_number, vendors_name)
        VALUES (@id_vendors_number, @vendors_name);
    END TRY
    BEGIN CATCH
        DECLARE @error_message NVARCHAR(4000);
        DECLARE @error_severity INT;
        DECLARE @error_state INT;
        SELECT @error_message = ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@error_message, @error_severity, @error_state);
    END CATCH
END;
GO


-- Procedimiento para insertar datos en dim_products
CREATE PROCEDURE insert_dim_products
    @id_brand INT,
    @description VARCHAR(100),
    @size VARCHAR(100),
    @volume INT,
    @purchase_price DECIMAL(15, 2),
    @sales_price DECIMAL(15, 2),
    @classification VARCHAR(500),
    @id_vendors_number INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO dim_products (id_brand, description, size, volume, purchase_price, sales_price, classification, id_vendors_number)
        VALUES (@id_brand, @description, @size, @volume, @purchase_price, @sales_price, @classification, @id_vendors_number);
    END TRY
    BEGIN CATCH
        DECLARE @error_message NVARCHAR(4000);
        DECLARE @error_severity INT;
        DECLARE @error_state INT;
        SELECT @error_message = ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@error_message, @error_severity, @error_state);
    END CATCH
END;
GO




-- Procedimiento para insertar datos en sales
CREATE PROCEDURE insert_sales
    @id_inventario INT,
    @id_store INT,
    @id_vendors_number INT,
    @id_brand INT,
    @sales_date DATE,
    @quantity_sales INT,
    @sales_price DECIMAL(15, 2),
    @total_amount DECIMAL(15, 2),
    @excise_tax DECIMAL(15, 2)
AS
BEGIN
    BEGIN TRY
        INSERT INTO sales (id_inventario, id_store, id_vendors_number, id_brand, sales_date, quantity_sales, sales_price, total_amount, excise_tax)
        VALUES (@id_inventario, @id_store, @id_vendors_number, @id_brand, @sales_date, @quantity_sales, @sales_price, @total_amount, @excise_tax);
    END TRY
    BEGIN CATCH
        DECLARE @error_message NVARCHAR(4000);
        DECLARE @error_severity INT;
        DECLARE @error_state INT;
        SELECT @error_message = ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@error_message, @error_severity, @error_state);
    END CATCH
END;
GO





-- Procedimiento para insertar datos en purchase
CREATE PROCEDURE insert_purchase
    @id_inventario INT,
    @id_store INT,
    @id_brand INT,
    @id_vendor_number INT,
    @id_po_number INT,
    @receiving_date DATE,
    @purchase_price DECIMAL(15, 2),
    @quantity_purchases INT,
    @total_price DECIMAL(15, 2)
AS
BEGIN
    BEGIN TRY
        INSERT INTO purchase (id_inventario, id_store, id_brand, id_vendor_number, id_po_number, receiving_date, purchase_price, quantity_purchases, total_price)
        VALUES (@id_inventario, @id_store, @id_brand, @id_vendor_number, @id_po_number, @receiving_date, @purchase_price, @quantity_purchases, @total_price);
    END TRY
    BEGIN CATCH
        DECLARE @error_message NVARCHAR(4000);
        DECLARE @error_severity INT;
        DECLARE @error_state INT;
        SELECT @error_message = ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@error_message, @error_severity, @error_state);
    END CATCH
END;
GO



'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'
SELECT * 
FROM vw_total_productos_inventario;




select * 
from dim_store


DELETE FROM dim_store;

