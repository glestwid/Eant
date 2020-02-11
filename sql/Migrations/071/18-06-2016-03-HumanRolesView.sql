if object_id('valeant.HumanRoles') IS NULL
    EXEC('create view valeant.HumanRoles as select ''This is a code stub which will be replaced by an Alter Statement'' as CodeStub')
GO

alter view valeant.HumanRoles 
as
select
	r.Id,
	r.Name,
	hr.HumanId,
	r.IsAdministrator,
	r.Code,
	h.Code as HumanCode
from 
	valeant.humantorole hr
	left join valeant.[role] r on r.Id = hr.RoleId
	left join valeant.human h on h.Id = hr.HumanId