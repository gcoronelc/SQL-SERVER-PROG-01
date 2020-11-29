

CREATE PROCEDURE USP_TABLA_TEMP_01
AS
BEGIN
	-- Creando la variable de tipo tabla.
	DECLARE @Catalogo TABLE
	(
		idProd int NOT NULL PRIMARY KEY,
		nombre varchar(30) NULL,
		precio money
	);
	-- Insertando datos en la variable de tipo tabla.
	INSERT INTO @Catalogo VALUES
	(1, 'Refrigeradora', 2400.0),
	(2, 'Televisor', 3500.0),
	(3, 'Laptop', 4500.0);
	-- Consultando datos de la variable de tipo tabla.
	SELECT * FROM @Catalogo;
END;
GO


EXEC USP_TABLA_TEMP_01;
GO

SELECT * FROM RH.DBO.EMPLEADO;
GO

CREATE PROCEDURE USP_TABLA_TEMP_02
AS
BEGIN
	-- Creando la variable de tipo tabla.
	DECLARE @EMPLEADO TABLE
	(
		idEmp VARCHAR(10) NOT NULL PRIMARY KEY,
		nombre varchar(100) NULL,
		ingresos money
	);
	-- Insertando datos en la variable de tipo tabla.
	INSERT INTO @EMPLEADO 
	select idempleado, concat(apellido, ', ', nombre), sueldo from rh.dbo.empleado;
	-- Consultando datos de la variable de tipo tabla.
	SELECT * FROM @EMPLEADO;
END;
GO


EXEC USP_TABLA_TEMP_02;
GO


-- Ejercicio 
/*
Desarrollar un procedimiento que permita el resumen de los ingresos
comprometidos, lo recaudado, lo que falta cobrar y la cantidad de matriculados
de cada curso. BD EDUCA.
*/

use educa;
go

select * from curso;
go

select * from matricula;
go

drop procedure usp_educa_resumen;
go

create procedure usp_educa_resumen
as
begin
	create table #resumen(
		idcurso int primary key,
		nombre varchar(60),
		matriculados int,
		comprometido money,
		recaudado money,
		falta money
	);
	-- Cursos
	insert into #resumen(idcurso, nombre)
	select cur_id, cur_nombre from dbo.curso;
	-- Matriculado y comprometido
	update #resumen  
	set matriculados = (select count(1) from MATRICULA m where m.cur_id = r.idcurso),
	comprometido = (select sum(mat_precio) from MATRICULA m where m.cur_id = r.idcurso),
	recaudado = (select sum(pag_importe) from PAGO p where p.cur_id = r.idcurso)
	from #resumen r;
	-- Actualizar falta
	update #resumen  
	set falta = isnull(comprometido,0) - isnull(recaudado,0);
	-- Consulta final
	select * from #resumen;
end
go


exec usp_educa_resumen
go



