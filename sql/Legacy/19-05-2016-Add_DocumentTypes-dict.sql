USE [valeant]
GO

DECLARE @ids [valeant].[BigintTable]

INSERT INTO [valeant].[simpledictionarytype] ([Value])
OUTPUT INSERTED.Id INTO @ids VALUES ('DocumentTypes')

declare @id int
select top 1 @id = Id from @ids

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Приказ', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Служебное задание', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Кассовый чек', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Товарный чек', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Квитанция', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Накладная', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Акт', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Парковочный талон', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Счет', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Электронный билет (авиа, ж/д)', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Проездной билет', 1, NULL, NULL, NULL, NULL)

GO


