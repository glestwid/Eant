

/****** Object:  Table [valeant].[employeeledgerentry]    Script Date: 25.05.2016 13:46:29 ******/
DROP TABLE [valeant].[employeeledgerentry]
GO

/****** Object:  Table [valeant].[employeeledgerentry]    Script Date: 25.05.2016 13:46:29 ******/
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
 CONSTRAINT [PK_ledgerentry] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [Valeant]
GO

/****** Object:  StoredProcedure [valeant].[InsertLedgerEntry]    Script Date: 25.05.2016 13:47:16 ******/
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
	@paymentpurpose NVARCHAR(255),
    @postinggroup NVARCHAR(255),
	@entrytype  int        




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
    [PaymentPurpose],
	[PostingGroup],
	[EntryType]


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
	 @paymentpurpose,
	 @postinggroup,
	 @entrytype)
    
END



/****** Object:  StoredProcedure [valeant].[ReadLedgerEntry]    Script Date: 22.05.2016 21:36:19 ******/
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

	IF ( NOT (@from  IS NULL)  AND NOT (@to IS NULL) )
	BEGIN
	 IF(@id IS NULL)
	 BEGIN
	   SELECT * FROM [valeant].[employeeledgerentry] WHERE [PostingDate] >=@from AND  [PostingDate]<=@to  
	 END
	 ELSE
	 BEGIN
	   SELECT * FROM [valeant].[employeeledgerentry] WHERE [valeant].[employeeledgerentry].VendorNumber =@id AND [PostingDate] >=@from AND  [PostingDate]<= @to
	 END
	END
	ELSE 
	BEGIN
    IF(@id IS NULL)
	 BEGIN
	   SELECT * FROM [valeant].[employeeledgerentry]
	 END
	 ELSE
	 BEGIN
	   SELECT * FROM [valeant].[employeeledgerentry] WHERE [valeant].[employeeledgerentry].VendorNumber =@id
	 END
    END


END


GO
/****** Object:  StoredProcedure [valeant].[ReadFuelCradTransactions]    Script Date: 26.05.2016 19:59:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [valeant].[ReadFuelCradTransactions] 
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

