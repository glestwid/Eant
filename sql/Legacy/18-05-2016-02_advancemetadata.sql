USE [valeant]
GO

/****** Object:  Table [dbo].[ActivityMetadata]    Script Date: 17.05.2016 23:14:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [valeant].[advancemetadata](
	[advanceId] [bigint] NOT NULL,
	[Property] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](255) NULL,
 CONSTRAINT [PK_DefinitionMetadata] PRIMARY KEY CLUSTERED 
(
	[advanceId] ASC,
	[Property] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [valeant].[advancemetadata]  WITH CHECK ADD  CONSTRAINT [FK_advancemetadata_advance] FOREIGN KEY([advanceId])
REFERENCES [valeant].[advance] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [valeant].[advancemetadata] CHECK CONSTRAINT [FK_advancemetadata_advance]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [valeant].[readadvanceall_version_3]
	@id bigint,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
    IF(@id IS NULL)
	BEGIN
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
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [valeant].[readadvance_version_3]
	@id bigint,
	@documentType nvarchar(255),
	@dateStart datetimeoffset, 
	@dateEnd datetimeoffset,
	@tokens [valeant].[NVarchar255Table] READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @documentTypeId bigint
	SELECT @documentTypeId = [d].[Id] FROM [valeant].[documenttype] [d] WHERE [d].[Value] = @documentType
    IF(@id IS NULL)
	BEGIN
		DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN [valeant].[advance] [ad] ON [ad].[Id] = [a].[Id]
		INNER JOIN @tokens [t] ON [t].[value] = [a].[token]
		WHERE [ad].[type] = @documentTypeId AND [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

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
			  ,[ep].[Value] as Position
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 
		  LEFT JOIN [valeant].[employeeposition] [ep] ON [ep].Id = [e].Position
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
			  ,[ep].[Value] as Position
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].[states_version_3] [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  LEFT JOIN [valeant].[employeeposition] [ep] ON [ep].Id = [e].Position
		  WHERE [t].Id = @documentTypeId AND [a].[id] = @id

		  SELECT [a].[id], [a].[token], [a].[tokent] FROM [valeant].[advancetoken] [a]
		  WHERE [a].[id] = @id

		  SELECT [m].[advanceId], [m].[Property], [Value] FROM [valeant].[advancemetadata] [m]
		  WHERE [m].[advanceId] = @id
	END
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [valeant].[readadvanceallfilter_version_3]
	@id bigint,
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

GO

CREATE TYPE [valeant].[metadatavalues] AS TABLE(
	[Property] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](255) NULL
)

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [valeant].[InsertOrUpdateAdvance]
	@id bigint OUT,
	@number bigint OUT,
	@dateadvance datetimeoffset,
	@type nvarchar(255),
	@sum bigint,
	@state nvarchar(255),
	@datatype nvarchar(1024),
	@action nvarchar(1024),
	@content xml,
	@creator bigint,
	@datecreate datetimeoffset,
	@comment nvarchar(MAX),
	@approvalSheet nvarchar(MAX),
	@clearapprovalsheet bit,
	@processsubtype nvarchar(2),
	@tokens [valeant].[token] READONLY,
	@metadata [valeant].[metadatavalues] READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @createdTransaction bit
    IF @@TRANCOUNT = 0
    BEGIN
      SET @createdTransaction = 1
      SET XACT_ABORT ON
      BEGIN TRANSACTION
    END
	BEGIN TRY
		DECLARE @idA bigint
		DECLARE @contenttype bigint
		DECLARE @documentstate bigint
		DECLARE @documenttype bigint
		DECLARE @advanceId bigint
		DECLARE @actionId bigint
		DECLARE @map bigint
		--SELECT @number = ISNULL(MAX([number]),0) FROM [valeant].[advance] WITH (TABLOCK, HOLDLOCK)
		SELECT @contenttype = [Id] FROM [valeant].[contenttype] WHERE [Value] = @datatype
		SELECT @documentstate = [Id] FROM [valeant].[states_version_3] WHERE [name] = @state
		SELECT @documenttype = [Id] FROM [valeant].[documenttype] WHERE [Value] = @type
		SELECT @idA = MAX([a].[number]) FROM [valeant].[advance] [a] WITH (UPDLOCK, HOLDLOCK) WHERE [a].[type] = @documenttype
		SELECT @actionId = Id FROM [valeant].[actions_version_2] WHERE [name] = @action
		IF(@action IS NULL)
		BEGIN
			SET @actionId = -1
		END
		ELSE
		BEGIN
			SELECT @actionId = Id FROM [valeant].[action] WHERE [action] = @action
		END

		SELECT @map = [id] FROM [valeant].[historymap] WHERE [actionid] = @actionId AND [documentid] = @documenttype
		IF(@contenttype IS NULL)
		BEGIN
			DECLARE @ids TABLE(Id bigint)
			INSERT INTO [valeant].[contenttype]
			OUTPUT inserted.Id INTO @ids
			VALUES(@datatype)
			SELECT @contenttype = Id FROM @ids
		END
		IF(@id IS NULL)
		BEGIN
			DECLARE @aids [valeant].[BigintTable]
			EXEC [valeant].[GetNextNumber] @documenttype, @number OUTPUT
			INSERT INTO [valeant].[advance]
				([number]
				,[dateadvance]
				,[type]
				,[sum]
				,[state]
				,[datatype]
				,[content]
				,[creator]
				,[approvalSheet]
				,[processsubtype]
				,[datecreate])
			OUTPUT inserted.Id INTO @aids
			VALUES(@number, @dateadvance, @documenttype, @sum, @documentstate, @contenttype, @content, @creator, @approvalSheet, @processsubtype, @datecreate)
			SELECT @advanceId = Id FROM @aids
		END
		ELSE
		BEGIN
			SET @advanceId = @id
			UPDATE [valeant].[advance]
				SET	[sum] = @sum
				,[state] = @documentstate
				,[datatype] = @contenttype
				,[content] = @content
				,[approvalSheet] = CASE @clearapprovalsheet WHEN 1 THEN NULL ELSE @approvalSheet END
				WHERE 
				Id = @id
			SELECT @number = [number] FROM [valeant].[advance] WHERE Id = @id
		END
		DELETE FROM [valeant].[advancetoken] WHERE [id] = @advanceId
		INSERT INTO [valeant].[advancetoken]
		SELECT @advanceId, [Token], [Tokent] FROM @tokens

		DECLARE @metadataCount int 
		SELECT @metadataCount = COUNT(*) FROM @metadata

		IF(@map IS NOT NULL)
		BEGIN
			DECLARE @numberHistory INT
			SELECT @numberHistory = ISNULL(MAX(number),0) FROM [valeant].[advancehistory] [h] WHERE [h].[id] = @advanceId
			INSERT INTO [valeant].[advancehistory]
			VALUES(@advanceId, @numberHistory + 1, @datecreate, @creator, @map, @comment)
		END	

		IF(@metadataCount > 0)
		BEGIN
			DELETE FROM [valeant].[advancemetadata] WHERE advanceId = @advanceId
			INSERT INTO [valeant].[advancemetadata]
			SELECT @advanceId, Property, Value FROM @Metadata
		END

		SET @id = @advanceId
		IF @createdTransaction = 1 COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @createdTransaction = 1 ROLLBACK TRANSACTION
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH;
END
