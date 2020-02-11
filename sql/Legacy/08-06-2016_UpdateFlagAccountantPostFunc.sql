USE [Valeant]
GO

update [valeant].[matrix_version_3] set postfunc = 'document.UpdateFlagAccountant(false)'
where postfunc like '%document.IsFlagAccountant_=_false%'
update [valeant].[matrix_version_3] set postfunc = 'document.UpdateFlagAccountant(true)'
where postfunc like '%document.IsFlagAccountant_=_true%'