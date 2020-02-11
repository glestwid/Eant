USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[CreateNewTravelNumber]    Script Date: 4/1/2016 2:47:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[CreateNewTravelNumber] 
	@number bigint OUT
AS
BEGIN
	SET NOCOUNT ON;
	declare @type bigint
	select @type=id from [valeant].[documenttype] where Value=N'Заявка на командировку/служебную поездку'
	exec [valeant].[GetNextNumber] @type, @number OUTPUT
END


