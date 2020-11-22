-- TIPOS DE ERRORES
/*
- Errores de sintaxis
- Errores de lógica
- Errores en tiempo de ejecución
*/

select * from dbo.curso;
select @@ROWCOUNT;
go


begin

	declare @filas int;

	begin tran;

	update dbo.curso
	set cur_matriculados = 10
	where cur_matriculados = 0;
	
	select @filas = @@ROWCOUNT;

	rollback;

	print 'Filas: ' + cast( @filas as varchar );

end;
go


begin
	declare @numerr int;
	update dbo.curso set cur_vacantes = 24;
	select @numerr = @@ERROR;
	print 'Error: ' + cast(@numerr as varchar);
end;
go


begin
	RAISERROR ('Hay error en el proceso', 16, 1); 
end;
go




begin
	BEGIN TRY 
		-- BEGIN TRANSACTION; 
		-- Bloque de código SQL a proteger 
		RAISERROR ('Hay error en el proceso', 16, 1); 
		-- COMMIT TRANSACTION; 
	END TRY 
	BEGIN CATCH 
		-- ROLLBACK TRANSACTION;
		SELECT ERROR_NUMBER() AS Numero_de_Error, 
		ERROR_SEVERITY() AS Gravedad_del_Error, 
		ERROR_STATE() AS Estado_del_Error, 
		ERROR_PROCEDURE() AS Procedimiento_del_Error, 
		ERROR_LINE() AS Linea_de_Error, ERROR_MESSAGE() AS Mensaje_de_Error;
		print 'Que paso, creo que hay error.';
	END CATCH;
end;
go



BEGIN
BEGIN TRY 
	DECLARE @TOTAL INT; 
	SET @TOTAL = 20; 
	SELECT @TOTAL/0;
END TRY 
BEGIN CATCH 
	SELECT ERROR_NUMBER() AS Numero_de_Error, 
	ERROR_SEVERITY() AS Gravedad_del_Error, 
	ERROR_STATE() AS Estado_del_Error, 
	ERROR_PROCEDURE() AS Procedimiento_del_Error, 
	ERROR_LINE() AS Linea_de_Error, 
	ERROR_MESSAGE() AS Mensaje_de_Error; 
END CATCH;
END;
GO




BEGIN
BEGIN TRY 
	SELECT * FROM TablaNoExiste; 
END TRY 
BEGIN CATCH 
	SELECT 
	ERROR_NUMBER() AS ErrorNumber, 
	ERROR_MESSAGE() AS ErrorMessage; 
END CATCH;
END;
GO


CREATE PROCEDURE DBO.usp_ProcEjemplo2 
AS
BEGIN
	SELECT * FROM TablaNoExiste;
END;
GO

BEGIN
BEGIN TRY 
	EXECUTE usp_ProcEjemplo2; 
END TRY 
BEGIN CATCH 
	SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage; 
END CATCH; 
END;
GO


BEGIN
BEGIN TRY 
	THROW 51000, 'El registro no existe.', 1;
END TRY 
BEGIN CATCH 
	SELECT ERROR_NUMBER() AS Numero_de_Error, 
	ERROR_SEVERITY() AS Gravedad_del_Error, 
	ERROR_STATE() AS Estado_del_Error, 
	ERROR_PROCEDURE() AS Procedimiento_del_Error, 
	ERROR_LINE() AS Linea_de_Error, ERROR_MESSAGE() AS Mensaje_de_Error;
	print 'Que paso, creo que hay error.';
END CATCH;
END;
go


DROP PROCEDURE DBO.SP_GENERA_CICLO;
GO

CREATE PROCEDURE DBO.SP_GENERA_CICLO
AS
BEGIN
DECLARE @CICLO VARCHAR(10), @NEWCICLO VARCHAR(10),
		@ANIO INT, @MES INT, @FINICIO DATE, @FFINAL DATE;
BEGIN TRY

	BEGIN TRAN;

	SELECT @CICLO = IDCICLO 
	FROM DBO.CICLO 
	WHERE IDCICLO = (SELECT MAX(IDCICLO) FROM DBO.CICLO);

	SET @ANIO = CAST( LEFT(@CICLO,4) AS INT );
	SET @MES = CAST( RIGHT(@CICLO,2) AS INT );

	IF( @MES < 12 )
		SET @MES = @MES + 1;
	ELSE
	BEGIN
		SET @MES = 1;
		SET @ANIO = @ANIO + 1;
	END;

	SET @CICLO = '00' + CAST(@MES AS VARCHAR);
	SET @CICLO = CAST(@ANIO AS VARCHAR) + '-'+ RIGHT(@CICLO,2);

	SET @FINICIO = CONVERT(varchar,CONCAT(@CICLO,'-01'),101);
	SET @FFINAL = EOMONTH ( @FINICIO );

	INSERT INTO DBO.CICLO(IDCICLO,FecInicio,FecTermino)
	VALUES(@CICLO, @FINICIO, @FFINAL);
	
	COMMIT TRAN;

END TRY 
BEGIN CATCH 
	ROLLBACK;
	PRINT 'HAY ERROR';
END CATCH;
END;


EXEC DBO.SP_GENERA_CICLO;
GO

SELECT CONVERT(varchar, '2017-08-25', 101);


DECLARE @date DATETIME = '12/2/2016';  
SELECT EOMONTH ( @date ) AS Result;  
GO 





