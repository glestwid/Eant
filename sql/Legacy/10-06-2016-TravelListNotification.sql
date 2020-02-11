GO
declare @id int 

SET IDENTITY_INSERT [valeant].[notification] ON 


if NOT EXISTS  (SELECT id FROM [valeant].[notification] where [templatesubject]=  N'ApproveTravelListNotificationSubjectTemplate') 
BEGIN
select @id =(max(id) +1) from [valeant].[notification]
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (@id, N'ApproveTravelListNotificationSubjectTemplate', N'ApproveTravelListNotificationTemplate', N'#/approval', N'#/requests/newTravelList?id={0}&action=Согласовать&prevState=approval')
END

if NOT EXISTS  (SELECT id FROM [valeant].[notification] where [templatesubject]=  N'RevisionTravelListNotificationSubjectTemplate') 
BEGIN
select @id =(max(id) +1) from [valeant].[notification]
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (@id, N'RevisionTravelListNotificationSubjectTemplate', N'RevisionTravelListNotificationTemplate', N'#/approval', N'#/requests/newTravelList?id={0}&action=Отправить&prevState=travelLists')
END

if NOT EXISTS  (SELECT id FROM [valeant].[notification] where [templatesubject]=  N'RefusingTravelListNotificationSubjectTemplate') 
BEGIN
select @id =(max(id) +1) from [valeant].[notification]
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (@id, N'RefusingTravelListNotificationSubjectTemplate', N'RefusingTravelListNotificationTemplate', N'#/approval', N'#/requests/newTravelList?id={0}&action=Просмотр&prevState=travelLists')
END

if NOT EXISTS  (SELECT id FROM [valeant].[notification] where [templatesubject]=  N'ApprovedTravelListNotificationSubjectTemplate') 
BEGIN
select @id =(max(id) +1) from [valeant].[notification]
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (@id, N'ApprovedTravelListNotificationSubjectTemplate', N'ApprovedTravelListNotificationTemplate', N'#/approval', N'#/requests/newTravelList?id={0}&action=Просмотр&prevState=travelLists')
END

SET IDENTITY_INSERT [valeant].[notification] OFF


GO 
DECLARE  @approveNotification  int
DECLARE  @revisionNotification int
DECLARE  @refusingNotification int
DECLARE  @approvedNotification int


SELECT   @approveNotification = id FROM [valeant].[notification] where [templatesubject]=  N'ApproveTravelListNotificationSubjectTemplate'
SELECT   @revisionNotification = id FROM [valeant].[notification] where [templatesubject]=  N'RevisionTravelListNotificationSubjectTemplate'
SELECT   @refusingNotification = id FROM [valeant].[notification] where [templatesubject]=  N'RefusingTravelListNotificationSubjectTemplate'
SELECT   @approvedNotification = id FROM [valeant].[notification] where [templatesubject]=  N'ApprovedTravelListNotificationSubjectTemplate'


UPDATE [valeant].[node_properties_version_3] SET notification = @approvedNotification   where state = 6 and document =3
UPDATE [valeant].[node_properties_version_3] SET notification = @approveNotification   where state = 3 and document =3
UPDATE [valeant].[node_properties_version_3] SET notification = @approveNotification   where state = 8 and document =3
UPDATE [valeant].[node_properties_version_3] SET notification = @revisionNotification   where state = 5 and document =3
UPDATE [valeant].[node_properties_version_3] SET notification = @refusingNotification    where state = 4 and document =3





