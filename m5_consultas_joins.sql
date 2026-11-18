-- Módulo 5: Consultas SQL con JOINs - RetailPro / TechStore
-- Base: Ventas_Tech_DB | Motor: Microsoft SQL Server (SSMS)
-- Fuente del esquema: ventas tech db.sql (M3)
-- Ejecutar después de cargar los datos del M3.
USE Ventas_Tech_DB;
GO

-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: enriquecer cada venta con cliente, producto, categoría y ciudad para Power BI.
SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS region,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    CAST(v.cantidad * v.precio_unitario AS DECIMAL(18,2)) AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;
-- Hallazgo: con los datos de ejemplo de M3, las 10 ventas pueden analizarse por
-- cliente, producto, categoría y ciudad; esta vista alimentará el dashboard.

-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: identificar clientes registrados sin compras para acciones de CRM.
SELECT
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro, c.nombre;
-- Hallazgo: 0 de los 5 clientes del M3 están sin compras; CRM no tiene
-- clientes inactivos por primera compra en esta muestra.

-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: detectar artículos del catálogo sin movimiento comercial.
SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
LEFT JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY cat.nombre_categoria, p.nombre_producto;
-- Hallazgo: 0 de los 6 productos del M3 carecen de ventas; el área de producto
-- no detecta artículos sin movimiento en esta muestra.

-- Consulta 4: Consolidado por canal (UNION ALL)
-- Propósito: comparar dos períodos sin asumir que existe una columna canal.
-- 'Primera quincena (1-10)' y 'Primera quincena (11-15)' son etiquetas
-- analíticas de períodos, NO canales comerciales reales.
SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        v.fecha_venta,
        CAST(v.cantidad * v.precio_unitario AS DECIMAL(18,2)) AS total,
        'Periodo 01-10 marzo' AS canal
    FROM ventas AS v
    WHERE v.fecha_venta >= '20240301' AND v.fecha_venta < '20240311'

    UNION ALL

    SELECT
        v.fecha_venta,
        CAST(v.cantidad * v.precio_unitario AS DECIMAL(18,2)) AS total,
        'Periodo 11-15 marzo' AS canal
    FROM ventas AS v
    WHERE v.fecha_venta >= '20240311' AND v.fecha_venta < '20240316'
) AS consolidado
GROUP BY canal
ORDER BY canal;
-- Hallazgo: en los datos M3, el período 01-10 marzo suma 3.620,00 y el
-- 11-15 marzo suma 2.824,00; el primero aporta más ventas (6.444,00 total).
-- Nota: los importes no tienen moneda especificada en el esquema.
