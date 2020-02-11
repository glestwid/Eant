USE [Valeant]
GO


 



/****** Object:  StoredProcedure [valeant].[UpdateHumanProfile]    Script Date: 4/19/2016 12:37:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [valeant].UpdateHumanProfile 
 @id bigint,
 @tel nvarchar(16) = null,
 @LoyaltyCards nvarchar(250) = null,
 @InternationalPassportFirstName nvarchar(250) = null,
 @InternationalPassportLastName nvarchar(250) = null,
 @InternationalPassportBirthPlace nvarchar(250) = null,
 @NumberInternationalPassport nvarchar(20) = null,
 @InternationalPassportIssueDate datetime = null,
 @InternationalPassportExpiryDate datetime = null
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
go
USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[ReadHumanById]    Script Date: 4/19/2016 11:01:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [valeant].[ReadHumanById]
    @id Bigint
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]
    WHERE [h].[Id] = @id

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id] AND [hr].[HumanId] = @id
END


go


USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[ReadHuman]    Script Date: 4/19/2016 11:01:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
ALTER PROCEDURE [valeant].[ReadHuman]
    @userAccount nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id Bigint    
    SELECT @id = [h].[Id] FROM [valeant].[human] [h] WHERE [h].[UserAccount] = @userAccount

    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]
    WHERE [h].[Id] = @id

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id] AND [hr].[HumanId] = @id
END





go

USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[ReadHuman]    Script Date: 4/19/2016 11:01:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
ALTER PROCEDURE [valeant].[ReadHuman]
    @userAccount nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id Bigint    
    SELECT @id = [h].[Id] FROM [valeant].[human] [h] WHERE [h].[UserAccount] = @userAccount

    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]
    WHERE [h].[Id] = @id

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id] AND [hr].[HumanId] = @id
END





go

USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[ReadHumans]    Script Date: 4/19/2016 11:01:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
ALTER PROCEDURE [valeant].[ReadHumans]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ids TABLE(Id Bigint)
    INSERT INTO @ids 
    SELECT [h].[Id] FROM [valeant].[human] h 
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
    WHERE [e].[Status] != 2
    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        INNER JOIN @ids [ids] ON [ids].[Id] = [h].[Id]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id]
        INNER JOIN @ids [ids] ON [ids].[Id] = [hr].[HumanId]
END

go

alter PROCEDURE [valeant].[ReaAdvanceCreator]
    @documentId bigint
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id bigint

    SELECT @id = [creator] FROM [valeant].[advance] WHERE [id] = @documentId
    
    SELECT 
        [h].[Code], 
        [h].[FullName], 
        [e].[ClockNumber], 
        [s].[Value], 
        [d].[Code], 
        [d].[Name],
        [h].[UserAccount],
        [h].[Email],
        [h].[Id],
        [h].[AssistantId],
        [h].[DeputyId],
        [assistanth].[FullName],
        [deputyh].[FullName],
        [managerh1].[FullName],
        [e].[Manager1stLevel],
        [managerh2].[FullName],
        [e].[Manager2ndLevel],
        [p].[Value],
        [c].[Description],
        [h].[DocumentIssuedBy],
        [h].[DocumentIssuedOn],
        [h].[DocumentNumber],
        [h].[DocumentSeries],
        [h].[NumberInternationalPassport],
        [h].InternationalPassportIssueDate,
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate,
        [e].[FuelCard],
        [c].Code
    FROM [valeant].[human] h
        INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
        INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
        INNER JOIN [valeant].[departmentstatus] [s] ON [s].[Id] = [d].[Status]
        INNER JOIN [valeant].[employeeposition] [p] ON [p].[id] = [e].[Position]
        INNER JOIN [valeant].[costcenter] [c] ON [c].[Id] = [e].[CostCentre]
        INNER JOIN [valeant].[organization] [o] ON [o].[Id] = [d].[Organization]
        INNER JOIN [valeant].[country] [country] ON [country].[Id] = [o].[Country]
        LEFT OUTER JOIN [valeant].[human] [assistanth] ON [assistanth].[Id] = [h].[AssistantId]
        LEFT OUTER JOIN [valeant].[human] [deputyh] ON [deputyh].[Id] = [h].[DeputyId]
        LEFT OUTER JOIN [valeant].[human] [managerh1] ON [managerh1].[Id] = [e].[Manager1stLevel]
        LEFT OUTER JOIN [valeant].[human] [managerh2] ON [managerh2].[Id] = [e].[Manager2ndLevel]
    WHERE [h].[Id] = @id

    SELECT [r].[Id], [r].[Name], [hr].[HumanId], [r].[IsAdministrator], [r].[Code] FROM [valeant].[role] [r]
        INNER JOIN [valeant].[humantorole] [hr] ON [hr].[RoleId] = [r].[Id] AND [hr].[HumanId] = @id
END


GO

