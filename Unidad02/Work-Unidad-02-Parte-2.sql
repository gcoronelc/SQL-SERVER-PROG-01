
-- Ejemplo Simple

USE EDUCA;
GO

DROP PROC dbo.usp_lista_cursos;
GO

CREATE PROCEDURE dbo.usp_lista_cursos
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM dbo.CURSO;
	SELECT * FROM dbo.ALUMNO;
END;
GO

EXEC dbo.usp_lista_cursos;
GO


-- Parámetros de entrada

CREATE PROCEDURE dbo.usp_suma ( @num1 int, @num2 int )
AS
BEGIN
	DECLARE @suma int;
	SET @suma = @num1 + @num2;
	SELECT @num1 NUM1, @num2 NUM2, @suma SUMA;
END;
GO

EXEC dbo.usp_suma 54, 76;
GO


-- Parametro de salida

drop proc dbo.usp_suma2;
go

CREATE PROCEDURE dbo.usp_suma2 ( @num1 int, @num2 int, @suma int out )
--WITH ENCRYPTION
AS
BEGIN
	SET @suma = @num1 + @num2;
END;
GO

BEGIN
	DECLARE @rpta decimal(10,2);
	EXEC dbo.usp_suma2 54, 76, @rpta OUT;
	PRINT CONCAT( 'SUMA: ', @rpta );
END;
GO

sp_helptext usp_suma2;
go


-- Parametro de salida - otro ejemplo

USE EDUCA;
GO

drop proc dbo.usp_precio ;
go

CREATE PROCEDURE dbo.usp_precio 
( 
	@p_idcurso int, 
	@p_precio money OUT,
	@p_estado INT OUT    -- 1: Ok, -1: El código no existe 
)
AS
BEGIN
	SELECT @p_precio = cur_precio
	FROM dbo.CURSO
	WHERE cur_id = @p_idcurso;
	if( @@ROWCOUNT = 1 )
		set @p_estado = 1;
	else 
		set @p_estado = -1;
END;
GO

BEGIN
	DECLARE @precio money;
	DECLARE @estado int;
	EXEC dbo.usp_precio 13, @precio OUT, @estado OUT;
	IF( @estado = 1 )
		PRINT CONCAT( 'PRECIO: ', @precio );
	ELSE
		PRINT 'Código no existe';
END;
GO


-- Ejercicio
/*
Desarrollar un procedimiento que permita consultar
el salario y cargo de un empleado.
Entrada:
	Código del empleado
Salida
	Salrio del empleado
	Nombre del cargo
	Estado: 1 o -1
*/

-- Juan Durand

USE RH
GO

IF EXISTS(SELECT Name FROM sys.procedures WHERE Name='usp_salario')
	DROP PROC dbo.usp_salario;
GO

CREATE PROCEDURE dbo.usp_salario
( 
	@codemp VARCHAR(5)
	,@salario money OUT
	,@nombre VARCHAR(100) OUT
	,@p_estado INT OUT    -- 1: Ok, -1: El código no existe 
)
AS
BEGIN

	SELECT	
		@salario=ISNULL(E.sueldo,0) + ISNULL(E.comision,0)
		,@nombre= ISNULL(C.nombre,'')
	FROM empleado E
	INNER JOIN cargo C ON C.idcargo=E.idcargo
	WHERE idempleado=@codemp --usar 'E'0001 (ejemplo)

	IF( @@ROWCOUNT = 1 )
		SET @p_estado = 1;
	ELSE
		SET @p_estado = -1;
END;
GO

BEGIN
	DECLARE @salario money;
	DECLARE @nombre VARCHAR(100);
	DECLARE @estado int;
	EXEC dbo.usp_salario 'E0001', @salario OUT, @nombre OUT, @estado OUT;
	IF( @estado = 1 )
	BEGIN
		PRINT CONCAT( 'SALARIO: ', @salario );
		PRINT CONCAT( 'NOMBRE: ', @nombre );
	END
	ELSE
		PRINT 'Código no existe';
END;
GO

-- SET

BEGIN
	DECLARE @NOMBRE VARCHAR(10);
	SET @NOMBRE = 'GUSTAVO CORONEL';
	PRINT 'NOMBRE: ' + @NOMBRE;
END;
GO


BEGIN
	DECLARE @MES VARCHAR(10);
	SET @MES =  DATEPART(MONTH,GETDATE()) ;
	PRINT 'MES: ' + @MES;
END;
GO


BEGIN
	DECLARE @INGRESOS DECIMAL(12,2);
	SET @INGRESOS =  (SELECT SUM(PAG_IMPORTE) FROM EDUCA.DBO.PAGO) ;
	PRINT CONCAT('INGRESOS: ', @INGRESOS);
END;
GO

BEGIN
	DECLARE @INGRESOS DECIMAL(12,2);
	SET @INGRESOS =  (SELECT pag_importe FROM EDUCA.DBO.PAGO WHERE cur_id = 888) ;
	PRINT CONCAT('INGRESOS: ', ISNULL(@INGRESOS,0));
END;
GO

