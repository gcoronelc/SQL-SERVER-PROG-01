use educa;
go

select * from educa.dbo.MATRICULA where cur_id = 1 and alu_id=4;
select * from educa.dbo.PAGO where cur_id = 1 and alu_id=4;
go

drop procedure usp_pago;
go

create procedure usp_pago(
@curso int, @estudiante int, @importe money, @estado int output
)
as
begin
BEGIN TRY   

	set @estado = -5;
	BEGIN TRAN;

	declare @precio money, @cuotasTotales int;
	declare @pagado money, @cuotasPagadas int;
	declare @faltaPagar money, @cuotasFaltan int;

	-- Obteniendo la deuda
	select @precio = mat_precio, @cuotasTotales = mat_cuotas
	from dbo.matricula 
	where cur_id = @curso and alu_id = @estudiante;

	if( @@ROWCOUNT <> 1 )
	begin
		set @estado = -4;
		THROW 51000, 'No hay datos.', 1;
	end;

	-- Obteneiendo lo pagado
	select @pagado = sum(pag_importe), @cuotasPagadas = count(1)
	from dbo.pago 
	where cur_id = @curso and alu_id = @estudiante;

	-- Analizando la deuda
	if( @pagado >= @precio )
	begin
		set @estado = -3;
		THROW 51000, 'No hay deuda.', 1;
	end;

	-- Analizando cuota
	set @faltaPagar = @precio - @pagado;
	set @cuotasFaltan = @cuotasTotales - @cuotasPagadas;

	if( (@cuotasFaltan = 1) and (@importe < @faltaPagar ))
	begin
		set @estado = -1;
		THROW 51000, 'Importe no es suficiente.', 1;
	end;

	if( (@cuotasFaltan = 1) and (@importe > @faltaPagar ))
	begin
		set @estado = -2;
		THROW 51000, 'Importe en exceso.', 1;
	end;

	-- Registrar el pago
	insert into pago(cur_id,alu_id,pag_cuota,pag_fecha, pag_importe)
	values(@curso,@estudiante,@cuotasPagadas + 1,getdate(),@importe);

	-- Confirmar Tx
	COMMIT;
	set @estado = 1;
END TRY
BEGIN CATCH 
	ROLLBACK;
END CATCH;

end;
go


declare @estado int;
exec usp_pago 1, 4, 400, @estado output;
print concat('Estado: ', @estado);
GO

