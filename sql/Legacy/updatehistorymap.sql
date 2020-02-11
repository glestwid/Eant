USE [Valeant]
GO
/****** Object:  Index [PK_historymap]    Script Date: 14.04.2016 16:06:56 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[valeant].[historymap]') AND name = N'PK_historymap')
ALTER TABLE [valeant].[historymap] DROP CONSTRAINT [PK_historymap]
GO
/****** Object:  Table [valeant].[historymap]    Script Date: 14.04.2016 16:06:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[historymap]') AND type in (N'U'))
DROP TABLE [valeant].[historymap]
GO
/****** Object:  Table [valeant].[historymap]    Script Date: 14.04.2016 16:06:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[historymap]') AND type in (N'U'))
BEGIN
CREATE TABLE [valeant].[historymap](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[actionid] [bigint] NOT NULL,
	[documentid] [bigint] NOT NULL,
	[history] [nvarchar](1024) NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [PK_historymap]    Script Date: 14.04.2016 16:06:56 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[valeant].[historymap]') AND name = N'PK_historymap')
ALTER TABLE [valeant].[historymap] ADD  CONSTRAINT [PK_historymap] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET IDENTITY_INSERT [valeant].[historymap] ON 

GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (1, 1, 1, N'Заявка на аванс была аннулирована')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (2, 2, 1, N'Заявка на аванс была отправлена на утверждение')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (3, 3, 1, N'Заявка на аванс была отправлена на на доработку')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (4, 4, 1, N'Заявка на аванс не была согласована')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (5, 5, 1, N'Заявка на аванс согласована')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (6, 6, 1, N'Заявка на аванс была отозвана')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (7, 7, 1, N'Заявка на аванс была отредактирована')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (8, 11, 1, N'Заявка на аванс была создана')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (9, 1, 2, N'Заявка на Заявка на командировку/служебную поездку была аннулирована')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (10, 2, 2, N'Заявка на Заявка на командировку/служебную поездку была отправлена на утверждение')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (11, 3, 2, N'Заявка на Заявка на командировку/служебную поездку была отправлена на на доработку')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (12, 4, 2, N'Заявка на Заявка на командировку/служебную поездку не была согласована')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (13, 5, 2, N'Заявка на Заявка на командировку/служебную поездку согласована')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (14, 6, 2, N'Заявка на Заявка на командировку/служебную поездку была отозвана')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (15, 7, 2, N'Заявка на Заявка на командировку/служебную поездку была отредактирована')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (16, 11, 2, N'Заявка на Заявка на командировку/служебную поездку была создана')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (17, 12, 2, N'Заявка на Заявка на командировку/служебную поездку была закрыта')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (18, 13, 2, N'Заявка на Заявка на командировку/служебную поездку была заменена')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (19, 1, 3, N'Маршрутный лист был аннулирован')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (20, 2, 3, N'Маршрутный лист был отправлен на утверждение')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (21, 3, 3, N'Маршрутный лист был отправлен на на доработку')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (22, 4, 3, N'Маршрутный лист не был согласован')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (23, 5, 3, N'Маршрутный лист согласован')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (24, 6, 3, N'Маршрутный лист был отозван')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (25, 7, 3, N'Маршрутный лист был отредактирован')
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history]) VALUES (38, 11, 3, N'Маршрутный лист был создан')
GO
SET IDENTITY_INSERT [valeant].[historymap] OFF
GO
