-- =====================================
-- BLOQUE ANONIMO
-- =====================================
/*
BEGIN

	Sentencias a ejecutar

END;
GO
*/


-- Ejemplo

BEGIN
	
	DECLARE  @NUM1 INT,  @NUM2 INT,  @SUMA INT;
	
	SET @NUM1 =  CAST( RAND() * 100 AS INT );
	SET @NUM2 =  CAST( RAND() * 100 AS INT );
	
	SET @SUMA = @NUM1 + @NUM2;
	
	PRINT CONCAT( 'NUM1 = ', @NUM1 );
	PRINT CONCAT( 'NUM2 = ', @NUM2 );
	PRINT CONCAT( 'SUMA = ', @SUMA );

END;
GO


-- FUNCION ESCALAR

CREATE FUNCTION dbo.fn_suma ( @num1 int, @num2 int )
RETURNS int
AS
BEGIN
	DECLARE @suma int;
	SET @suma = @num1 + @num2;
	RETURN @suma;
END;
GO

SELECT DBO.fn_suma(34,56) SUMA;
GO


-- EJERCICIO 1
/*
Crear una funcion para obtener el promedio de un estudiante 
en su curso de SQL Server Programación.
*/

-- MIGUEL ARENAS

create function dbo.fn_promedio (@nota1 int ,@nota2 int)
returns int
as
begin 
	declare @promedio int;
	set @promedio=(@nota1+@nota2)/2;
	return @promedio;
end;
go

select dbo.fn_promedio(16,13)
go


-- HUAMAN
CREATE FUNCTION DBO.FN_DIV(@NUM1 INT, @NUM2 INT)
RETURNS INT
AS 
BEGIN
	DECLARE @PROMEDIO INT;
	SET @PROMEDIO = (@NUM1 + @NUM2)/2;
	RETURN @PROMEDIO;
	END;
GO

SELECT DBO.FN_DIV (20,10) PROMEDIO;
GO


-- FUNCION DE TABLA EN LINEA
-- Tambien se conoce como vista parametrizada

USE RH;
GO

-- Los empleados de un departamento

DROP FUNCTION dbo.fn_empleados;
GO

CREATE FUNCTION dbo.fn_empleados ( @p_dpto int )
RETURNS TABLE
AS
RETURN 
   SELECT idempleado, apellido, nombre
   FROM dbo.empleado
   WHERE iddepartamento = case when @p_dpto is null then iddepartamento else @p_dpto end;
GO

SELECT * FROM dbo.fn_empleados(103);
GO

SELECT * FROM dbo.fn_empleados(777);
GO

SELECT * FROM dbo.fn_empleados(null);
GO

SELECT ISNULL(10, 20);
GO

SELECT ISNULL(NULL, 20);
GO

DROP FUNCTION dbo.fn_empleados;
GO

CREATE FUNCTION dbo.fn_empleados ( @p_dpto int )
RETURNS TABLE
AS
RETURN 
   SELECT idempleado, apellido, nombre
   FROM dbo.empleado
   WHERE iddepartamento = ISNULL(@p_dpto,iddepartamento);
GO



-- Ejercicio
-- Desarrollar una función que retorne las compras realizadas
-- por un cliente. Usar NORTHWIND

USE NORTHWIND;
GO

CREATE FUNCTION dbo.fn_VENTAS ( @CustomerID varchar(10) )
RETURNS TABLE
AS
RETURN 
   SELECT *
   FROM dbo.Orders
   WHERE CustomerID = ISNULL(@CustomerID,CustomerID);
GO


select * from dbo.fn_VENTAS(NULL);
go

select * from dbo.fn_VENTAS('HANAR');
go


--	Función de tabla de múltiples instrucciones


CREATE FUNCTION dbo.fn_catalogo ( )
RETURNS @tabla TABLE 
( 
	codigo int identity(1,1) primary key not null,
	nombre varchar(50) not null,
	precio money not null
)
AS
BEGIN
	INSERT INTO @tabla(nombre,precio) values('Televisor', 1500.00);
	INSERT INTO @tabla(nombre,precio) values('Refrigeradora', 1450.00);
	INSERT INTO @tabla(nombre,precio) values('Lavadora', 1350.00);
	RETURN;
END;
GO

SELECT * FROM dbo.fn_catalogo();
GO

CREATE FUNCTION dbo.fn_catalogo2 ( )
RETURNS @tabla TABLE 
( 
	codigo int identity(1,1) primary key not null,
	nombre varchar(50) not null,
	precio money not null
)
AS
BEGIN
	INSERT INTO @tabla(nombre,precio) 
	select ProductName, UnitPrice from dbo.Products;
	RETURN;
END;
GO

SELECT * FROM dbo.fn_catalogo2();
GO







