-- Ejercicio 4
/*
En la base de datos EDUTEC, crear un procedimiento que reciba como parámetro
un periodo, por ejemplo 2010, 2011, 2012, etc. y reporte por cada ciclo en el periodo
los siguientes datos:
▪ Cantidad de cursos programados
▪ Cantidad de alumnos proyectados
▪ Cantidad de alumnos matriculados
▪ Importe proyectado (de alumnos proyectados)
▪ Importe real (de alumnos matriculados)

Ejemplo, para el 2010

CICLO       CANT.CURSOS       CANT.ALU.PROY     CANT.ALU.MAT    IMP.PROY    IMP.REAL
-------------------------------------------------------------------------------------
2010-01         30                600               360           
2010-02         40                800               600
2010-03         35                700               490
. . .
2010-12         40                800               640

*/

USE  EDUTEC;
GO

SELECT * FROM DBO.CICLO WHERE IDCICLO LIKE '2019%';
GO

select * from dbo.CursoProgramado;
go

drop procedure dbo.usp_resumen_periodo;
go

create procedure dbo.usp_resumen_periodo( @periodo varchar(10) )
as
begin
	create table #resumen(
		id          int identity(1,1) primary key,
		ciclo       varchar(10) not null,
		cantcursos  int null,
		cantaluproy int null,
		cantalumat  int null,
		imgproy     numeric(10,2) null,
		imgreal     numeric(10,2) null
	);
	declare @id_min int, @id_max int, @idactual int;
	declare @ciclo varchar(10), @cantcursos int, @cantaluproy int;
	declare @cantalumat int, @imgproy numeric(10,2), @imgreal numeric(10,2);
	-- Llenado de la columna ciclo
	insert into #resumen( ciclo ) 
	select idciclo from dbo.ciclo where idciclo like concat(@periodo,'%');
	-- Valores del id
	select @id_min = min(id), @id_max = max(id) from #resumen;
	-- Buble general
	set @idactual = @id_min;
	while( @idactual <= @id_max )
	begin
		-- leer el idciclo
		select @ciclo = ciclo from #resumen where id = @idactual;
		-- Calcular la cantidad de cursos
		select @cantcursos = count(1) from dbo.CursoProgramado
		where idciclo =  @ciclo and activo = 1;
		-- Calcular la cantidad de alumnos proyectados
		select @cantaluproy = sum(Vacantes + Matriculados) 
		from dbo.CursoProgramado
		where idciclo =  @ciclo and activo = 1;
		-- Calcular la cantidad de alumnos matriculados
		select @cantalumat = sum(Matriculados) 
		from dbo.CursoProgramado
		where idciclo =  @ciclo and activo = 1;
		-- Calcular el ingreso proyectado
		select @imgproy = sum((Vacantes + Matriculados) * PreCursoProg) 
		from dbo.CursoProgramado
		where idciclo =  @ciclo and activo = 1;
		-- Calcular el ingreso real
		select @imgreal = sum(Matriculados * PreCursoProg) 
		from dbo.CursoProgramado
		where idciclo =  @ciclo and activo = 1;
		-- Actualizar fila
		update #resumen 
		set cantcursos = @cantcursos, cantaluproy = @cantaluproy,
			cantalumat = @cantalumat, imgproy = @imgproy, imgreal = @imgreal
		where id = @idactual;
		-- incrementar el idactual
		set @idactual = @idactual + 1;
	end;
	-- Reporte final
	select * from #resumen;
end;
go

begin
	exec dbo.usp_resumen_periodo '2019';
end;
go


