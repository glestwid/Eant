SELECT 
	[c].[id],
	[c].[ancestor],
	[na].[id],
	[na].[description], 
	[na].[type],
	[a].[name],
	[nd].[id], 
	[nd].[description],
	[nd].[type],
	[c].[type],
	[c].[value], 
	[ac].[token],
	[c].[straight],
	[n].[id]
	FROM [valeant].[node_version_2] [na]
INNER JOIN [valeant].[nodeclosure_valeant_2] [C] ON [c].[ancestor] = [na].[id] 
LEFT OUTER JOIN [valeant].[actions_version_2] [a] ON [a].[id] = [c].[action]
LEFT OUTER JOIN [valeant].[node_version_2] [nd] ON [nd].[id] = [c].[descendant]
LEFT OUTER JOIN [valeant].[nodeclosureaccesslist_version_2] [ac] ON [ac].[nodeclosure] = [c].[id]
LEFT OUTER JOIN [valeant].[notification] [n] ON [c].[notification] = [n].[id]
