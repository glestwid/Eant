SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE valeant.advancehistory ADD
	Comment nvarchar(MAX) NULL
GO
ALTER TABLE valeant.advancehistory SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO
ALTER PROCEDURE [valeant].[ReadHIstory]
	@id bigint,
	@document nvarchar(256)
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @documenttype bigint
	SELECT @documenttype = [Id] FROM [valeant].[documenttype] WHERE [Value] = @document
	SELECT [hi].[id], [hi].[number], [hi].[date], [h].[fullname], [m].[history], [hi].[Comment] FROM [valeant].[advancehistory] [hi]
	INNER JOIN [valeant].[human] [h] ON [h].[id] = [hi].[Creator]
	INNER JOIN [valeant].[historymap] [m] ON [m].[id] = [hi].[map]
	WHERE [hi].[id] = @id
	ORDER BY [hi].[number]
END 
GO
USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[InsertOrUpdateAdvance]    Script Date: 20.03.2016 13:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
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
	@tokens [valeant].[token] READONLY
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
		SELECT @documentstate = [Id] FROM [valeant].[states_version_2] WHERE [name] = @state
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
				,[datecreate])
			OUTPUT inserted.Id INTO @aids
			VALUES(@number, @dateadvance, @documenttype, @sum, @documentstate, @contenttype, @content, @creator, @datecreate)
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
				WHERE 
				Id = @id
			SELECT @number = [number] FROM [valeant].[advance] WHERE Id = @id
		END
		DELETE FROM [valeant].[advancetoken] WHERE [id] = @advanceId
		INSERT INTO [valeant].[advancetoken]
		SELECT @advanceId, [Token], [Tokent] FROM @tokens

		IF(@map IS NOT NULL)
		BEGIN
			DECLARE @numberHistory INT
			SELECT @numberHistory = ISNULL(MAX(number),0) FROM [valeant].[advancehistory] [h] WHERE [h].[id] = @advanceId
			INSERT INTO [valeant].[advancehistory]
			VALUES(@advanceId, @numberHistory + 1, @datecreate, @creator, @map, @comment)
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

GO
TRUNCATE TABLE [valeant].[notification]
GO
SET IDENTITY_INSERT [valeant].[notification] ON 

INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (1, N'ApproveAdvanceNotificationSubjectTemplate', N'ApproveAdvanceNotificationTemplate', N'#/approval', N'#/requests/newPrepaymentRequest?id={0}&action=Согласовать&prevState=approval')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (3, N'ApproveTripNotificationSubjectTemplate', N'ApproveTripNotificationTemplate', N'#/approval', N'#/requests/tripRequests/newTripRequest?id={0}&action=Согласовать&prevState=approval')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (4, N'RevisionTripNotificationSubjectTemplate', N'RevisionTripNotificationTemplate', N'#/approval', N'#/requests/tripRequests/newTripRequest?id={0}&action=Отправить&prevState=tripRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (5, N'RefusingTripNotificationSubjectTemplate', N'RefusingTripNotificationTemplate', N'#/approval', N'#/requests/tripRequests/newTripRequest?id={0}&action=Просмотр&prevState=tripRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (6, N'RevisionAdvanceNotificationSubjectTemplate', N'RevisionAdvanceNotificationTemplate', N'#/approval', N'#/requests/newPrepaymentRequest?id={0}&action=Отправить&prevState=prepaymentRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (7, N'RefusingAdvanceNotificationSubjectTemplate', N'RefusingAdvanceNotificationTemplate', N'#/approval', N'#/requests/newPrepaymentRequest?id={0}&action=Просмотр&prevState=prepaymentRequests')
INSERT [valeant].[notification] ([id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart]) VALUES (9, N'ApprovedAdvanceNotificationSubjectTemplate', N'ApprovedAdvanceNotificationTemplate', N'#/approval', N'#/requests/newPrepaymentRequest?id={0}&action=Просмотр&prevState=prepaymentRequests')

SET IDENTITY_INSERT [valeant].[notification] OFF

GO

UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 1 WHERE [id] = 13
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 6 WHERE [id] = 18
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 1 WHERE [id] = 26
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 1 WHERE [id] = 34
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 9 WHERE [id] = 35
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 7 WHERE [id] = 37
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 3 WHERE [id] = 53
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 3 WHERE [id] = 59
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 3 WHERE [id] = 65
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 3 WHERE [id] = 71
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 3 WHERE [id] = 79
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 5 WHERE [id] = 84
UPDATE [valeant].[nodeclosure_valeant_2] SET [notification] = 4 WHERE [id] = 92

GO  

UPDATE [valeant].[human] SET [UserAccount] = @AntonAndreevNewAccount, [EMail] = 'Anton.Andreev@valeant.com' WHERE [Code] = '01-000001207'
UPDATE [valeant].[human] SET [UserAccount] = @AlexandraBelousovaNewAccount, [EMail] = 'Alexandra.Belousova@valeant.com' WHERE [Code] = '01-000001141'
UPDATE [valeant].[human] SET [UserAccount] = @VladimirGudkovNewAccount, [EMail] = 'Vladimir.Gudkov@valeant.com' WHERE [Code] = '01-000000594'
UPDATE [valeant].[human] SET [UserAccount] = @johnconnollyNewAccount, [EMail] = 'John.Connolly@valeant.com' WHERE [Code] = '01-000000393'
UPDATE [valeant].[human] SET [UserAccount] = @AndreyMakarovNewAccount, [EMail] = 'Andrey.Makarov@valeant.com' WHERE [Code] = '01-000001077'
UPDATE [valeant].[human] SET [UserAccount] = @KonstantinPautinaNewAccount, [EMail] = 'Konstantin.Pautina@valeant.com' WHERE [Code] = '01-000001327'
UPDATE [valeant].[human] SET [UserAccount] = @TimofeiFeoktistovNewAccount, [EMail] = 'Timofei.Feoktistov@valeant.com' WHERE [Code] = '01-000000245'
UPDATE [valeant].[human] SET [UserAccount] = @AndreyKhmelevskiyNewAccount, [EMail] = 'Andrey.Khmelevskiy@valeant.com' WHERE [Code] = '01-000000890'
UPDATE [valeant].[human] SET [UserAccount] = @DmitriyAbramovNewAccount, [EMail] = 'Dmitriy.Abramov@valeant.com' WHERE [Code] = '01-000001093'
Update [valeant].[versions] set [version] = [version] + 1 where name = 'Structure'

