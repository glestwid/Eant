USE [valeant]
GO

/****** Object:  StoredProcedure [valeant].[RegisterDepartmentStructure]    Script Date: 07.07.2016 15:08:56 ******/
DROP PROCEDURE [valeant].[RegisterDepartmentStructure]
GO

/****** Object:  UserDefinedTableType [valeant].[humanType]    Script Date: 07.07.2016 15:08:09 ******/
DROP TYPE [valeant].[humanType]
GO

/****** Object:  UserDefinedTableType [valeant].[humanType]    Script Date: 07.07.2016 15:08:09 ******/
CREATE TYPE [valeant].[humanType] AS TABLE(
	[Code] [valeant].[Code] NOT NULL,
	[FullName] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](320) NULL,
	[DocumentSeries] [nvarchar](10) NOT NULL,
	[DocumentNumber] [nvarchar](20) NOT NULL,
	[DocumentIssuedOn] [datetime] NOT NULL,
	[DocumentIssuedBy] [nvarchar](255) NOT NULL,
	[UserAccount] [nvarchar](255) NULL,
	[Birthday] [nvarchar](50) NULL,
	[City] [nvarchar](255) NULL
)
GO

/****** Object:  Table [valeant].[human]    Script Date: 07.07.2016 15:10:36 ******/
ALTER TABLE [valeant].[human] ADD [City] nvarchar(255)

/****** Object:  StoredProcedure [valeant].[RegisterDepartmentStructure]    Script Date: 07.07.2016 15:08:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [valeant].[RegisterDepartmentStructure]
	@country [valeant].[countryType] READONLY,
	@organization [valeant].[organizationType] READONLY,
	@costcenter [valeant].[costcenterType] READONLY,
	@department [valeant].[departmentType] READONLY,
	@departmentcondition [valeant].[departmentconditionType] READONLY,
	@employeeposition [valeant].[employeepositionType] READONLY,
	@human [valeant].[humanType] READONLY,
	@employee [valeant].[employeeType] READONLY,
	@defaultRole nvarchar(255)
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
		--регистрируем страну организации
		DECLARE @countryRows [valeant].[valeantrowType]
		MERGE [valeant].[country] AS [target]
		USING @country AS [source]
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [target].[Name] = [source].[Name]
		WHEN NOT MATCHED THEN
			INSERT ([Code], [Name])
			VALUES ([source].[Code], [source].[Name])
		OUTPUT inserted.Id, inserted.Code, $action INTO @countryRows;

		--регистрация организации
		DECLARE @organizationRows [valeant].[valeantrowType]
		MERGE [valeant].[organization] AS target
		USING (
			SELECT [o].[Code], [o].[Value], [cr].[Id] FROM @organization o
			INNER JOIN @countryRows cr ON [o].[Country] = [cr].[Code]
		) AS [source] ([Code], [Value], [Country])
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [target].Value = [source].Value, [target].Country = [source].Country
		WHEN NOT MATCHED THEN
			INSERT([Code], [Value], [Country])
			VALUES([source].[Code], [source].Value, [source].Country)
		OUTPUT inserted.Id, inserted.Code, $action INTO @organizationRows;

		--регистрация костов
		DECLARE @costcenterRows [valeant].[valeantrowType]
		MERGE [valeant].[costcenter] AS [target]
		USING @costcenter AS [source]
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [target].[Description] = [source].[Description]
		WHEN NOT MATCHED THEN
			INSERT([Code], [Description])
			VALUES([source].[Code], [source].[Description])
		OUTPUT inserted.Id, inserted.Code, $action INTO @costcenterRows;

		--регистрация департаментов
		DECLARE @departmentRows [valeant].[valeantrowType]
		MERGE [valeant].[department] AS [target]
		USING (
			SELECT [d].[Code], [d].[Name], [d].[Status], [o].[Id], [cc].[Id] FROM @department [d]
			INNER JOIN @organizationRows [o] ON [d].[Organization] = [o].[Code]
			LEFT OUTER JOIN @costcenterRows [cc] ON [d].[CostCenter] = [cc].[Code]
		 )
		AS [source] ([Code], [Name], [Status], [Organization], [CostCenter])
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET 
				[target].[Code] = [source].[Code],
				[target].[Name] = [source].[Name],
				[target].[Status] = [source].[Status],
				[target].[Organization] = [source].[Organization],
				[target].[CostCenter] = [source].[CostCenter]
		WHEN NOT MATCHED THEN
			INSERT([Code], [Name], [Status], [Organization], [CostCenter])
			VALUES([source].[Code], [source].[Name], [source].[Status], [source].[Organization], [source].[CostCenter])
		OUTPUT inserted.Id, inserted.Code, $action INTO @departmentRows;

		--структура департаментов
		UPDATE [d] SET [d].[Parent] = [dr].[Id]
		FROM [valeant].[department] [d]
		INNER JOIN @department [dd] ON [d].[Code] = [dd].[Code]
		INNER JOIN @departmentRows [dr] ON [dd].[Parent] = [dr].[Code]
		
		--состояние
		MERGE [valeant].[departmentcondition] AS [target]
		USING (
			SELECT [dr].[Id], [dc].[Name], [dc].[Value] FROM @departmentRows [dr]
			INNER JOIN @departmentcondition [dc] ON [dc].[Code] = [dr].[Code]
			)
		AS [source] ([Id], [Name], [Value])
		ON ([target].[IdDepartment] = [source].[Id] AND [target].[Name] = [source].[Name])
		WHEN MATCHED THEN 
			UPDATE SET [target].[Value] = [source].[Value]
		WHEN NOT MATCHED THEN
			INSERT([IdDepartment], [Name], [Value])
			VALUES([source].[Id], [source].[Name], [source].[Value]);

		--должности
		DECLARE @positionRows [valeant].[valeantrowType]
		MERGE [valeant].[employeeposition] AS [target]
		USING @employeeposition AS [source]
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [target].[Value] = [source].[Value]
		WHEN NOT MATCHED THEN
			INSERT([Code], [Value])
			VALUES([source].[Code], [source].[Value])
		OUTPUT inserted.Id, inserted.Code, $action INTO @positionRows;

		--люди
		DECLARE @humanRows [valeant].[valeantrowType]
		MERGE [valeant].[human] AS [target]
		USING @human AS [source]
		ON ([target].[Code] = [source].[Code])
		WHEN MATCHED THEN 
			UPDATE SET [FullName] = [source].[FullName],
			[Email] = [source].[Email],
			[DocumentSeries] = [source].[DocumentSeries],
			[DocumentNumber] = [source].[DocumentNumber],
			[DocumentIssuedOn] = [source].[DocumentIssuedOn],
			[DocumentIssuedBy] = [source].[DocumentIssuedBy],
			[UserAccount] = [source].[UserAccount]
		WHEN NOT MATCHED THEN
			INSERT([Code], [FullName], [Email], [DocumentSeries], [DocumentNumber], [DocumentIssuedOn], [DocumentIssuedBy], [UserAccount], [Birthday], [City])
			VALUES(
				[source].[Code], 
				[source].[FullName], 
				[source].[Email], 
				[source].[DocumentSeries], 
				[source].[DocumentNumber], 
				[source].[DocumentIssuedOn], 
				[source].[DocumentIssuedBy], 
				[source].[UserAccount],
				[source].[Birthday],
				[source].[City])
		OUTPUT inserted.Id, inserted.Code, $action INTO @humanRows;

		MERGE [valeant].[employee] AS [target]
		USING (
			SELECT [h].[Id], [e].[ClockNumber], [d].[Id], [p].[Id],[e].[Status], [h1].[Id], [h2].[Id], [c].[Id] FROM @employee [e]
			LEFT OUTER JOIN @humanRows [h] ON [e].[Human] = [h].[Code]
			LEFT OUTER JOIN @departmentRows [d] ON [e].[Department] = [d].[Code]
			LEFT OUTER JOIN @positionRows [p] ON [p].[Code] = [e].[Position]
			LEFT OUTER JOIN @humanRows h1 ON [e].[Manager1stLevel] = [h1].[Code]
			LEFT OUTER JOIN @humanRows h2 ON [e].[Manager2ndLevel] = [h2].[Code]
			LEFT OUTER JOIN @costcenterRows [c] ON [e].[CostCentre] = [c].[Code]
		) AS source ([human], [ClockNumber], [Department], [Position], [Status], [Manager1stLevel], [Manager2ndLevel], [CostCentre])
		ON ([target].[ClockNumber] = [source].[ClockNumber] AND [target].[human] = [source].[human])
		WHEN MATCHED THEN
			UPDATE SET 
				[Department] = [source].[Department],
				[Position] = [source].[Position],
				[Status] = [source].[Status],
				[Manager1stLevel] = [source].[Manager1stLevel],
				[Manager2ndLevel] = [source].[Manager2ndLevel],
				[CostCentre] = [source].[CostCentre]
		WHEN NOT MATCHED THEN
			INSERT([human], [ClockNumber], [Department], [Position], [Status], [Manager1stLevel], [Manager2ndLevel], [CostCentre])
			VALUES(
				[source].[human], 
				[source].[ClockNumber], 
				[source].[Department], 
				[source].[Position], 
				[source].[Status], 
				[source].[Manager1stLevel], 
				[source].[Manager2ndLevel], 
				[source].[CostCentre]);

		DECLARE @defaultRoleId Bigint
		SELECT TOP 1 @defaultRole = Id FROM [valeant].[role] WHERE [Name] = @defaultRole
		
		IF(NOT @defaultRole IS NULL)
		BEGIN
			MERGE [valeant].[humantorole] AS [target]
			USING @humanRows AS [source]
			ON [target].[HumanId] = [source].[Id] AND [target].[RoleId] = @defaultRole
			WHEN NOT MATCHED THEN
			INSERT ([HumanId], [RoleId])
			VALUES(Id, @defaultRole);
		END
		Update [valeant].[versions] set [version] = [version] + 1 where name = 'Structure'
	END TRY
	BEGIN CATCH
		IF @createdTransaction = 1 ROLLBACK TRANSACTION
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH;
    IF @createdTransaction = 1 COMMIT TRANSACTION
END
GO

ALTER view [valeant].[Humans] 
as
select 
    h.Code, 
    h.FullName, 
    e.ClockNumber, 
    s.[Value] as DepartmentStatus, 
    d.Code as DepartmentCode, 
    d.Name as DepartmentName,
    h.UserAccount,
    h.Email,
    h.Id,
    h.AssistantId,
    h.DeputyId,
    assistanth.FullName as AssistantFullName,
    deputyh.FullName as DeputyFullName,
    managerh1.FullName as Manager1FullName,
    e.Manager1stLevel,
    managerh2.FullName as Manager2FullName,
    e.Manager2ndLevel,
    p.[Value] as PositionName,
    c.[Description] as CostCenterDescription,
    h.DocumentIssuedBy,
    h.DocumentIssuedOn,
    h.DocumentNumber,
    h.DocumentSeries,
    h.NumberInternationalPassport,
    h.InternationalPassportIssueDate,
    o.[Value] as OrganizationName,
    country.Name as CountryName,
    h.Tel,
    h.LoyaltyCards,
    h.InternationalPassportFirstName,
    h.InternationalPassportLastName ,
    h.InternationalPassportBirthPlace,
    h.InternationalPassportExpiryDate,
    e.FuelCard,
    c.Code as CostCenterCode,
	h.LastLoginTime,
	p.Id as PositionId,
	p.[Group] as PositionGroupId,
	e.[Status] as EmployeeStatus,
	h.DeputyDateStart, 
	h.DeputyDateEnd,
	h.Birthday,
	h.City
from valeant.human h
    left join valeant.employee e on h.Id = e.human
    left join valeant.department d on d.Id = e.Department
    left join valeant.departmentstatus s on s.Id = d.[Status]
    left join valeant.employeeposition p on p.id = e.Position
    left join valeant.costcenter c on c.Id = e.CostCentre
    left join valeant.organization o on o.Id = d.Organization
    left join valeant.country country on country.Id = o.Country
    left join valeant.human assistanth on assistanth.Id = h.AssistantId
    left join valeant.human deputyh on deputyh.Id = h.DeputyId
    left join valeant.human managerh1 on managerh1.Id = e.Manager1stLevel
    left join valeant.human managerh2 on managerh2.Id = e.Manager2ndLevel


GO


/****** Object:  StoredProcedure [valeant].[ReadAllGiftRequestMetadataForReport]    Script Date: 08.07.2016 11:08:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [valeant].[ReadAllGiftRequestMetadataForReport]
	@dateStart datetimeoffset=null, 
	@dateEnd datetimeoffset=null
as
BEGIN
	SET NOCOUNT ON;
	declare @documentType nvarchar(255)
	set @documentType = N'Заявка на подарок'
	DECLARE @documentTypeId bigint
	SELECT @documentTypeId = [d].[Id] FROM [valeant].[documenttype] [d] WHERE [d].[Value] = @documentType
	
	DECLARE @ids [valeant].[BigintTable]
		INSERT INTO @ids
		SELECT DISTINCT [a].[Id] FROM [valeant].[advancetoken] [a]
		INNER JOIN [valeant].[advance] [ad] ON [ad].[Id] = [a].[Id]
		WHERE [ad].[type] = @documentTypeId 
		--AND [ad].[dateadvance] BETWEEN @dateStart AND @dateEnd

		SELECT [number] as Number
			  ,convert(nvarchar(max), [dateadvance], 104) as Date
			  ,e.ClockNumber as CodeEmployee
			  ,[h].[FullName] as FIOEmployee
			  ,[h].[City] as CityEmployee
			  ,[sum] as SumGift
			  ,a.content.value('(/GiftRequestDataEx/GiftReciever/SecondName)[1]', 'nvarchar(max)') + ' ' +
			  a.content.value('(/GiftRequestDataEx/GiftReciever/Name)[1]', 'nvarchar(max)') + ' ' +
			  a.content.value('(/GiftRequestDataEx/GiftReciever/MiddleName)[1]', 'nvarchar(max)')
			  as FIOPerson
			  ,a.content.value('(/GiftRequestDataEx/GiftReciever/Organization)[1]', 'nvarchar(max)') as CompanyPerson
			  ,a.content.value('(/GiftRequestDataEx/Status)[1]', 'nvarchar(max)') as Status --s.Value as Status
			  ,a.content.value('(/GiftRequestDataEx/Reason)[1]', 'nvarchar(max)') as Comments
		  FROM [valeant].[advance] [a]
		  INNER JOIN [valeant].[documenttype] [t] ON t.[Id] = [type]
		  INNER JOIN [valeant].documentState [s] ON s.[Id] = [state]
		  INNER JOIN [valeant].[contenttype] [c] ON [c].[Id] = [a].[datatype]
		  INNER JOIN [valeant].[human] [h] ON [h].Id = [a].[creator]
		  INNER JOIN [valeant].[employee] [e] ON [e].[human] = [a].[creator]
		  INNER JOIN [valeant].[department] [d] ON [e].[Department] = [d].[Id]
		  INNER JOIN @ids [ids] ON [ids].[Id] = [a].[Id] 
		  ORDER BY number DESC
end


GO
/****** Object:  StoredProcedure [valeant].[spGetPrepaymentRequestsReportFilter]    Script Date: 08.07.2016 11:05:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [valeant].[spGetPrepaymentRequestsReportFilter]
    @type int = null,
	@start DateTimeOffset,
	@end DateTimeOffset
AS
BEGIN
	  select 
	    a.Id,
		a.Number, 
		a.datecreate as RequestDate, 
		h.Code as CreatorCode, 
		h.FullName as CreatorFullName,
		h.City as CreatorCity,
		a.[sum] as Summa,
		s.name as RequestStatus,
		history.Comment as StatusComment
	from valeant.advance a
		left join valeant.human h on h.Id = a.creator
		left join valeant.states_version_3 s on s.id = a.[state]
		outer apply (
			select top 1 Comment 
			from valeant.advancehistory 
			where Id = a.Id and Comment is not null
			order by [number] desc
			) history
		WHERE (@type is null or a.[type] = @type) AND a.datecreate between @start and @end
END

GO
/****** Object:  StoredProcedure [valeant].[spGetPrepaymentRequestsReport]    Script Date: 08.07.2016 11:04:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [valeant].[spGetPrepaymentRequestsReport]
	@type int = null
AS
BEGIN
	SET NOCOUNT ON;
	select 
		a.Id,
		a.Number, 
		a.dateadvance as RequestDate, 
		e.ClockNumber as CreatorCode, 
		h.FullName as CreatorFullName,
		h.City as CreatorCity,
		a.[sum] as Summa,
		s.name as RequestStatus,
		history.Comment as StatusComment
	from valeant.advance a
		left join valeant.human h on h.Id = a.creator
		join valeant.employee e on e.human = h.Id 
		left join valeant.states_version_3 s on s.id = a.[state]
		outer apply (
			select top 1 Comment 
			from valeant.advancehistory 
			where Id = a.Id
			order by [number] desc
			) history
	where (@type is null) or a.[type] = @type
END 

GO
/****** Object:  StoredProcedure [valeant].[spGetTravelListsReportFilter]    Script Date: 08.07.2016 11:11:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [valeant].[spGetTravelListsReportFilter]
    @type int = null,
	@start DateTimeOffset,
	@end DateTimeOffset
AS
BEGIN
	  select 
	    a.Id,
		a.Number, 
		a.dateadvance as RequestDate, 
		h.Code as CreatorCode, 
		h.FullName as CreatorFullName,
		h.City as CreatorCity,
		a.[sum] as Summa,
		s.name as RequestStatus,
		history.Comment as StatusComment
	from valeant.advance a
		left join valeant.human h on h.Id = a.creator
		left join valeant.states_version_3 s on s.id = a.[state]
		outer apply (
			select top 1 Comment 
			from valeant.advancehistory 
			where Id = a.Id and Comment is not null
			order by [number] desc
			) history
		WHERE (@type is null or a.[type] = @type) AND a.datecreate between @start and @end
END
