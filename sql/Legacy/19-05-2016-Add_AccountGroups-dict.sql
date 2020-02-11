USE [valeant]
GO

DECLARE @ids [valeant].[BigintTable]

INSERT INTO [valeant].[simpledictionarytype] ([Value])
OUTPUT INSERTED.Id INTO @ids VALUES ('AccountGroups')

declare @id int
select top 1 @id = Id from @ids

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, '71_RUB', 1, 'расчеты в рублях', NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, '71_RUB_COR', 1, 'расчеты корпоративной кредитной картой', NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, '1_RUB_TIC', 1, 'расчеты по билетам, приобретенным компанией', NULL, NULL, NULL)

GO

