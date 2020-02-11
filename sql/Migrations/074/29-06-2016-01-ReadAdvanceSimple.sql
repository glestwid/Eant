USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[ReadAdvanceSimple]    Script Date: 6/29/2016 1:07:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [valeant].[ReadAdvanceSimple] 
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




