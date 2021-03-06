--access lists
/*
1	полный просмотр заявки на аванс
2	полное редактирование заявки на аванс
3	полный просмотр заявки на командировку
7	редактирование для создателя заявки на командировку
*/

--nodes
/*
1	В разработке
2	Черновик
3	На согласовании (1st рук.)
4	Аннулирована
5	На доработке
6	Утверждена
7	Оплачена
8	На согласовании (2nd рук.)
9	На согласовании (О.С.)
10	Отозван
11	На согласовании (Ген. директор)
12	На согласовании (HR сотр.)
13	На согласовании (Travel коорд.)
14	Заменена
15	Ожидает авансового отчета
16	Закрыта
*/

--actions
/*
id	name
1	Аннулировать
2	Отправить
3	На доработку
4	Отказать
5	Согласовать
6	Отозвать
7	Редактировать
8	Просмотр
9	История
10	Создать
11	Закрыть
12	Заменить
*/

--типы
/*
1	Заявка на аванс
2	Заявка на командировку/служебную поездку
*/
USE [Valeant]
GO
/****** Object:  Table [valeant].[nodetype_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
DROP TABLE [valeant].[nodetype_version_2]
GO
/****** Object:  Table [valeant].[nodeclosureaccesslist_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
DROP TABLE [valeant].[nodeclosureaccesslist_version_2]
GO
/****** Object:  Table [valeant].[nodeclosure_valeant_2]    Script Date: 3/25/2016 5:16:13 PM ******/
DROP TABLE [valeant].[nodeclosure_valeant_2]
GO
/****** Object:  Table [valeant].[node_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
DROP TABLE [valeant].[node_version_2]
GO
/****** Object:  Table [valeant].[documentblock_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
DROP TABLE [valeant].[documentblock_version_2]
GO
/****** Object:  Table [valeant].[documentblock_accesstype_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
DROP TABLE [valeant].[documentblock_accesstype_version_2]
GO
/****** Object:  Table [valeant].[documentblock_accesslist_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
DROP TABLE [valeant].[documentblock_accesslist_version_2]
GO
/****** Object:  Table [valeant].[documentblock_accesslist_details_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
DROP TABLE [valeant].[documentblock_accesslist_details_version_2]
GO
/****** Object:  Table [valeant].[documentblock_accesslist_details_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GO
/****** Object:  Table [valeant].[documentblock_accesslist_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GO
/****** Object:  Table [valeant].[documentblock_accesstype_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[documentblock_accesstype_version_2](
	[id] [bigint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_documentblock_accesstype_version_2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[documentblock_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[documentblock_version_2](
	[id] [bigint] NOT NULL,
	[block] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_documentblock] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[node_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[node_version_2](
	[id] [bigint] NOT NULL,
	[type] [int] NOT NULL,
	[id2] [bigint] NULL,
	[description] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_node] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[nodeclosure_valeant_2]    Script Date: 3/25/2016 5:16:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[nodeclosure_valeant_2](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[ancestor] [bigint] NULL,
	[descendant] [bigint] NULL,
	[action] [bigint] NULL,
	[value] [int] NULL,
	[type] [bigint] NOT NULL,
	[straight] [bit] NOT NULL,
	[notification] [bigint] NULL,
 CONSTRAINT [PK_nodeclosure_valeant_2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[nodeclosureaccesslist_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[nodeclosureaccesslist_version_2](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[nodeclosure] [bigint] NOT NULL,
	[token] [nvarchar](15) NOT NULL,
	[blockaccesslist] [bigint] NULL,
 CONSTRAINT [PK_nodeclosureaccesslist_version_2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[nodetype_version_2]    Script Date: 3/25/2016 5:16:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[nodetype_version_2](
	[id] [bigint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_nodetype_version_2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] ON 

INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (1,  1, 1, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (2,  2, 1, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (3,  3, 2, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (4,  3, 3, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (5,  3, 4, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (6,  3, 5, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (7,  3, 6, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (39, 3, 7, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (40, 3, 8, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (41, 3, 9, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (69, 3, 10, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (8,  4, 2, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (10, 4, 3, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (11, 4, 4, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (12, 4, 5, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (13, 4, 6, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (42, 4, 7, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (43, 4, 8, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (44, 4, 9, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (14, 5, 2, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (15, 5, 3, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (16, 5, 4, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (17, 5, 5, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (18, 5, 6, 3)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (45, 5, 7, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (46, 5, 8, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (47, 5, 9, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (19, 6, 2, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (20, 6, 3, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (21, 6, 4, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (22, 6, 5, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (23, 6, 6, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (48, 6, 7, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (49, 6, 8, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (50, 6, 9, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (24, 7, 2, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (25, 7, 3, 3)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (26, 7, 4, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (27, 7, 5, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (28, 7, 6, 3)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (51, 7, 7, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (52, 7, 8, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (53, 7, 9, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (29, 8, 2, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (30, 8, 3, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (31, 8, 4, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (32, 8, 5, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (33, 8, 6, 3)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (54, 8, 7, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (55, 8, 8, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (56, 8, 9, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (70, 8, 10, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (34, 9, 2, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (35, 9, 3, 3)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (36, 9, 4, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (37, 9, 5, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (38, 9, 6, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (57, 9, 7, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (58, 9, 8, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (59, 9, 9, 2)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (60, 10, 6, 3)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (61, 10, 5, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (62, 10, 4, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (63, 10, 3, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (64, 10, 2, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (65, 10, 1, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (66, 10, 7, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (67, 10, 8, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (68, 10, 9, 1)


SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] OFF
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (1, 1, N'allview', N'полный просмотр')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (2, 1, N'alledit', N'полное редактирование')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (3, 2, N'allview', N'полный просмотр')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (4, 2, N'alledit', N'полное редактирование')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (5, 2, N'allview_trip', N'полный просмотр без поля tr координатора')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (6, 2, N'tredit_trip', N'редактирование для tr координатора')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (7, 2, N'owneredit', N'редактирование для создателя заявки')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (8, 2, N'hrapplove', N'Утверждение HR')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (9, 2, N'trapplove', N'Утверждение TR')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (10, 2, N'initiator_revoke', N'Отзыв заявки инициатором')
INSERT [valeant].[documentblock_accesstype_version_2] ([id], [name], [description]) VALUES (1, N'View', N'Просмотр')
INSERT [valeant].[documentblock_accesstype_version_2] ([id], [name], [description]) VALUES (2, N'Edit', N'Редактирование')
INSERT [valeant].[documentblock_accesstype_version_2] ([id], [name], [description]) VALUES (3, N'Hide', N'Скрыть')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (1, N'cost')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (2, N'formHeader')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (3, N'order')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (4, N'destinationsData')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (5, N'dailyCostsData')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (6, N'travelCoordinator')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (7, N'hotelRequestsData')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (8, N'trasferRequestsData')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (9, N'ticketRequestsData')
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (10, N'scanPdfsData')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (1, 3, NULL, N'В разработке')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (2, 1, 1, N'Черновик')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (3, 1, 2, N'На согласовании (1st рук.)')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (4, 1, 3, N'Аннулирована')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (5, 1, 4, N'На доработке')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (6, 1, 5, N'Утверждена')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (7, 1, 6, N'Оплачена')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (8, 1, 7, N'На согласовании (2nd рук.)')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (9, 1, 8, N'На согласовании (О.С.)')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (10, 1, 9, N'Отозван')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (11, 1, 10, N'На согласовании (Ген. директор)')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (12, 1, 11, N'На согласовании (HR сотр.)')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (13, 1, 12, N'На согласовании (Travel коорд.)')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (14, 1, 13, N'Заменена')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (15, 1, 14, N'Ожидает авансового отчета')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (16, 1, 15, N'Закрыта')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (17, 2, 1, N'LimitCheker')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (18, 2, 2, N'ExpenditureCheker')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (19, 2, 3, N'IntervalMore14Days')
INSERT [valeant].[node_version_2] ([id], [type], [id2], [description]) VALUES (20, 2, 4, N'TravelCoordinatorLimitCheker')
SET IDENTITY_INSERT [valeant].[nodeclosure_valeant_2] ON 

INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (1, 1, 2, 10, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (2, 1, 3, 2, NULL, 1, 1, 1)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (3, 2, NULL, 8, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (4, 2, 2, 7, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (5, 2, NULL, 9, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (6, 2, 4, 1, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (7, 2, 3, 2, NULL, 1, 1, 1)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (8, 3, 2, 6, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (9, 3, NULL, 8, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (10, 3, NULL, 9, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (11, 3, 5, 3, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (12, 3, 4, 4, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (13, 3, 17, 5, NULL, 1, 0, 1)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (14, 5, NULL, 8, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (15, 5, NULL, 9, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (16, 5, 5, 7, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (17, 5, 4, 1, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (18, 5, 3, 2, NULL, 1, 1, 6)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (19, 17, 18, NULL, 0, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (20, 17, 8, NULL, 1, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (21, 8, 2, 6, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (22, 8, NULL, 8, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (23, 8, NULL, 9, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (24, 8, 5, 3, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (25, 8, 4, 4, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (26, 8, 18, 5, NULL, 1, 0, 1)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (27, 18, 9, NULL, 0, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (28, 18, 6, NULL, 1, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (29, 9, 2, 6, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (30, 9, NULL, 8, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (31, 9, NULL, 9, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (32, 9, 5, 3, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (33, 9, 4, 4, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (34, 9, 6, 5, NULL, 1, 0, 1)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (35, 6, NULL, 8, NULL, 1, 0, 9)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (36, 6, NULL, 9, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (37, 4, NULL, 8, NULL, 1, 0, 7)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (38, 4, NULL, 9, NULL, 1, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (39, 1, 2, 10, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (40, 1, 19, 2, NULL, 2, 1, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (41, 2, NULL, 8, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (42, 2, 2, 7, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (43, 2, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (44, 2, 4, 1, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (45, 2, 19, 2, NULL, 2, 1, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (46, 19, 11, NULL, 1, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (47, 19, 3, NULL, 0, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (48, 11, 2, 6, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (49, 11, NULL, 8, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (50, 11, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (51, 11, 5, 3, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (52, 11, 4, 4, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (53, 11, 3, 5, NULL, 2, 0, 3)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (54, 3, 2, 6, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (55, 3, NULL, 8, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (56, 3, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (57, 3, 5, 3, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (58, 3, 4, 4, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (59, 3, 12, 5, NULL, 2, 0, 3)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (60, 12, 2, 6, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (61, 12, NULL, 8, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (62, 12, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (63, 12, 5, 3, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (64, 12, 4, 4, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (65, 12, 13, 5, NULL, 2, 0, 3)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (66, 13, 2, 6, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (67, 13, NULL, 8, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (68, 13, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (69, 13, 5, 3, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (70, 13, 4, 4, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (71, 13, 20, 5, NULL, 2, 0, 3)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (72, 20, 8, NULL, 0, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (73, 20, 15, NULL, 1, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (74, 8, 2, 6, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (75, 8, NULL, 8, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (76, 8, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (77, 8, 5, 3, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (78, 8, 4, 4, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (79, 8, 15, 5, NULL, 2, 0, 3)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (80, 15, NULL, 8, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (81, 15, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (82, 8, 16, 11, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (83, 15, 4, 1, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (84, 4, NULL, 8, NULL, 2, 0, 5)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (85, 4, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (86, 16, NULL, 8, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (87, 16, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (88, 5, NULL, 8, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (89, 5, NULL, 9, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (90, 5, 5, 7, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (91, 5, 4, 1, NULL, 2, 0, NULL)
INSERT [valeant].[nodeclosure_valeant_2] ([id], [ancestor], [descendant], [action], [value], [type], [straight], [notification]) VALUES (92, 5, 19, 2, NULL, 2, 1, 4)
SET IDENTITY_INSERT [valeant].[nodeclosure_valeant_2] OFF
SET IDENTITY_INSERT [valeant].[nodeclosureaccesslist_version_2] ON 

INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (1, 1, N'O*', 2)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (2, 2, N'O*', 2)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (3, 3, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (4, 4, N'O*', 2)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (5, 5, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (6, 6, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (7, 7, N'O*', 2)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (8, 8, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (9, 9, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (10, 9, N'M1*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (11, 10, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (12, 10, N'M1*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (13, 11, N'M1*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (14, 12, N'M1*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (15, 13, N'M1*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (16, 14, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (17, 15, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (18, 16, N'O*', 2)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (19, 17, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (20, 18, N'O*', 2)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (21, 19, N'SYSTEM', NULL)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (22, 20, N'SYSTEM', NULL)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (23, 21, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (24, 22, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (25, 22, N'M2*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (26, 23, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (27, 23, N'M2*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (28, 24, N'M2*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (29, 25, N'M2*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (30, 26, N'M2*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (31, 27, N'SYSTEM', NULL)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (32, 28, N'SYSTEM', NULL)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (33, 29, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (34, 30, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (35, 30, N'R', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (36, 31, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (37, 31, N'R', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (38, 32, N'R', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (39, 33, N'R', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (40, 34, N'R', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (41, 35, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (42, 36, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (43, 37, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (44, 38, N'O*', 1)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (45, 39, N'O*', 7)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (46, 40, N'O*', 7)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (47, 41, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (48, 42, N'O*', 7)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (49, 43, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (50, 44, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (51, 45, N'O*', 7)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (52, 46, N'SYSTEM', NULL)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (53, 47, N'SYSTEM', NULL)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (54, 48, N'O*', 10)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (55, 49, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (56, 49, N'G-00000001', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (57, 50, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (58, 50, N'G-00000001', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (59, 51, N'G-00000001', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (60, 52, N'G-00000001', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (61, 53, N'G-00000001', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (62, 54, N'O*', 10)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (63, 55, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (64, 55, N'M1*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (65, 56, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (66, 56, N'M1*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (67, 57, N'M1*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (68, 58, N'M1*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (69, 59, N'M1*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (70, 60, N'O*', 10)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (71, 61, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (72, 61, N'R-00000003', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (73, 62, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (74, 62, N'R-00000003', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (75, 63, N'R-00000003', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (76, 64, N'R-00000003', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (77, 65, N'R-00000003', 8)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (78, 66, N'O*', 10)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (79, 67, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (80, 67, N'R-00000004', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (81, 68, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (82, 68, N'R-00000004', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (83, 69, N'R-00000004', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (84, 70, N'R-00000004', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (85, 71, N'R-00000004', 9)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (86, 72, N'SYSTEM', NULL)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (87, 73, N'SYSTEM', NULL)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (88, 74, N'O*', 10)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (89, 75, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (90, 75, N'M2*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (91, 76, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (92, 76, N'M2*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (93, 77, N'M2*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (94, 78, N'M2*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (95, 79, N'M2*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (96, 80, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (97, 81, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (98, 82, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (99, 83, N'O*', 3)
GO
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (100, 84, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (101, 85, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (102, 86, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (103, 87, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (104, 88, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (105, 89, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (106, 90, N'O*', 7)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (107, 91, N'O*', 3)
INSERT [valeant].[nodeclosureaccesslist_version_2] ([id], [nodeclosure], [token], [blockaccesslist]) VALUES (108, 92, N'O*', 7)
SET IDENTITY_INSERT [valeant].[nodeclosureaccesslist_version_2] OFF
INSERT [valeant].[nodetype_version_2] ([id], [name]) VALUES (1, N'state')
INSERT [valeant].[nodetype_version_2] ([id], [name]) VALUES (2, N'selector')
INSERT [valeant].[nodetype_version_2] ([id], [name]) VALUES (3, N'Root')
go
