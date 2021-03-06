SELECT [s].[id], [s].[name], [t].[value], [a].[name], [p].[actions], [p].[document]
FROM [valeant].[node_properties_version_3] [p]
INNER JOIN [valeant].[states_version_3] [s] ON [p].[state] = [s].[id]
INNER JOIN [valeant].[tokens_version_3] [t] ON [p].[token] = [t].[id]
INNER JOIN [valeant].[documentblock_accesslist_version_2] [a] ON [a].[id] = [p].[access_list_documentblock]

