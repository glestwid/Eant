alter table valeant.documenttype
add Name nvarchar(128) null
go

update valeant.documenttype set Name = 'PrepaumentRequest' where Value = 'Заявка на аванс'
update valeant.documenttype set Name = 'TripRequest' where Value = 'Заявка на командировку/служебную поездку'
update valeant.documenttype set Name = 'TravelList' where Value = 'Маршрутный лист'
update valeant.documenttype set Name = 'TripReport' where Value = 'Авансовый отчет по командировке/служебной поездке'
update valeant.documenttype set Name = 'RepresentativeReport' where Value = 'Авансовый отчет по представительским и текущим расходам'
update valeant.documenttype set Name = 'GiftRequest' where Value = 'Заявка на подарок'

alter table valeant.documenttype
alter column Name nvarchar(128) not null
go