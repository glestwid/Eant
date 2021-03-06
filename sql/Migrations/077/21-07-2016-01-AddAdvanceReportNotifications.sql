USE [valeant]
GO
SET IDENTITY_INSERT [valeant].[notification] ON 

INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) 
VALUES (23, N'ApproveTripReportNotificationSubjectTemplate', N'ApproveTripReportNotificationTemplate', N'#/approval', 
N'#/advanceReports/newTripAdvanceReport?id={0}&prevState=approval')
GO
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) 
VALUES (24, N'RevisionTripReportNotificationSubjectTemplate', N'RevisionTripReportNotificationTemplate', N'#/approval', 
N'#/advanceReports/newTripAdvanceReport?id={0}&prevState=advanceReports')
GO
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) 
VALUES (25, N'RefusingTripReportNotificationSubjectTemplate', N'RefusingTripReportNotificationTemplate', N'#/approval', 
N'#/advanceReports/newTripAdvanceReport?id={0}&prevState=approval')
GO
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) 
VALUES (26, N'ApprovedTripReportNotificationSubjectTemplate', N'ApprovedTripReportNotificationTemplate', N'#/approval', 
N'#/advanceReports/newTripAdvanceReport?id={0}&prevState=approval')
GO
SET IDENTITY_INSERT [valeant].[notification] OFF
GO

update [valeant].[valeant].[node_properties_version_3] set notification = 25 where id = 48 -- refusing
update [valeant].[valeant].[node_properties_version_3] set notification = 24 where id = 49 -- revision
update [valeant].[valeant].[node_properties_version_3] set notification = 23 where id in (50, 54, 58, 60, 62, 64, 66) -- approve
update [valeant].[valeant].[node_properties_version_3] set notification = 26 where id = 52 -- approved
