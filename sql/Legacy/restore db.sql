USE Master; 
GO
  
ALTER DATABASE Valeant SET SINGLE_USER WITH ROLLBACK IMMEDIATE 
GO
 
-- and finally 
restore DATABASE Valeant from disk='C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Backup\VALEANT.BAK' 
GO

ALTER DATABASE Valeant  SET MULTI_USER
go


use Valeant
go
exec sp_addrolemember 'db_owner', 'test\ValeantRobot'
go
