

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

