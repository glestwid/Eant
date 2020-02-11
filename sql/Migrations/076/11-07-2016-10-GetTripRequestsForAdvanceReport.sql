USE [valeant]
GO
/****** Object:  StoredProcedure [valeant].[readadvanceall_version_3]    Script Date: 11.07.2016 15:55:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [valeant].[GetTripRequestsForAdvanceReport]
@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
 
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]
		INNER JOIN [valeant].[advance] [ad] ON [a].[id] = [ad].[Id]
		

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
		  where type = 2
		  AND ( SELECT TOP 1 [aa].content.value('(/AdvanceTripReportDataEx//MainData/TripRequest/Id)[1]', 'bigint') tripId
				FROM [valeant].[advance] [aa]
				INNER JOIN [valeant].[states_version_3] [ss] ON ss.[Id] = [state]
				WHERE (ss.name LIKE '%соглас%' OR ss.name = 'Черновик' OR ss.name = 'Утверждена' )
				AND aa.[type] = 4
				AND [aa].content.value('(/AdvanceTripReportDataEx//MainData/TripRequest/Id)[1]', 'bigint') = [a].Id
			) IS NULL
		  ORDER BY number DESC

		  --SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  --INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  --ORDER BY [id]

		  --SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  --INNER JOIN @ids [ids] ON [ids].[Id] = [m].[advanceId]
		  --ORDER BY [m].[advanceId]
	END 

