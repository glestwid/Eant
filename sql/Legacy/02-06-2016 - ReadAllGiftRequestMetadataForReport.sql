USE [Valeant]
GO

create proc [valeant].ReadAllGiftRequestMetadataForReport
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
			  ,'' as CityEmployee
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