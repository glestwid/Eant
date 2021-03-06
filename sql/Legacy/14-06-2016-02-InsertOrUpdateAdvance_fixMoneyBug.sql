IF OBJECT_ID('valeant.InsertOrUpdateAdvance') IS NULL
    EXEC('CREATE PROCEDURE valeant.InsertOrUpdateAdvance AS SET NOCOUNT ON;')
GO


ALTER PROCEDURE [valeant].[InsertOrUpdateAdvance]
	@id bigint OUT,
	@number bigint OUT,
	@dateadvance datetimeoffset,
	@type nvarchar(255),
	@sum money,
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
