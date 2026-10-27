-- Modulo 2 - Unidad 1: estructura de un sistema de ventas
-- Motor elegido: Microsoft SQL Server.
-- Ejecutar en una base de datos que no tenga estas tablas.
-- Se incluyen las columnas indicadas en los pasos 3 y 4.

CREATE TABLE clientes (
    -- INT almacena identificadores enteros. PRIMARY KEY evita duplicados y nulos.
    id_cliente INT PRIMARY KEY,

    -- NVARCHAR(100) admite hasta 100 caracteres Unicode, incluidos acentos.
    nombre NVARCHAR(100),

    -- NVARCHAR(MAX) permite guardar notas extensas o una biografia en Unicode.
    perfil_bio NVARCHAR(MAX),

    -- DATE guarda solo la fecha, sin hora.
    fecha_registro DATE
);

CREATE TABLE productos (
    -- INT almacena identificadores enteros. PRIMARY KEY identifica cada producto.
    id_producto INT PRIMARY KEY,

    -- NVARCHAR(255) permite una descripcion de hasta 255 caracteres Unicode.
    descripcion NVARCHAR(255),

    -- DECIMAL(10,2) almacena 10 digitos en total: 8 enteros y 2 decimales.
    -- Es un tipo exacto, adecuado para dinero, a diferencia de FLOAT.
    precio DECIMAL(10,2),

    -- BIT representa dos estados: 1 = activo y 0 = inactivo.
    -- NOT NULL exige indicar uno de esos estados para cada producto.
    esta_activo BIT NOT NULL
);
