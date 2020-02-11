USE [Valeant]
GO
/****** Object:  Table [valeant].[employeeledgerentry]    Script Date: 05.05.2016 12:30:58 ******/
DROP TABLE [valeant].[employeeledgerentry]
GO

/****** Object:  Table [valeant].[employeeledgerentry]    Script Date: 05.05.2016 12:30:58 ******/
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
 CONSTRAINT [PK_ledgerentry] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [valeant].[InsertLedgerEntry]
    -- Add the parameters for the stored procedure here
    @number int,
    @entrykey NVARCHAR(255),
    @vendornumber NVARCHAR(50),
    @documentnumber NVARCHAR(255),
    @documenttype NVARCHAR(255),
	@postingdate DATETIME,
    @ammount money,
	@description NVARCHAR(255),
	@paymentpurpose NVARCHAR(255)



AS
BEGIN
    
    SET NOCOUNT ON;

    DELETE FROM [valeant].[employeeledgerentry] where [EntryNumber] = @number

    INSERT INTO [valeant].[employeeledgerentry] 
    ([EntryNumber],
    [EntryKey],
    [VendorNumber],
    [DocumentNumber],
    [DocumentType],
	[PostingDate],
    [Ammount],
	[Description],
    [PaymentPurpose]

	)
    VALUES 
    (@number,
     @entrykey,
     @vendornumber,
     @documentnumber,
     @documenttype,
	 @postingdate,
     @ammount,
	 @description,
	 @paymentpurpose)
    
END

GO

USE [Valeant]
GO

