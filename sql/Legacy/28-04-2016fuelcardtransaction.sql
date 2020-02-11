USE [Valeant]
GO

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


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-
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




