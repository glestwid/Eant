

/****** Object:  Table [valeant].[employeeledgerentry]    Script Date: 6/23/2016 6:14:26 PM ******/
DROP TABLE [valeant].[employeeledgerentry]
GO

/****** Object:  Table [valeant].[employeeledgerentry]    Script Date: 6/23/2016 6:14:26 PM ******/
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


/****** Object:  StoredProcedure [valeant].[InsertLedgerEntry]    Script Date: 6/23/2016 6:15:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [valeant].[InsertLedgerEntry]
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


/****** Object:  StoredProcedure [valeant].[ReadLedgerEntry]    Script Date: 6/23/2016 6:15:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [valeant].[ReadLedgerEntry]
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




