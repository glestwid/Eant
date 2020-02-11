USE [valeant]

ALTER TABLE [valeant].[node_properties_version_3] ADD expression VARCHAR(MAX) NULL;

GO
ALTER PROCEDURE [valeant].[read_matrix_all_info_version_3] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [id], [name], [title], [approvalsheettitle] FROM [valeant].[states_version_3]
	SELECT [id], [value], [calc], [export] FROM [valeant].[tokens_version_3]
	SELECT [id], [name], [description] FROM [valeant].[documentblock_accesstype_version_2]
	SELECT [id], [block] FROM [valeant].[documentblock_version_2]
	SELECT [id], [documenttype], [name], [description] FROM [valeant].[documentblock_accesslist_version_2]
	SELECT [id], [accesslist], [block], [access] FROM [valeant].[documentblock_accesslist_details_version_2]
	SELECT [id], [templatesubject], [templatemessage], [allListUrlPart], [documentPart] FROM [valeant].[notification]
	SELECT [id], [state], [token], [access_list_documentblock], [notification], [actions], [document], [expression] FROM [valeant].[node_properties_version_3]
	SELECT [id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet] FROM [valeant].[matrix_version_3]
END
GO

DECLARE @nameDocument NVARCHAR(MAX)
DECLARE @idDocument BIGINT
DECLARE @idMatrix BIGINT
DECLARE @idProperty BIGINT
DECLARE @idStateFrom BIGINT
DECLARE @idStateTo BIGINT
DECLARE @condition NVARCHAR(MAX)
DECLARE @postfunc NVARCHAR(MAX)
DECLARE @state BIGINT
DECLARE @token BIGINT
DECLARE @accesslist BIGINT
DECLARE @notification BIGINT
DECLARE @actions NVARCHAR(MAX)

SET @nameDocument = N'Заявка на аванс'

BEGIN TRY
	BEGIN TRANSACTION

	SELECT @idDocument = id FROM [valeant].[documenttype] WHERE Value = @nameDocument
	IF(@idDocument IS NULL)
	BEGIN
		RAISERROR('"Не найден тип документа "%s""', 16, 1, @nameDocument)
	END

	DELETE FROM [valeant].[matrix_version_3] WHERE [document] = @idDocument
	DELETE FROM [valeant].[node_properties_version_3] WHERE [document] = @idDocument

	SELECT @idMatrix = MAX([id]) FROM [valeant].[matrix_version_3]
	SELECT @idProperty = MAX(id) FROM [valeant].[node_properties_version_3]
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Описываем матрицу
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--В разработке
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- В разработке -> Черновик <<Создать>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'В разработке'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @condition = N'iif(action.Equals("Создать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = N'document.UpdateCost()'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--В разработке -> На согласовании (Непосредственный руководитель) <<Отправить документ на согласование>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'В разработке'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @condition = N'iif(action.Equals("Отправить документ на согласование", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = N'document.UpdateCost()'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--В разработке
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Черновик
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Черновик -> На согласовании (Непосредственный руководитель) <<Отправить документ на согласование>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @condition = N'iif(action.Equals("Отправить документ на согласование", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Черновик -> Аннулирована <<Аннулировать>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Аннулирована'
	SELECT @condition = N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Черновик -> Черновик <<Сохранить>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @condition = N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Черновик
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На доработке
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На доработке -> Аннулирована	iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На доработке'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Аннулирована'
	SELECT @condition = N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	--На доработке -> На согласовании (Непосредственный руководитель)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На доработке'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @condition = N'iif(action.Equals("Отправить документ на согласование", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На доработке -> Черновик
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На доработке'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @condition = N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На доработке
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель) -> Черновик
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @condition = N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель) -> На доработке
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На доработке'
	SELECT @condition = N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель) -> Аннулирована
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Аннулирована'
	SELECT @condition = N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель) -> На согласовании (Руководитель 2-го уровня)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND document.LimitCheck(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель) -> На согласовании (Директор департамента)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.LimitCheck()) AND document.CheckApprovalFirstLiner(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель) -> На согласовании (Ген. директор)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.LimitCheck()) AND (NOT document.CheckApprovalFirstLiner()) AND document.CheckApprovalCeo(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель) -> Утверждена	
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Утверждена'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.LimitCheck()) AND (NOT document.CheckApprovalFirstLiner()) AND (NOT document.CheckApprovalCeo()), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня) -> Черновик
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @condition = N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня) -> На доработке
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На доработке'
	SELECT @condition = N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня) -> Аннулирована
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Аннулирована'
	SELECT @condition = N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня) -> На согласовании (Ответственный за статью расхода)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND document.RoCheck(tokens), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня) -> На согласовании (Директор департамента)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND document.CheckApprovalFirstLiner(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня) -> На согласовании (Ген. директор)	
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND (NOT document.CheckApprovalFirstLiner()) AND document.CheckApprovalCeo(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня) -> Утверждена
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Утверждена'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND (NOT document.CheckApprovalFirstLiner()) AND (NOT document.CheckApprovalCeo()), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода) -> Черновик
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @condition = N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода) -> На доработке
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На доработке'
	SELECT @condition = N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода) -> Аннулирована
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Аннулирована'
	SELECT @condition = N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода) -> На согласовании (Ответственный за статью расхода)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND document.RoCheck(tokens), true, false)'
	SELECT @postfunc = NULL--'document.UpdateCost(actor)'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода) -> На согласовании (Директор департамента)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND document.CheckApprovalFirstLiner(), true, false)'
	SELECT @postfunc = NULL--'document.UpdateCost(actor)'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода) -> На согласовании (Ген. директор)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND (NOT document.CheckApprovalFirstLiner()) AND document.CheckApprovalCeo(), true, false)'
	SELECT @postfunc = NULL--'document.UpdateCost(actor)'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода) -> Утверждена
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Утверждена'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND (NOT document.CheckApprovalFirstLiner()) AND (NOT document.CheckApprovalCeo()), true, false)'
	SELECT @postfunc = NULL--'document.UpdateCost(actor)'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Директор департамента)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Директор департамента) -> Черновик 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @condition = N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Директор департамента) -> На доработке
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На доработке'
	SELECT @condition = N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Директор департамента) -> Аннулирована
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Аннулирована'
	SELECT @condition = N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Директор департамента) -> На согласовании (Ген. директор)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND document.CheckApprovalCeo(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Директор департамента) -> Утверждена 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Утверждена'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.CheckApprovalCeo()), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Директор департамента)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ген. директор)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ген. директор) -> Черновик 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SELECT @condition = N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ген. директор) -> На доработке 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На доработке'
	SELECT @condition = N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ген. директор) -> Аннулирована 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Аннулирована'
	SELECT @condition = N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ген. директор) -> Утверждена 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Утверждена'
	SELECT @condition = N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ген. директор)
	--------------------------------------------------------------------------------------------------------------------------------------------------


	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Утверждена
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Утверждена -> Оплачена
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Утверждена'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Оплачена'
	SELECT @condition = N'iif(action.Equals("Оплатить", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Утверждена
	--------------------------------------------------------------------------------------------------------------------------------------------------


	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Оплачена
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Оплачена -> Утверждена 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Оплачена'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Утверждена'
	SELECT @condition = N'iif(action.Equals("Снять пометку об оплате", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки строки матрицы"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Оплачена
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Описываем свойства
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--В разработке
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT 'В разработке'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'В разработке'
	SET @actions = 'Отправить документ на согласование, Создать'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'alledit'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--В разработке
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Черновик
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT 'Черновик'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Черновик'
	SET @actions = 'Аннулировать,Отправить документ на согласование,Сохранить'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'alledit'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Черновик
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На доработке
	--------------------------------------------------------------------------------------------------------------------------------------------------
	PRINT 'На доработке'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На доработке'
	SET @actions = 'Аннулировать,Отправить документ на согласование,Сохранить'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'alledit'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На доработке
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT 'На согласовании (Непосредственный руководитель)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SET @actions = 'Отозвать'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL	
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	-- M1*
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Непосредственный руководитель)'
	SET @actions = 'Согласовать,Отказать,На доработку'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'M1*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Непосредственный руководитель)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT 'На согласовании (Руководитель 2-го уровня)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SET @actions = 'Отозвать'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	-- M2*
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Руководитель 2-го уровня)'
	SET @actions = 'Согласовать,Отказать,На доработку'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'M2*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Руководитель 2-го уровня)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT 'На согласовании (Ответственный за статью расхода)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SET @actions = 'Отозвать'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	-- R
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ответственный за статью расхода)'
	SET @actions = 'Согласовать,Отказать,На доработку'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'R'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document], [expression])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument, 'document.UpdateCost(action, actor)')
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ответственный за статью расхода)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Директор департамента)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT 'На согласовании (Директор департамента)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SET @actions = 'Отозвать'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	-- F*
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Директор департамента)'
	SET @actions = 'Согласовать,Отказать,На доработку'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'R'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Директор департамента)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ген. директор)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT 'На согласовании (Ген. директор)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SET @actions = 'Отозвать'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	-- G-00000001
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'На согласовании (Ген. директор)'
	SET @actions = 'Согласовать,Отказать,На доработку'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'G-00000001'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--На согласовании (Ген. директор)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Утверждена
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT 'Утверждена'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Утверждена'
	SET @actions = 'Печать'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--R-00000006
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Утверждена'
	SET @actions = 'Печать'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'R-00000006'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Утверждена
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Оплачена
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT 'Оплачена'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Оплачена'
	SET @actions = 'Печать'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--R-00000006
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Оплачена'
	SET @actions = 'Печать, Снять пометку об оплате'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'R-00000006'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Оплачена
	--------------------------------------------------------------------------------------------------------------------------------------------------


	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Аннулирована
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT 'Аннулирована'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'Аннулирована'
	SET @actions = 'Empty'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"Не определены необходимые аргументы для вставки свойства"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--Аннулирована
	--------------------------------------------------------------------------------------------------------------------------------------------------

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

		SELECT @ErrorMessage, @ErrorSeverity, @ErrorState
END CATCH

