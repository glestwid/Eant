USE [valeant]
GO
/****** Object:  StoredProcedure [valeant].[readparentdepartments]    Script Date: 6/16/2016 3:54:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[readparentdepartments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [valeant].[readparentdepartments]
GO
/****** Object:  Table [valeant].[settings]    Script Date: 6/16/2016 3:54:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[settings]') AND type in (N'U'))
DROP TABLE [valeant].[settings]
GO
/****** Object:  Table [valeant].[matrix_version_3]    Script Date: 6/16/2016 3:54:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[matrix_version_3]') AND type in (N'U'))
DROP TABLE [valeant].[matrix_version_3]
GO
/****** Object:  Table [valeant].[matrix_version_3]    Script Date: 6/16/2016 3:54:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[matrix_version_3]') AND type in (N'U'))
BEGIN
CREATE TABLE [valeant].[matrix_version_3](
	[id] [bigint] NOT NULL,
	[from] [bigint] NOT NULL,
	[to] [bigint] NOT NULL,
	[condition] [nvarchar](max) NOT NULL,
	[document] [bigint] NOT NULL,
	[postfunc] [nvarchar](max) NULL,
	[approvalsheetitem] [nvarchar](24) NULL,
	[clearapprovalsheet] [bit] NOT NULL CONSTRAINT [DF_matrix_version_3_clear]  DEFAULT ((0)),
 CONSTRAINT [PK_matrix_version_3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [valeant].[settings]    Script Date: 6/16/2016 3:54:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[settings]') AND type in (N'U'))
BEGIN
CREATE TABLE [valeant].[settings](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[value] [nvarchar](1024) NOT NULL,
	[description] [nvarchar](1024) NOT NULL,
 CONSTRAINT [PK_settings] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (1, 1, 2, N'action=="Создать"', 1, N'document.UpdateCost()', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (2, 1, 3, N'action=="Отправить"', 1, N'document.UpdateCost()', N'A.01.00.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (3, 2, 4, N'action=="Аннулировать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (4, 2, 3, N'action=="Отправить"', 1, NULL, N'A.01.01.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (5, 2, 2, N'action=="Сохранить"', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (6, 3, 5, N'action=="На доработку"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (7, 3, 4, N'action=="Отказать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (8, 3, 4, N'action=="Аннулировать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (9, 3, 2, N'action=="Отозвать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (10, 3, 18, N'action=="Согласовать"', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (11, 18, 19, N'action=="Empty" AND NOT document.LimitCheck()', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (12, 18, 8, N'action=="Empty" AND document.LimitCheck()', 1, NULL, N'A.02.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (13, 8, 5, N'action=="На доработку"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (14, 8, 4, N'action=="Отказать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (15, 8, 4, N'action=="Аннулировать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (16, 8, 2, N'action=="Отозвать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (17, 8, 19, N'action=="Согласовать"', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (18, 19, 6, N'action=="Empty" AND NOT document.RoCheck(tokens)', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (19, 19, 9, N'action=="Empty" AND document.RoCheck(tokens)', 1, NULL, N'A.03.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (20, 9, 5, N'action=="На доработку"', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (21, 9, 4, N'action=="Отказать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (22, 9, 4, N'action=="Аннулировать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (23, 9, 2, N'action=="Отозвать"', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (24, 9, 19, N'action=="Согласовать"', 1, N'document.UpdateCost(actor)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (25, 5, 4, N'action=="Аннулировать"', 1, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (26, 5, 3, N'action=="Отправить"', 1, NULL, N'A.01.02.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (27, 5, 2, N'action=="Сохранить"', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (28, 1, 2, N'iif(action.Equals("Создать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (29, 2, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (30, 2, 2, N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (31, 1, 20, N'iif(owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (32, 20, 13, N'iif(action.Equals("Empty", StringComparison.InvariantCultureIgnoreCase) AND document.MainData.TripType.Name.Equals("Командировка", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, N'ABC.05.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (33, 20, 14, N'iif(action.Equals("Empty", StringComparison.InvariantCultureIgnoreCase) AND document.MainData.TripType.Name.Equals("Командировка", StringComparison.InvariantCultureIgnoreCase), false, true)', 2, NULL, N'ABC.06.00.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (34, 2, 20, N'iif(owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (35, 13, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (36, 13, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (37, 13, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (38, 14, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (39, 14, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (40, 14, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (41, 5, 20, N'iif(owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (42, 13, 14, N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, N'ABC.06.01.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (43, 14, 16, N'iif(owner.IsCeo AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(true)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (44, 16, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (45, 2, 12, N'iif(owner.IsFirstLevel AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', N'B.03.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (46, 12, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (47, 12, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (48, 12, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (49, 5, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (50, 12, 20, N'iif(owner.IsFirstLevel AND NOT document.FlagTravelCoordinator  AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (51, 14, 21, N'iif(NOT owner.IsCeo AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(true)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (52, 21, 12, N'iif(owner.IsFirstLevel AND document.ScanPdfsData.Options.OverLimit, true, false)', 2, NULL, N'B.08.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (53, 21, 16, N'iif(NOT owner.IsCeo AND document.ScanPdfsData.Options.OverLimit, false, true)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (54, 12, 16, N'iif(owner.IsFirstLevel AND document.FlagTravelCoordinator  AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (55, 1, 12, N'iif(owner.IsFirstLevel AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', N'B.04.00.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (56, 5, 5, N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (57, 2, 3, N'iif(owner.IsSimple AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', N'A.01.01.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (58, 3, 5, N'iif(owner.IsSimple AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (59, 3, 2, N'iif(owner.IsSimple AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (60, 3, 4, N'iif(owner.IsSimple AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (61, 5, 3, N'iif(owner.IsSimple AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', N'A.01.02.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (62, 3, 22, N'iif(owner.IsSimple AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (63, 22, 20, N'iif(owner.IsSimple AND action.Equals("Empty", StringComparison.InvariantCultureIgnoreCase) AND document.IsDateGr(14), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (64, 22, 24, N'iif(owner.IsSimple AND action.Equals("Empty", StringComparison.InvariantCultureIgnoreCase) AND document.IsDateGr(14), false, true)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (65, 24, 12, N'iif(owner.IsSimple AND action.Equals("Empty", StringComparison.InvariantCultureIgnoreCase) AND document.IsForeignCountry(owner), true, false)', 2, NULL, N'A.03.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (66, 24, 23, N'iif(owner.IsSimple AND action.Equals("Empty", StringComparison.InvariantCultureIgnoreCase) AND document.IsForeignCountry(owner), false, true)', 2, NULL, N'A.02.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (67, 23, 5, N'iif(owner.IsSimple AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (68, 23, 4, N'iif(owner.IsSimple AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (69, 23, 20, N'iif(owner.IsSimple AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (71, 8, 5, N'iif(owner.IsSimple AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (72, 8, 2, N'iif(owner.IsSimple AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (73, 8, 4, N'iif(owner.IsSimple AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (74, 8, 16, N'iif(owner.IsSimple AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (75, 21, 8, N'iif(owner.IsSimple AND document.ScanPdfsData.Options.OverLimit, true, false)', 2, NULL, N'A.07.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (76, 1, 3, N'iif(owner.IsSimple AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, N'A.01.00.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (77, 1, 2, N'iif(action.Equals("Создать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (78, 1, 6, N'iif(owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (79, 1, 3, N'iif(NOT owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (80, 3, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (81, 3, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (82, 3, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (83, 25, 6, N'iif(document.OverSpent < 0 OR NOT owner.IsSimple, true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (84, 25, 8, N'iif(document.OverSpent > 0 OR owner.IsSimple, true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (85, 8, 6, N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (86, 3, 25, N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (87, 8, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (88, 8, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (89, 8, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (90, 2, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (91, 2, 6, N'iif(owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (92, 2, 3, N'iif(NOT owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (93, 2, 2, N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (94, 1, 2, N'iif(owner.FlagOne AND action.Equals("Создать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (95, 1, 3, N'iif(owner.FlagOne AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (96, 2, 4, N'iif(owner.FlagOne AND action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (97, 2, 3, N'iif(owner.FlagOne AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (98, 2, 2, N'iif(owner.FlagOne AND action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (99, 5, 2, N'iif(owner.FlagOne AND action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (100, 5, 4, N'iif(owner.FlagOne AND action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (101, 5, 3, N'iif(owner.FlagOne AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (102, 3, 30, N'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (103, 3, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (104, 3, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (105, 3, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (106, 30, 8, N'iif(owner.FlagOne AND document.Check2NdLevel(), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (107, 30, 31, N'iif(owner.FlagOne AND document.Check2NdLevel(), false, true)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (108, 8, 31, N'iif(NOT document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (109, 8, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (110, 8, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (111, 8, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (112, 31, 32, N'iif(owner.FlagOne AND document.CheckOtherCosts(), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (113, 31, 28, N'iif(owner.FlagOne AND document.CheckOtherCosts(), false, true)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (114, 32, 12, N'iif(owner.FlagOne AND document.CheckHwoIs(owner), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (115, 32, 26, N'iif(owner.FlagOne AND document.CheckHwoIs(owner), false, true)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (116, 12, 28, N'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (117, 12, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (118, 12, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (119, 12, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (120, 26, 28, N'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (121, 26, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (122, 26, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (123, 26, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (124, 28, 29, N'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(true)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (125, 28, 8, N'iif(owner.FlagOne AND action.Equals("Дополнительное согласование", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(true)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (126, 28, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (127, 8, 27, N'iif(document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (131, 27, 29, N'iif(document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (132, 27, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (133, 27, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (134, 27, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (135, 29, 6, N'iif(document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (136, 29, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (137, 29, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (138, 29, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (139, 1, 2, N'iif(owner.FlagOne AND action.Equals("Создать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateCost()', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (140, 1, 3, N'iif(owner.FlagOne AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateCost()', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (141, 2, 4, N'iif(owner.FlagOne AND action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (142, 2, 3, N'iif(owner.FlagOne AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (143, 2, 2, N'iif(owner.FlagOne AND action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateCost()', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (144, 5, 2, N'iif(owner.FlagOne AND action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (145, 5, 4, N'iif(owner.FlagOne AND action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (146, 5, 3, N'iif(owner.FlagOne AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (147, 3, 30, N'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (148, 3, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (149, 3, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (150, 3, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (151, 30, 8, N'iif(owner.FlagOne AND document.Check2NdLevel(), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (152, 30, 31, N'iif(owner.FlagOne AND document.Check2NdLevel(), false, true)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (153, 8, 31, N'iif(NOT document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (154, 8, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (155, 8, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (156, 8, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (157, 31, 32, N'iif(owner.FlagOne AND document.CheckOtherCosts(), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (158, 31, 28, N'iif(owner.FlagOne AND document.CheckOtherCosts(), false, true)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (159, 32, 12, N'iif(owner.FlagOne AND document.CheckHwoIs(), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (160, 32, 26, N'iif(owner.FlagOne AND document.CheckHwoIs(), false, true)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (161, 12, 19, N'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (162, 12, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (163, 12, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (164, 12, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (165, 26, 19, N'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (166, 19, 28, N'iif(owner.FlagOne AND action.Equals("Empty") AND document.RoCheck(tokens), false, true)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (167, 19, 9, N'iif(owner.FlagOne AND action.Equals("Empty") AND document.RoCheck(tokens), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (168, 9, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (169, 9, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 1)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (170, 9, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (171, 9, 19, N'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateCost(actor)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (172, 26, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (173, 26, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (174, 26, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (175, 28, 29, N'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(true)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (176, 28, 8, N'iif(owner.FlagOne AND action.Equals("Дополнительное согласование", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(true)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (177, 28, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (178, 8, 27, N'iif(document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (182, 27, 29, N'iif(document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (183, 27, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (184, 27, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (185, 27, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (186, 29, 6, N'iif(document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (187, 29, 5, N'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (188, 29, 4, N'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (189, 29, 2, N'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 5, N'document.UpdateFlagAccountant(false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (190, 5, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (191, 5, 2, N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (192, 5, 3, N'iif(NOT owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (193, 5, 12, N'iif(owner.IsFirstLevel AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', N'B.03.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (194, 7, 6, N'action=="Снять пометку об оплате"', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (195, 6, 7, N'action=="Оплатить"', 1, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (196, 1, 2, N'iif(action.Equals("Создать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (197, 1, 3, N'iif(action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (198, 2, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (199, 2, 3, N'iif(action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (200, 2, 2, N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (201, 3, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (202, 3, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (203, 3, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (204, 5, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (205, 5, 5, N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (206, 5, 3, N'iif(action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (207, 3, 6, N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (208, 12, 20, N'iif(NOT owner.IsFirstLevel AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
SET IDENTITY_INSERT [valeant].[settings] ON 

GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (1, N'ServiceTelephoneNumber', N'+7(495) 523-9847 +7(495) 523-9848', N'Телефоны службы поддержки')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (2, N'ServiceEmal', N'service.it@valeant.eu', N'Электронный адрес службы поддержки')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (3, N'SmtpAddress', N'127.0.0.1', N'Адрес smtp сервера')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (4, N'SmtpSenderAddress', N'vladimir.kovalev.mail@gmail.com', N'Адрес робота')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (7, N'SmtpSenderDisplayName', N'Uprs service', N'Читаемое имя робота')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (8, N'SmtpAccountName', N'free', N'Учетка smtp')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (9, N'SmtpPassword', N'pass', N'Пароль smtp')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (10, N'SmtpPort', N'25', N'Smtp порт')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (12, N'SmtpNotification', N'0', N'Отправлять ли уведомления')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (13, N'Storage', N'c:\Valeant\Storage', N'Место хранения файлов')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (15, N'StorageItemCount', N'1000', N'Максимальное число файлов в подпапке')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (16, N'commercial_department_code', N'01-000000030', N'Код коммерческого департамента')
GO
INSERT [valeant].[settings] ([id], [name], [value], [description]) VALUES (17, N'commercial_department_cost_max', N'3000.00', N'')
GO
SET IDENTITY_INSERT [valeant].[settings] OFF
GO
/****** Object:  StoredProcedure [valeant].[readparentdepartments]    Script Date: 6/16/2016 3:54:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[readparentdepartments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [valeant].[readparentdepartments] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [valeant].[readparentdepartments] 
	@code NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	WITH departments([parent], [Code], [level]) AS
	(
		SELECT [parent], [Code], 1 FROM [valeant].[department] WHERE Code = @code
		UNION ALL
		SELECT [d].[parent], [d].[Code], [d1].[level] + 1  FROM [valeant].[department] [d]
		INNER JOIN departments AS [d1] ON [d].[id] = [d1].[Parent]
	)
	SELECT [Code], [level] FROM departments ORDER BY [level] desc;
END

GO
