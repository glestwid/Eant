USE [valeant]
GO

DECLARE @ids [valeant].[BigintTable]

INSERT INTO [valeant].[simpledictionarytype] ([Value])
OUTPUT INSERTED.Id INTO @ids VALUES ('TripAims')

declare @id int
select top 1 @id = Id from @ids

INSERT INTO [valeant].[simpledictionary] ([Type], [Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Участие в тренинге', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Обучение', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Проведение рабочих встреч', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Участие в конференции (цикловая/ежегодная)', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Трудоустройство', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Корпоративное мероприятие', 1, NULL, NULL, NULL, NULL)

INSERT INTO [valeant].[simpledictionary] ([Type],[Value], [Actual], [Advansed], [Reference], [Flag], [Flag1])
     VALUES (@id, 'Получение/перегон автомобиля', 1, NULL, NULL, NULL, NULL)
GO

