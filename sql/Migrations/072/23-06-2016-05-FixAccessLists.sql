USE [valeant]
GO

-- авансовый на командировку
INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (12, 2, 1) -- trip, form header, view

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (13, 2, 2) -- trip, form header, edit

INSERT INTO [valeant].[documentblock_accesslist_version_2]
           ([id]
           ,[documenttype]
           ,[name]
           ,[description])
     VALUES
           (18, 4, 'allviewwocost', 'полный просмотр авансового отчета по командировке/служебной поездке без бух полей')

INSERT INTO [valeant].[documentblock_accesslist_version_2]
           ([id]
           ,[documenttype]
           ,[name]
           ,[description])
     VALUES
           (19, 4, 'alleditwocost', 'полное редактирование авансового отчета по командировке/служебной поездке без бух полей')


INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (18, 2, 1) -- trip, form header, view

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (18, 11, 1) -- trip, ReportTrip view

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (18, 12, 3) -- trip, ReportCost, hide

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (19, 2, 2) -- trip, form header, edit

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (19, 11, 2) -- trip, ReportTrip view

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (19, 12, 3) -- trip, ReportCost, hide

 update [valeant].[valeant].[node_properties_version_3] set access_list_documentblock = 13 where token in (12,13) and document = 4
 update [valeant].[valeant].[node_properties_version_3] set access_list_documentblock = 19 where access_list_documentblock = 13 and token not in (12,13) and document = 4
 update [valeant].[valeant].[node_properties_version_3] set access_list_documentblock = 18 where access_list_documentblock = 12 and token not in (12,13) and document = 4


-- авансовый на представительский
INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (14, 2, 1) -- advance, form header, view

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (15, 2, 2) -- advance, form header, edit

INSERT INTO [valeant].[documentblock_accesslist_version_2]
           ([id]
           ,[documenttype]
           ,[name]
           ,[description])
     VALUES
           (20, 5, 'allviewwocost', 'полный просмотр авансового отчета по представительским и текущим расходам без бух полей')

INSERT INTO [valeant].[documentblock_accesslist_version_2]
           ([id]
           ,[documenttype]
           ,[name]
           ,[description])
     VALUES
           (21, 5, 'alleditwocost', 'полное редактирование авансового отчета по представительским и текущим расходам без бух полей')


INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (20, 2, 1) -- advance, form header, view

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (20, 11, 1) -- advance, ReportTrip view

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (20, 12, 3) -- advance, ReportCost, hide

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (21, 2, 2) -- advance, form header, edit

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (21, 11, 2) -- advance, ReportTrip view

INSERT INTO [valeant].[documentblock_accesslist_details_version_2]
           ([accesslist]
           ,[block]
           ,[access])
     VALUES
           (21, 12, 3) -- advance, ReportCost, hide

 update [valeant].[valeant].[node_properties_version_3] set access_list_documentblock = 15 where token in (12,13) and document = 5
 update [valeant].[valeant].[node_properties_version_3] set access_list_documentblock = 21 where access_list_documentblock = 15 and token not in (12,13) and document = 5
 update [valeant].[valeant].[node_properties_version_3] set access_list_documentblock = 20 where access_list_documentblock = 14 and token not in (12,13) and document = 5

GO


