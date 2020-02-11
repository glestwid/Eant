USE [Valeant]
GO

/****** Object:  StoredProcedure [valeant].[UpdateHumanProfile]    Script Date: 17.05.2016 18:36:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [valeant].[UpdateHumanProfile] 
 @id bigint,
 @tel nvarchar(16) = null,
 @LoyaltyCards nvarchar(250) = null,
 @InternationalPassportFirstName nvarchar(250) = null,
 @InternationalPassportLastName nvarchar(250) = null,
 @InternationalPassportBirthPlace nvarchar(250) = null,
 @NumberInternationalPassport nvarchar(20) = null,
 @InternationalPassportIssueDate datetime = null,
 @InternationalPassportExpiryDate datetime = null,
 @FuelCard    bigint =null
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
  UPDATE [valeant].[human]
   SET 
    [Tel] = @tel,
    [LoyaltyCards] = @LoyaltyCards,
    InternationalPassportFirstName = @InternationalPassportFirstName,
    InternationalPassportLastName = @InternationalPassportLastName,
    InternationalPassportBirthPlace = @InternationalPassportBirthPlace,
    NumberInternationalPassport = @NumberInternationalPassport,
    InternationalPassportIssueDate = @InternationalPassportIssueDate,
    InternationalPassportExpiryDate = @InternationalPassportExpiryDate
  WHERE [Id] = @id

   UPDATE [valeant].[employee]
   SET 
    [FuelCard] = @FuelCard
   
   WHERE [Human] = @id

  Update [valeant].[versions] set [version] = [version] + 1 where name = 'Structure'
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

