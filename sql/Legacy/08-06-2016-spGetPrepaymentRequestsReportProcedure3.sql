GO
/****** Object:  StoredProcedure [valeant].[spGetPrepaymentRequestsReport]    Script Date: 08.06.2016 15:42:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [valeant].[spGetPrepaymentRequestsReport]
    @type int = null
AS
BEGIN
	SET NOCOUNT ON;
	
	    
     IF (@type is NULL)
	  BEGIN
	  select 
	    a.Id,
	    a.Number, 
		a.dateadvance as RequestDate, 
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
			where number = a.number and Comment is not null
			order by [Date] desc
			) history

     END
	 ELSE
	  BEGIN
	  select
	    a.Id,
	    a.Number, 
		a.dateadvance as RequestDate, 
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
			where number = a.number and Comment is not null
			order by [Date] desc
			) history
      where type = @type  
     END



END


GO

/****** Object:  StoredProcedure [valeant].[spGetPrepaymentRequestsReportFilter]    Script Date: 08.06.2016 15:42:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 IF OBJECT_ID('valeant.spGetPrepaymentRequestsReportFilter') IS NULL
    EXEC('CREATE PROCEDURE valeant.spGetPrepaymentRequestsReportFilter AS SET NOCOUNT ON;')  

GO

ALTER PROCEDURE [valeant].[spGetPrepaymentRequestsReportFilter]
    @type int = null,
	@start DateTimeOffset,
	@end DateTimeOffset 
	

AS
BEGIN
	SET NOCOUNT ON;
	
	    
     IF (@type is NULL)
	  BEGIN
	  select 
	    a.Id,
		a.Number, 
		a.dateadvance as RequestDate, 
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
			where number = a.number and Comment is not null
			order by [Date] desc
			) history
		WHERE  a.datecreate between @start and @end
     END
	 ELSE
	  BEGIN
	  
	  select 
	    a.Id,
		a.Number, 
		a.dateadvance as RequestDate, 
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
			where number = a.number and Comment is not null
			order by [Date] desc
			) history
		WHERE a.type =@type AND a.datecreate between @start and @end
     END



END





