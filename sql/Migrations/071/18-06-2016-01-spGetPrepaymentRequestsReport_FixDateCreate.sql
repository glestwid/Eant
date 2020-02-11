IF OBJECT_ID('valeant.spGetPrepaymentRequestsReportFilter') IS NULL
    EXEC('CREATE PROCEDURE valeant.spGetPrepaymentRequestsReportFilter AS SET NOCOUNT ON;')  
GO

ALTER PROCEDURE [valeant].[spGetPrepaymentRequestsReportFilter]
    @type int = null,
	@start DateTimeOffset,
	@end DateTimeOffset
AS
BEGIN
	  select 
	    a.Id,
		a.Number, 
		content.value('(/AdvanceReportDataEx/AdvanceRequestsData/Options/AdvanceDate)[1]', 'datetimeoffset') as RequestDate, 
		h.Code as CreatorCode, 
		h.FullName as CreatorFullName,
		null as CreatorCity,
		a.[sum] as Summa,
		s.name as RequestStatus,
		history.Comment as StatusComment
	from valeant.advance a
		left join valeant.human h on h.Id = a.creator
		left join valeant.states_version_3 s on s.id = a.[state]
		outer apply (
			select top 1 Comment 
			from valeant.advancehistory 
			where Id = a.Id and Comment is not null
			order by [number] desc
			) history
		WHERE (@type is null or a.[type] = @type) AND a.datecreate between @start and @end
END