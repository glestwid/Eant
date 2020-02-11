USE [valeant]
GO
DECLARE @id BIGINT
SELECT @id = MAX(ID) + 1 FROM [valeant].[matrix_version_3]
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) 
VALUES (@id, 12, 20, N'iif(NOT owner.IsFirstLevel AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, NULL, NULL, 0)
