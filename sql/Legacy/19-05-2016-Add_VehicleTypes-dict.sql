USE [valeant]
GO

DECLARE @ids [valeant].[BigintTable]

INSERT INTO [valeant].[simpledictionarytype] ([Value])
OUTPUT INSERTED.Id INTO @ids VALUES ('VehicleTypes')

declare @id int
select top 1 @id = Id from @ids

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Служебный автомобиль', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'ЖД', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Авиа', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Прочее', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Транспорт не требуется', 1, NULL, NULL, NULL, NULL)
GO

