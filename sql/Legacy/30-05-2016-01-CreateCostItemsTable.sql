use [Valeant]
go

begin TRY
	begin tran

	-- create new table for expenditures
	create table [valeant].[expenditures] (
		Id bigint identity (1,1) not null primary key,
		Title nvarchar(256) not null,
		ApproverRoleId bigint null
			foreign key references [valeant].[role](Id),
		GroupLimitCode nvarchar(16) null,
		CreditGroupId bigint null,
		Account1GroupId bigint null,
		Account2GroupId bigint null,
		IsActive bit not null default 1
	)

	-- copy expenditures from simpledictionary
	insert into [valeant].[expenditures] (Title, GroupLimitCode, IsActive, ApproverRoleId)
		select sd.Value, 0, sd.Actual, r.Id
		from [valeant].[simpledictionarytype] sdt
		left join [valeant].[simpledictionary] sd on sd.[Type] = sdt.Id
		left join [valeant].[role] r on r.Code = sd.Advansed
		where sdt.Value = 'Expenditure'

	-- add foreign to limits table
	alter table [valeant].[limits]
		add ExpenditureId bigint null 

	-- relink limits with expenditures
	update lim set lim.ExpenditureId = ex.Id
	from [valeant].[limits] lim
	left join [valeant].[simpledictionary] sd on sd.Id = lim.Expenditure
	left join [valeant].[expenditures] ex on ex.Title = sd.Value

	--remove old column (it was replaced by ExpenditureId)
	alter table [valeant].[limits] drop column Expenditure
	alter table [valeant].[limits] alter column ExpenditureId bigint not null
	alter table [valeant].[limits] add foreign key (ExpenditureId) references [valeant].[expenditures](Id)

	-- delete expenditures from simpledictionary
	delete sd from [valeant].[simpledictionarytype] sdt
	inner join [valeant].[simpledictionary] sd on sd.[Type] = sdt.Id
	where sdt.Value = 'Expenditure'

	-- create connction table
	create table [valeant].[expenditureDocumentType] (
		ExpenditureId bigint not null 
			foreign key references [valeant].[expenditures](Id),
		DocumentTypeId bigint not null 
			foreign key references [valeant].[documenttype](Id),
		constraint PK_ExpenditureId_DocumentTypeId primary key (ExpenditureId, DocumentTypeId)
	)

	-- fill connection table for only 'Заявка на аванс'
	declare @DocumentTypeId bigint
	select @DocumentTypeId = dt.Id from [valeant].[documenttype] dt where dt.Value = 'Заявка на аванс'
	insert into [valeant].[expenditureDocumentType] (ExpenditureId, DocumentTypeId)
		select ex.Id, @DocumentTypeId from [valeant].[expenditures] ex

	select 'Ok'
	commit tran
end TRY
begin catch
	if @@TRANCOUNT > 0
		rollback tran

	 SELECT 
        ERROR_NUMBER() AS ErrorNumber
       ,ERROR_MESSAGE() AS ErrorMessage;	
end catch


