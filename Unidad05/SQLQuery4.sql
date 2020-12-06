USE [master]
GO

BACKUP DATABASE [EduTec] 
TO  DISK = N'D:\EduTec.bak';
GO

RESTORE DATABASE [EduTec] 
FROM  DISK = N'D:\EduTec.bak' 
WITH  FILE = 1;
GO