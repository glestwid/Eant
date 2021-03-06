USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[ReadLedgerEntry]    Script Date: 21.06.2016 22:51:07 ******/
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
	 (select SUM([Ammount]) FROM [valeant].[employeeledgerentry] GROUP BY  [EntryNumber]) as AmmountSum
	  FROM [valeant].[employeeledgerentry]  WHERE ([PostingDate] >=@from OR @from is null) AND  ([PostingDate]<=@to  or @to is null) and (VendorNumber =@id or @id is null)
	 
	
	 	

END


