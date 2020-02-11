USE [valeant]
GO

update [valeant].[valeant].[node_properties_version_3] set [actions] = N'Отправить документ на согласование, Создать' where [state] = 1 and [document] <> 3
update [valeant].[valeant].[node_properties_version_3] set [actions] = N'Отправить документ на согласование' where [state] = 1 and [document] = 3

GO


