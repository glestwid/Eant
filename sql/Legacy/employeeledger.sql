USE [Valeant]
GO

/****** Object:  StoredProcedure [valeant].[InsertLedgerEntry]    Script Date: 18.04.2016 13:41:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [valeant].[InsertLedgerEntry]
	-- Add the parameters for the stored procedure here
	@number int,
	@entrykey NVARCHAR(255),
	@vendornumber NVARCHAR(50),
	@documentnumber NVARCHAR(255),
	@documenttype NVARCHAR(255),
	@ammount money

AS
BEGIN
	
	SET NOCOUNT ON;

    INSERT INTO [valeant].[employeeledgerentry] 
	([EntryNumber],
	[EntryKey],
	[VendorNumber],
	[DocumentNumber],
	[DocumentType],
	[Ammount])
	VALUES 
	(@number,
	 @entrykey,
	 @vendornumber,
	 @documentnumber,
	 @documenttype,
	 @ammount)
	
END

GO

/****** Object:  StoredProcedure [valeant].[ClearLedgerEntries]    Script Date: 18.04.2016 13:41:39 ******/
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

USE [Valeant]
GO

/****** Object:  Table [valeant].[employeeledgerentry]    Script Date: 18.04.2016 13:42:59 ******/
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
	[Ammount] [money] NULL,
 CONSTRAINT [PK_ledgerentry] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  StoredProcedure [valeant].[ReadLedgerEntry]    Script Date: 18.04.2016 18:25:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [valeant].[ReadLedgerEntry]
		@id nvarchar(255)
AS
BEGIN

	SET NOCOUNT ON;
SET NOCOUNT ON;
    IF(@id IS NULL)
	 BEGIN
	   SELECT * FROM [valeant].[employeeledgerentry]
	 END
	 ELSE
	 BEGIN
	   SELECT * FROM [valeant].[employeeledgerentry] WHERE [valeant].[employeeledgerentry].VendorNumber =@id
	 END


END

GO






