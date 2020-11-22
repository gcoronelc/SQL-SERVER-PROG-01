
-- Ejercicio 3

create function dbo.fnCalculadora
( @num1 int, @num2 int, @operador varchar(5))
returns int
as
begin
	declare @rpta int;
	set @rpta = case 
		when @operador = '+' then @num1 + @num2 
		when @operador = '-' then @num1 - @num2 
		when @operador = '*' then @num1 * @num2 
		when @operador = '/' then @num1 / @num2 
		else 0
	end;
	return @rpta;
end;
go

select dbo.fnCalculadora(8,7,'*') rpta;
go


-- Ejercicio 5
-- @PA Porcentaje de asistencia
-- @PF Promedio final

drop function dbo.fnCondicionEstudiante;
go

create function dbo.fnCondicionEstudiante ( @PA int, @PF int)
returns varchar(50)
as
begin
	declare @rpta varchar(50);
	set @rpta = case 
		when (@PA >= 80) and (@PF >= 14 and @PF <= 20) then 'Aprobado' 
		when (@PA >= 80) and (@PF >= 10 and @PF < 14) then 'Asistente' 
		else 'Desaprobado'
	end;
	return @rpta;
end;
go

select dbo.fnCondicionEstudiante(79,18) Condicion;
go


-- ==========================================================
-- BUCLE: WHILE
-- ==========================================================

BEGIN
	declare @n int;
	set @n = 10;
	WHILE(@n >= 0) 
	BEGIN
		IF(@n = 5) BREAK;
		PRINT 'ALIANZA CAMPEON';
		set @n = @n - 1;
	END;
END;
GO

-- Es un bucle infinito
BEGIN
	declare @n int;
	set @n = 10;
	WHILE(@n >= 0) 
	BEGIN
		IF(@n = 5) CONTINUE;
		PRINT 'ALIANZA CAMPEON';
		set @n = @n - 1;
	END;
END;
GO


-- Es similar al break
BEGIN
	declare @n int;
	set @n = 10;
	WHILE(@n >= 0) 
	BEGIN
		IF(@n = 5) goto FIN;
		PRINT 'ALIANZA CAMPEON';
		set @n = @n - 1;
	END;
	FIN:
	PRINT 'Fin del proceso';
END;
GO




