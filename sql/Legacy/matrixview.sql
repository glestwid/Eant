/*
INSERT INTO [valeant].[matrix_version_3]
VALUES(77, 1, 2, 'iif(action.Equals("Создать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
INSERT INTO [valeant].[matrix_version_3]
VALUES(78, 1, 6, 'iif(owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
INSERT INTO [valeant].[matrix_version_3]
VALUES(79, 1, 3, 'iif(NOT owner.IsCeo AND action.Equals("Отправить", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
*/
/*
INSERT INTO [valeant].[matrix_version_3]
VALUES(80, 3, 5, 'iif(action.Equals("На доработку", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]
VALUES(81, 3, 4, 'iif(action.Equals("Отказать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)

INSERT INTO [valeant].[matrix_version_3]
VALUES(82, 3, 4, 'iif(action.Equals("Аннулировать", StringComparison.InvariantCultureIgnoreCase), true, false)', 3, NULL, NULL, 0)
*/

SELECT [m].[id], [s1].[id], [s1].[name], [s2].[id], [s2].[name], [condition], [postfunc], [dt].[Value], [m].[approvalsheetitem]
FROM [valeant].[matrix_version_3] [m]
INNER JOIN [valeant].[states_version_3] [s1] ON [s1].[id] = [m].[from]
INNER JOIN [valeant].[states_version_3] [s2] ON [s2].[id] = [m].[to]
INNER JOIN [valeant].[documenttype] [dt] ON [dt].[Id] = [m].[document]
WHERE [dt].[Id] = 2
ORDER BY [dt].[Id], [s1].[id]


