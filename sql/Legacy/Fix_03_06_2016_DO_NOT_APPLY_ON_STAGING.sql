USE [Valeant]
GO

alter table valeant.expenditures
add ApproverRoleId bigint null foreign key references [valeant].[role](Id)

alter table valeant.expenditures
drop constraint FK__expenditu__Appro__1D9B5BB6

alter table valeant.expenditures
drop column ApproverId

go

update e set e.ApproverRoleId = r.Id
from valeant.expenditures e
left join valeant.role r on r.Code = e.Advansed

alter table valeant.expenditures
drop column Advansed