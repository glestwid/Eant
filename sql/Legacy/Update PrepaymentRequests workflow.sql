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

SET @nameDocument = N'������ �� �����'

BEGIN TRY
	BEGIN TRANSACTION

	SELECT @idDocument = id FROM [valeant].[documenttype] WHERE Value = @nameDocument
	IF(@idDocument IS NULL)
	BEGIN
		RAISERROR('"�� ������ ��� ��������� "%s""', 16, 1, @nameDocument)
	END

	DELETE FROM [valeant].[matrix_version_3] WHERE [document] = @idDocument
	DELETE FROM [valeant].[node_properties_version_3] WHERE [document] = @idDocument

	SELECT @idMatrix = MAX([id]) FROM [valeant].[matrix_version_3]
	SELECT @idProperty = MAX(id) FROM [valeant].[node_properties_version_3]
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������� �������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--� ����������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- � ���������� -> �������� <<�������>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'� ����������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @condition = N'iif(action.Equals("�������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = N'document.UpdateCost()'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--� ���������� -> �� ������������ (���������������� ������������) <<��������� �������� �� ������������>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'� ����������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @condition = N'iif(action.Equals("��������� �������� �� ������������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = N'document.UpdateCost()'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--� ����������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�������� -> �� ������������ (���������������� ������������) <<��������� �������� �� ������������>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @condition = N'iif(action.Equals("��������� �������� �� ������������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�������� -> ������������ <<������������>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'������������'
	SELECT @condition = N'iif(action.Equals("������������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�������� -> �������� <<���������>>
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @condition = N'iif(action.Equals("���������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ���������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ��������� -> ������������	iif(action.Equals("������������", StringComparison.InvariantCultureIgnoreCase), true, false)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ���������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'������������'
	SELECT @condition = N'iif(action.Equals("������������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ��������� -> �� ������������ (���������������� ������������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ���������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @condition = N'iif(action.Equals("��������� �������� �� ������������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ��������� -> ��������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ���������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @condition = N'iif(action.Equals("���������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ���������
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������) -> ��������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������) -> �� ���������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ���������'
	SELECT @condition = N'iif(action.Equals("�� ���������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������) -> ������������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'������������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������) -> �� ������������ (������������ 2-�� ������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND document.LimitCheck(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������) -> �� ������������ (�������� ������������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.LimitCheck()) AND document.CheckApprovalFirstLiner(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������) -> �� ������������ (���. ��������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.LimitCheck()) AND (NOT document.CheckApprovalFirstLiner()) AND document.CheckApprovalCeo(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������) -> ����������	
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'����������'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.LimitCheck()) AND (NOT document.CheckApprovalFirstLiner()) AND (NOT document.CheckApprovalCeo()), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������) -> ��������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������) -> �� ���������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ���������'
	SELECT @condition = N'iif(action.Equals("�� ���������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������) -> ������������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'������������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������) -> �� ������������ (������������� �� ������ �������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND document.RoCheck(tokens), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������) -> �� ������������ (�������� ������������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND document.CheckApprovalFirstLiner(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������) -> �� ������������ (���. ��������)	
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND (NOT document.CheckApprovalFirstLiner()) AND document.CheckApprovalCeo(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������) -> ����������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'����������'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND (NOT document.CheckApprovalFirstLiner()) AND (NOT document.CheckApprovalCeo()), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������) -> ��������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������) -> �� ���������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ���������'
	SELECT @condition = N'iif(action.Equals("�� ���������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������) -> ������������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'������������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������) -> �� ������������ (������������� �� ������ �������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND document.RoCheck(tokens), true, false)'
	SELECT @postfunc = NULL--'document.UpdateCost(actor)'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������) -> �� ������������ (�������� ������������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND document.CheckApprovalFirstLiner(), true, false)'
	SELECT @postfunc = NULL--'document.UpdateCost(actor)'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������) -> �� ������������ (���. ��������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND (NOT document.CheckApprovalFirstLiner()) AND document.CheckApprovalCeo(), true, false)'
	SELECT @postfunc = NULL--'document.UpdateCost(actor)'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������) -> ����������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'����������'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.RoCheck(tokens)) AND (NOT document.CheckApprovalFirstLiner()) AND (NOT document.CheckApprovalCeo()), true, false)'
	SELECT @postfunc = NULL--'document.UpdateCost(actor)'
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (�������� ������������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (�������� ������������) -> �������� 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (�������� ������������) -> �� ���������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ���������'
	SELECT @condition = N'iif(action.Equals("�� ���������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (�������� ������������) -> ������������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'������������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (�������� ������������) -> �� ������������ (���. ��������)
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND document.CheckApprovalCeo(), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (�������� ������������) -> ���������� 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'����������'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase) AND (NOT document.CheckApprovalCeo()), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (�������� ������������)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���. ��������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���. ��������) -> �������� 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���. ��������) -> �� ��������� 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ���������'
	SELECT @condition = N'iif(action.Equals("�� ���������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���. ��������) -> ������������ 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'������������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���. ��������) -> ���������� 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'����������'
	SELECT @condition = N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���. ��������)
	--------------------------------------------------------------------------------------------------------------------------------------------------


	--------------------------------------------------------------------------------------------------------------------------------------------------
	--����������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--���������� -> ��������
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'����������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @condition = N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--����������
	--------------------------------------------------------------------------------------------------------------------------------------------------


	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�������� -> ���������� 
	SELECT @idStateFrom = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SELECT @idStateTo = [id] FROM [valeant].[states_version_3] WHERE [name] = N'����������'
	SELECT @condition = N'iif(action.Equals("����� ������� �� ������", StringComparison.InvariantCultureIgnoreCase), true, false)'
	SELECT @postfunc = NULL
	IF(@idStateFrom IS NULL OR @idStateTo IS NULL OR @condition IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ������ �������"', 16, 1)
	END
	SET @idMatrix = @idMatrix + 1
	INSERT INTO [valeant].[matrix_version_3]([id], [from], [to], [condition], [document], [postfunc])
	VALUES(@idMatrix, @idStateFrom, @idStateTo, @condition, @idDocument, @postfunc)
	SET @idStateFrom = NULL
	SET @idStateTo = NULL
	SET @condition = NULL
	SET @postfunc = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������� ��������
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--� ����������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT '� ����������'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'� ����������'
	SET @actions = '��������� �������� �� ������������, �������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'alledit'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--� ����������
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT '��������'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SET @actions = '������������,��������� �������� �� ������������,���������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'alledit'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ���������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	PRINT '�� ���������'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ���������'
	SET @actions = '������������,��������� �������� �� ������������,���������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'alledit'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ���������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT '�� ������������ (���������������� ������������)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SET @actions = '��������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL	
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
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
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���������������� ������������)'
	SET @actions = '�����������,��������,�� ���������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'M1*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���������������� ������������)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT '�� ������������ (������������ 2-�� ������)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SET @actions = '��������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
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
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������ 2-�� ������)'
	SET @actions = '�����������,��������,�� ���������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'M2*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������ 2-�� ������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT '�� ������������ (������������� �� ������ �������)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SET @actions = '��������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
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
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (������������� �� ������ �������)'
	SET @actions = '�����������,��������,�� ���������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'R'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document], [expression])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument, 'document.UpdateCost(action, actor)')
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (������������� �� ������ �������)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (�������� ������������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT '�� ������������ (�������� ������������)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SET @actions = '��������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
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
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (�������� ������������)'
	SET @actions = '�����������,��������,�� ���������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'R'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (�������� ������������)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���. ��������)
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- O*
	PRINT '�� ������������ (���. ��������)'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SET @actions = '��������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
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
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'�� ������������ (���. ��������)'
	SET @actions = '�����������,��������,�� ���������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'G-00000001'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--�� ������������ (���. ��������)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--����������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT '����������'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'����������'
	SET @actions = '������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
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
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'����������'
	SET @actions = '������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'R-00000006'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--����������
	--------------------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT '��������'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SET @actions = '������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
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
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'��������'
	SET @actions = '������, ����� ������� �� ������'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'R-00000006'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--��������
	--------------------------------------------------------------------------------------------------------------------------------------------------


	--------------------------------------------------------------------------------------------------------------------------------------------------
	--������������
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--O*
	PRINT '������������'
	SET @idProperty = @idProperty + 1
	SELECT @state = [id] FROM [valeant].[states_version_3] WHERE [name] = N'������������'
	SET @actions = 'Empty'
	SELECT @token = [id] FROM [valeant].[tokens_version_3] WHERE [value] = N'O*'
	SELECT @accesslist = [id] FROM [valeant].[documentblock_accesslist_version_2] WHERE [documenttype] = @idDocument AND name = N'allview'
	SET @notification = NULL
	IF(@actions IS NULL OR @state IS NULL OR @token IS NULL OR @accesslist IS NULL)
	BEGIN
		RAISERROR(N'"�� ���������� ����������� ��������� ��� ������� ��������"', 16, 1)
	END
	INSERT INTO [valeant].[node_properties_version_3]([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
	VALUES(@idProperty, @state, @token, @accesslist, @notification, @actions, @idDocument)
	SET @state = NULL
	SET @token = NULL
	SET @accesslist = NULL
	SET @notification = NULL
	SET @actions = NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	--������������
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

