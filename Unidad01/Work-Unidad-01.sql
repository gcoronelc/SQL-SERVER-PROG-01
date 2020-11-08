

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

SELECT a.index_id, name, avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats (DB_ID(), 
OBJECT_ID(N'dbo.Customers'), NULL, NULL, NULL) AS a
JOIN sys.indexes AS b 
ON a.object_id = b.object_id AND a.index_id = b.index_id;
GO

-- Para eliminar la fragmentación

ALTER INDEX [PK_Customers] ON [dbo].[Customers] REORGANIZE  WITH ( LOB_COMPACTION = ON )
GO


ALTER INDEX PK_Customers 
ON DBO.Customers
REBUILD;
GO










