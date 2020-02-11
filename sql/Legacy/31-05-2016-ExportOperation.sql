GO
declare @id int 
declare @stateid int


SET IDENTITY_INSERT [valeant].[historymap] OFF

IF NOT EXISTS(select [id] from  [valeant].[states_version_3] where [title]='Exported' )
BEGIN
  select @stateid =(max(id) +1) from [valeant].[matrix_version_3]
 INSERT INTO [valeant].[states_version_3] ( [id], [name], [title]) VALUES (@stateid,N'Выгружен', N'Exported')
END

select @stateid =(max(id)) from [valeant].[states_version_3]



delete from  [valeant].[matrix_version_3] where [condition]='action="Выгрузить"'

delete from  [valeant].[node_properties_version_3] where [actions]='Выгрузить'



select @id =(max(id) +1) from [valeant].[matrix_version_3]
insert into [valeant].[matrix_version_3] (id, [from], [to], document, condition,clearapprovalsheet)
values (@id,6,@stateid,4,'action="Выгрузить"',0)
select @id =(max(id) +1) from [valeant].[matrix_version_3]
insert into [valeant].[matrix_version_3] (id, [from], [to], document, condition,clearapprovalsheet)
values (@id,6,@stateid,5,'action="Выгрузить"',0)

select @id =(max(id) +1) from [valeant].[node_properties_version_3]
insert into [valeant].[node_properties_version_3] ([id],[state],[token],[access_list_documentblock],[actions],[document])
values(@id,@stateid,1,14,'Выгрузить',4)
select @id =(max(id) +1) from [valeant].[node_properties_version_3]
insert into [valeant].[node_properties_version_3] ([id],[state],[token],[access_list_documentblock],[actions],[document])
values(@id,@stateid,1,14,'Выгрузить',5)

IF NOT EXISTS(select [id] from  [valeant].[action] where [action]='Выгрузить' )
BEGIN
 INSERT INTO [valeant].[action] (  [action], [description]) VALUES (N'Выгрузить', N'Выгрузить в Navision')
END



SET IDENTITY_INSERT [valeant].[historymap] ON 

DECLARE @actionid int

select @actionid = id from [valeant].[action] where [action]='Выгрузить' 

delete from [valeant].[historymap] where [actionid] = @actionid

select @id =(max(id) +1) from [valeant].[historymap]
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (@id, @actionid,  4, N'Документ выгружен в Navision', 0)
select @id =(max(id) +1) from [valeant].[historymap]
INSERT [valeant].[historymap] ([id], [actionid], [documentid], [history], [inreport]) VALUES (@id, @actionid,  5, N'Документ выгружен в Navision', 0)


