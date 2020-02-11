USE [Valeant]
GO

/****** Object:  StoredProcedure [valeant].[InsertOrUpdateCostCenter]    Script Date: 18.07.2016 21:50:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF OBJECT_ID('valeant.InsertOrUpdateCostCenter') IS NULL
    EXEC('CREATE PROCEDURE valeant.InsertOrUpdateCostCenter AS SET NOCOUNT ON;')
GO


ALTER PROCEDURE [valeant].[InsertOrUpdateCostCenter]
   @id bigint,
   @code nvarchar(20),
   @description nvarchar(2000)
   
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
       
       IF(@id IS NULL)
       BEGIN
           INSERT INTO [valeant].[costcenter]([Code], [Description])
           VALUES(@code, @description)
       END
       ELSE
       BEGIN
           UPDATE [valeant].[costcenter] SET 
               [Code] = @code,
               [Description] = @description
           WHERE 
               [id] = @id
       END
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


GO
