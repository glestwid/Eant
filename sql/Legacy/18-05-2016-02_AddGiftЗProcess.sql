USE [valeant]
GO
SET IDENTITY_INSERT [valeant].[documenttype] ON 
GO
--регистрирация нового типа документа
INSERT [valeant].[documenttype] ([Id], [Value]) VALUES (6, N'Заявка на подарок')
GO
--регистрирация аксесс-листов
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (16, 6, N'allview', N'полный просмотр заявки на подарок')
INSERT [valeant].[documentblock_accesslist_version_2] ([id], [documenttype], [name], [description]) VALUES (17, 6, N'allview', N'полное редактирование заявки на подарок')
GO
--блок формы заявки на подарок
SET IDENTITY_INSERT [valeant].[documenttype] OFF
GO
INSERT [valeant].[documentblock_version_2] ([id], [block]) VALUES (13, N'giftRequest')
GO
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] ON 
GO
--аксесс листы
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] ON 
GO
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (78, 16, 13, 1)
INSERT [valeant].[documentblock_accesslist_details_version_2] ([id], [accesslist], [block], [access]) VALUES (79, 17, 13, 2)
GO
SET IDENTITY_INSERT [valeant].[documentblock_accesslist_details_version_2] OFF
GO
--узлы
DECLARE @id BIGINT
--В разработке
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 1, 1, 17, NULL, N'Отправить, Сохранить', 6)
--Черновик
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 2, 1, 17, NULL, N'Аннулировать,Отправить,Сохранить', 6)
--Аннулирована
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 4, 1, 16, NULL, N'Empty', 6)
--На согласовании (Непосредственный руководитель)
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 3, 1, 16, NULL, N'Отозвать', 6)
--На согласовании (Непосредственный руководитель)
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 3, 2, 16, NULL, N'Согласовать, Отказать, На доработку', 6)
--На доработке
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 5, 1, 17, NULL, N'Аннулировать,Отправить,Сохранить', 6)
--Утверждена
SELECT @id = MAX(ID) + 1 FROM [valeant].[node_properties_version_3]
INSERT [valeant].[node_properties_version_3] ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document]) VALUES (@id, 6, 1, 16, 9, N'Печать', 6)
GO
--матрица
DECLARE @id BIGINT
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--в разработке->черновик
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 1, 2, N'iif(action.Equals("Создать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--в разработке->На согласовании (Непосредственный руководитель)
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 1, 3, N'iif(action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--черновик->Аннулирована
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 2, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--черновик->На согласовании (Непосредственный руководитель)
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 2, 3, N'iif(action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--черновик->черновик
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 2, 2, N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--На согласовании (Непосредственный руководитель)->На доработке
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 3, 5, N'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--На согласовании (Непосредственный руководитель)->Аннулирована
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 3, 4, N'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--На согласовании (Непосредственный руководитель)->Черновик
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 3, 2, N'iif(action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--На доработке ->Аннулирована
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 5, 4, N'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--На доработке ->На доработке
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 5, 5, N'iif(action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--На доработке ->На согласовании (Непосредственный руководитель)
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 5, 3, N'iif(action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
--На согласовании (Непосредственный руководитель)->Утверждена
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (@id, 3, 6, N'iif(action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 6, NULL, NULL, 0)

GO
SET IDENTITY_INSERT [valeant].[historymap] ON 
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (39, 1, 6, N'Заявка на подарок была аннулирована', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (40, 2, 6, N'Заявка на подарок была отправлена на согласование', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (41, 3, 6, N'Заявка на подарок была отправлена на на доработку', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (42, 4, 6, N'Заявка на подарок не была согласована', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (43, 5, 6, N'Заявка на подарок согласована', 1)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (44, 6, 6, N'Заявка на подарок была отозвана', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (45, 7, 6, N'Заявка на подарок была отредактирована', 0)
GO
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (46, 11, 6, N'Заявка на подарок была создана', 0)
GO
SET IDENTITY_INSERT [valeant].[historymap] OFF
GO
