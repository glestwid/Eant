USE [valeant]
GO

DECLARE @ids [valeant].[BigintTable]

INSERT INTO [valeant].[simpledictionarytype] ([Value])
OUTPUT INSERTED.Id INTO @ids VALUES ('DailyLimits')

declare @id int
select top 1 @id = Id from @ids

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Россия', 1, '1000', NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'СНГ', 1, '1700', NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Прочие', 1, '3000', NULL, NULL, NULL)

GO

