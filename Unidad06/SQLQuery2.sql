-- EJEMPLO DE AUDITORIA DE LA TABLA CURSO,
-- COLUMNA PRECIO

drop table dbo.audi_curso_precio;
go

create table dbo.audi_curso_precio(
	id int identity(1,1) primary key,
	cur_id int,
	old_precio money,
	new_precio money,
	fecha date,
	inicio_sesion varchar(100),
	usuario_bd    varchar(100)
);
go

drop trigger dbo.tr_curso_update;
go

create trigger dbo.tr_curso_update
on dbo.curso
for update
as
begin
	if update(cur_precio)
	begin
		insert into dbo.audi_curso_precio(cur_id, old_precio, new_precio, 
		fecha, inicio_sesion, usuario_bd) 
		SELECT I.CUR_ID, D.CUR_PRECIO, I.CUR_PRECIO, GETDATE(), NULL, NULL
		FROM INSERTED I JOIN DELETED D ON I.CUR_ID = D.CUR_ID;
	end;
end;
go


SELECT * FROM DBO.CURSO;

SELECT GETDATE();
GO


SELECT * FROM dbo.audi_curso_precio;
GO

UPDATE DBO.CURSO 
SET CUR_PRECIO = 1500
WHERE CUR_ID = 4;
GO

UPDATE DBO.CURSO 
SET CUR_PROFESOR = 'ricardo marcelo' 
WHERE CUR_ID = 2;
GO



