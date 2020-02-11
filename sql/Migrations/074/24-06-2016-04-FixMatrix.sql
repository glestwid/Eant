 USE [valeant]
GO

   update [valeant].[valeant].[node_properties_version_3] set actions = REPLACE(actions, N'Отправить', N'Отправить документ на согласование')
   where actions not like N'%Отправить документ на согласование%'
 
 GO