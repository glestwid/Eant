 USE [valeant]
GO

update [valeant].[valeant].[matrix_version_3] set condition = REPLACE(condition, N'Отправить', N'Отправить документ на согласование')
 
 GO