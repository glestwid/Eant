USE [valeant]
GO
/****** Object:  Table [valeant].[documentblock_accesslist_details_version_2]    Script Date: 4/12/2016 9:01:26 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[valeant].[documentblock_accesslist_details_version_2]') AND type in (N'U'))
DROP TABLE [valeant].[documentblock_accesslist_details_version_2]
GO
/****** Object:  Table [valeant].[documentblock_accesslist_details_version_2]    Script Date: 4/12/2016 9:01:26 AM ******/
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
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] OFF
GO
