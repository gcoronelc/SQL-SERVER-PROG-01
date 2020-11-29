

DECLARE cur_cursos CURSOR
FOR
SELECT cur_id, cur_nombre, cur_precio
FROM EDUCA.dbo.CURSO;

OPEN cur_cursos;


DECLARE @cur_id int, @cur_nombre varchar(100), @cur_precio money;

-- Primera fila
FETCH NEXT FROM cur_cursos
INTO @cur_id, @cur_nombre, @cur_precio;

WHILE( @@FETCH_STATUS = 0 )
BEGIN
	-- Imprime la fila
	PRINT CONCAT(@cur_id, ' - ', @cur_nombre, ' - ', @cur_precio);
	-- La siguiente fila
	FETCH NEXT FROM cur_cursos
	INTO @cur_id, @cur_nombre, @cur_precio;
END;


CLOSE cur_cursos;

DEALLOCATE cur_cursos;


-- Ejemplo 10

USE RH;
GO

DECLARE cur_depts CURSOR
FOR
	SELECT d.iddepartamento codido, d.nombre nombre, count(*) emps
	FROM dbo.departamento d
	join dbo.empleado e
	on d.iddepartamento = e.iddepartamento
	group by d.iddepartamento, d.nombre;

OPEN cur_depts;

DECLARE @codigo int, @nombre varchar(100), @emps int
PRINT CONCAT('COD', SPACE(4), LEFT('NOMBRE' + SPACE(20), 20), SPACE(4), 'EMPS');
PRINT '-----------------------------------';
FETCH NEXT FROM cur_depts INTO @codigo, @nombre, @emps;
WHILE( @@FETCH_STATUS = 0 )
BEGIN
	PRINT CONCAT(@codigo, SPACE(4), LEFT(@nombre + SPACE(20), 20), SPACE(4), @emps);
	FETCH NEXT FROM cur_depts INTO @codigo, @nombre, @emps;
END;


CLOSE cur_depts;
DEALLOCATE cur_depts;
GO


-- Ejercicio
/*
Desarrollar un script utilizando cursores que permita mostrar
la cantidad de cursos y estuiantes que tiene cada profesor
por trimestre. BD: EDUTEC.
*/

USE EDUTEC;
GO

SELECT * FROM EDUTEC.DBO.CICLO;
SELECT * FROM EDUTEC.DBO.CURSOPROGRAMADO;
GO

DECLARE CUR_RESUMEN CURSOR
FOR
	SELECT 
		P.ApeProfesor [PROFESOR],
		YEAR(C.FECINICIO) [AÑO],
		DATEPART(qq, C.FecInicio) TRIMESTRE, 
		count(1) CURSOS,
		SUM(CP.Matriculados) [CANT. ESTUDIANTES]
	FROM EDUTEC.DBO.CURSOPROGRAMADO CP
	JOIN EDUTEC.DBO.Profesor P 	on CP.IdProfesor = P.IdProfesor
	JOIN EDUTEC.dbo.Ciclo C ON CP.IdCiclo = C.IdCiclo
	group by P.ApeProfesor, YEAR(C.FECINICIO), DATEPART(qq, C.FecInicio)
	order by 1,2,3;

OPEN CUR_RESUMEN;

DECLARE @profesor varchar(50), @anio int, @trimestre int, @cursos int, @estudiantes int
PRINT '------------------------------------------------------';
FETCH NEXT FROM CUR_RESUMEN INTO @profesor, @anio, @trimestre, @cursos, @estudiantes;
WHILE( @@FETCH_STATUS = 0 )
BEGIN
	PRINT CONCAT( @profesor, SPACE(4), @anio, SPACE(4), @trimestre, SPACE(4), @cursos, SPACE(4), @estudiantes);
	FETCH NEXT FROM CUR_RESUMEN INTO @profesor, @anio, @trimestre, @cursos, @estudiantes;
END;

PRINT CONCAT('FILAS: ', @@CURSOR_ROWS);

CLOSE CUR_RESUMEN;
DEALLOCATE CUR_RESUMEN;
GO


