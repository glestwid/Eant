--#Bug 671

insert into [valeant].[action] ([action]) values ('Оплатить')
go

insert into [valeant].[historymap] (actionid, documentid, history, inreport)
values
((select id from [valeant].[action] where [action] = 'Оплатить'), 1, 'Заявка на аванс была оплачена', 0)
go