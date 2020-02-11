/*
	1 - 
	Имя: Андреев Антон Александрович
	Email: Anton.Andreev@Valeant.com
	Accout: Valeant\Anton.Andreev
	Должность: Специалист по системе управления взаимоотношениями с клиентами
	Департамент: Группа по работе с корпоративными приложениями
	Руководитель: Белоусова Александра Игоревна
	2 -
	Имя: Паутина Константин Александрович
	Email: Konstantin.Pautina@Valeant.com
	Accout: Valeant\Konstantin.Pautina
	Должность: Специалист по корпоративным приложениям
	Департамент: Группа по работе с корпоративными приложениями
	Руководитель: Белоусова Александра Игоревна
	3 -
	Имя: Белоусова Александра Игоревна
	Email: alexandra.belousova@valeant.com
	Accout: valeant\alexandra.belousova
	Должность: Менеджер
	Департамент: Группа по работе с корпоративными приложениями
	Руководитель: Феоктистов Тимофей Ильич
	4 -
	Имя: Хмелевский Андрей Николаевич
	Email: Andrey.Khmelevskiy@valeant.com
	Accout: valeant\Andrey.Khmelevskiy
	Должность: Руководитель группы
	Департамент: Группа технической поддержки
	Руководитель: Феоктистов Тимофей Ильич
	5 - 
	Имя: Макаров Андрей Евгеньевич
	Email: Andrey.Makarov@Valeant.com
	Accout: Valeant\Andrey.Makarov
	Должность: Специалист
	Департамент: Группа технической поддержки
	Руководитель: Феоктистов Тимофей Ильич
	6 -
	Имя: Феоктистов Тимофей Ильич
	Email: Timofei.Feoktistov@valeant.com
	Accout: valeant\Timofei.Feoktistov
	Должность: Менеджер
	Департамент: Отдел информационных технологий по России и странам СНГ
	Руководитель: Гудков Владимир Анатольевич
	7 - 
	Имя: Гудков Владимир Анатольевич
	Email: Vladimir.Gudkov@valeant.com
	Accout: valeant\Vladimir.Gudkov
	Должность: Директор по финансам и информационным технологиям по России и странам СНГ
	Департамент: Финансовый департамент
	Руководитель: Коннолли Джон
	8 -
	Имя: Коннолли Джон 
	Email: john.connolly@valeant.com
	Accout: WIN-OU97UVALM34\xrxAdmin
	Должность: Генеральный директор
	Департамент: Администрация
	Руководитель:
	9 -
	Имя: Абрамов Дмитрий Николаевич
	Email: Dmitriy.Abramov@Valeant.com
	Account: Valeant\Dmitriy.Abramov
	Должность: Старший фармацевтический представитель
	Департамент: Курск
	Руководитель: Фурсин Алексей Алексеевич
	10 -
	Имя: Демин Сергей Александрович
	Email: Sergey.Demin@valeant.com
	Account: valeant\Sergey.Demin
	Должность: Коммерческий директор
	Департамент: Коммерческий департамент
	Руководитель: Коннолли Джон
*/

DECLARE @Flag INT
SET @Flag = 1

DECLARE @AntonAndreevNewAccount NVARCHAR(50)
DECLARE @KonstantinPautinaNewAccount NVARCHAR(50)
DECLARE @AlexandraBelousovaNewAccount NVARCHAR(50)
DECLARE @AndreyMakarovNewAccount NVARCHAR(50)
DECLARE @AndreyKhmelevskiyNewAccount NVARCHAR(50)
DECLARE @TimofeiFeoktistovNewAccount NVARCHAR(50)
DECLARE @VladimirGudkovNewAccount NVARCHAR(50)
DECLARE @johnconnollyNewAccount NVARCHAR(50)
DECLARE @DmitriyAbramovNewAccount NVARCHAR(50)
DECLARE @SergeyDeminNewAccount NVARCHAR(50)
DECLARE @OvchinnikovaNewAccount NVARCHAR(50)
DECLARE @BoldinaNewAccount NVARCHAR(50)
DECLARE @AbalmasovaNewAccount NVARCHAR(50)
DECLARE @MazurovaNewAccount NVARCHAR(50)

--change current

DECLARE @oldDomain NVARCHAR(15)
SET @oldDomain = 'valeant'
DECLARE @newAccount NVARCHAR(50)
--SET @newAccount = 'WIN-OU97UVALM34\xrxAdmin'
SET @newAccount ='DMITRY-MOBILE\dmryvkin'
--SET @newAccount = 'Jenya-HOME\jenya'
--SET @newAccount = 'XRXEU\w32cxd4y'


BEGIN TRAN
	IF(@Flag = 1)
		SET @AntonAndreevNewAccount = @newAccount
	ELSE
		SET @AntonAndreevNewAccount = @oldDomain + '\Anton.Andreev'
	
	IF(@Flag = 2)
		SET @KonstantinPautinaNewAccount = @newAccount
	ELSE
		SET @KonstantinPautinaNewAccount = @oldDomain + '\Konstantin.Pautina'

	IF(@Flag = 3)
		SET @AlexandraBelousovaNewAccount = @newAccount
	ELSE
		SET @AlexandraBelousovaNewAccount = @oldDomain + '\alexandra.belousova'

	IF(@Flag = 4)
		SET @AndreyKhmelevskiyNewAccount = @newAccount
	ELSE
		SET @AndreyKhmelevskiyNewAccount = @oldDomain + '\Andrey.Khmelevskiy'
	
	IF(@Flag = 5)
		SET @AndreyMakarovNewAccount = @newAccount
	ELSE
		SET @AndreyMakarovNewAccount = @oldDomain + '\Andrey.Makarov'

	IF(@Flag = 6)
		SET @TimofeiFeoktistovNewAccount = @newAccount
	ELSE
		SET @TimofeiFeoktistovNewAccount = @oldDomain + '\Timofei.Feoktistov'

	IF(@Flag = 7)
		SET @VladimirGudkovNewAccount = @newAccount
	ELSE
		SET @VladimirGudkovNewAccount = @oldDomain + '\Vladimir.Gudkov'

	IF(@Flag = 8)
		SET @johnconnollyNewAccount = @newAccount
	ELSE
		SET @johnconnollyNewAccount = @oldDomain + '\john.connolly'

	IF(@Flag = 9)
		SET @DmitriyAbramovNewAccount = @newAccount
	ELSE
		SET @DmitriyAbramovNewAccount = @oldDomain + '\Dmitriy.Abramov'

	IF(@Flag = 10)
		SET @SergeyDeminNewAccount = @newAccount
	ELSE
		SET @SergeyDeminNewAccount = @oldDomain + '\Sergey.Demin'
    
	IF(@Flag = 11)
		SET @OvchinnikovaNewAccount = @newAccount
	ELSE
		SET @OvchinnikovaNewAccount = @oldDomain + '\liliya.ovchinnikova'

	IF(@Flag = 12)
		SET @BoldinaNewAccount = @newAccount
	ELSE
		SET @BoldinaNewAccount = @oldDomain + '\Tatiana.Boldina'

	IF(@Flag = 13)
		SET @AbalmasovaNewAccount = @newAccount
	ELSE
		SET @AbalmasovaNewAccount = @oldDomain + '\Viktoriya.Abalmasova'

	IF(@Flag = 14)
		SET @MazurovaNewAccount = @newAccount
	ELSE
		SET @MazurovaNewAccount = @oldDomain + '\Victoria.Mazurova'

	UPDATE [valeant].[human] SET [UserAccount] = @AntonAndreevNewAccount, [EMail] = 'Anton.Andreev@valeant.com' WHERE [Code] = '01-000001207'
	UPDATE [valeant].[human] SET [UserAccount] = @AlexandraBelousovaNewAccount, [EMail] = 'Alexandra.Belousova@valeant.com' WHERE [Code] = '01-000001141'
	UPDATE [valeant].[human] SET [UserAccount] = @VladimirGudkovNewAccount, [EMail] = 'Vladimir.Gudkov@valeant.com' WHERE [Code] = '01-000000594'
	UPDATE [valeant].[human] SET [UserAccount] = @johnconnollyNewAccount, [EMail] = 'John.Connolly@valeant.com' WHERE [Code] = '01-000000393'
	UPDATE [valeant].[human] SET [UserAccount] = @AndreyMakarovNewAccount, [EMail] = 'Andrey.Makarov@valeant.com' WHERE [Code] = '01-000001077'
	UPDATE [valeant].[human] SET [UserAccount] = @KonstantinPautinaNewAccount, [EMail] = 'Konstantin.Pautina@valeant.com' WHERE [Code] = '01-000001327'
	UPDATE [valeant].[human] SET [UserAccount] = @TimofeiFeoktistovNewAccount, [EMail] = 'Timofei.Feoktistov@valeant.com' WHERE [Code] = '01-000000245'
	UPDATE [valeant].[human] SET [UserAccount] = @AndreyKhmelevskiyNewAccount, [EMail] = 'Andrey.Khmelevskiy@valeant.com' WHERE [Code] = '01-000000890'
	UPDATE [valeant].[human] SET [UserAccount] = @DmitriyAbramovNewAccount, [EMail] = 'Dmitriy.Abramov@valeant.com' WHERE [Code] = '01-000001093'
	UPDATE [valeant].[human] SET [UserAccount] = @SergeyDeminNewAccount, [EMail] = 'Sergey.Demin@valeant.com' WHERE [Code] = '01-000000432'
	UPDATE [valeant].[human] SET [UserAccount] = @OvchinnikovaNewAccount, [EMail] ='liliya.ovchinnikova@valeant.com'  WHERE [Code] = '01-0000000097'
	UPDATE [valeant].[human] SET [UserAccount] = @BoldinaNewAccount, [EMail] ='Tatiana.Boldina@valeant.com'  WHERE [Code] = '01-000000956'
	UPDATE [valeant].[human] SET [UserAccount] = @MazurovaNewAccount, [EMail] ='Viktoriya.Abalmasova@Valeant.com'  WHERE [Code] = '01-000000700'
	UPDATE [valeant].[human] SET [UserAccount] = @AbalmasovaNewAccount, [EMail] ='Victoria.Mazurova@Valeant.com' WHERE [Code] = '01-000000959'
	
	Update [valeant].[versions] set [version] = [version] + 1 where name = 'Structure'

--IF(@@ERROR = 0) 
	COMMIT TRAN
--ELSE 
--	ROLLBACK TRAN

SELECT 
N'Code: '+ [h].[Code],
N'Имя: ' + [h].[FullName],
N'Email: ' + [h].[Email],
N'Accout: ' + [h].[UserAccount],
N'Должность: ' + [p].[Value],
N'Департамент: ' + [d].[Name],
N'Руководитель: ' + [h1].[FullName]
FROM [valeant].[human] [h]
	INNER JOIN [valeant].[employee] [e] ON [h].[Id] = [e].[human]
	INNER JOIN [valeant].[employeeposition] [p] ON [e].[Position] = [p].[Id]
	INNER JOIN [valeant].[department] [d] ON [d].[Id] = [e].[Department]
	LEFT OUTER JOIN [valeant].[human] [h1] ON [e].[Manager1stLevel] = [h1].[Id]
WHERE [h].[Code] IN
('01-000001207', '01-000001141', '01-000000594', '01-000000393', '01-000001077', '01-000001327', '01-000000245', '01-000000890', '01-000001093', '01-000000432', '01-000000700', '01-000000959')
