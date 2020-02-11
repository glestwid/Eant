USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[InsertLedgerEntry]    Script Date: 20.04.2016 12:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



alter table [valeant].[employee] drop column ValidityInternationalPassport
go


CREATE TABLE [valeant].[car](
    [Id] [bigint] IDENTITY(1,1) NOT NULL,
    [human] [bigint] NULL,
    [Number] [nvarchar](10) NOT NULL,
    [Type] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_car] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




CREATE PROCEDURE [valeant].[ReadCars] 
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Id], [human], [Number],[Type] from  [valeant].[car]
END

GO



CREATE PROCEDURE [valeant].[ReadHumanByCode]
    @code nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id Bigint    
    SELECT @id = [h].[Id] FROM [valeant].[human] [h] WHERE [h].[Code] = @code

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
        [h].[InternationalPassportIssueDate],
        [o].[Value],
        [country].[Name],
        [h].[Tel],
        [h].[LoyaltyCards],
        [h].InternationalPassportFirstName,
        [h].InternationalPassportLastName ,
        [h].InternationalPassportBirthPlace,
        [h].InternationalPassportExpiryDate
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


ALTER PROCEDURE [valeant].[InsertLedgerEntry]
    -- Add the parameters for the stored procedure here
    @number int,
    @entrykey NVARCHAR(255),
    @vendornumber NVARCHAR(50),
    @documentnumber NVARCHAR(255),
    @documenttype NVARCHAR(255),
    @ammount money

AS
BEGIN
    
    SET NOCOUNT ON;

    DELETE FROM [valeant].[employeeledgerentry] where [EntryNumber] = @number

    INSERT INTO [valeant].[employeeledgerentry] 
    ([EntryNumber],
    [EntryKey],
    [VendorNumber],
    [DocumentNumber],
    [DocumentType],
    [Ammount])
    VALUES 
    (@number,
     @entrykey,
     @vendornumber,
     @documentnumber,
     @documenttype,
     @ammount)
    
END
