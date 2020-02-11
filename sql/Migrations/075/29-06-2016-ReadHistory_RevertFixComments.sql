IF OBJECT_ID('valeant.ReadHIstory') IS NULL
    EXEC('CREATE PROCEDURE valeant.ReadHistory AS SET NOCOUNT ON;')  
GO

ALTER PROCEDURE valeant.ReadHistory
	@id bigint,
	@document nvarchar(256)
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @documenttype bigint
	SELECT @documenttype = Id FROM valeant.documenttype WHERE Value = @document

	SELECT hi.id, hi.number, hi.[date], h.fullname, m.history, hi.Comment, m.InReport 
		FROM valeant.advancehistory hi
		INNER JOIN valeant.human h ON h.id = hi.Creator
		INNER JOIN valeant.historymap m ON m.id = hi.map	
		--outer apply (
		--	select top 1 Comment 
		--	from valeant.advancehistory 
		--	where Id = hi.Id and Comment is not null
		--	order by [number] desc
		--	) history
	WHERE hi.id = @id
	ORDER BY hi.number
END 


