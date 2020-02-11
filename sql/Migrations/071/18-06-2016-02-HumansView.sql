if object_id('valeant.Humans') IS NULL
    EXEC('create view valeant.Humans as select ''This is a code stub which will be replaced by an Alter Statement'' as CodeStub')
GO

alter view valeant.Humans 
as
select 
    h.Code, 
    h.FullName, 
    e.ClockNumber, 
    s.[Value] as DepartmentStatus, 
    d.Code as DepartmentCode, 
    d.Name as DepartmentName,
    h.UserAccount,
    h.Email,
    h.Id,
    h.AssistantId,
    h.DeputyId,
    assistanth.FullName as AssistantFullName,
    deputyh.FullName as DeputyFullName,
    managerh1.FullName as Manager1FullName,
    e.Manager1stLevel,
    managerh2.FullName as Manager2FullName,
    e.Manager2ndLevel,
    p.[Value] as PositionName,
    c.[Description] as CostCenterDescription,
    h.DocumentIssuedBy,
    h.DocumentIssuedOn,
    h.DocumentNumber,
    h.DocumentSeries,
    h.NumberInternationalPassport,
    h.InternationalPassportIssueDate,
    o.[Value] as OrganizationName,
    country.Name as CountryName,
    h.Tel,
    h.LoyaltyCards,
    h.InternationalPassportFirstName,
    h.InternationalPassportLastName ,
    h.InternationalPassportBirthPlace,
    h.InternationalPassportExpiryDate,
    e.FuelCard,
    c.Code as CostCenterCode,
	h.LastLoginTime,
	p.Id as PositionId,
	p.[Group] as PositionGroupId,
	e.[Status] as EmployeeStatus
from valeant.human h
    left join valeant.employee e on h.Id = e.human
    left join valeant.department d on d.Id = e.Department
    left join valeant.departmentstatus s on s.Id = d.[Status]
    left join valeant.employeeposition p on p.id = e.Position
    left join valeant.costcenter c on c.Id = e.CostCentre
    left join valeant.organization o on o.Id = d.Organization
    left join valeant.country country on country.Id = o.Country
    left join valeant.human assistanth on assistanth.Id = h.AssistantId
    left join valeant.human deputyh on deputyh.Id = h.DeputyId
    left join valeant.human managerh1 on managerh1.Id = e.Manager1stLevel
    left join valeant.human managerh2 on managerh2.Id = e.Manager2ndLevel
