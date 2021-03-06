USE [Valeant]
GO

ALTER PROCEDURE [valeant].[readapprovedhistory_version_3]
	@id bigint,
	@document nvarchar(256)
AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @documenttype bigint
	SELECT @documenttype = [Id] FROM [valeant].[documenttype] WHERE [Value] = @document
	SELECT [hi].[id], [hi].[number], [hi].[date], [h].[fullname], [ep].[Value] FROM [valeant].[advancehistory] [hi]
	INNER JOIN [valeant].[human] [h] ON [h].[id] = [hi].[Creator]
	INNER JOIN [valeant].[employee] [e] ON [e].[Id] = [h].[Id]
	INNER JOIN [valeant].[employeeposition] [ep] ON [ep].[Id] = [e].[Position]
	INNER JOIN [valeant].[historymap] [m] ON [m].[id] = [hi].[map] AND [m].[InReport] = 1
	WHERE [hi].[id] = @id
	ORDER BY [hi].[number]
END