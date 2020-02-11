USE Valeant
go

insert into valeant.node_properties_version_3 ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
values (93, 6, 12, 1, null, 'Оплатить', 1)
insert into valeant.node_properties_version_3 ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
values (94, 7, 12, 1, null, 'Печать,Снять пометку об оплате', 1)
insert into valeant.node_properties_version_3 ([id], [state], [token], [access_list_documentblock], [notification], [actions], [document])
values (95, 7, 1, 1, null, 'Печать', 1)
go

insert into valeant.matrix_version_3 ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet])
values (195, 6, 7, 'action=="Оплатить"', 1, null, null, 0)
insert into valeant.matrix_version_3 ([id], [from], [to], [condition], [document], [postfunc], [approvalsheetitem], [clearapprovalsheet])
values (194, 7, 6, 'action=="Снять пометку об оплате"', 1, null, null, 0)
go