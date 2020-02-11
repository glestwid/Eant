USE [valeant]
GO
INSERT [valeant].[matrix_version_3] ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet]) VALUES (193, 5, 12, N'iif(owner.IsFirstLevel AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 2, N'document.UpdateFlagTravelCoordinator(false)', N'B.03.00.01', 0)
