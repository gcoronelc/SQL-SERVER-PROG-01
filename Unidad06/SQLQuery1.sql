

CREATE TRIGGER dbo.tr_alumno_all
ON dbo.alumno
FOR INSERT,UPDATE,DELETE
AS
begin
   print 'Se ejecuto el trigger tr_alumno_all';
end;
go

select * from dbo.Alumno;
go

insert into dbo.alumno(idalumno,apealumno,nomalumno,emailalumno,clave)
values('A8888','ramos','jose','jramos@gmail.com','123456');
go

update dbo.alumno 
set telalumno = '7845768923'
where idalumno = 'A8888';
go

delete from  dbo.alumno 
where idalumno = 'A8888';
go