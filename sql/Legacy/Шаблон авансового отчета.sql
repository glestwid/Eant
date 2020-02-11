USE [valeant]
GO

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(94, 1, 2, 'iif(owner.FlagOne AND action.Equals("Создать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(95, 1, 3, 'iif(owner.FlagOne AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(96, 2, 4, 'iif(owner.FlagOne AND action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(97, 2, 3, 'iif(owner.FlagOne AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(98, 2, 2, 'iif(owner.FlagOne AND action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(99, 5, 2, 'iif(owner.FlagOne AND action.Equals("Сохранить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(100, 5, 4, 'iif(owner.FlagOne AND action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(101, 5, 3, 'iif(owner.FlagOne AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(102, 3, 30, 'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(103, 3, 5, 'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(104, 3, 4, 'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(105, 3, 2, 'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(106, 30, 8, 'iif(owner.FlagOne AND document.Check2NdLevel(), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(107, 30, 31, 'iif(owner.FlagOne AND document.Check2NdLevel(), false, true)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(108, 8, 31, 'iif(NOT document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(109, 8, 5, 'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(110, 8, 4, 'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(111, 8, 2, 'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(112, 31, 32, 'iif(owner.FlagOne AND document.CheckOtherCosts(), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(113, 31, 28, 'iif(owner.FlagOne AND document.CheckOtherCosts(), false, true)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(114, 32, 12, 'iif(owner.FlagOne AND document.CheckHwoIs(), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(115, 32, 26, 'iif(owner.FlagOne AND document.CheckHwoIs(), false, true)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(116, 12, 28, 'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(117, 12, 5, 'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(118, 12, 4, 'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(119, 12, 2, 'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(120, 26, 28, 'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(121, 26, 5, 'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(122, 26, 4, 'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(123, 26, 2, 'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(124, 28, 29, 'iif(owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = true', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(125, 28, 8, 'iif(owner.FlagOne AND action.Equals("Дополнительное согласование", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = true', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(126, 28, 2, 'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(127, 8, 27, 'iif(document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(128, 8, 5, 'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(129, 8, 4, 'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(130, 8, 2, 'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(131, 27, 29, 'iif(document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(132, 27, 5, 'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(133, 27, 4, 'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(134, 27, 2, 'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(135, 29, 6, 'iif(document.IsFlagAccountant AND owner.FlagOne AND action.Equals("Согласовать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(136, 29, 5, 'iif(owner.FlagOne AND action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(137, 29, 4, 'iif(owner.FlagOne AND action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)

INSERT INTO [valeant].[matrix_version_3]([id],[from],[to],[condition],[document],[postfunc],[approvalsheetitem],[clearapprovalsheet])
VALUES(138, 29, 2, 'iif(owner.FlagOne AND action.Equals("Отозвать", StringComparison.InvariantCultureIgnoreCase), true, false)', 4, 'document.IsFlagAccountant = false', NULL, 0)




GO


