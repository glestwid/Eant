use valeant;
CREATE TABLE [valeant].[SequenceGenerator](Sequence BIGINT)
GO
INSERT INTO [valeant].[SequenceGenerator] SELECT 0
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[GetNextTripRequestTKNumber]
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
		SET NOCOUNT ON;
		DECLARE @NextSequence BIGINT
		UPDATE [valeant].[SequenceGenerator] 
		SET @NextSequence = Sequence = Sequence + 1
		SELECT [Sequence] FROM [valeant].[SequenceGenerator]
		IF @createdTransaction > 0
		BEGIN
			COMMIT TRANSACTION
		END
	END TRY
	BEGIN CATCH
		IF @createdTransaction > 0
		BEGIN
			ROLLBACK TRANSACTION
			DECLARE @ErrorMessage NVARCHAR(4000);
			DECLARE @ErrorSeverity INT;
			DECLARE @ErrorState INT;
			SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		END
	END CATCH
END
GO