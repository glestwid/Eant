USE [Valeant]
GO
update [valeant].[valeant].[notification] set [documentPart] = '#/travelLists/newTravelList?id={0}&prevState=approval' where [templatesubject] = 'ApproveTravelListNotificationSubjectTemplate'
update [valeant].[valeant].[notification] set [documentPart] = '#/travelLists/newTravelList?id={0}&prevState=travelLists' where [templatesubject] = 'RevisionTravelListNotificationSubjectTemplate'
update [valeant].[valeant].[notification] set [documentPart] = '#/travelLists/newTravelList?id={0}&prevState=approval' where [templatesubject] = 'RefusingTravelListNotificationSubjectTemplate'
update [valeant].[valeant].[notification] set [documentPart] = '#/travelLists/newTravelList?id={0}&prevState=approval' where [templatesubject] = 'ApprovedTravelListNotificationSubjectTemplate'
update [valeant].[valeant].[notification] set [documentPart] = '#/travelLists/newTravelList?id={0}&prevState=approval' where [templatesubject] = 'PaidAdvanceNotificationSubjectTemplate'