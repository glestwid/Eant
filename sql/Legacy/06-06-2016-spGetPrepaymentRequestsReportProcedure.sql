IF OBJECT_ID('valeant.spGetPrepaymentRequestsReport') IS NULL
    EXEC('CREATE PROCEDURE valeant.spGetPrepaymentRequestsReport AS SET NOCOUNT ON;')
GO

ALTER PROCEDURE valeant.spGetPrepaymentRequestsReport
AS
BEGIN
	SET NOCOUNT ON;
	select 
		a.Number, 
		a.dateadvance as RequestDate, 
		h.Code as CreatorCode, 
		h.FullName as CreatorFullName,
		null as CreatorCity,
		a.[sum] as Summa,
		s.name as RequestStatus,
		null as StatusComment
	from valeant.advance a
		left join valeant.human h on h.Id = a.creator
		left join valeant.states_version_3 s on s.id = a.[state]
END