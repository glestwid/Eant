DECLARE @ancestorName nvarchar(255)
DECLARE @descendantName nvarchar(255)
DECLARE @actionName nvarchar(255)
DECLARE @value int
DECLARE @typeName nvarchar(50)
DECLARE @straight bit
DECLARE @tokens [valeant].[NVarchar255Table]

TRUNCATE TABLE [valeant].[nodeclosure_valeant_2]
TRUNCATE TABLE [valeant].[nodeclosureaccesslist_version_2]

--Заявка на аванс

--Начало
--Сохраняем черновик
SET @ancestorName = N'В разработке'
SET @descendantName = N'Черновик'
SET @actionName = N'Создать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*') --Фиктивный доступ
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Сразу отправляем на согласование
SET @ancestorName = N'В разработке'
SET @descendantName = N'На согласовании (1st рук.)'
SET @actionName = N'Отправить'
SET @typeName = N'Заявка на аванс'
SET @straight = 1
SET @value = NULL
INSERT INTO @tokens VALUES('O*') --Фиктивный доступ
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Черновик
--Просмотр
SET @ancestorName = N'Черновик'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*') --Доступ только создателю справки
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Редактирование
SET @ancestorName = N'Черновик'
SET @descendantName = N'Черновик'
SET @actionName = N'Редактировать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'Черновик'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Анулирование заявки
SET @ancestorName = N'Черновик'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Аннулировать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на согласование
SET @ancestorName = N'Черновик'
SET @descendantName = N'На согласовании (1st рук.)'
SET @actionName = N'Отправить'
SET @typeName = N'Заявка на аванс'
SET @straight = 1
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На согласовании (1st рук.)
--Отзыв
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = N'Черновик'
SET @actionName = N'Отозвать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на дороботку
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = N'На доработке'
SET @actionName = N'На доработку'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Аннулирование заявки
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Отказать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Согласование на первом уровне
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = N'LimitCheker'--Уходит в селектор проверки лимитов
SET @actionName = N'Согласовать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На доработке
--Просмотр
SET @ancestorName = N'На доработке'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На доработке'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Редактирование
SET @ancestorName = N'На доработке'
SET @descendantName = N'На доработке'
SET @actionName = N'Редактировать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Аннулирование
SET @ancestorName = N'На доработке'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Аннулировать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на согласование
SET @ancestorName = N'На доработке'
SET @descendantName = N'На согласовании (1st рук.)'
SET @actionName = N'Отправить'
SET @typeName = N'Заявка на аванс'
SET @straight = 1
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--LimitCheker (selector)
--раз
SET @ancestorName = N'LimitCheker'
SET @descendantName = N'ExpenditureCheker'
SET @actionName = NULL
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = 0 --При нуле уходит на проверку необходимости утверждения ответственным сотрудником
INSERT INTO @tokens VALUES('SYSTEM')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--два
SET @ancestorName = N'LimitCheker'
SET @descendantName = N'На согласовании (2nd рук.)'
SET @actionName = NULL
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = 1 --При единице уходит на согласование руководителем 2 уровня
INSERT INTO @tokens VALUES('SYSTEM')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На согласовании (2nd рук.)
--Отзыв заявки
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = N'Черновик'
SET @actionName = N'Отозвать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на доработку
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = N'На доработке'
SET @actionName = N'На доработку'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отказ в согласовании
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Отказать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Согласование заявки
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = N'ExpenditureCheker' -- уходит на проверку необходимости проверки ответственным сотрудником
SET @actionName = N'Согласовать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--ExpenditureCheker (selector)
--Раз
SET @ancestorName = N'ExpenditureCheker'
SET @descendantName = N'На согласовании (О.С.)'
SET @actionName = NULL
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = 0 --При нуле уходит на согласование О.С.
INSERT INTO @tokens VALUES('SYSTEM')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Два
SET @ancestorName = N'ExpenditureCheker'
SET @descendantName = N'Утверждена'
SET @actionName = NULL
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = 1 -- При единице утверждается
INSERT INTO @tokens VALUES('SYSTEM')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На согласование О.С.
--Отзыв заявки
SET @ancestorName = N'На согласовании (О.С.)'
SET @descendantName = N'Черновик'
SET @actionName = N'Отозвать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр
SET @ancestorName = N'На согласовании (О.С.)'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('R')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На согласовании (О.С.)'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('R')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на доработку
SET @ancestorName = N'На согласовании (О.С.)'
SET @descendantName = N'На доработке'
SET @actionName = N'На доработку'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('R')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отказ в согласовании
SET @ancestorName = N'На согласовании (О.С.)'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Отказать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('R')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Согласование заявки
SET @ancestorName = N'На согласовании (О.С.)'
SET @descendantName = N'Утверждена'
SET @actionName = N'Согласовать'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('R')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Утверждена
--Просмотр
SET @ancestorName = N'Утверждена'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'Утверждена'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Аннулирована
--Просмотр
SET @ancestorName = N'Аннулирована'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'Аннулирована'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на аванс'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens


--Заявка на коммандировку

--Начало
--Сохраняем черновик
SET @ancestorName = N'В разработке'
SET @descendantName = N'Черновик'
SET @actionName = N'Создать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*') --Фиктивный доступ
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Сразу отправляем на согласование
SET @ancestorName = N'В разработке'
SET @descendantName = N'IntervalMore14Days' --На проверку интервала до начала коммандировки
SET @actionName = N'Отправить'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 1
SET @value = NULL
INSERT INTO @tokens VALUES('O*') --Фиктивный доступ
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Черновик
--Просмотр
SET @ancestorName = N'Черновик'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*') --Доступ только создателю справки
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Редактирование
SET @ancestorName = N'Черновик'
SET @descendantName = N'Черновик'
SET @actionName = N'Редактировать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'Черновик'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Анулирование заявки
SET @ancestorName = N'Черновик'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Аннулировать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на согласование
SET @ancestorName = N'Черновик'
SET @descendantName = N'IntervalMore14Days'
SET @actionName = N'Отправить'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 1
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--IntervalMore14Days
--Раз
SET @ancestorName = N'IntervalMore14Days'
SET @descendantName = N'На согласовании (Ген. директор)' 
SET @actionName = NULL
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = 1 -- Если 1 то улетает на согласование ген. директором
INSERT INTO @tokens VALUES('SYSTEM')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Два
SET @ancestorName = N'IntervalMore14Days'
SET @descendantName = N'На согласовании (1st рук.)' 
SET @actionName = NULL
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = 0 -- Если 0 то улетает на согласование с рук. 1 уровня.
INSERT INTO @tokens VALUES('SYSTEM')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На согласовании (Ген. директор)
--Отзыв заявки
SET @ancestorName = N'На согласовании (Ген. директор)'
SET @descendantName = N'Черновик'
SET @actionName = N'Отозвать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр
SET @ancestorName = N'На согласовании (Ген. директор)'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('G-00000001')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На согласовании (Ген. директор)'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('G-00000001')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на доработку
SET @ancestorName = N'На согласовании (Ген. директор)'
SET @descendantName = N'На доработке'
SET @actionName = N'На доработку'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('G-00000001')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отказ в согласовании
SET @ancestorName = N'На согласовании (Ген. директор)'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Отказать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('G-00000001')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Согласование заявки
SET @ancestorName = N'На согласовании (Ген. директор)'
SET @descendantName = N'На согласовании (1st рук.)'
SET @actionName = N'Согласовать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('G-00000001')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На согласовании (1st рук.)
--Отзыв заявки
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = N'Черновик'
SET @actionName = N'Отозвать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на доработку
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = N'На доработке'
SET @actionName = N'На доработку'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отказ в согласовании
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Отказать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Согласование заявки
SET @ancestorName = N'На согласовании (1st рук.)'
SET @descendantName = N'На согласовании (HR сотр.)'
SET @actionName = N'Согласовать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M1*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На согласовании (HR сотр.)
--Отзыв заявки
SET @ancestorName = N'На согласовании (HR сотр.)'
SET @descendantName = N'Черновик'
SET @actionName = N'Отозвать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр
SET @ancestorName = N'На согласовании (HR сотр.)'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('R-00000003')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На согласовании (HR сотр.)'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('R-00000003')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на доработку
SET @ancestorName = N'На согласовании (HR сотр.)'
SET @descendantName = N'На доработке'
SET @actionName = N'На доработку'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('R-00000003')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отказ в согласовании
SET @ancestorName = N'На согласовании (HR сотр.)'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Отказать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('R-00000003')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Согласование заявки
SET @ancestorName = N'На согласовании (HR сотр.)'
SET @descendantName = N'На согласовании (Travel коорд.)'
SET @actionName = N'Согласовать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('R-00000003')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На согласовании (Travel коорд.)
--Отзыв заявки
SET @ancestorName = N'На согласовании (Travel коорд.)'
SET @descendantName = N'Черновик'
SET @actionName = N'Отозвать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр
SET @ancestorName = N'На согласовании (Travel коорд.)'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('R-00000004')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На согласовании (Travel коорд.)'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('R-00000004')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на доработку
SET @ancestorName = N'На согласовании (Travel коорд.)'
SET @descendantName = N'На доработке'
SET @actionName = N'На доработку'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('R-00000004')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отказ в согласовании
SET @ancestorName = N'На согласовании (Travel коорд.)'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Отказать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('R-00000004')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Согласование заявки
SET @ancestorName = N'На согласовании (Travel коорд.)'
SET @descendantName = N'TravelCoordinatorLimitCheker' --Превышение лимитов
SET @actionName = N'Согласовать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('R-00000004')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--TravelCoordinatorLimitCheker
--Раз
SET @ancestorName = N'TravelCoordinatorLimitCheker'
SET @descendantName = N'На согласовании (2nd рук.)' 
SET @actionName = NULL
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = 0 -- Если 0 то улетает на согласование рук. 2 уровня.
INSERT INTO @tokens VALUES('SYSTEM')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Два
SET @ancestorName = N'TravelCoordinatorLimitCheker'
SET @descendantName = N'Ожидает авансового отчета'
SET @actionName = NULL
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = 1 -- Если 1 то улетает на ожидание авансового отчета
INSERT INTO @tokens VALUES('SYSTEM')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На согласовании (2nd рук.)
--Отзыв заявки
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = N'Черновик'
SET @actionName = N'Отозвать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на доработку
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = N'На доработке'
SET @actionName = N'На доработку'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отказ в согласовании
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Отказать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Согласование заявки
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = N'Ожидает авансового отчета'
SET @actionName = N'Согласовать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('M2*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Ожидает авансового отчета
--Просмотр
SET @ancestorName = N'Ожидает авансового отчета'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'Ожидает авансового отчета'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Закрытие заявки
SET @ancestorName = N'На согласовании (2nd рук.)'
SET @descendantName = N'Закрыта'
SET @actionName = N'Закрыть'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Анулирование заявки
SET @ancestorName = N'Ожидает авансового отчета'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Аннулировать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Аннулирована
--Просмотр
SET @ancestorName = N'Аннулирована'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'Аннулирована'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Закрыта
--Просмотр
SET @ancestorName = N'Закрыта'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'Закрыта'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--На доработке
--Просмотр
SET @ancestorName = N'На доработке'
SET @descendantName = NULL
SET @actionName = N'Просмотр'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Просмотр истории
SET @ancestorName = N'На доработке'
SET @descendantName = NULL
SET @actionName = N'История'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Редактирование
SET @ancestorName = N'На доработке'
SET @descendantName = N'На доработке'
SET @actionName = N'Редактировать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Аннулирование
SET @ancestorName = N'На доработке'
SET @descendantName = N'Аннулирована'
SET @actionName = N'Аннулировать'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 0
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens

--Отправка на согласование
SET @ancestorName = N'На доработке'
SET @descendantName = N'IntervalMore14Days'
SET @actionName = N'Отправить'
SET @typeName = N'Заявка на командировку/служебную поездку'
SET @straight = 1
SET @value = NULL
INSERT INTO @tokens VALUES('O*')
EXEC [valeant].[insertclosure_version_2] @ancestorName, @descendantName, @actionName, @value, @typeName, @straight, @tokens
DELETE FROM @tokens
