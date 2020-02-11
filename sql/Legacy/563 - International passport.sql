USE [Valeant]
GO

  alter table [valeant].[human] drop column ValidityInternationalPassport
  alter table [valeant].[human] add  InternationalPassportFirstName nvarchar(250) null
  alter table [valeant].[human] add  InternationalPassportLastName nvarchar(250) null
  alter table [valeant].[human] add  InternationalPassportBirthPlace nvarchar(250) null
  alter table [valeant].[human] add  InternationalPassportIssueDate datetime null
  alter table [valeant].[human] add  InternationalPassportExpiryDate datetime null

  go