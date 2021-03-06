USE [Valeant]
GO
/****** Object:  Table [valeant].[notification]    Script Date: 5/12/2016 12:35:31 PM ******/
DROP TABLE [valeant].[notification]
GO
/****** Object:  Table [valeant].[node_properties_version_3]    Script Date: 5/12/2016 12:35:31 PM ******/
DROP TABLE [valeant].[node_properties_version_3]
GO
/****** Object:  Table [valeant].[node_properties_version_3]    Script Date: 5/12/2016 12:35:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[node_properties_version_3](
	[id] [bigint] NOT NULL,
	[state] [bigint] NOT NULL,
	[token] [bigint] NOT NULL,
	[access_list_documentblock] [bigint] NOT NULL,
	[notification] [bigint] NULL,
	[actions] [nvarchar](max) NOT NULL,
	[document] [bigint] NOT NULL CONSTRAINT [DF_node_properties_version_3_document]  DEFAULT ((1)),
 CONSTRAINT [PK_node_properties_version_3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [valeant].[notification]    Script Date: 5/12/2016 12:35:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[notification](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[templatesubject] [nvarchar](50) NOT NULL,
	[templatemessage] [nvarchar](50) NOT NULL,
	[allListUrlPart] [nvarchar](50) NOT NULL,
	[documentPart] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_notification] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (1, 1, 1, 2, NULL, N'Отправить, Сохранить', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (2, 1, 1, 7, 3, N'Отправить, Сохранить', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (3, 2, 1, 2, NULL, N'Аннулировать,Отправить,Сохранить', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (4, 2, 1, 7, 4, N'Аннулировать,Отправить,Сохранить', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (5, 4, 1, 1, NULL, N'Empty', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (6, 4, 1, 5, 5, N'Empty', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (7, 3, 1, 1, NULL, N'Отозвать', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (8, 3, 1, 5, 3, N'Отозвать', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (9, 3, 2, 1, NULL, N'Согласовать, Отказать, На доработку', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (10, 3, 2, 5, NULL, N'Согласовать, Отказать, На доработку', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (11, 5, 1, 2, NULL, N'Аннулировать,Отправить,Сохранить', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (12, 5, 1, 7, NULL, N'Аннулировать,Отправить,Сохранить', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (13, 18, 8, 1, NULL, N'Empty', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (14, 19, 8, 1, NULL, N'Empty', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (15, 19, 9, 1, NULL, N'Empty', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (16, 8, 3, 1, NULL, N'Согласовать, Отказать, На доработку', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (17, 8, 3, 5, 3, N'Согласовать, Отказать, На доработку', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (18, 8, 1, 1, NULL, N'Отозвать', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (19, 8, 1, 5, 3, N'Отозвать', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (20, 9, 9, 1, NULL, N'Согласовать, Отказать, На доработку', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (21, 9, 1, 1, NULL, N'Отозвать', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (22, 6, 1, 1, NULL, N'Печать', 1)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (23, 20, 8, 5, NULL, N'Empty', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (24, 16, 1, 5, NULL, N'Аннулировать', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (25, 13, 6, 8, NULL, N'Согласовать, Отказать, На доработку', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (26, 13, 1, 5, NULL, N'Отозвать', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (27, 14, 7, 9, NULL, N'Согласовать, Отказать, На доработку', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (28, 14, 1, 5, NULL, N'Отозвать', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (29, 12, 4, 3, NULL, N'Согласовать, Отказать, На доработку', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (30, 12, 1, 5, NULL, N'Отозвать', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (31, 21, 8, 3, NULL, N'Empty', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (32, 22, 8, 3, NULL, N'Empty', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (33, 23, 5, 5, NULL, N'Согласовать, Отказать, На доработку', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (34, 23, 1, 5, NULL, N'Отозвать', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (35, 24, 8, 3, NULL, N'Empty', 2)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (36, 25, 8, 10, NULL, N'Empty', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (37, 6, 1, 10, NULL, N'Empty', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (38, 3, 1, 10, NULL, N'Отозвать', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (39, 3, 2, 10, NULL, N'Согласовать, Отказать, На доработку', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (40, 4, 1, 10, NULL, N'Empty', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (41, 5, 1, 11, NULL, N'Аннулировать,Отправить,Сохранить', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (42, 2, 1, 11, NULL, N'Аннулировать,Отправить,Сохранить', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (43, 8, 3, 10, NULL, N'Согласовать, Отказать, На доработку', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (44, 8, 1, 10, NULL, N'Отозвать', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (45, 1, 1, 11, NULL, N'Отправить', 3)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (46, 1, 1, 13, NULL, N'Отправить, Сохранить', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (47, 2, 1, 13, NULL, N'Аннулировать,Отправить,Сохранить', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (48, 4, 1, 12, NULL, N'Empty', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (49, 5, 1, 13, NULL, N'Аннулировать,Отправить,Сохранить', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (50, 3, 2, 12, NULL, N'Согласовать, Отказать, На доработку', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (51, 3, 1, 12, NULL, N'Отозвать', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (52, 6, 1, 12, NULL, N'Empty', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (53, 30, 8, 12, NULL, N'Empty', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (54, 8, 3, 12, NULL, N'Согласовать, Отказать, На доработку', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (55, 8, 1, 12, NULL, N'Отозвать', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (56, 31, 8, 12, NULL, N'Empty', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (57, 32, 8, 12, NULL, N'Empty', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (58, 26, 10, 12, NULL, N'Согласовать, Отказать, На доработку', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (59, 26, 1, 12, NULL, N'Отозвать', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (60, 12, 4, 12, NULL, N'Согласовать, Отказать, На доработку', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (61, 12, 1, 12, NULL, N'Отозвать', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (62, 28, 12, 12, NULL, N'Дополнительное согласование, Согласовать', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (63, 28, 1, 12, NULL, N'Отозвать', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (64, 27, 11, 12, NULL, N'Согласовать, Отказать, На доработку', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (65, 27, 1, 12, NULL, N'Отозвать', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (66, 29, 13, 12, NULL, N'Согласовать, Отказать, На доработку', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (67, 29, 1, 12, NULL, N'Отозвать', 4)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (68, 1, 1, 15, NULL, N'Отправить, Сохранить', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (69, 2, 1, 15, NULL, N'Аннулировать,Отправить,Сохранить', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (70, 4, 1, 14, NULL, N'Empty', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (71, 5, 1, 15, NULL, N'Аннулировать,Отправить,Сохранить', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (72, 3, 2, 14, NULL, N'Согласовать, Отказать, На доработку', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (73, 3, 1, 14, NULL, N'Отозвать', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (74, 6, 1, 14, NULL, N'Empty', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (75, 30, 8, 14, NULL, N'Empty', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (76, 8, 3, 14, NULL, N'Согласовать, Отказать, На доработку', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (77, 8, 1, 14, NULL, N'Отозвать', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (78, 31, 8, 14, NULL, N'Empty', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (79, 32, 8, 14, NULL, N'Empty', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (80, 26, 10, 14, NULL, N'Согласовать, Отказать, На доработку', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (81, 26, 1, 14, NULL, N'Отозвать', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (82, 12, 4, 14, NULL, N'Согласовать, Отказать, На доработку', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (83, 12, 1, 14, NULL, N'Отозвать', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (84, 28, 12, 14, NULL, N'Дополнительное согласование, Согласовать', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (85, 28, 1, 14, NULL, N'Отозвать', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (86, 27, 11, 14, NULL, N'Согласовать, Отказать, На доработку', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (87, 27, 1, 14, NULL, N'Отозвать', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (88, 29, 13, 14, NULL, N'Согласовать, Отказать, На доработку', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (89, 29, 1, 14, NULL, N'Отозвать', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (90, 19, 8, 14, NULL, N'Empty', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (91, 9, 9, 14, NULL, N'Согласовать, Отказать, На доработку', 5)
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (92, 9, 1, 14, NULL, N'Отозвать', 5)
SET IDENTITY_INSERT [valeant].[notification] ON 

INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (1, N'ApproveAdvanceNotificationSubjectTemplate', N'ApproveAdvanceNotificationTemplate', N'#/approval', N'#/requests/newPrepaymentRequest?id={0}&action=Согласовать&prevState=approval')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (3, N'ApproveTripNotificationSubjectTemplate', N'ApproveTripNotificationTemplate', N'#/approval', N'#/requests/tripRequests/newTripRequest?id={0}&action=Согласовать&prevState=approval')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (4, N'RevisionTripNotificationSubjectTemplate', N'RevisionTripNotificationTemplate', N'#/approval', N'#/requests/tripRequests/newTripRequest?id={0}&action=Отправить&prevState=tripRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (5, N'RefusingTripNotificationSubjectTemplate', N'RefusingTripNotificationTemplate', N'#/approval', N'#/requests/tripRequests/newTripRequest?id={0}&action=Просмотр&prevState=tripRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (6, N'RevisionAdvanceNotificationSubjectTemplate', N'RevisionAdvanceNotificationTemplate', N'#/approval', N'#/requests/newPrepaymentRequest?id={0}&action=Отправить&prevState=prepaymentRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (7, N'RefusingAdvanceNotificationSubjectTemplate', N'RefusingAdvanceNotificationTemplate', N'#/approval', N'#/requests/newPrepaymentRequest?id={0}&action=Просмотр&prevState=prepaymentRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (9, N'ApprovedAdvanceNotificationSubjectTemplate', N'ApprovedAdvanceNotificationTemplate', N'#/approval', N'#/requests/newPrepaymentRequest?id={0}&action=Просмотр&prevState=prepaymentRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (11, N'ApprovedTripNotificationSubjectTemplate', N'ApprovedTripNotificationTemplate', N'#/approval', N'#/requests/tripRequests/newTripRequest?id={0}&action=Просмотр')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (14, N'ApproveGiftNotificationSubjectTemplate', N'ApproveGiftNotificationTemplate', N'#/approval', N'#/requests/newGiftRequest?id={0}&action=Согласовать&prevState=approval')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (15, N'RevisionGiftNotificationSubjectTemplate', N'RevisionGiftNotificationTemplate', N'#/approval', N'#/requests/giftRequests/newGiftRequest?id={0}&action=Отправить&prevState=tripRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (16, N'RefusingGiftNotificationSubjectTemplate', N'RefusingGiftNotificationTemplate', N'#/approval', N'#/requests/giftRequests/newGiftRequest?id={0}&action=Просмотр&prevState=tripRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (17, N'ApprovedGiftNotificationSubjectTemplate', N'ApprovedGiftNotificationTemplate', N'#/approval', N'#/requests/newGiftRequest?id={0}&action=Просмотр')
SET IDENTITY_INSERT [valeant].[notification] OFF
