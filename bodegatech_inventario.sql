-- ==========================================================
-- BodegaTech - Script de Inventario
-- Autor: Oscar Andres Naranjo Forero
-- Fecha: 2026-10-26
-- Entorno: Microsoft SQL Server (SSMS)
-- ==========================================================
-- Ejecutar en la base de datos de practicas seleccionada en SSMS.
-- Al re-ejecutar, se elimina el inventario anterior y se recrea.

-- SECCION DDL: DEFINICION DE LA ESTRUCTURA
-- DROP TABLE elimina la tabla si ya existe.
DROP TABLE IF EXISTS inventario;

-- CREATE TABLE define las columnas y la clave primaria.
CREATE TABLE inventario (
    -- INT almacena identificadores enteros. La PK impide duplicados y nulos.
    id_producto INT PRIMARY KEY,

    -- NVARCHAR conserva caracteres Unicode, incluidos los acentos.
    nombre_producto NVARCHAR(100) NOT NULL,
    categoria NVARCHAR(50) NOT NULL,

    -- DECIMAL almacena importes exactos en USD: 10 digitos, 2 decimales.
    precio_unitario DECIMAL(10,2) NOT NULL,

    -- INT representa unidades completas de inventario, sin fracciones.
    stock_actual INT NOT NULL,
    stock_minimo INT NOT NULL,

    -- DATE guarda la fecha de ingreso sin incluir hora.
    fecha_ingreso DATE NOT NULL,

    -- BIT es el tipo de SQL Server para 1 = disponible y 0 = descontinuado.
    -- Sustituye TINYINT(1), cuya sintaxis no es valida en SQL Server.
    activo BIT NOT NULL
);

-- SECCION DML: CARGA Y MODIFICACION DE LOS DATOS
-- INSERT INTO: cargar los 10 productos con columnas explicitas.
-- El prefijo N conserva los caracteres Unicode de los textos.
-- Las fechas usan YYYYMMDD, un formato no ambiguo en SQL Server.
INSERT INTO inventario (
    id_producto, nombre_producto, categoria, precio_unitario,
    stock_actual, stock_minimo, fecha_ingreso, activo
)
VALUES
    (1, N'Laptop Pro 15', N'Computación', 1200.00, 15, 3, '20240110', 1),
    (2, N'Mouse Inalámbrico', N'Accesorios', 28.00, 80, 10, '20240110', 1),
    (3, N'Monitor 4K 27"', N'Computación', 450.00, 12, 2, '20240115', 1),
    (4, N'Teclado Mecánico', N'Accesorios', 95.00, 40, 5, '20240115', 1),
    (5, N'Laptop Basic 14', N'Computación', 650.00, 20, 3, '20240201', 1),
    (6, N'Auriculares BT Pro', N'Audio', 120.00, 35, 5, '20240201', 1),
    (7, N'Hub USB-C 7 puertos', N'Accesorios', 45.00, 60, 10, '20240210', 1),
    (8, N'Webcam HD 1080p', N'Accesorios', 85.00, 25, 5, '20240210', 1),
    (9, N'SSD Externo 1TB', N'Almacenamiento', 130.00, 18, 3, '20240301', 1),
    (10, N'Parlante Bluetooth', N'Audio', 60.00, 45, 8, '20240301', 1);

-- UPDATE: registrar las ventas del dia.
-- Laptop Pro 15: 15 - 3 = 12 unidades.
UPDATE inventario
SET stock_actual = stock_actual - 3
WHERE id_producto = 1;

-- Mouse Inalambrico: 80 - 12 = 68 unidades.
UPDATE inventario
SET stock_actual = stock_actual - 12
WHERE id_producto = 2;

-- Auriculares BT Pro: 35 - 5 = 30 unidades.
UPDATE inventario
SET stock_actual = stock_actual - 5
WHERE id_producto = 6;

-- UPDATE: marcar la Webcam como descontinuada, conservando sus 25 unidades.
UPDATE inventario
SET activo = 0
WHERE id_producto = 8;

-- SELECT: ver la tabla completa para validar los 10 productos.
-- Verificar por id: 1 -> stock 12; 2 -> stock 68; 6 -> stock 30;
-- 8 -> activo 0. Los demas productos mantienen sus valores iniciales.
SELECT * FROM inventario;
