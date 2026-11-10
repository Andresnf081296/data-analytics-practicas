-- RetailPro | Módulo 4: Consultas SQL de negocio
-- Motor: Microsoft SQL Server (T-SQL)
-- Base de datos: Ventas_Tech_DB
-- Fuente: únicamente tabla ventas
USE Ventas_Tech_DB;
GO

-- CONSULTA 1: Resumen ejecutivo mensual
-- El ticket promedio se calcula como facturación total / número de pedidos.
SELECT
    YEAR(fecha_venta) AS anio,
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    CAST(SUM(cantidad * precio_unitario) * 1.0 / NULLIF(COUNT(*), 0) AS DECIMAL(18, 2)) AS ticket_promedio
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY anio, mes;

-- CONSULTA 2: Ranking de los 5 productos con mayor facturación
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC, id_producto ASC;

-- CONSULTA 3: Clientes recurrentes (más de un registro de pedido)
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

-- CONSULTA 4: Comparación contra el promedio de facturación por producto
WITH facturacion_por_producto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado * 1.0) FROM facturacion_por_producto)
            THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado * 1.0) FROM facturacion_por_producto)
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM facturacion_por_producto
ORDER BY total_facturado DESC;

-- BLOQUE DE CIERRE: Hallazgos de negocio
-- IMPORTANTE: completar estos tres hallazgos con cifras reales después de ejecutar las consultas.
-- Hallazgo 1: En marzo de 2024 se registraron [N] pedidos, con una facturación de [TOTAL] y un ticket promedio de [TICKET].
-- Hallazgo 2: El producto [ID] lideró el ranking con [UNIDADES] unidades vendidas y [TOTAL] de facturación.
-- Hallazgo 3: Se identificaron [N] clientes recurrentes; el cliente [ID] realizó [PEDIDOS] pedidos y gastó [TOTAL].
