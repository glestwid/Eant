USE [Valeant]
GO
/****** Object:  User [test\ValeantRobot]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE USER [test\ValeantRobot] FOR LOGIN [TEST\ValeantRobot] WITH DEFAULT_SCHEMA=[test\ValeantRobot]
GO
/****** Object:  User [VALEANT\ValiantRobot]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE USER [VALEANT\ValiantRobot] WITH DEFAULT_SCHEMA=[VALEANT\ValiantRobot]
GO
ALTER ROLE [db_owner] ADD MEMBER [test\ValeantRobot]
GO
ALTER ROLE [db_owner] ADD MEMBER [VALEANT\ValiantRobot]
GO
/****** Object:  Schema [test\ValeantRobot]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE SCHEMA [test\ValeantRobot]
GO
/****** Object:  Schema [valeant]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE SCHEMA [valeant]
GO
/****** Object:  Schema [VALEANT\ValiantRobot]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE SCHEMA [VALEANT\ValiantRobot]
GO
/****** Object:  UserDefinedDataType [valeant].[Code]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[Code] FROM [nvarchar](20) NULL
GO
/****** Object:  UserDefinedTableType [valeant].[attachmenttype]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[attachmenttype] AS TABLE(
	[urn] [nvarchar](255) NULL,
	[content-type] [nvarchar](255) NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[BigintTable]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[BigintTable] AS TABLE(
	[Id] [bigint] NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[costcenterType]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[costcenterType] AS TABLE(
	[Code] [valeant].[Code] NOT NULL,
	[Description] [nvarchar](2000) NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[countryType]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[countryType] AS TABLE(
	[Code] [valeant].[Code] NOT NULL,
	[Name] [nvarchar](2000) NOT NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[departmentconditionType]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[departmentconditionType] AS TABLE(
	[Code] [valeant].[Code] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](2000) NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[departmentType]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[departmentType] AS TABLE(
	[Code] [valeant].[Code] NOT NULL,
	[Name] [nvarchar](2000) NOT NULL,
	[Parent] [valeant].[Code] NULL,
	[Status] [bigint] NOT NULL,
	[Organization] [valeant].[Code] NOT NULL,
	[CostCenter] [valeant].[Code] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[employeepositionType]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[employeepositionType] AS TABLE(
	[Code] [valeant].[Code] NOT NULL,
	[Value] [nvarchar](255) NOT NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[employeeType]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[employeeType] AS TABLE(
	[ClockNumber] [valeant].[Code] NOT NULL,
	[Human] [valeant].[Code] NULL,
	[Department] [valeant].[Code] NULL,
	[Position] [valeant].[Code] NULL,
	[Status] [valeant].[Code] NOT NULL,
	[Manager1stLevel] [valeant].[Code] NULL,
	[Manager2ndLevel] [valeant].[Code] NULL,
	[CostCentre] [valeant].[Code] NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[humanType]    Script Date: 6/29/2016 3:59:13 PM ******/
CREATE TYPE [valeant].[humanType] AS TABLE(
	[Code] [valeant].[Code] NOT NULL,
	[FullName] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](320) NULL,
	[DocumentSeries] [nvarchar](10) NOT NULL,
	[DocumentNumber] [nvarchar](20) NOT NULL,
	[DocumentIssuedOn] [datetime] NOT NULL,
	[DocumentIssuedBy] [nvarchar](255) NOT NULL,
	[UserAccount] [nvarchar](255) NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[metadatavalues]    Script Date: 6/29/2016 3:59:14 PM ******/
CREATE TYPE [valeant].[metadatavalues] AS TABLE(
	[Property] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](255) NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[NVarchar255Table]    Script Date: 6/29/2016 3:59:14 PM ******/
CREATE TYPE [valeant].[NVarchar255Table] AS TABLE(
	[value] [nvarchar](255) NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[organizationType]    Script Date: 6/29/2016 3:59:14 PM ******/
CREATE TYPE [valeant].[organizationType] AS TABLE(
	[Code] [valeant].[Code] NOT NULL,
	[Value] [nvarchar](2000) NOT NULL,
	[Country] [valeant].[Code] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[token]    Script Date: 6/29/2016 3:59:14 PM ******/
CREATE TYPE [valeant].[token] AS TABLE(
	[Token] [nvarchar](15) NULL,
	[Tokent] [nvarchar](15) NULL
)
GO
/****** Object:  UserDefinedTableType [valeant].[valeantrowType]    Script Date: 6/29/2016 3:59:14 PM ******/
CREATE TYPE [valeant].[valeantrowType] AS TABLE(
	[Id] [bigint] NOT NULL,
	[Code] [valeant].[Code] NOT NULL,
	[ActionTaken] [nvarchar](10) NOT NULL
)
GO
/****** Object:  Table [valeant].[action]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[action](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[action] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_action] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[actionmap]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[actionmap](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[action] [bigint] NOT NULL,
	[state] [bigint] NOT NULL,
	[token] [nvarchar](15) NOT NULL,
	[description] [nvarchar](1024) NOT NULL,
 CONSTRAINT [PK_actionmap] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[actionmaptodocument]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[actionmaptodocument](
	[document] [bigint] NOT NULL,
	[action] [bigint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[actions_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[actions_version_2](
	[id] [bigint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_actgion_version_2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[advance]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[advance](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[number] [bigint] NOT NULL,
	[dateadvance] [datetimeoffset](7) NOT NULL,
	[type] [bigint] NOT NULL,
	[sum] [money] NOT NULL,
	[state] [bigint] NOT NULL,
	[datatype] [bigint] NOT NULL,
	[content] [xml] NOT NULL,
	[creator] [bigint] NOT NULL,
	[datecreate] [datetimeoffset](7) NOT NULL,
	[approvalsheet] [nvarchar](max) NULL,
	[processsubtype] [nvarchar](2) NOT NULL,
 CONSTRAINT [PK_advance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [valeant].[advancehistory]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[advancehistory](
	[id] [bigint] NOT NULL,
	[number] [int] NOT NULL,
	[Date] [datetimeoffset](7) NOT NULL,
	[Creator] [bigint] NOT NULL,
	[Map] [bigint] NOT NULL,
	[Comment] [nvarchar](max) NULL,
 CONSTRAINT [PK_advancehistory] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [valeant].[advancemetadata]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[advancemetadata](
	[advanceId] [bigint] NOT NULL,
	[Property] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](255) NULL,
 CONSTRAINT [PK_DefinitionMetadata] PRIMARY KEY CLUSTERED 
(
	[advanceId] ASC,
	[Property] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[advancetoken]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[advancetoken](
	[id] [bigint] NOT NULL,
	[token] [nvarchar](15) NOT NULL,
	[tokent] [nvarchar](15) NOT NULL,
 CONSTRAINT [PK_advancetoken] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[attachments]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[attachments](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[advance] [bigint] NOT NULL,
	[urn] [nvarchar](255) NOT NULL,
	[content-type] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_attachments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[car]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[car](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[human] [bigint] NULL,
	[Number] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_car] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[contenttype]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[contenttype](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](1024) NOT NULL,
 CONSTRAINT [PK_contenttype] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[costcenter]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[costcenter](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [valeant].[Code] NOT NULL,
	[Description] [nvarchar](2000) NULL,
 CONSTRAINT [PK_CostCentre] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[country]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[country](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [valeant].[Code] NOT NULL,
	[Name] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_country] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[department]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[department](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [valeant].[Code] NOT NULL,
	[Name] [nvarchar](2000) NOT NULL,
	[Parent] [bigint] NULL,
	[Status] [bigint] NOT NULL,
	[Organization] [bigint] NOT NULL,
	[CostCenter] [bigint] NULL,
 CONSTRAINT [PK_department] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[departmentcondition]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[departmentcondition](
	[IdDepartment] [bigint] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](2000) NULL,
 CONSTRAINT [PK_departmentcondition] PRIMARY KEY CLUSTERED 
(
	[IdDepartment] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[departmentstatus]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[departmentstatus](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_departmentstatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[document]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[document](
	[Id] [bigint] NOT NULL,
	[Type] [bigint] NOT NULL,
	[NodeId] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Status] [bigint] NOT NULL,
	[Creator] [bigint] NOT NULL,
	[Create] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_document] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[documentblock_accesslist_details_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[documentblock_accesslist_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[documentblock_accesstype_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[documentblock_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[documentstate]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[documentstate](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
	[Semantic] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_documentstate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[documentstatemap]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[documentstatemap](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[documenttype] [bigint] NOT NULL,
	[currentstate] [bigint] NULL,
	[nextstate] [bigint] NULL,
	[view] [bigint] NOT NULL,
	[action] [bigint] NOT NULL,
 CONSTRAINT [PK_documentstatemap] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[documenttype]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[documenttype](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_documenttype] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[employee]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[employee](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[human] [bigint] NOT NULL,
	[ClockNumber] [valeant].[Code] NOT NULL,
	[Department] [bigint] NULL,
	[Position] [bigint] NULL,
	[Status] [bigint] NOT NULL,
	[Manager1stLevel] [bigint] NULL,
	[Manager2ndLevel] [bigint] NULL,
	[FuelCard] [bigint] NULL,
	[Tel] [nvarchar](16) NULL,
	[CostCentre] [bigint] NULL,
 CONSTRAINT [PK_employee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[employeedocumenttype]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[employeedocumenttype](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_employeedocumenttype] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[employeeledgerentry]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[employeeledgerentry](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[EntryNumber] [int] NULL,
	[EntryKey] [nvarchar](255) NULL,
	[VendorNumber] [nvarchar](50) NULL,
	[DocumentNumber] [nvarchar](255) NULL,
	[DocumentType] [nvarchar](255) NULL,
	[PostingDate] [datetime] NULL,
	[Ammount] [money] NULL,
	[Description] [nvarchar](255) NULL,
	[PaymentPurpose] [nvarchar](255) NULL,
	[PostingGroup] [nvarchar](255) NULL,
	[EntryType] [int] NULL,
	[VendorLedgerEntryNumber] [int] NULL,
 CONSTRAINT [PK_ledgerentry] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[employeeposition]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[employeeposition](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [valeant].[Code] NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
	[Group] [bigint] NOT NULL CONSTRAINT [DF_employeeposition_Group]  DEFAULT ((1)),
 CONSTRAINT [PK_employeeposition] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[employeepositiongroup]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[employeepositiongroup](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_employeepositiongroup] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[employeestatus]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[employeestatus](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_employeestatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[expenditureDocumentType]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[expenditureDocumentType](
	[ExpenditureId] [bigint] NOT NULL,
	[DocumentTypeId] [bigint] NOT NULL,
 CONSTRAINT [PK_ExpenditureId_DocumentTypeId] PRIMARY KEY CLUSTERED 
(
	[ExpenditureId] ASC,
	[DocumentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[expenditures]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[expenditures](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[GroupLimitCode] [nvarchar](16) NOT NULL,
	[CreditGroupId] [bigint] NULL,
	[Account1GroupId] [bigint] NULL,
	[Account2GroupId] [bigint] NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[ApproverRoleId] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[fieldtype]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[fieldtype](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_fieldtype] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[fuelcardtransaction]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[fuelcardtransaction](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CardHolderId] [bigint] NULL,
	[CardHolderName] [nvarchar](255) NULL,
	[CardNumber] [bigint] NOT NULL,
	[Time] [datetime] NOT NULL,
	[Terminal] [nvarchar](255) NULL,
	[Product] [nvarchar](50) NULL,
	[Quantity] [decimal](8, 2) NULL,
	[Ammount] [money] NULL,
	[FullAmmount] [money] NULL,
	[Discount] [money] NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[functionemployee]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[functionemployee](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_FunctionEmployee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[functionemployeetorole]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[functionemployeetorole](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdRole] [bigint] NOT NULL,
	[IdFunction] [bigint] NOT NULL,
 CONSTRAINT [PK_functionemployeetorole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[historymap]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[human]    Script Date: 6/29/2016 3:59:14 PM ******/
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
	[UserAccount] [nvarchar](255) NULL,
	[AssistantId] [bigint] NULL,
	[DeputyId] [bigint] NULL,
	[DeputyDateStart] [datetimeoffset](7) NULL,
	[DeputyDateEnd] [datetimeoffset](7) NULL,
	[LoyaltyCards] [nvarchar](255) NULL,
	[InternationalPassportFirstName] [nvarchar](250) NULL,
	[InternationalPassportLastName] [nvarchar](250) NULL,
	[InternationalPassportBirthPlace] [nvarchar](250) NULL,
	[InternationalPassportIssueDate] [datetime] NULL,
	[InternationalPassportExpiryDate] [datetime] NULL,
	[LastLoginTime] [datetime] NULL,
 CONSTRAINT [PK_human] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[humantorole]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[humantorole](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[HumanId] [bigint] NOT NULL,
	[RoleId] [bigint] NOT NULL,
 CONSTRAINT [PK_HumanToRole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[limits]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[limits](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[positiongroup] [bigint] NOT NULL,
	[limit] [money] NOT NULL,
	[ExpenditureId] [bigint] NOT NULL,
 CONSTRAINT [PK_limits] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[listmap]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[listmap](
	[id] [bigint] NOT NULL,
	[mapvalue] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_listmap] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[mapvalue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[matrix_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[mime]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [valeant].[mime](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[extension] [nvarchar](10) NOT NULL,
	[mime] [nvarchar](100) NOT NULL,
	[default] [bit] NOT NULL CONSTRAINT [DF_MimeTypes_default]  DEFAULT ((1)),
	[description] [nvarchar](255) NULL,
	[icon] [varbinary](8000) NULL,
 CONSTRAINT [PK_MimeTypes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [valeant].[node_properties_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[node_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[nodeclosure_valeant_2]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[nodeclosureaccesslist_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[nodetype_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[notification]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[numbers]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[numbers](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[type] [bigint] NOT NULL,
	[number] [bigint] NOT NULL,
 CONSTRAINT [PK_Numbers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[organization]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[organization](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [valeant].[Code] NOT NULL,
	[Value] [nvarchar](2000) NOT NULL,
	[Country] [bigint] NOT NULL,
 CONSTRAINT [PK_organization] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[role]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[role](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[IsAdministrator] [bit] NOT NULL CONSTRAINT [DF_role_IsAdministrator]  DEFAULT ((0)),
	[Code] [nchar](10) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[selector]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[selector](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[value] [nvarchar](50) NOT NULL,
	[title] [nvarchar](255) NULL,
 CONSTRAINT [PK_selectors] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[selectormap]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[selectormap](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[selectorid] [bigint] NOT NULL,
	[next] [bigint] NULL,
	[selector] [bigint] NULL,
	[selectorresult] [int] NOT NULL,
	[notification] [bigint] NULL,
 CONSTRAINT [PK_selectormap] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[selectors_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[selectors_version_2](
	[id] [bigint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_selectors_version_2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[SequenceGenerator]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[SequenceGenerator](
	[Sequence] [bigint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[settings]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GO
/****** Object:  Table [valeant].[simpledictionary]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[simpledictionary](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Type] [bigint] NOT NULL,
	[Value] [nvarchar](1024) NOT NULL,
	[Actual] [bit] NOT NULL,
	[Advansed] [nvarchar](max) NULL,
	[Reference] [bigint] NULL,
	[Flag] [bit] NULL,
	[Flag1] [bit] NULL,
 CONSTRAINT [PK_SimpleDictionaries] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [valeant].[simpledictionarytype]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[simpledictionarytype](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_SimpleDictionaryType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[statemap]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[statemap](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[type] [bigint] NOT NULL,
	[action] [bigint] NOT NULL,
	[state] [bigint] NOT NULL,
	[next] [bigint] NULL,
	[selector] [bigint] NULL,
	[notification] [bigint] NULL,
	[description] [nvarchar](1024) NULL,
 CONSTRAINT [PK_statemap] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[states_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[tokenmap]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[tokenmap](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[type] [bigint] NOT NULL,
	[tokentype] [nvarchar](15) NOT NULL,
	[state] [bigint] NOT NULL,
 CONSTRAINT [PK_tokenmap] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[tokens_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
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
/****** Object:  Table [valeant].[versions]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[versions](
	[Name] [nvarchar](255) NOT NULL,
	[Version] [bigint] NOT NULL,
 CONSTRAINT [PK_versions] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [valeant].[view]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [valeant].[view](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[view] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_view] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [valeant].[Documents]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [valeant].[Documents] 
as
select 
	a.Id, 
	a.number as Number,
	a.dateadvance as DocumentDate,
	dt.Value as DocumentTypeDisplayName,
	a.[sum] as Summa,
	s.name as DocumentStateDisplayName,
	ct.Value as DocumentContentType,
	a.content as DocumentContent,
	a.creator as CreatorId,
	a.datecreate as CreationDate,
	h.FullName as CreatorDisplayName,
	d.Name as CreatorDepartmentName,
	a.approvalsheet as ApprovalSheet,
	a.processsubtype as ProcessSubtype,
	dt.Name as DocumentTypeName,
	s.title as DocumentStateName
from valeant.advance a
	left join valeant.documenttype dt on dt.Id = a.[type]
	left join valeant.states_version_3 s on s.Id = a.[state]
	left join valeant.contenttype ct on ct.Id = a.datatype
	left join valeant.human h on h.Id = a.creator
	left join valeant.employee e on e.human = a.creator
	left join valeant.department d on d.Id = e.Department
GO
/****** Object:  View [valeant].[HumanRoles]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [valeant].[HumanRoles] 
as
select
	r.Id,
	r.Name,
	hr.HumanId,
	r.IsAdministrator,
	r.Code,
	h.Code as HumanCode
from 
	valeant.humantorole hr
	left join valeant.[role] r on r.Id = hr.RoleId
	left join valeant.human h on h.Id = hr.HumanId
GO
/****** Object:  View [valeant].[Humans]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [valeant].[Humans] 
as
select 
    h.Code, 
    h.FullName, 
    e.ClockNumber, 
    s.[Value] as DepartmentStatus, 
    d.Code as DepartmentCode, 
    d.Name as DepartmentName,
    h.UserAccount,
    h.Email,
    h.Id,
    h.AssistantId,
    h.DeputyId,
    assistanth.FullName as AssistantFullName,
    deputyh.FullName as DeputyFullName,
    managerh1.FullName as Manager1FullName,
    e.Manager1stLevel,
    managerh2.FullName as Manager2FullName,
    e.Manager2ndLevel,
    p.[Value] as PositionName,
    c.[Description] as CostCenterDescription,
    h.DocumentIssuedBy,
    h.DocumentIssuedOn,
    h.DocumentNumber,
    h.DocumentSeries,
    h.NumberInternationalPassport,
    h.InternationalPassportIssueDate,
    o.[Value] as OrganizationName,
    country.Name as CountryName,
    h.Tel,
    h.LoyaltyCards,
    h.InternationalPassportFirstName,
    h.InternationalPassportLastName ,
    h.InternationalPassportBirthPlace,
    h.InternationalPassportExpiryDate,
    e.FuelCard,
    c.Code as CostCenterCode,
	h.LastLoginTime,
	p.Id as PositionId,
	p.[Group] as PositionGroupId,
	e.[Status] as EmployeeStatus,
	h.DeputyDateStart, 
	h.DeputyDateEnd
from valeant.human h
    left join valeant.employee e on h.Id = e.human
    left join valeant.department d on d.Id = e.Department
    left join valeant.departmentstatus s on s.Id = d.[Status]
    left join valeant.employeeposition p on p.id = e.Position
    left join valeant.costcenter c on c.Id = e.CostCentre
    left join valeant.organization o on o.Id = d.Organization
    left join valeant.country country on country.Id = o.Country
    left join valeant.human assistanth on assistanth.Id = h.AssistantId
    left join valeant.human deputyh on deputyh.Id = h.DeputyId
    left join valeant.human managerh1 on managerh1.Id = e.Manager1stLevel
    left join valeant.human managerh2 on managerh2.Id = e.Manager2ndLevel


GO
ALTER TABLE [valeant].[advancemetadata]  WITH CHECK ADD  CONSTRAINT [FK_advancemetadata_advance] FOREIGN KEY([advanceId])
REFERENCES [valeant].[advance] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [valeant].[advancemetadata] CHECK CONSTRAINT [FK_advancemetadata_advance]
GO
ALTER TABLE [valeant].[expenditureDocumentType]  WITH CHECK ADD FOREIGN KEY([DocumentTypeId])
REFERENCES [valeant].[documenttype] ([Id])
GO
ALTER TABLE [valeant].[expenditureDocumentType]  WITH CHECK ADD FOREIGN KEY([ExpenditureId])
REFERENCES [valeant].[expenditures] ([Id])
GO
ALTER TABLE [valeant].[expenditures]  WITH CHECK ADD FOREIGN KEY([ApproverRoleId])
REFERENCES [valeant].[role] ([Id])
GO
ALTER TABLE [valeant].[limits]  WITH CHECK ADD FOREIGN KEY([ExpenditureId])
REFERENCES [valeant].[expenditures] ([Id])
GO
/****** Object:  StoredProcedure [valeant].[CheckCostItem]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[CheckCostItem] 
	@name nvarchar(1024),
	@result nvarchar(16) OUT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT @result = [d].[Advansed] FROM [valeant].[simpledictionary] [d] WHERE [d].[Value] = @name
END





GO
/****** Object:  StoredProcedure [valeant].[ClearLedgerEntries]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [valeant].[ClearLedgerEntries] 
	AS
BEGIN
	
	SET NOCOUNT ON;

    DELETE from [valeant].[employeeledgerentry]
END



GO
/****** Object:  StoredProcedure [valeant].[GetNextNumber]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[GetNextNumber] 
	@type bigint,
	@number bigint OUT
AS
BEGIN
	SET NOCOUNT ON;

    IF(NOT EXISTS(SELECT 'A' FROM [valeant].[numbers] WITH (UPDLOCK, ROWLOCK) WHERE [type] = @type))
	BEGIN
		SET @number = 1
		INSERT INTO [valeant].[numbers]([type], [number]) VALUES(@type, @number)
	END
	ELSE
	BEGIN
		SELECT @number = [number] FROM [valeant].[numbers] WHERE [type] = @type
		SET @number = @number + 1
		UPDATE [valeant].[numbers] SET [number] = @number WHERE [type] = @type
	END
END





GO
/****** Object:  StoredProcedure [valeant].[GetNextTripRequestTKNumber]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[GetNextTripRequestTKNumber]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @createdTransaction bit
	    IF @@TRANCOUNT = 0
    BEGIN
      SET @createdTransaction = 1
      SET XACT_ABORT ON
      BEGIN TRANSACTION
    END
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @NextSequence BIGINT
		UPDATE [valeant].[SequenceGenerator] 
		SET @NextSequence = Sequence = Sequence + 1
		SELECT [Sequence] FROM [valeant].[SequenceGenerator]
		IF @createdTransaction > 0
		BEGIN
			COMMIT TRANSACTION
		END
	END TRY
	BEGIN CATCH
		IF @createdTransaction > 0
		BEGIN
			ROLLBACK TRANSACTION
			DECLARE @ErrorMessage NVARCHAR(4000);
			DECLARE @ErrorSeverity INT;
			DECLARE @ErrorState INT;
			SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		END
	END CATCH
END

GO
/****** Object:  StoredProcedure [valeant].[GetVersion]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[GetVersion]
	@name nvarchar(255),
	@version bigint OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
    SELECT @version = [Version] FROM [valeant].[versions] WHERE [Name] = @name
END





GO
/****** Object:  StoredProcedure [valeant].[InsertFuelCardTransaction]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[InsertFuelCardTransaction]
	 @cardHolderId		bigint,
     @cardNumber		bigint,
	 @cardHolderName	nvarchar(255) =NULL,
	 @time				datetime,
	 @terminal			nvarchar(255),
	 @product			nvarchar(50),
	 @quantity			decimal(8,2),
	 @ammount			money,
	 @fullAmmount		money,
     @discount			money

AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT Id FROM [valeant].[fuelcardtransaction] WHERE [Time] = @time AND [CardNumber] = @cardNumber)
	 BEGIN
	  INSERT   INTO [valeant].[fuelcardtransaction] 
	  ([CardHolderId],
	   [CardHolderName], 
	   [CardNumber],
	   [Time],
	   [Terminal],
	   [Product],
	   [Quantity],
	   [Ammount],
	   [FullAmmount],
	   [Discount])   
	   VALUES
	   (@cardHolderId,
	    @cardHolderName,
	    @cardNumber,
		@time,
		@terminal,
		@product,
		@quantity,
		@ammount,
		@fullAmmount,
		@discount)
	 END

END


GO
/****** Object:  StoredProcedure [valeant].[InsertLedgerEntry]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [valeant].[InsertLedgerEntry]
    -- Add the parameters for the stored procedure here
    @number int,
	@vendorledgerentryno int,
    @entrykey NVARCHAR(255),
    @vendornumber NVARCHAR(50),
    @documentnumber NVARCHAR(255),
    @documenttype NVARCHAR(255),
	@postingdate DATETIME,
    @ammount money,
	@description NVARCHAR(255),
	@paymentpurpose NVARCHAR(255),
    @postinggroup NVARCHAR(255),
	@entrytype  int        




AS
BEGIN
    
    SET NOCOUNT ON;

    DELETE FROM [valeant].[employeeledgerentry] where [EntryNumber] = @number

    INSERT INTO [valeant].[employeeledgerentry] 
    ([EntryNumber],
    [VendorLedgerEntryNumber],
    [EntryKey],
    [VendorNumber],
    [DocumentNumber],
    [DocumentType],
	[PostingDate],
    [Ammount],
	[Description],
    [PaymentPurpose],
	[PostingGroup],
	[EntryType]


	)
    VALUES 
    (@number,
	 @vendorledgerentryno,
     @entrykey,
     @vendornumber,
     @documentnumber,
     @documenttype,
	 @postingdate,
     @ammount,
	 @description,
	 @paymentpurpose,
	 @postinggroup,
	 @entrytype)
    
END



/****** Object:  StoredProcedure [valeant].[ReadLedgerEntry]    Script Date: 22.05.2016 21:36:19 ******/
SET ANSI_NULLS ON


GO
/****** Object:  StoredProcedure [valeant].[InsertOrUpdateAdvance]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [valeant].[InsertOrUpdateAdvance]
	@id bigint OUT,
	@number bigint OUT,
	@dateadvance datetimeoffset,
	@type nvarchar(255),
	@sum money,
	@state nvarchar(255),
	@datatype nvarchar(1024),
	@action nvarchar(1024),
	@content xml,
	@creator bigint,
	@datecreate datetimeoffset,
	@comment nvarchar(MAX),
	@approvalSheet nvarchar(MAX),
	@clearapprovalsheet bit,
	@processsubtype nvarchar(2),
	@tokens [valeant].[token] READONLY,
	@metadata [valeant].[metadatavalues] READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @createdTransaction bit
    IF @@TRANCOUNT = 0
    BEGIN
      SET @createdTransaction = 1
      SET XACT_ABORT ON
      BEGIN TRANSACTION
    END
	BEGIN TRY
		DECLARE @idA bigint
		DECLARE @contenttype bigint
		DECLARE @documentstate bigint
		DECLARE @documenttype bigint
		DECLARE @advanceId bigint
		DECLARE @actionId bigint
		DECLARE @map bigint
		--SELECT @number = ISNULL(MAX([number]),0) FROM [valeant].[advance] WITH (TABLOCK, HOLDLOCK)
		SELECT @contenttype = [Id] FROM [valeant].[contenttype] WHERE [Value] = @datatype
		SELECT @documentstate = [Id] FROM [valeant].[states_version_3] WHERE [name] = @state
		SELECT @documenttype = [Id] FROM [valeant].[documenttype] WHERE [Value] = @type
		SELECT @idA = MAX([a].[number]) FROM [valeant].[advance] [a] WITH (UPDLOCK, HOLDLOCK) WHERE [a].[type] = @documenttype
		SELECT @actionId = Id FROM [valeant].[actions_version_2] WHERE [name] = @action
		IF(@action IS NULL)
		BEGIN
			SET @actionId = -1
		END
		ELSE
		BEGIN
			SELECT @actionId = Id FROM [valeant].[action] WHERE [action] = @action
		END

		SELECT @map = [id] FROM [valeant].[historymap] WHERE [actionid] = @actionId AND [documentid] = @documenttype
		IF(@contenttype IS NULL)
		BEGIN
			DECLARE @ids TABLE(Id bigint)
			INSERT INTO [valeant].[contenttype]
			OUTPUT inserted.Id INTO @ids
			VALUES(@datatype)
			SELECT @contenttype = Id FROM @ids
		END
		IF(@id IS NULL)
		BEGIN
			DECLARE @aids [valeant].[BigintTable]
			EXEC [valeant].[GetNextNumber] @documenttype, @number OUTPUT
			INSERT INTO [valeant].[advance]
				([number]
				,[dateadvance]
				,[type]
				,[sum]
				,[state]
				,[datatype]
				,[content]
				,[creator]
				,[approvalSheet]
				,[processsubtype]
				,[datecreate])
			OUTPUT inserted.Id INTO @aids
			VALUES(@number, @dateadvance, @documenttype, @sum, @documentstate, @contenttype, @content, @creator, @approvalSheet, @processsubtype, @datecreate)
			SELECT @advanceId = Id FROM @aids
		END
		ELSE
		BEGIN
			SET @advanceId = @id
			UPDATE [valeant].[advance]
				SET	[sum] = @sum
				,[state] = @documentstate
				,[datatype] = @contenttype
				,[content] = @content
				,[approvalSheet] = CASE @clearapprovalsheet WHEN 1 THEN NULL ELSE @approvalSheet END
				WHERE 
				Id = @id
			SELECT @number = [number] FROM [valeant].[advance] WHERE Id = @id
		END
		DELETE FROM [valeant].[advancetoken] WHERE [id] = @advanceId
		INSERT INTO [valeant].[advancetoken]
		SELECT @advanceId, [Token], [Tokent] FROM @tokens

		DECLARE @metadataCount int 
		SELECT @metadataCount = COUNT(*) FROM @metadata

		IF(@map IS NOT NULL)
		BEGIN
			DECLARE @numberHistory INT
			SELECT @numberHistory = ISNULL(MAX(number),0) FROM [valeant].[advancehistory] [h] WHERE [h].[id] = @advanceId
			INSERT INTO [valeant].[advancehistory]
			VALUES(@advanceId, @numberHistory + 1, @datecreate, @creator, @map, @comment)
		END	

		IF(@metadataCount > 0)
		BEGIN
			DELETE FROM [valeant].[advancemetadata] WHERE advanceId = @advanceId
			INSERT INTO [valeant].[advancemetadata]
			SELECT @advanceId, Property, Value FROM @Metadata
		END

		SET @id = @advanceId
		IF @createdTransaction = 1 COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @createdTransaction = 1 ROLLBACK TRANSACTION
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH;
END

GO
/****** Object:  StoredProcedure [valeant].[InsertOrUpdateCar]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [valeant].[InsertOrUpdateCar] 
	@Number NVARCHAR(50),
	@Type   NVARCHAR(50),
	@human  BIGINT
AS
BEGIN
	 IF  EXISTS (SELECT * FROM [valeant].[car] WHERE [NUMBER] = @Number )
	 BEGIN
	     UPDATE [valeant].[car] SET [TYPE] =@Type, [HUMAN] =@Human WHERE [NUMBER] = @Number
	  END
     ELSE
	 BEGIN
	     INSERT INTO  [valeant].[car] VALUES (@human,@Number,@Type)
	 
	 END

END



GO
/****** Object:  StoredProcedure [valeant].[insertorupdatesimpledictionary_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[insertorupdatesimpledictionary_version_2] 
   @id bigint,
   @typeName nvarchar(255),
   @value nvarchar(1024),
   @advansed nvarchar(max),
   @reference bigint,
   @flag bit,
   @flag1 bit
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @createdTransaction bit
  IF @@TRANCOUNT = 0
  BEGIN
    SET @createdTransaction = 1
    SET XACT_ABORT ON
    BEGIN TRANSACTION
  END
   BEGIN TRY
       DECLARE @typeId int
       SELECT @typeId = [id] FROM [valeant].[simpledictionarytype] WHERE [value] = @typeName
       IF @typeId IS NULL
       BEGIN
           RAISERROR(N'Не найден тип словаря', 16, 1)
       END
       IF(@id IS NULL)
       BEGIN
           INSERT INTO [valeant].[simpledictionary]([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
           VALUES(@typeId, @value, 1, @advansed, @reference, @flag, @flag1)
       END
       ELSE
       BEGIN
           UPDATE [valeant].[simpledictionary] SET 
               [value] = @value,
               [Advansed] = @advansed, 
               [Reference] = @reference,
               [Flag] = @flag,
               [Flag1] = @flag1
           WHERE 
               [id] = @id
       END
       IF @createdTransaction = 1 COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
       IF @createdTransaction = 1 ROLLBACK TRANSACTION
       DECLARE @ErrorMessage NVARCHAR(4000);
       DECLARE @ErrorSeverity INT;
       DECLARE @ErrorState INT;
       SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
   END CATCH;
END






GO
/****** Object:  StoredProcedure [valeant].[raedblockaccesslist_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[raedblockaccesslist_version_2] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [d].[id], [t].[value] FROM [valeant].[documentblock_accesslist_version_2] [d]
	INNER JOIN [valeant].[documenttype] [t] ON [d].[documenttype] = [t].[id]

	SELECT [ad].[accesslist], [b].[block], [at].[name] FROM [valeant].[documentblock_accesslist_details_version_2] [ad]
	INNER JOIN [valeant].[documentblock_version_2] [b] ON [b].[id] = [ad].[block]
	INNER JOIN [valeant].[documentblock_accesstype_version_2] [at] ON [at].[id] = [ad].[access]
	ORDER BY [ad].[accesslist]
END




GO
/****** Object:  StoredProcedure [valeant].[ReaAdvanceCreator]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[ReaAdvanceCreator]
    @documentId bigint
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id bigint

    SELECT @id = [creator] FROM [valeant].[advance] WHERE [id] = @documentId
    
    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code,
		[h].LastLoginTime
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]
    WHERE [h].[Id] = @id

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id] AND [hr].[HumanId] = @id
END



GO
/****** Object:  StoredProcedure [valeant].[read_matrix_all_info_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[read_matrix_all_info_version_3] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [id], [name], [title], [approvalsheettitle] FROM [valeant].[states_version_3]
	SELECT [id], [value], [calc], [export] FROM [valeant].[tokens_version_3]
	SELECT [id], [name], [description] FROM [valeant].[documentblock_accesstype_version_2]
	SELECT [id], [block] FROM [valeant].[documentblock_version_2]
	SELECT [id], [documenttype], [name], [description] FROM [valeant].[documentblock_accesslist_version_2]
	SELECT [id], [accesslist], [block], [access] FROM [valeant].[documentblock_accesslist_details_version_2]
	SELECT [id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart] FROM [valeant].[notification]
	SELECT [id], [state], [token], [access_list_documentblock], [notification], [actions], [document] FROM [valeant].[node_properties_version_3]
	SELECT [id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet] FROM [valeant].[matrix_version_3]
END





GO
/****** Object:  StoredProcedure [valeant].[readactions_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readactions_version_2] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [id], [name], [description] FROM [valeant].[actions_version_2]
END




GO
/****** Object:  StoredProcedure [valeant].[ReadAdvance]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadAdvance]
	@id bigint,
	@documentType nvarchar(255),
	@dateStart datetimeoffset, 
	@dateEnd datetimeoffset,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @documentTypeId bigint
	SELECT @documentTypeId = [d].[Id] FROM [valeant].[documenttype] [d] WHERE [d].[Value] = @documentType
    IF(@id IS NULL)
	BEGIN
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN [valeant].[advance] [ad] ON [ad].[Id] = [a].[Id]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]
		WHERE [ad].[type] = @documentTypeId AND [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_2] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 
		  ORDER BY number DESC
		  
		  SELECT DISTINCT [a].[id], [ac].[name] FROM [valeant].[actions_version_2] [ac]
		  INNER JOIN [valeant].[nodeclosure_valeant_2] [c] ON [c].[action] = [ac].[id]
		  INNER JOIN [valeant].[node_version_2] [n] ON [n].[id] = [c].[ancestor]
		  INNER JOIN [valeant].[advance] [a] ON [a].[state] = [n].[id2] AND [n].[type] = 1 AND [a].[type] = [c].[type]
		  INNER JOIN [valeant].[nodeclosureaccesslist_version_2] [al] ON [al].[nodeclosure] = [c].[id]
		  INNER JOIN [valeant].[advancetoken] [at] ON [at].[tokent] = [al].[token]
		  INNER JOIN @tokens [t] ON [t].[value] = [at].[token]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [ac].[name]

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [id]
	END 
	ELSE
	BEGIN
		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_2] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  WHERE [t].Id = @documentTypeId AND [a].[id] = @id

		  SELECT DISTINCT [a].[id], [ac].[name] FROM [valeant].[actions_version_2] [ac]
		  INNER JOIN [valeant].[nodeclosure_valeant_2] [c] ON [c].[action] = [ac].[id]
		  INNER JOIN [valeant].[node_version_2] [n] ON [n].[id] = [c].[ancestor]
		  INNER JOIN [valeant].[advance] [a] ON [a].[state] = [n].[id2] AND [n].[type] = 1 AND [a].[type] = [c].[type]
		  INNER JOIN [valeant].[nodeclosureaccesslist_version_2] [al] ON [al].[nodeclosure] = [c].[id]
		  INNER JOIN [valeant].[advancetoken] [at] ON [at].[tokent] = [al].[token]
		  INNER JOIN @tokens [t] ON [t].[value] = [at].[token]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  WHERE [a].[type] = @documentTypeId AND [a].[Id] = @id
		  ORDER BY [ac].[name]

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  WHERE [a].[id] = @id
	END
END




GO
/****** Object:  StoredProcedure [valeant].[readadvance_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[readadvance_version_3]
	@id bigint,
	@documentType nvarchar(255),
	@dateStart datetimeoffset, 
	@dateEnd datetimeoffset,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @documentTypeId bigint
	SELECT @documentTypeId = [d].[Id] FROM [valeant].[documenttype] [d] WHERE [d].[Value] = @documentType
    IF(@id IS NULL)
	BEGIN
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN [valeant].[advance] [ad] ON [ad].[Id] = [a].[Id]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]
		WHERE [ad].[type] = @documentTypeId AND [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
			  ,[a].[approvalsheet]
			  ,[a].[processsubtype]
			  ,[ep].[Value] as Position
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 
		  LEFT JOIN [valeant].[employeeposition] [ep] ON [ep].Id = [e].Position
		  ORDER BY number DESC

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [id]

		  SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [m].[advanceId]
		  ORDER BY [m].[advanceId]
	END 
	ELSE
	BEGIN
		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
			  ,[a].[approvalsheet]
			  ,[a].[processsubtype]
			  ,[ep].[Value] as Position
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  LEFT JOIN [valeant].[employeeposition] [ep] ON [ep].Id = [e].Position
		  WHERE [t].Id = @documentTypeId AND [a].[id] = @id

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  WHERE [a].[id] = @id

		  SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  WHERE [m].[advanceId] = @id
	END
END

GO
/****** Object:  StoredProcedure [valeant].[ReadAdvanceAll]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[ReadAdvanceAll]
	@id bigint,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
    IF(@id IS NULL)
	BEGIN
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]

		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_2] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 
		  ORDER BY number DESC

		  SELECT DISTINCT [a].[id], [ac].[name] FROM [valeant].[actions_version_2] [ac]
		  INNER JOIN [valeant].[nodeclosure_valeant_2] [c] ON [c].[action] = [ac].[id]
		  INNER JOIN [valeant].[node_version_2] [n] ON [n].[id] = [c].[ancestor]
		  INNER JOIN [valeant].[advance] [a] ON [a].[state] = [n].[id2] AND [n].[type] = 1 AND [a].[type] = [c].[type]
		  INNER JOIN [valeant].[nodeclosureaccesslist_version_2] [al] ON [al].[nodeclosure] = [c].[id]
		  INNER JOIN [valeant].[advancetoken] [at] ON [at].[tokent] = [al].[token]
		  INNER JOIN @tokens [t] ON [t].[value] = [at].[token]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [ac].[name]

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [id]
	END 
	ELSE
	BEGIN
		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_2] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  WHERE [a].[id] = @id

		  SELECT DISTINCT [a].[id], [ac].[name] FROM [valeant].[actions_version_2] [ac]
		  INNER JOIN [valeant].[nodeclosure_valeant_2] [c] ON [c].[action] = [ac].[id]
		  INNER JOIN [valeant].[node_version_2] [n] ON [n].[id] = [c].[ancestor]
		  INNER JOIN [valeant].[advance] [a] ON [a].[state] = [n].[id2] AND [n].[type] = 1  AND [a].[type] = [c].[type]
		  INNER JOIN [valeant].[nodeclosureaccesslist_version_2] [al] ON [al].[nodeclosure] = [c].[id]
		  INNER JOIN [valeant].[advancetoken] [at] ON [at].[tokent] = [al].[token]
		  INNER JOIN @tokens [t] ON [t].[value] = [at].[token]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  WHERE [a].[Id] = @id
		  ORDER BY [ac].[name]
	END
END




GO
/****** Object:  StoredProcedure [valeant].[readadvanceall_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[readadvanceall_version_3]
	@id bigint,
	@dateStart datetimeoffset, 
	@dateEnd datetimeoffset,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
    IF(@id IS NULL)
	BEGIN
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]
		INNER JOIN [valeant].[advance] [ad] ON [a].[id] = [ad].[Id]
		WHERE [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
			  ,[a].[approvalsheet]
			  ,[a].[processsubtype]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 
		  ORDER BY number DESC

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [id]

		  SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [m].[advanceId]
		  ORDER BY [m].[advanceId]
	END 
	ELSE
	BEGIN
		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
			  ,[a].[approvalsheet]
			  ,[a].[processsubtype]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  WHERE [a].[id] = @id

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  WHERE [a].[id] = @id

		  SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  WHERE [m].[advanceId] = @id
	END
END

GO
/****** Object:  StoredProcedure [valeant].[readadvanceallfilter_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[readadvanceallfilter_version_3]
	@id bigint,
	@statusName nvarchar(255),
	@dateStart datetimeoffset, 
	@dateEnd datetimeoffset,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
    IF(@id IS NULL)
	BEGIN
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN [valeant].[advance] [ad] ON [ad].[Id] = [a].[Id]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]
		INNER JOIN [valeant].[states_version_3] [s] ON [s].[id] = [ad].[state] AND [s].[name] = @statusName
		WHERE [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
			  ,[a].[approvalsheet]
			  ,[a].[processsubtype]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 
		  ORDER BY number DESC

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [id]

		  SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [m].[advanceId]
		  ORDER BY [m].[advanceId]
	END 
	ELSE
	BEGIN
		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
			  ,[a].[approvalsheet]
			  ,[a].[processsubtype]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  WHERE [a].[id] = @id

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  WHERE [a].[id] = @id

		  SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  WHERE [m].[advanceId] = @id
	END
END


GO
/****** Object:  StoredProcedure [valeant].[readadvancecontent_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readadvancecontent_version_3] 
	@id bigint
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [a].[content], [t].[Value] FROM [valeant].[advance] [a]
	INNER JOIN [valeant].[contenttype] [t] ON [a].[datatype] = [t].[Id]
	WHERE [a].[Id] = @id
END



GO
/****** Object:  StoredProcedure [valeant].[ReadAdvanceFilter]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[ReadAdvanceFilter]
	@id bigint,
	@documentType nvarchar(255),
	@statusName nvarchar(255),
	@dateStart datetimeoffset, 
	@dateEnd datetimeoffset,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @documentTypeId bigint
	SELECT @documentTypeId = [d].[Id] FROM [valeant].[documenttype] [d] WHERE [d].[Value] = @documentType
    IF(@id IS NULL)
	BEGIN
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN [valeant].[advance] [ad] ON [ad].[Id] = [a].[Id]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]
		WHERE [ad].[type] = @documentTypeId AND [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_2] [s] ON s.[Id] = [state] AND [s].[Name] = @statusName
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 

		  SELECT DISTINCT [a].[id], [ac].[name] FROM [valeant].[actions_version_2] [ac]
		  INNER JOIN [valeant].[nodeclosure_valeant_2] [c] ON [c].[action] = [ac].[id]
		  INNER JOIN [valeant].[node_version_2] [n] ON [n].[id] = [c].[ancestor]
		  INNER JOIN [valeant].[advance] [a] ON [a].[state] = [n].[id2] AND [n].[type] = 1 AND [a].[type] = [c].[type]
		  INNER JOIN [valeant].[nodeclosureaccesslist_version_2] [al] ON [al].[nodeclosure] = [c].[id]
		  INNER JOIN [valeant].[advancetoken] [at] ON [at].[tokent] = [al].[token]
		  INNER JOIN @tokens [t] ON [t].[value] = [at].[token]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [ac].[name]
	END 
	ELSE
	BEGIN
		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_2] [s] ON s.[Id] = [state] AND [s].[Name] = @statusName
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  WHERE [t].Id = @documentTypeId AND [a].[id] = @id

		  SELECT DISTINCT [a].[id], [ac].[name] FROM [valeant].[actions_version_2] [ac]
		  INNER JOIN [valeant].[nodeclosure_valeant_2] [c] ON [c].[action] = [ac].[id]
		  INNER JOIN [valeant].[node_version_2] [n] ON [n].[id] = [c].[ancestor]
		  INNER JOIN [valeant].[advance] [a] ON [a].[state] = [n].[id2] AND [n].[type] = 1 AND [a].[type] = [c].[type]
		  INNER JOIN [valeant].[nodeclosureaccesslist_version_2] [al] ON [al].[nodeclosure] = [c].[id]
		  INNER JOIN [valeant].[advancetoken] [at] ON [at].[tokent] = [al].[token]
		  INNER JOIN @tokens [t] ON [t].[value] = [at].[token]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  WHERE [a].[type] = @documentTypeId AND [a].[Id] = @id
		  ORDER BY [ac].[name]
	END
END



GO
/****** Object:  StoredProcedure [valeant].[readadvancefilter_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[readadvancefilter_version_3]
	@id bigint,
	@documentType nvarchar(255),
	@statusName nvarchar(255),
	@dateStart datetimeoffset, 
	@dateEnd datetimeoffset,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @documentTypeId bigint
	SELECT @documentTypeId = [d].[Id] FROM [valeant].[documenttype] [d] WHERE [d].[Value] = @documentType
    IF(@id IS NULL)
	BEGIN
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN [valeant].[advance] [ad] ON [ad].[Id] = [a].[Id]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]
		INNER JOIN [valeant].[states_version_3] [s] ON [s].[id] = [ad].[state] AND [s].[name] = @statusName
		WHERE [ad].[type] = @documentTypeId AND [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
			  ,[a].[approvalsheet]
			  ,[a].[processsubtype]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 
		
		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [id]
	END 
	ELSE
	BEGIN
		SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
			  ,[a].[approvalsheet]
			  ,[a].[processsubtype]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  WHERE [t].Id = @documentTypeId AND [a].[id] = @id

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  WHERE [a].[id] = @id
	END
END





GO
/****** Object:  StoredProcedure [valeant].[ReadAdvanceSimple]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadAdvanceSimple] 
	@advanceId bigint
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [a].[Id]
			  ,[number]
			  ,[dateadvance]
			  ,t.[Value]
			  ,[sum]
			  ,s.[Name]
			  ,c.[Value]
			  ,[content]
			  ,[creator]
			  ,[datecreate]
			  ,[h].[FullName]
			  ,[d].[Name]
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  WHERE [a].[id] = @advanceId
END





GO
/****** Object:  StoredProcedure [valeant].[ReadAllGiftRequestMetadataForReport]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [valeant].[ReadAllGiftRequestMetadataForReport]
	@dateStart datetimeoffset=null, 
	@dateEnd datetimeoffset=null
as
BEGIN
	SET NOCOUNT ON;
	declare @documentType nvarchar(255)
	set @documentType = N'Заявка на подарок'
	DECLARE @documentTypeId bigint
	SELECT @documentTypeId = [d].[Id] FROM [valeant].[documenttype] [d] WHERE [d].[Value] = @documentType
	
	DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN [valeant].[advance] [ad] ON [ad].[Id] = [a].[Id]
		WHERE [ad].[type] = @documentTypeId 
		--AND [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

		SELECT [number] as Number
			  ,convert(nvarchar(max), [dateadvance], 104) as Date
			  ,e.ClockNumber as CodeEmployee
			  ,[h].[FullName] as FIOEmployee
			  ,'' as CityEmployee
			  ,[sum] as SumGift
			  ,a.content.value('(/GiftRequestDataEx/GiftReciever/SecondName)[1]', 'nvarchar(max)') + ' ' +
			  a.content.value('(/GiftRequestDataEx/GiftReciever/Name)[1]', 'nvarchar(max)') + ' ' +
			  a.content.value('(/GiftRequestDataEx/GiftReciever/MiddleName)[1]', 'nvarchar(max)')
			  as FIOPerson
			  ,a.content.value('(/GiftRequestDataEx/GiftReciever/Organization)[1]', 'nvarchar(max)') as CompanyPerson
			  ,a.content.value('(/GiftRequestDataEx/Status)[1]', 'nvarchar(max)') as Status --s.Value as Status
			  ,a.content.value('(/GiftRequestDataEx/Reason)[1]', 'nvarchar(max)') as Comments
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].documentState [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 
		  ORDER BY number DESC
end
GO
/****** Object:  StoredProcedure [valeant].[readapprovedhistory_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[readapprovedhistory_version_3]
	@id bigint,
	@document nvarchar(256)
AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @documenttype bigint
	SELECT @documenttype = [Id] FROM [valeant].[documenttype] WHERE [Value] = @document
	SELECT [hi].[id], [hi].[number], [hi].[date], [h].[fullname], [ep].[Value] FROM [valeant].[advancehistory] [hi]
	INNER JOIN [valeant].[human] [h] ON [h].[id] = [hi].[Creator]
	INNER JOIN [valeant].[employee] [e] ON [e].[Id] = [h].[Id]
	INNER JOIN [valeant].[employeeposition] [ep] ON [ep].[Id] = [e].[Position]
	INNER JOIN [valeant].[historymap] [m] ON [m].[id] = [hi].[map] AND [m].[InReport] = 1
	WHERE [hi].[id] = @id
	ORDER BY [hi].[number]
END
GO
/****** Object:  StoredProcedure [valeant].[readattachment]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readattachment] 
	@urn nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
    SELECT [a].[urn], [a].[content-type] FROM [valeant].[attachments] [a] WHERE [a].[urn] = @urn
END




GO
/****** Object:  StoredProcedure [valeant].[ReadCars]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [valeant].[ReadCars] 
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Id], [human], [Number],[Type] from  [valeant].[car]
END



GO
/****** Object:  StoredProcedure [valeant].[ReadCostcenter]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadCostcenter]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [Id], [Code], [Description] FROM [Valeant].[valeant].[costcenter]
END





GO
/****** Object:  StoredProcedure [valeant].[readdocumenttype_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readdocumenttype_version_2] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [Id], [Value] FROM [valeant].[documenttype]
END




GO
/****** Object:  StoredProcedure [valeant].[ReadEmployees]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadEmployees]
	@status [bigint]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		[h].[UserAccount],
		[h].[FullName],
		[o].[Value], 
		[c].[Name], 
		[e].[ClockNumber],
		[h].[Code], 
		[ct].[Description],
		[e].[FuelCard],
		[h].[Email],
		[e].[Status],
		[d].[Name],
		[d].[Status],
		[d1].[Name],
		[d1].[Status],
		[d2].[Name],
		[d2].[Status],
		[p].Value,
		[h].[DocumentSeries],
		[h].[DocumentNumber],
		[h].[DocumentIssuedOn],
		[h].[DocumentIssuedBy]
	FROM [valeant].[employee] [e]
	INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
	LEFT OUTER JOIN [valeant].[department] [d1] ON [d].[Parent] = [d1].[Id]
	LEFT OUTER JOIN [valeant].[department] [d2] ON [d1].[Parent] = [d2].[Id]
	INNER JOIN [valeant].[employeeposition] [p] ON [p].[Id] = [e].[Position]
	INNER JOIN [valeant].[organization] [o] ON [d].[Organization] = [o].[Id]
	INNER JOIN [valeant].[country] [c] ON [c].[Id] = [o].[Country]
	INNER JOIN [valeant].[human] [h] ON [h].[Id] = [e].[human]
	LEFT OUTER JOIN [valeant].[costcenter] [ct] ON [ct].Id = [e].[CostCentre]
	WHERE [e].[Status] != 2
END








GO
/****** Object:  StoredProcedure [valeant].[ReadFuelCradTransactions]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadFuelCradTransactions] 
	@HumanId     bigint    =null,
	@from        datetime = null,
	@to          datetime  = null       
AS
BEGIN

	SET NOCOUNT ON;
    
	IF ( NOT (@HumanId  IS NULL))
	BEGIN	  
	 
	 IF ( NOT (@from  IS NULL)  AND NOT (@to IS NULL) )
	 BEGIN
	  SELECT * from [valeant].[fuelcardtransaction] where CardHolderId = @HumanId AND [Time]>=@from AND [Time]<=@to
	 END
	 ELSE
	 BEGIN
	  SELECT * from [valeant].[fuelcardtransaction] where CardHolderId = @HumanId
	 END
    END
	ELSE
	BEGIN
	  IF ( NOT (@from  IS NULL)  AND NOT (@to IS NULL) )
	 BEGIN
	  SELECT * from [valeant].[fuelcardtransaction] where  [Time]>=@from AND [Time]<=@to
	 END
	 ELSE
	 BEGIN
	  SELECT * from [valeant].[fuelcardtransaction] 
	 END
	END 
END


GO
/****** Object:  StoredProcedure [valeant].[ReadHIstory]    Script Date: 6/29/2016 3:59:14 PM ******/
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
	SELECT @documenttype = Id FROM valeant.documenttype WHERE Value = @document

	SELECT hi.id, hi.number, hi.[date], h.fullname, m.history, history.Comment, m.InReport 
		FROM valeant.advancehistory hi
		INNER JOIN valeant.human h ON h.id = hi.Creator
		INNER JOIN valeant.historymap m ON m.id = hi.map
		outer apply (
			select top 1 Comment 
			from valeant.advancehistory 
			where Id = hi.Id and Comment is not null
			order by [number] desc
			) history
	WHERE hi.id = @id
	ORDER BY hi.number
END 



GO
/****** Object:  StoredProcedure [valeant].[ReadHistoryMap]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadHistoryMap]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [h].[id], [h].[actionid], [a].[action], [h].[documentid], [d].[value], [h].[history] FROM [valeant].[historymap] [h]
	LEFT OUTER JOIN [valeant].[action] [a] ON [a].[id] = [h].[actionid]
	INNER JOIN [valeant].[documenttype] [d] ON [d].[id] = [h].[documentid]

END





GO
/****** Object:  StoredProcedure [valeant].[ReadHuman]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadHuman]
    @userAccount nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id Bigint    
    SELECT @id = [h].[Id] FROM [valeant].[human] [h] WHERE [h].[UserAccount] = @userAccount

    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code,
		[h].LastLoginTime
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]
    WHERE [h].[Id] = @id

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id] AND [hr].[HumanId] = @id
END





GO
/****** Object:  StoredProcedure [valeant].[ReadHumanByCode]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadHumanByCode]
    @code nvarchar(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id Bigint    
    SELECT @id = [h].[Id] FROM [valeant].[human] [h] WHERE [h].[code] = @code

    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code,
		[h].LastLoginTime
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]
    WHERE [h].[Id] = @id

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id] AND [hr].[HumanId] = @id
END



GO
/****** Object:  StoredProcedure [valeant].[ReadHumanById]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[ReadHumanById]
    @id Bigint
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code,
		[h].LastLoginTime
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]
    WHERE [h].[Id] = @id

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id] AND [hr].[HumanId] = @id
END



GO
/****** Object:  StoredProcedure [valeant].[ReadHumanRoles]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadHumanRoles]
	@userAccount nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [r].[Id], [r].[Name], [r].[Code] FROM [valeant].[role] [r]
	INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id]
	INNER JOIN [valeant].[human] [h] ON [h].[Id] = [hr].[HumanId]
	WHERE [h].[UserAccount] = @userAccount
END






GO
/****** Object:  StoredProcedure [valeant].[ReadHumans]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadHumans]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ids TABLE(Id Bigint)
    INSERT INTO @ids 
    SELECT [h].[Id] FROM [valeant].[human] h 
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
    WHERE [e].[Status] != 2
    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code,
		[h].LastLoginTime
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        INNER JOIN @ids [ids] ON [ids].[Id] = [h].[Id]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id]
        INNER JOIN @ids [ids] ON [ids].[Id] = [hr].[HumanId]
END


GO
/****** Object:  StoredProcedure [valeant].[ReadLedgerEntry]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [valeant].[ReadLedgerEntry]
		@id nvarchar(255)= null,
		@from datetime   = null,
		@to   datetime   = null
AS
BEGIN

	SET NOCOUNT ON;

	
	SELECT 
	 [id], 
	 [EntryNumber],
	 [EntryKey],
	 [VendorNumber],
	 [DocumentNumber],
	 [DocumentType],
	 [PostingDate],
	 [Ammount],
	 [Description],
	 [PaymentPurpose], 
	 [PostingGroup],
	 [EntryType],
	  AmmountSum
	  FROM [valeant].[employeeledgerentry] as a
	  inner join ( select [VendorLedgerEntryNumber],SUM([Ammount]) as AmmountSum from [valeant].[employeeledgerentry] group by [VendorLedgerEntryNumber]) as b on a.VendorLedgerEntryNumber = b.[VendorLedgerEntryNumber]
	 where  ([VendorNumber]=@id or @id is null) and (@from < PostingDate or @from is null) and (@to >= PostingDate or @to is null)
	 	

	
	 	

END




GO
/****** Object:  StoredProcedure [valeant].[ReadLimits]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[ReadLimits] 
	@humanId bigint
AS
BEGIN
    SELECT [l].[Id], [d].[Title], [l].[limit], [r].[Code]
		FROM [valeant].[expenditures] [d]
		LEFT JOIN [valeant].[role] r on r.Id = d.ApproverRoleId
		INNER JOIN [valeant].[limits] [l] ON [d].[Id] = [l].[ExpenditureId]
		INNER JOIN [valeant].[employeepositiongroup] [g] ON [g].[id] = [l].[positiongroup]
		INNER JOIN [valeant].[employeeposition] [p] ON [p].[Group] = [l].[positiongroup]
		INNER JOIN [valeant].[employee] [e] ON [e].[Position] = [p].[Id]
		INNER JOIN [valeant].[human] [h] ON [e].[human] = [h].[id]
	WHERE [h].[id] = @humanId
	ORDER BY [d].[Title]
END

GO
/****** Object:  StoredProcedure [valeant].[readmime_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readmime_version_2] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [extension], [mime] FROM [valeant].[mime]
END




GO
/****** Object:  StoredProcedure [valeant].[readnodeclosure_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readnodeclosure_version_2] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [id], [ancestor], [descendant], [action], [value], [type], [straight], [notification] FROM [valeant].[nodeclosure_valeant_2]
END




GO
/****** Object:  StoredProcedure [valeant].[readnodeclosureaccesslist_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readnodeclosureaccesslist_version_2]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [nodeclosure], [token], [blockaccesslist]  FROM [valeant].[nodeclosureaccesslist_version_2]
END




GO
/****** Object:  StoredProcedure [valeant].[readnodes_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readnodes_version_2] 
AS
BEGIN
	SET NOCOUNT ON
	SELECT [id], [type], [id2], [description] FROM [valeant].[node_version_2]
END




GO
/****** Object:  StoredProcedure [valeant].[readnotification_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readnotification_version_2]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart] FROM [valeant].[notification]
END




GO
/****** Object:  StoredProcedure [valeant].[readparentdepartments]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readparentdepartments] 
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
/****** Object:  StoredProcedure [valeant].[ReadRoles]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadRoles]
AS
BEGIN
	SET NOCOUNT ON;
    SELECT [r].[Id], [r].[Name], [r].[Code] FROM [valeant].[role] r
END






GO
/****** Object:  StoredProcedure [valeant].[ReadSelectors]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadSelectors] 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [sm].[id], [dt].[id], [dt].[Value], [sm].[selectorid], [sel].[value], [sm].[next], [s].[Value], [sm].[selector], [s1].[value], [sm].[selectorresult], [sm].[notification] FROM [valeant].[selectormap] [sm]
	INNER JOIN [valeant].[statemap] [st] ON [st].[selector] = [sm].[selectorid]
	INNER JOIN [valeant].[documenttype] [dt] ON [dt].[Id] = [st].[type]
	INNER JOIN [valeant].[selector] [sel] ON [sel].[Id] = [sm].[selectorid]
	LEFT OUTER JOIN [valeant].[documentstate] [s] ON [sm].[next] = [s].[id]
	LEFT OUTER JOIN [valeant].[selector] [s1] ON [s1].[id] = [sm].[selector]

	SELECT [id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart] FROM [valeant].[notification]
END





GO
/****** Object:  StoredProcedure [valeant].[readselectors_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[readselectors_version_2]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [id],[name],[description] FROM [valeant].[selectors_version_2]
END




GO
/****** Object:  StoredProcedure [valeant].[ReadSettings]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadSettings]
	@name nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	IF(@name IS NULL)
    BEGIN
		SELECT [s].[id], [s].[name], [s].[value], [s].[description] FROM [valeant].[settings] [s]
	END
	ELSE
	BEGIN
		SELECT [s].[id], [s].[name], [s].[value], [s].[description] FROM [valeant].[settings] [s] WHERE [s].[name] = @name
	END
END





GO
/****** Object:  StoredProcedure [valeant].[ReadSimpleDictionary]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadSimpleDictionary] 
	@type nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @dictionaryType bigint
	SELECT @dictionaryType = [Id] FROM [valeant].[simpledictionarytype] [t] WHERE [t].[Value] = @type
	SELECT [Id], [Value] FROM [valeant].[simpledictionary] [sd]
    WHERE [sd].[Type] = @dictionaryType AND [Actual] = 1
END





GO
/****** Object:  StoredProcedure [valeant].[ReadSimpleDictionaryFull]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadSimpleDictionaryFull] 
	@typeName nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [d].[Id], [d].[Type], [d].[Value], [d].[Actual], [d].[Advansed], [d].[Reference], [d].[Flag], [d].[Flag1] FROM [valeant].[simpledictionary] [d]
	INNER JOIN [valeant].[simpledictionarytype] [t] ON [t].[Id] = [d].[Type]
	WHERE [t].[Value] = @typeName AND [d].[Actual] = 1
	ORDER BY [d].[Value]
END





GO
/****** Object:  StoredProcedure [valeant].[ReadStateMap]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadStateMap]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [sm].[Id], [dt].[id], [dt].[Value], [a].[id], [a].[action], [s1].[id], [s1].[value], [s2].[id], [s2].[value], [sel].[id], [sel].[value], [sm].[description], [sm].[notification]
	FROM [valeant].[statemap] [sm]
	INNER JOIN [valeant].[documenttype] [dt] ON [dt].[Id] = [sm].[type]
	INNER JOIN [valeant].[action] [a] ON [a].[id] = [sm].[action]
	INNER JOIN [valeant].[documentstate] [s1] ON [sm].[state] = [s1].[id]
	LEFT OUTER JOIN [valeant].[documentstate] [s2] ON [sm].[next] = [s2].[id]
	LEFT OUTER JOIN [valeant].[selector] [sel] ON [sel].[id] = [sm].[selector]
	SELECT [id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart] FROM [valeant].[notification]
END





GO
/****** Object:  StoredProcedure [valeant].[readstates_version_3]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[readstates_version_3]
AS
BEGIN
	SELECT [id],[name],[title] FROM [valeant].[states_version_3]
END




GO
/****** Object:  StoredProcedure [valeant].[ReadTokenMaps]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[ReadTokenMaps]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [m].[id], [type], [dt].[Value], [tokentype], [state], [s].[Value] FROM [valeant].[tokenmap] [m]
	INNER JOIN [valeant].[documenttype] [dt] ON [m].[type] = [dt].[id]
	INNER JOIN [valeant].[documentstate] [s] ON [m].[state] = [s].[Id]
END





GO
/****** Object:  StoredProcedure [valeant].[RegisterDepartmentStructure]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[RegisterDepartmentStructure]
	@country [valeant].[countryType] READONLY,
	@organization [valeant].[organizationType] READONLY,
	@costcenter [valeant].[costcenterType] READONLY,
	@department [valeant].[departmentType] READONLY,
	@departmentcondition [valeant].[departmentconditionType] READONLY,
	@employeeposition [valeant].[employeepositionType] READONLY,
	@human [valeant].[humanType] READONLY,
	@employee [valeant].[employeeType] READONLY,
	@defaultRole nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @createdTransaction bit
    IF @@TRANCOUNT = 0
    BEGIN
      SET @createdTransaction = 1
      SET XACT_ABORT ON
      BEGIN TRANSACTION
    END
	
	BEGIN TRY
		--регистрируем страну организации
		DECLARE @countryRows [valeant].[valeantrowType]
		MERGE [valeant].[country] AS [target]
		USING @country AS [source]
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [target].[Name] = [source].[Name]
		WHEN NOT MATCHED THEN
			INSERT ([Code], [Name])
			VALUES ([source].[Code], [source].[Name])
		OUTPUT inserted.Id, inserted.Code, $action INTO @countryRows;

		--регистрация организации
		DECLARE @organizationRows [valeant].[valeantrowType]
		MERGE [valeant].[organization] AS target
		USING (
			SELECT [o].[Code], [o].[Value], [cr].[Id] FROM @organization o
			INNER JOIN @countryRows cr ON [o].[Country] = [cr].[Code]
		) AS [source] ([Code], [Value], [Country])
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [target].Value = [source].Value, [target].Country = [source].Country
		WHEN NOT MATCHED THEN
			INSERT([Code], [Value], [Country])
			VALUES([source].[Code], [source].Value, [source].Country)
		OUTPUT inserted.Id, inserted.Code, $action INTO @organizationRows;

		--регистрация костов
		DECLARE @costcenterRows [valeant].[valeantrowType]
		MERGE [valeant].[costcenter] AS [target]
		USING @costcenter AS [source]
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [target].[Description] = [source].[Description]
		WHEN NOT MATCHED THEN
			INSERT([Code], [Description])
			VALUES([source].[Code], [source].[Description])
		OUTPUT inserted.Id, inserted.Code, $action INTO @costcenterRows;

		--регистрация департаментов
		DECLARE @departmentRows [valeant].[valeantrowType]
		MERGE [valeant].[department] AS [target]
		USING (
			SELECT [d].[Code], [d].[Name], [d].[Status], [o].[Id], [cc].[Id] FROM @department [d]
			INNER JOIN @organizationRows [o] ON [d].[Organization] = [o].[Code]
			LEFT OUTER JOIN @costcenterRows [cc] ON [d].[CostCenter] = [cc].[Code]
		 )
		AS [source] ([Code], [Name], [Status], [Organization], [CostCenter])
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET 
				[target].[Code] = [source].[Code],
				[target].[Name] = [source].[Name],
				[target].[Status] = [source].[Status],
				[target].[Organization] = [source].[Organization],
				[target].[CostCenter] = [source].[CostCenter]
		WHEN NOT MATCHED THEN
			INSERT([Code], [Name], [Status], [Organization], [CostCenter])
			VALUES([source].[Code], [source].[Name], [source].[Status], [source].[Organization], [source].[CostCenter])
		OUTPUT inserted.Id, inserted.Code, $action INTO @departmentRows;

		--структура департаментов
		UPDATE [d] SET [d].[Parent] = [dr].[Id]
		FROM [valeant].[department] [d]
		INNER JOIN @department [dd] ON [d].[Code] = [dd].[Code]
		INNER JOIN @departmentRows [dr] ON [dd].[Parent] = [dr].[Code]
		
		--состояние
		MERGE [valeant].[departmentcondition] AS [target]
		USING (
			SELECT [dr].[Id], [dc].[Name], [dc].[Value] FROM @departmentRows [dr]
			INNER JOIN @departmentcondition [dc] ON [dc].[Code] = [dr].[Code]
			)
		AS [source] ([Id], [Name], [Value])
		ON ([target].[IdDepartment] = [source].[Id] AND [target].[Name] = [source].[Name])
		WHEN MATCHED THEN 
			UPDATE SET [target].[Value] = [source].[Value]
		WHEN NOT MATCHED THEN
			INSERT([IdDepartment], [Name], [Value])
			VALUES([source].[Id], [source].[Name], [source].[Value]);

		--должности
		DECLARE @positionRows [valeant].[valeantrowType]
		MERGE [valeant].[employeeposition] AS [target]
		USING @employeeposition AS [source]
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [target].[Value] = [source].[Value]
		WHEN NOT MATCHED THEN
			INSERT([Code], [Value])
			VALUES([source].[Code], [source].[Value])
		OUTPUT inserted.Id, inserted.Code, $action INTO @positionRows;

		--люди
		DECLARE @humanRows [valeant].[valeantrowType]
		MERGE [valeant].[human] AS [target]
		USING @human AS [source]
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [FullName] = [source].[FullName],
			[Email] = [source].[Email],
			[DocumentSeries] = [source].[DocumentSeries],
			[DocumentNumber] = [source].[DocumentNumber],
			[DocumentIssuedOn] = [source].[DocumentIssuedOn],
			[DocumentIssuedBy] = [source].[DocumentIssuedBy],
			[UserAccount] = [source].[UserAccount]
		WHEN NOT MATCHED THEN
			INSERT([Code], [FullName], [Email], [DocumentSeries], [DocumentNumber], [DocumentIssuedOn], [DocumentIssuedBy], [UserAccount])
			VALUES(
				[source].[Code], 
				[source].[FullName], 
				[source].[Email], 
				[source].[DocumentSeries], 
				[source].[DocumentNumber], 
				[source].[DocumentIssuedOn], 
				[source].[DocumentIssuedBy], 
				[source].[UserAccount])
		OUTPUT inserted.Id, inserted.Code, $action INTO @humanRows;

		MERGE [valeant].[employee] AS [target]
		USING (
			SELECT [h].[Id], [e].[ClockNumber], [d].[Id], [p].[Id],[e].[Status], [h1].[Id], [h2].[Id], [c].[Id] FROM @employee [e]
			LEFT OUTER JOIN @humanRows [h] ON [e].[Human] = [h].[Code]
			LEFT OUTER JOIN @departmentRows [d] ON [e].[Department] = [d].[Code]
			LEFT OUTER JOIN @positionRows [p] ON [p].[Code] = [e].[Position]
			LEFT OUTER JOIN @humanRows h1 ON [e].[Manager1stLevel] = [h1].[Code]
			LEFT OUTER JOIN @humanRows h2 ON [e].[Manager2ndLevel] = [h2].[Code]
			LEFT OUTER JOIN @costcenterRows [c] ON [e].[CostCentre] = [c].[Code]
		) AS source ([human], [ClockNumber], [Department], [Position], [Status], [Manager1stLevel], [Manager2ndLevel], [CostCentre])
		ON ([target].[ClockNumber] = [source].[ClockNumber] AND [target].[human] = [source].[human])
		WHEN MATCHED THEN
			UPDATE SET 
				[Department] = [source].[Department],
				[Position] = [source].[Position],
				[Status] = [source].[Status],
				[Manager1stLevel] = [source].[Manager1stLevel],
				[Manager2ndLevel] = [source].[Manager2ndLevel],
				[CostCentre] = [source].[CostCentre]
		WHEN NOT MATCHED THEN
			INSERT([human], [ClockNumber], [Department], [Position], [Status], [Manager1stLevel], [Manager2ndLevel], [CostCentre])
			VALUES(
				[source].[human], 
				[source].[ClockNumber], 
				[source].[Department], 
				[source].[Position], 
				[source].[Status], 
				[source].[Manager1stLevel], 
				[source].[Manager2ndLevel], 
				[source].[CostCentre]);

		DECLARE @defaultRoleId Bigint
		SELECT TOP 1 @defaultRole = Id FROM [valeant].[role] WHERE [Name] = @defaultRole
		
		IF(NOT @defaultRole IS NULL)
		BEGIN
			MERGE [valeant].[humantorole] AS [target]
			USING @humanRows AS [source]
			ON [target].[HumanId] = [source].[Id] AND [target].[RoleId] = @defaultRole
			WHEN NOT MATCHED THEN
			INSERT ([HumanId], [RoleId])
			VALUES(Id, @defaultRole);
		END
		Update [valeant].[versions] set [version] = [version] + 1 where name = 'Structure'
	END TRY
	BEGIN CATCH
		IF @createdTransaction = 1 ROLLBACK TRANSACTION
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH;
    IF @createdTransaction = 1 COMMIT TRANSACTION
END







GO
/****** Object:  StoredProcedure [valeant].[removesimpledictionary_version_2]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[removesimpledictionary_version_2]
   @id bigint,
   @typeName nvarchar(255)
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @createdTransaction bit
  IF @@TRANCOUNT = 0
  BEGIN
    SET @createdTransaction = 1
    SET XACT_ABORT ON
    BEGIN TRANSACTION
  END
   BEGIN TRY
       DECLARE @typeId bigint
       SELECT @typeId = [id] FROM [valeant].[simpledictionarytype] WHERE [value] = @typeName
       IF @typeId IS NULL
       BEGIN
           RAISERROR(N'Не найден тип словаря', 16, 1)
       END
       UPDATE [valeant].[simpledictionary] SET [Actual] = 0 WHERE [id] = @id
       IF @createdTransaction = 1 COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
       IF @createdTransaction = 1 ROLLBACK TRANSACTION
       DECLARE @ErrorMessage NVARCHAR(4000);
       DECLARE @ErrorSeverity INT;
       DECLARE @ErrorState INT;
       SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
   END CATCH;

END



GO
/****** Object:  StoredProcedure [valeant].[spGetPrepaymentRequestsReport]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[spGetPrepaymentRequestsReport]
	@type int = null
AS
BEGIN
	SET NOCOUNT ON;
	select 
		a.Id,
		a.Number, 
		a.dateadvance as RequestDate, 
		e.ClockNumber as CreatorCode, 
		h.FullName as CreatorFullName,
		null as CreatorCity,
		a.[sum] as Summa,
		s.name as RequestStatus,
		history.Comment as StatusComment
	from valeant.advance a
		left join valeant.human h on h.Id = a.creator
		join valeant.employee e on e.human = h.Id 
		left join valeant.states_version_3 s on s.id = a.[state]
		outer apply (
			select top 1 Comment 
			from valeant.advancehistory 
			where Id = a.Id and Comment is not null
			order by [number] desc
			) history
	where (@type is null) or a.[type] = @type
END

GO
/****** Object:  StoredProcedure [valeant].[spGetPrepaymentRequestsReportFilter]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[spGetPrepaymentRequestsReportFilter]
    @type int = null,
	@start DateTimeOffset,
	@end DateTimeOffset
AS
BEGIN
	  select 
	    a.Id,
		a.Number, 
		a.dateadvance as RequestDate, 
		h.Code as CreatorCode, 
		h.FullName as CreatorFullName,
		null as CreatorCity,
		a.[sum] as Summa,
		s.name as RequestStatus,
		history.Comment as StatusComment
	from valeant.advance a
		left join valeant.human h on h.Id = a.creator
		left join valeant.states_version_3 s on s.id = a.[state]
		outer apply (
			select top 1 Comment 
			from valeant.advancehistory 
			where Id = a.Id and Comment is not null
			order by [number] desc
			) history
		WHERE (@type is null or a.[type] = @type) AND a.datecreate between @start and @end
END
GO
/****** Object:  StoredProcedure [valeant].[spGetTravelListsReportFilter]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[spGetTravelListsReportFilter]
    @type int = null,
	@start DateTimeOffset,
	@end DateTimeOffset
AS
BEGIN
	  select 
	    a.Id,
		a.Number, 
		a.dateadvance as RequestDate, 
		h.Code as CreatorCode, 
		h.FullName as CreatorFullName,
		null as CreatorCity,
		a.[sum] as Summa,
		s.name as RequestStatus,
		history.Comment as StatusComment
	from valeant.advance a
		left join valeant.human h on h.Id = a.creator
		left join valeant.states_version_3 s on s.id = a.[state]
		outer apply (
			select top 1 Comment 
			from valeant.advancehistory 
			where Id = a.Id and Comment is not null
			order by [number] desc
			) history
		WHERE (@type is null or a.[type] = @type) AND a.datecreate between @start and @end
END
GO
/****** Object:  StoredProcedure [valeant].[updateattachments]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [valeant].[updateattachments]
	@advance bigint,
	@attachment [valeant].[attachmenttype] READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @createdTransaction bit
    IF @@TRANCOUNT = 0
    BEGIN
      SET @createdTransaction = 1
      SET XACT_ABORT ON
      BEGIN TRANSACTION
    END
	BEGIN TRY
		DECLARE @ids [valeant].[BigintTable]
		MERGE [valeant].[attachments] AS [target]
		USING @attachment AS source
		ON ([target].[advance] = @advance AND [target].[urn] = [source].[urn])
		WHEN NOT MATCHED THEN
		INSERT ([advance], [urn], [content-type])
		VALUES (@advance, [source].[urn], [source].[content-type]);
	
		INSERT INTO @ids
		SELECT [a].[id]
		FROM [valeant].[attachments] [a]
		WHERE [a].[advance] = @advance AND [a].[urn] NOT IN
		(SELECT [a1].[urn] FROM @attachment [a1])

		SELECT [urn] FROM [valeant].[attachments] [a]
		INNER JOIN @ids [ids] ON [ids].[Id] = [a].[id]

		DELETE [a]
		FROM [valeant].[attachments] [a]
		INNER JOIN @ids [ids] ON [ids].[Id] = [a].[id]
		IF @createdTransaction = 1 COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @createdTransaction = 1 ROLLBACK TRANSACTION
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH;
END




GO
/****** Object:  StoredProcedure [valeant].[UpdateHuman]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[UpdateHuman] 
 @id bigint,
 @assistantId bigint,
 @deputyId bigint,
 @deputyDateStart datetimeoffset=NULL,
 @deputyDateEnd datetimeoffset=NULL,
 @roles [valeant].[BigintTable] READONLY
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @createdTransaction bit
    IF @@TRANCOUNT = 0
    BEGIN
      SET @createdTransaction = 1
      SET XACT_ABORT ON
      BEGIN TRANSACTION
    END
 BEGIN TRY
  UPDATE [valeant].[human]
   SET 
    [AssistantId] = @assistantId,
    [DeputyId] = @deputyId,
    [DeputyDateStart] = @deputyDateStart,
    [DeputyDateEnd] = @deputyDateEnd
  WHERE [Id] = @id
  DELETE FROM [valeant].[humantorole] WHERE [HumanId] = @id AND [RoleId] NOT IN (SELECT Id FROM @roles)
   MERGE [valeant].[humantorole] as target
   USING @roles AS source
   ON target.[HumanId] = @id AND target.[RoleId] = source.[Id]
   WHEN NOT MATCHED THEN
   INSERT ([HumanId], [RoleId])
   VALUES(@id, source.[Id]);
  Update [valeant].[versions] set [version] = [version] + 1 where name = 'Structure'
  IF @createdTransaction = 1 COMMIT TRANSACTION
 END TRY
 BEGIN CATCH
  IF @createdTransaction = 1 ROLLBACK TRANSACTION
  DECLARE @ErrorMessage NVARCHAR(4000);
  DECLARE @ErrorSeverity INT;
  DECLARE @ErrorState INT;
  SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
 END CATCH;
END


GO
/****** Object:  StoredProcedure [valeant].[UpdateHumanLastLoginTime]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[UpdateHumanLastLoginTime]
    @userAccount nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id Bigint    
    SELECT @id = [h].[Id] FROM [valeant].[human] [h] WHERE [h].[UserAccount] = @userAccount

    update[valeant].[human]
        set LastLoginTime = GETDATE()
    WHERE [Id] = @id
END


GO
/****** Object:  StoredProcedure [valeant].[UpdateHumanProfile]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[UpdateHumanProfile] 
 @id bigint,
 @tel nvarchar(16) = null,
 @LoyaltyCards nvarchar(250) = null,
 @InternationalPassportFirstName nvarchar(250) = null,
 @InternationalPassportLastName nvarchar(250) = null,
 @InternationalPassportBirthPlace nvarchar(250) = null,
 @NumberInternationalPassport nvarchar(20) = null,
 @InternationalPassportIssueDate datetime = null,
 @InternationalPassportExpiryDate datetime = null,
 @FuelCard    bigint =null
 AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @createdTransaction bit
    IF @@TRANCOUNT = 0
    BEGIN
      SET @createdTransaction = 1
      SET XACT_ABORT ON
      BEGIN TRANSACTION
    END
 BEGIN TRY
  UPDATE [valeant].[human]
   SET 
    [Tel] = @tel,
    [LoyaltyCards] = @LoyaltyCards,
    InternationalPassportFirstName = @InternationalPassportFirstName,
    InternationalPassportLastName = @InternationalPassportLastName,
    InternationalPassportBirthPlace = @InternationalPassportBirthPlace,
    NumberInternationalPassport = @NumberInternationalPassport,
    InternationalPassportIssueDate = @InternationalPassportIssueDate,
    InternationalPassportExpiryDate = @InternationalPassportExpiryDate
  WHERE [Id] = @id

   UPDATE [valeant].[employee]
   SET 
    [FuelCard] = @FuelCard
   
   WHERE [Human] = @id

  Update [valeant].[versions] set [version] = [version] + 1 where name = 'Structure'
  IF @createdTransaction = 1 COMMIT TRANSACTION
 END TRY
 BEGIN CATCH
  IF @createdTransaction = 1 ROLLBACK TRANSACTION
  DECLARE @ErrorMessage NVARCHAR(4000);
  DECLARE @ErrorSeverity INT;
  DECLARE @ErrorState INT;
  SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
 END CATCH;
END


GO
/****** Object:  StoredProcedure [valeant].[UpdateUserRoles]    Script Date: 6/29/2016 3:59:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[UpdateUserRoles]
	@humanId Bigint,
	@roles [valeant].[BigintTable] READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @createdTransaction bit
    IF @@TRANCOUNT = 0
    BEGIN
      SET @createdTransaction = 1
      SET XACT_ABORT ON
      BEGIN TRANSACTION
    END
	BEGIN TRY
		IF(EXISTS(SELECT Id FROM [valeant].[human] WHERE Id = @humanId))
		BEGIN
			DELETE FROM [valeant].[humantorole] WHERE [HumanId] = @humanId AND [RoleId] NOT IN (SELECT Id FROM @roles)
			MERGE [valeant].[humantorole] as target
			USING @roles AS source
			ON target.[HumanId] = @humanId AND target.[RoleId] = source.[Id]
			WHEN NOT MATCHED THEN
			INSERT ([HumanId], [RoleId])
			VALUES(@humanId, source.[Id]);
		END
	END TRY
	BEGIN CATCH
		IF @createdTransaction = 1 ROLLBACK TRANSACTION
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH;
    IF @createdTransaction = 1 COMMIT TRANSACTION
	
END





GO
