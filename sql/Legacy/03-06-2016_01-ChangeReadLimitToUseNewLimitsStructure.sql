USE [Valeant]
GO

ALTER PROCEDURE [valeant].[ReadLimits] 
	@humanId bigint
AS
BEGIN
    SELECT [l].[Id], [d].[Title], [l].[limit], [r].[Code]
		FROM [valeant].[expenditures] [d]
		LEFT JOIN [valeant].[role] r on r.Id = d.ApproverRoleId
		INNER JOIN [valeant].[limits] [l] ON [d].[Id] = [l].[ExpenditureId]
		INNER JOIN [valeant].[employeepositiongroup] [g] ON [g].[id] = [l].[positiongroup]
		INNER JOIN [valeant].[employeeposition] [p] ON [p].[Group] = [l].[positiongroup]
		INNER JOIN [valeant].[employee] [e] ON [e].[Position] = [p].[Id]
		INNER JOIN [valeant].[human] [h] ON [e].[human] = [h].[id]
	WHERE [h].[id] = @humanId
	ORDER BY [d].[Title]
END
