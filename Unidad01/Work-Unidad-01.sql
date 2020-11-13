

select * from dbo.Customers;


CREATE TABLE DEMO(
ID INTEGER,
DATO VARCHAR(100),
CONSTRAINT PK_DEMO PRIMARY KEY( ID )
);
GO


select * from dbo.[Order Details]
where ProductID = 1;
go

ALTER INDEX [City] ON [dbo].[Customers] DISABLE
GO

ALTER INDEX [City] ON [dbo].[Customers] REBUILD
GO

select * from dbo.Customers
where city like 'London';
go


-- Recostruir indice

ALTER INDEX PK_Customers ON DBO.Customers REBUILD;
GO


ALTER INDEX ALL ON DBO.Customers REBUILD;
GO


-- Fragmentación de índices


SELECT 
	c.name "Table name",
	b.name "Index", 
	avg_fragmentation_in_percent "Frag (%)", 
	page_count "Page count" 
FROM sys.dm_db_index_physical_stats (DB_ID(), 
NULL, NULL, NULL, NULL ) AS a
JOIN sys.indexes AS b 
ON a.object_id = b.object_id AND a.index_id = b.index_id
JOIN sys.tables c ON b.object_id = c.object_id
ORDER BY  3 DESC;
GO



-- Para eliminar la fragmentación

ALTER INDEX [PK_Customers] ON [dbo].[Customers] REORGANIZE;
GO

ALTER INDEX ALL ON DBO.Customers REORGANIZE;
GO












