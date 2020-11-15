-- Criterios de programación
/*
	El código sea fácil de leer
	El código debe ser mantenible
	Se debe evitar estructuras anidadas
	Tratar de eviatr el ELSE
*/

create function dbo.fn_mayor( @n1 int, @n2 int, @n3 int )
returns int
as
begin
	declare @mayor int;
	set @mayor = @n1; -- Punto de partida
	if( @mayor < @n2 ) set @mayor = @n2;
	if( @mayor < @n3 ) set @mayor = @n3;
	return @mayor;
end;
go


select dbo.fn_mayor( 215, 120, 67 ) as mayor;
go


drop function dbo.fn_par;
go

create function dbo.fn_par( @num int )
returns int
as
begin
	declare @par int;
	declare @resto int;
	set @resto = @num % 2;
	set @par = 0; -- Punto de partida
	if(@resto = 0) set @par = 1;
	return @par;
end;
go


select dbo.fn_par(20) resp1, dbo.fn_par(15) resp2;
go






