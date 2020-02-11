USE [valeant]
GO
SET IDENTITY_INSERT [valeant].[documenttype] ON 
GO
--������������� ������ ���� ���������
INSERT [valeant].[documenttype] ([Id], [Value]) VALUES (6, N'������ �� �������')
GO
--������������� ������-������
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (16, 6, N'allview', N'������ �������� ������ �� �������')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (17, 6, N'allview', N'������ �������������� ������ �� �������')
GO
--���� ����� ������ �� �������
SET IDENTITY_INSERT [valeant].[documenttype] OFF
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (13, N'giftRequest')
GO
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] ON 
GO
--������ �����
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] ON 
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (78, 16, 13, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (79, 17, 13, 2)
GO
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] OFF
GO
--����
DECLARE @id BIGINT
--� ����������
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 1, 1, 17, NULL, N'���������, ���������', 6)
--��������
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 2, 1, 17, NULL, N'������������,���������,���������', 6)
--������������
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 4, 1, 16, NULL, N'Empty', 6)
--�� ������������ (���������������� ������������)
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 3, 1, 16, NULL, N'��������', 6)
--�� ������������ (���������������� ������������)
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 3, 2, 16, NULL, N'�����������, ��������, �� ���������', 6)
--�� ���������
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 5, 1, 17, NULL, N'������������,���������,���������', 6)
--����������
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 6, 1, 16, 9, N'������', 6)
GO
--�������
DECLARE @id BIGINT
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--� ����������->��������
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 1, 2, N'iif(action.Equals("�������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--� ����������->�� ������������ (���������������� ������������)
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 1, 3, N'iif(action.Equals("���������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--��������->������������
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 2, 4, N'iif(action.Equals("������������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--��������->�� ������������ (���������������� ������������)
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 2, 3, N'iif(action.Equals("���������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--��������->��������
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 2, 2, N'iif(action.Equals("���������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--�� ������������ (���������������� ������������)->�� ���������
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 3, 5, N'iif(action.Equals("�� ���������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--�� ������������ (���������������� ������������)->������������
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 3, 4, N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--�� ������������ (���������������� ������������)->��������
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 3, 2, N'iif(action.Equals("��������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--�� ��������� ->������������
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 5, 4, N'iif(action.Equals("������������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--�� ��������� ->�� ���������
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 5, 5, N'iif(action.Equals("���������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--�� ��������� ->�� ������������ (���������������� ������������)
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 5, 3, N'iif(action.Equals("���������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--�� ������������ (���������������� ������������)->����������
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 3, 6, N'iif(action.Equals("�����������", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)

GO
SET IDENTITY_INSERT [valeant].[historymap] ON 
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (39, 1, 6, N'������ �� ������� ���� ������������', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (40, 2, 6, N'������ �� ������� ���� ���������� �� ������������', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (41, 3, 6, N'������ �� ������� ���� ���������� �� �� ���������', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (42, 4, 6, N'������ �� ������� �� ���� �����������', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (43, 5, 6, N'������ �� ������� �����������', 1)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (44, 6, 6, N'������ �� ������� ���� ��������', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (45, 7, 6, N'������ �� ������� ���� ���������������', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (46, 11, 6, N'������ �� ������� ���� �������', 0)
GO
SET IDENTITY_INSERT [valeant].[historymap] OFF
GO
