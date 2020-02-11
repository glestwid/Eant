USE [valeant]
GO
/****** Object:  StoredProcedure [valeant].[readadvanceallfilter_version_3]    Script Date: 08.07.2016 14:38:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [valeant].[readadvanceallfilter_version_3]
	@id bigint,
	@statusName nvarchar(255),
	@dateStart datetimeoffset, 
	@dateEnd datetimeoffset,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
    IF(@id IS NULL)
	BEGIN
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN [valeant].[advance] [ad] ON [ad].[Id] = [a].[Id]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]
		INNER JOIN [valeant].[states_version_3] [s] ON [s].[id] = [ad].[state] AND [s].[name] like @statusName + '%'
		WHERE [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

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
		  ORDER BY number DESC

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id]
		  ORDER BY [id]

		  SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [m].[advanceId]
		  ORDER BY [m].[advanceId]
	END 
	ELSE
	BEGIN
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
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  WHERE [a].[id] = @id

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  WHERE [a].[id] = @id

		  SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  WHERE [m].[advanceId] = @id
	END
END

