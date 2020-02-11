USE [Valeant]
GO
/****** Object:  StoredProcedure [valeant].[spGetPrepaymentRequestsReport]    Script Date: 6/29/2016 2:22:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [valeant].[spGetPrepaymentRequestsReport]
	@type int = null
AS
BEGIN
	SET NOCOUNT ON;
	select 
		a.Id,
		a.Number, 
		a.dateadvance as RequestDate, 
		e.ClockNumber as CreatorCode, 
		h.FullName as CreatorFullName,
		null as CreatorCity,
		a.[sum] as Summa,
		s.name as RequestStatus,
		history.Comment as StatusComment
	from valeant.advance a
		left join valeant.human h on h.Id = a.creator
		join valeant.employee e on e.human = h.Id 
		left join valeant.states_version_3 s on s.id = a.[state]
		outer apply (
			select top 1 Comment 
			from valeant.advancehistory 
			where Id = a.Id and Comment is not null
			order by [number] desc
			) history
	where (@type is null) or a.[type] = @type
END
