USE [valeant]
GO

DECLARE @ids [valeant].[BigintTable]

INSERT INTO [valeant].[simpledictionarytype] ([Value])
OUTPUT INSERTED.Id INTO @ids VALUES ('GiftSumLimit')

declare @id int
select top 1 @id = Id from @ids

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Лимит на подарки', 1, 4000, NULL, NULL, NULL)

GO

INSERT INTO [valeant].[simpledictionarytype] ([Value])  VALUES ('GiftRecievers')

GO

ALTER TABLE [valeant].[simpledictionary]
ALTER COLUMN [Advansed] nvarchar(max)

GO

USE [valeant]
GO
/****** Object:  StoredProcedure [valeant].[insertorupdatesimpledictionary_version_2]    Script Date: 27.05.2016 11:56:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [valeant].[insertorupdatesimpledictionary_version_2] 
   @id bigint,
   @typeName nvarchar(255),
   @value nvarchar(1024),
   @advansed nvarchar(max),
   @reference bigint,
   @flag bit,
   @flag1 bit
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
       DECLARE @typeId int
       SELECT @typeId = [id] FROM [valeant].[simpledictionarytype] WHERE [value] = @typeName
       IF @typeId IS NULL
       BEGIN
           RAISERROR(N'Не найден тип словаря', 16, 1)
       END
       IF(@id IS NULL)
       BEGIN
           INSERT INTO [valeant].[simpledictionary]([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
           VALUES(@typeId, @value, 1, @advansed, @reference, @flag, @flag1)
       END
       ELSE
       BEGIN
           UPDATE [valeant].[simpledictionary] SET 
               [value] = @value,
               [Advansed] = @advansed, 
               [Reference] = @reference,
               [Flag] = @flag,
               [Flag1] = @flag1
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





