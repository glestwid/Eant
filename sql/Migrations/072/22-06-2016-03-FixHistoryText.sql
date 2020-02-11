USE [valeant]
GO

UPDATE [valeant].[historymap]
   SET [history] = 'Заявка на командировку/служебную поездку была отправлена на согласование'
 WHERE [actionid] = 2 AND [documentid] = 2

GO


