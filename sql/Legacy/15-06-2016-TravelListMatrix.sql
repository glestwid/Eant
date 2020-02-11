GO

UPDATE [valeant].matrix_version_3 set condition = N'iif(document.SpentSum < document.Limit, true, false)' 
where [from] =25 and  [to] = 6 and document=3

UPDATE [valeant].matrix_version_3 set condition = N'iif(document.SpentSum >= document.Limit, true, false)' 
where [from] =25 and  [to] = 8 and document=3