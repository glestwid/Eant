if object_id('valeant.Documents') IS NULL
    EXEC('create view valeant.Documents as select ''This is a code stub which will be replaced by an Alter Statement'' as CodeStub')
GO

alter view valeant.Documents 
as
select 
	a.Id, 
	a.number as Number,
	a.dateadvance as DocumentDate,
	dt.Value as DocumentTypeDisplayName,
	a.[sum] as Summa,
	s.name as DocumentStateDisplayName,
	ct.Value as DocumentContentType,
	a.content as DocumentContent,
	a.creator as CreatorId,
	a.datecreate as CreationDate,
	h.FullName as CreatorDisplayName,
	d.Name as CreatorDepartmentName,
	a.approvalsheet as ApprovalSheet,
	a.processsubtype as ProcessSubtype,
	dt.Name as DocumentTypeName,
	s.title as DocumentStateName
from valeant.advance a
	left join valeant.documenttype dt on dt.Id = a.[type]
	left join valeant.states_version_3 s on s.Id = a.[state]
	left join valeant.contenttype ct on ct.Id = a.datatype
	left join valeant.human h on h.Id = a.creator
	left join valeant.employee e on e.human = a.creator
	left join valeant.department d on d.Id = e.Department