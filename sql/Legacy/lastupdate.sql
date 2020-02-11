USE [valeant]
GO
/****** Object:  Table [valeant].[documenttype]    Script Date: 17.04.2016 18:14:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[documenttype](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_documenttype] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[historymap]    Script Date: 17.04.2016 18:14:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[historymap](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[actionid] [bigint] NOT NULL,
	[documentid] [bigint] NOT NULL,
	[history] [nvarchar](1024) NOT NULL,
	[inreport] [bit] NOT NULL CONSTRAINT [DF_historymap_ineport]  DEFAULT ((0)),
 CONSTRAINT [PK_historymap] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[human]    Script Date: 17.04.2016 18:14:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[human](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [valeant].[Code] NOT NULL,
	[FullName] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](320) NULL,
	[DocumentSeries] [nvarchar](10) NOT NULL,
	[DocumentNumber] [nvarchar](20) NOT NULL,
	[DocumentIssuedOn] [datetime] NOT NULL,
	[DocumentIssuedBy] [nvarchar](255) NOT NULL,
	[NumberInternationalPassport] [nvarchar](20) NULL,
	[Tel] [nvarchar](16) NULL,
	[ValidityInternationalPassport] [datetime] NULL,
	[UserAccount] [nvarchar](255) NULL,
	[AssistantId] [bigint] NULL,
	[DeputyId] [bigint] NULL,
	[DeputyDateStart] [datetimeoffset](7) NULL,
	[DeputyDateEnd] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_human] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[matrix_version_3]    Script Date: 17.04.2016 18:14:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GO
/****** Object:  Table [valeant].[node_properties_version_3]    Script Date: 17.04.2016 18:14:51 ******/
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
/****** Object:  Table [valeant].[states_version_3]    Script Date: 17.04.2016 18:14:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GO
/****** Object:  Table [valeant].[tokens_version_3]    Script Date: 17.04.2016 18:14:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[tokens_version_3](
	[id] [bigint] NOT NULL,
	[value] [nvarchar](24) NOT NULL,
	[calc] [bit] NOT NULL CONSTRAINT [DF_tokens_version_3_calc]  DEFAULT ((0)),
	[export] [bit] NOT NULL CONSTRAINT [DF_tokens_version_3_export]  DEFAULT ((0))
) ON [PRIMARY]

GO
/****** Object:  StoredProcedure [valeant].[readapprovedhistory_version_3]    Script Date: 17.04.2016 18:14:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readapprovedhistory_version_3]
	@id bigint,
	@document nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @documenttype bigint
	SELECT @documenttype = [Id] FROM [valeant].[documenttype] WHERE [Value] = @document
	SELECT [hi].[id], [hi].[number], [hi].[date], [h].[fullname] FROM [valeant].[advancehistory] [hi]
	INNER JOIN [valeant].[human] [h] ON [h].[id] = [hi].[Creator]
	INNER JOIN [valeant].[historymap] [m] ON [m].[id] = [hi].[map] AND [m].[InReport] = 1
	WHERE [hi].[id] = @id
	ORDER BY [hi].[number]
END

GO
/****** Object:  StoredProcedure [valeant].[ReadHIstory]    Script Date: 17.04.2016 18:14:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[ReadHIstory]
	@id bigint,
	@document nvarchar(256)
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @documenttype bigint
	SELECT @documenttype = [Id] FROM [valeant].[documenttype] WHERE [Value] = @document
	SELECT [hi].[id], [hi].[number], [hi].[date], [h].[fullname], [m].[history], [hi].[Comment], [m].[InReport] FROM [valeant].[advancehistory] [hi]
	INNER JOIN [valeant].[human] [h] ON [h].[id] = [hi].[Creator]
	INNER JOIN [valeant].[historymap] [m] ON [m].[id] = [hi].[map]
	WHERE [hi].[id] = @id
	ORDER BY [hi].[number]
END 


GO
