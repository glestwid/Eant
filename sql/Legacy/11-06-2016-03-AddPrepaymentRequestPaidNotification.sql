declare @id int 
SET IDENTITY_INSERT [valeant].[notification] ON 

if NOT EXISTS  (SELECT id FROM [valeant].[notification] where [templatesubject]=  N'PaidAdvanceNotificationSubjectTemplate') 
BEGIN
select @id =(max(id) +1) from [valeant].[notification]
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) 
VALUES (@id, N'PaidAdvanceNotificationSubjectTemplate', N'PaidAdvanceNotificationTemplate', N'#/approval', N'#/requests/newPrepaymentRequest?id={0}&action=Согласовать&prevState=approval')
END

SET IDENTITY_INSERT [valeant].[notification] OFF

GO 

UPDATE [valeant].[node_properties_version_3] 
SET [notification] = (select id from [valeant].[notification] where [templatesubject]=  N'PaidAdvanceNotificationSubjectTemplate')
where [state] = 7 and token = 12 and document = 1