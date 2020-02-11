USE [valeant]
GO
/****** Object:  Table [valeant].[states_version_3]    Script Date: 14.04.2016 0:06:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[states_version_3]') AND type in (N'U'))
DROP TABLE [valeant].[states_version_3]
GO
/****** Object:  Table [valeant].[node_properties_version_3]    Script Date: 14.04.2016 0:06:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[node_properties_version_3]') AND type in (N'U'))
DROP TABLE [valeant].[node_properties_version_3]
GO
/****** Object:  Table [valeant].[matrix_version_3]    Script Date: 14.04.2016 0:06:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[matrix_version_3]') AND type in (N'U'))
DROP TABLE [valeant].[matrix_version_3]
GO
/****** Object:  Table [valeant].[documenttype]    Script Date: 14.04.2016 0:06:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documenttype]') AND type in (N'U'))
DROP TABLE [valeant].[documenttype]
GO
/****** Object:  Table [valeant].[documentblock_version_2]    Script Date: 14.04.2016 0:06:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documentblock_version_2]') AND type in (N'U'))
DROP TABLE [valeant].[documentblock_version_2]
GO
/****** Object:  Table [valeant].[documentblock_accesstype_version_2]    Script Date: 14.04.2016 0:06:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documentblock_accesstype_version_2]') AND type in (N'U'))
DROP TABLE [valeant].[documentblock_accesstype_version_2]
GO
/****** Object:  Table [valeant].[documentblock_accesslist_version_2]    Script Date: 14.04.2016 0:06:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documentblock_accesslist_version_2]') AND type in (N'U'))
DROP TABLE [valeant].[documentblock_accesslist_version_2]
GO
/****** Object:  Table [valeant].[documentblock_accesslist_details_version_2]    Script Date: 14.04.2016 0:06:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documentblock_accesslist_details_version_2]') AND type in (N'U'))
DROP TABLE [valeant].[documentblock_accesslist_details_version_2]
GO
/****** Object:  Table [valeant].[documentblock_accesslist_details_version_2]    Script Date: 14.04.2016 0:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documentblock_accesslist_details_version_2]') AND type in (N'U'))
BEGIN
CREATE TABLE [valeant].[documentblock_accesslist_details_version_2](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[accesslist] [bigint] NOT NULL,
	[block] [bigint] NOT NULL,
	[access] [bigint] NOT NULL,
 CONSTRAINT [PK_accesslist_details_version_2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [valeant].[documentblock_accesslist_version_2]    Script Date: 14.04.2016 0:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documentblock_accesslist_version_2]') AND type in (N'U'))
BEGIN
CREATE TABLE [valeant].[documentblock_accesslist_version_2](
	[id] [bigint] NOT NULL,
	[documenttype] [bigint] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_documentblock_accesslist_version_2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [valeant].[documentblock_accesstype_version_2]    Script Date: 14.04.2016 0:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documentblock_accesstype_version_2]') AND type in (N'U'))
BEGIN
CREATE TABLE [valeant].[documentblock_accesstype_version_2](
	[id] [bigint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_documentblock_accesstype_version_2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [valeant].[documentblock_version_2]    Script Date: 14.04.2016 0:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documentblock_version_2]') AND type in (N'U'))
BEGIN
CREATE TABLE [valeant].[documentblock_version_2](
	[id] [bigint] NOT NULL,
	[block] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_documentblock] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [valeant].[documenttype]    Script Date: 14.04.2016 0:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documenttype]') AND type in (N'U'))
BEGIN
CREATE TABLE [valeant].[documenttype](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_documenttype] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [valeant].[matrix_version_3]    Script Date: 14.04.2016 0:06:06 ******/
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
/****** Object:  Table [valeant].[node_properties_version_3]    Script Date: 14.04.2016 0:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[node_properties_version_3]') AND type in (N'U'))
BEGIN
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
END
GO
/****** Object:  Table [valeant].[states_version_3]    Script Date: 14.04.2016 0:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[states_version_3]') AND type in (N'U'))
BEGIN
CREATE TABLE [valeant].[states_version_3](
	[id] [bigint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[approvalsheettitle] [nvarchar](255) NULL,
 CONSTRAINT [PK_states_version_3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] ON 

GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (1, 1, 1, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (2, 2, 1, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (3, 3, 2, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (4, 3, 3, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (5, 3, 4, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (6, 3, 5, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (7, 3, 6, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (8, 4, 2, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (10, 4, 3, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (11, 4, 4, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (12, 4, 5, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (13, 4, 6, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (14, 5, 2, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (15, 5, 3, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (16, 5, 4, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (17, 5, 5, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (18, 5, 6, 3)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (19, 6, 2, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (20, 6, 3, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (21, 6, 4, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (22, 6, 5, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (23, 6, 6, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (24, 7, 2, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (25, 7, 3, 3)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (26, 7, 4, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (27, 7, 5, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (28, 7, 6, 3)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (29, 8, 2, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (30, 8, 3, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (31, 8, 4, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (32, 8, 5, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (33, 8, 6, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (39, 3, 7, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (40, 3, 8, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (41, 3, 9, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (42, 4, 7, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (43, 4, 8, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (44, 4, 9, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (45, 5, 7, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (46, 5, 8, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (47, 5, 9, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (48, 6, 7, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (49, 6, 8, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (50, 6, 9, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (51, 7, 7, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (52, 7, 8, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (53, 7, 9, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (54, 8, 7, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (55, 8, 8, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (56, 8, 9, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (60, 9, 2, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (61, 9, 3, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (62, 9, 4, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (63, 9, 5, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (64, 9, 6, 2)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (65, 9, 7, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (66, 9, 8, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (67, 9, 9, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (68, 10, 10, 1)
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (69, 11, 10, 2)
GO
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] OFF
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (1, 1, N'allview', N'полный просмотр')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (2, 1, N'alledit', N'полное редактирование')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (3, 2, N'allview', N'полный просмотр')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (4, 2, N'alledit', N'полное редактирование')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (5, 2, N'allview_trip', N'полный просмотр без поля tr координатора')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (6, 2, N'tredit_trip', N'редактирование для tr координатора')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (7, 2, N'owneredit', N'редактирование для создателя заявки')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (8, 2, N'hrapplove', N'Утверждение HR')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (9, 2, N'trapplove', N'Утверждение TR')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (10, 3, N'allview', N'полный просмотр маршрутного листа')
GO
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (11, 3, N'alledit', N'полное редактирование маршрутного листа')
GO
INSERT [valeant].[documentblock_accesstype_version_2] ([id], [name], [description]) VALUES (1, N'View', N'Просмотр')
GO
INSERT [valeant].[documentblock_accesstype_version_2] ([id], [name], [description]) VALUES (2, N'Edit', N'Редактирование')
GO
INSERT [valeant].[documentblock_accesstype_version_2] ([id], [name], [description]) VALUES (3, N'Hide', N'Скрыть')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (1, N'cost')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (2, N'formHeader')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (3, N'order')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (4, N'destinationsData')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (5, N'dailyCostsData')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (6, N'travelCoordinator')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (7, N'hotelRequestsData')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (8, N'trasferRequestsData')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (9, N'ticketRequestsData')
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (10, N'travelList')
GO
SET IDENTITY_INSERT [valeant].[documenttype] ON 

GO
INSERT [valeant].[documenttype] ([Id], [Value]) VALUES (1, N'Заявка на аванс')
GO
INSERT [valeant].[documenttype] ([Id], [Value]) VALUES (2, N'Заявка на командировку/служебную поездку')
GO
INSERT [valeant].[documenttype] ([Id], [Value]) VALUES (3, N'Маршрутный лист')
GO
SET IDENTITY_INSERT [valeant].[documenttype] OFF
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
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (31, 1, 20, N'iif(owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (32, 20, 13, N'iif(action.Equals("Empty", StringComparison.InvariantCultureIgnoreCase) AND document.MainData.TripType.Name.Equals("Командировка", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, N'ABC.05.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (33, 20, 14, N'iif(action.Equals("Empty", StringComparison.InvariantCultureIgnoreCase) AND document.MainData.TripType.Name.Equals("Командировка", StringComparison.InvariantCultureIgnoreCase), false, true)', 2, NULL, N'ABC.06.00.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (34, 2, 20, N'iif(owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (35, 13, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (36, 13, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (37, 13, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (38, 14, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (39, 14, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (40, 14, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (41, 5, 20, N'iif(owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (42, 13, 14, N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, N'ABC.06.01.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (43, 14, 16, N'iif(owner.IsCeo AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = true)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (44, 16, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (45, 2, 12, N'iif(owner.IsFirstLevel AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', N'B.03.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (46, 12, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (47, 12, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (48, 12, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (49, 5, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (50, 12, 20, N'iif(owner.IsFirstLevel AND NOT document.FlagTravelCoordinator  AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (51, 14, 21, N'iif(NOT owner.IsCeo AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = true)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (52, 21, 12, N'iif(owner.IsFirstLevel AND document.ScanPdfsData.Options.OverLimit, true, false)', 2, NULL, N'B.08.00.01', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (53, 21, 16, N'iif(NOT owner.IsCeo AND document.ScanPdfsData.Options.OverLimit, false, true)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (54, 12, 16, N'iif(owner.IsFirstLevel AND document.FlagTravelCoordinator  AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (55, 1, 12, N'iif(owner.IsFirstLevel AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', N'B.04.00.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (56, 5, 5, N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (57, 2, 3, N'iif(owner.IsSimple AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', N'A.01.01.00', 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (58, 3, 5, N'iif(owner.IsSimple AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (59, 3, 2, N'iif(owner.IsSimple AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (60, 3, 4, N'iif(owner.IsSimple AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', NULL, 0)
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (61, 5, 3, N'iif(owner.IsSimple AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'(document.FlagTravelCoordinator = false)', N'A.01.02.00', 0)
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
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (1, 1, 1, 2, NULL, N'Отправить, Сохранить', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (2, 1, 1, 7, NULL, N'Отправить, Сохранить', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (3, 2, 1, 2, NULL, N'Аннулировать,Отправить,Сохранить', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (4, 2, 1, 7, NULL, N'Аннулировать,Отправить,Сохранить', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (5, 4, 1, 1, NULL, N'Empty', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (6, 4, 1, 5, NULL, N'Empty', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (7, 3, 1, 1, NULL, N'Отозвать', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (8, 3, 1, 5, NULL, N'Отозвать', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (9, 3, 2, 1, NULL, N'Согласовать, Отказать, На доработку', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (10, 3, 2, 5, NULL, N'Согласовать, Отказать, На доработку', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (11, 5, 1, 2, NULL, N'Аннулировать,Отправить,Сохранить', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (12, 5, 1, 7, NULL, N'Аннулировать,Отправить,Сохранить', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (13, 18, 8, 1, NULL, N'Empty', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (14, 19, 8, 1, NULL, N'Empty', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (15, 19, 9, 1, NULL, N'Empty', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (16, 8, 3, 1, NULL, N'Согласовать, Отказать, На доработку', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (17, 8, 3, 5, NULL, N'Согласовать, Отказать, На доработку', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (18, 8, 1, 1, NULL, N'Отозвать', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (19, 8, 1, 5, NULL, N'Отозвать', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (20, 9, 9, 1, NULL, N'Согласовать, Отказать, На доработку', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (21, 9, 1, 1, NULL, N'Отозвать', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (22, 6, 1, 1, NULL, N'Печать', 1)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (23, 20, 8, 5, NULL, N'Empty', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (24, 16, 1, 5, NULL, N'Аннулировать', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (25, 13, 6, 8, NULL, N'Согласовать, Отказать, На доработку', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (26, 13, 1, 5, NULL, N'Отозвать', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (27, 14, 7, 9, NULL, N'Согласовать, Отказать, На доработку', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (28, 14, 1, 5, NULL, N'Отозвать', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (29, 12, 4, 3, NULL, N'Согласовать, Отказать, На доработку', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (30, 12, 1, 5, NULL, N'Отозвать', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (31, 21, 8, 3, NULL, N'Empty', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (32, 22, 8, 3, NULL, N'Empty', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (33, 23, 5, 5, NULL, N'Согласовать, Отказать, На доработку', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (34, 23, 1, 5, NULL, N'Отозвать', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (35, 24, 8, 3, NULL, N'Empty', 2)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (36, 25, 8, 10, NULL, N'Empty', 3)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (37, 6, 1, 10, NULL, N'Empty', 3)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (38, 3, 1, 10, NULL, N'Отозвать', 3)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (39, 3, 2, 10, NULL, N'Согласовать, Отказать, На доработку', 3)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (40, 4, 1, 10, NULL, N'Empty', 3)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (41, 5, 1, 11, NULL, N'Аннулировать,Отправить,Сохранить', 3)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (42, 2, 1, 11, NULL, N'Аннулировать,Отправить,Сохранить', 3)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (43, 8, 3, 10, NULL, N'Согласовать, Отказать, На доработку', 3)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (44, 8, 1, 10, NULL, N'Отозвать', 3)
GO
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (45, 1, 1, 11, NULL, N'Отправить', 3)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (1, N'В разработке', N'InDeveloping', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (2, N'Черновик', N'Created', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (3, N'На согласовании (Непосредственный руководитель)', N'PendingApproval1stLevel', N'Непосредственный руководитель')
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (4, N'Аннулирована', N'Cancelled', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (5, N'На доработке', N'RequiresModification', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (6, N'Утверждена', N'Pending', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (7, N'Оплачена', N'Paid', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (8, N'На согласовании (Руководитель 2-го уровня)', N'PendingApproval2ndLevel', N'Руководитель 2-го уровня')
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (9, N'На согласовании (Ответственный за статью расхода)', N'PendingApprovalResponsibleOfficer', N'Ответственный за статью расхода')
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (10, N'Отозван', N'Withdrawn', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (12, N'На согласовании (Ген. директор)', N'PendingApprovalCEO', N'Генеральный директор')
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (13, N'На согласовании (HR сотр.)', N'PendingApprovalHR', N'Сотрудник HR')
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (14, N'На согласовании (Трэвел координатор)', N'PendingApprovalTravel', N'Трэвел координатор')
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (15, N'Заменена', N'Replace', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (16, N'Ожидает авансового отчета', N'PendingAdvanceStatement', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (17, N'Закрыта', N'Close', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (18, N'Проверка лимита', N'CheckLimit', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (19, N'Проверка статей расхода', N'CheckCost', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (20, N'Проверка типа поезки', N'TripTypeCheck', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (21, N'Проверка лимита (Travel коорд.)', N'TripCheckLimit', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (22, N'Проверка даты начала командировки', N'FirstDateCheck', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (23, N'На согласовании (Директор департамента)', N'PendingApprovalFirstLevel', N'Директор департамента')
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (24, N'Проверка страны', N'CheckCity', NULL)
GO
INSERT [valeant].[states_version_3] ([id], [name], [title], [approvalsheettitle]) VALUES (25, N'Проверка превышения лимита топлива', N'CheckOverSpent', NULL)
GO
