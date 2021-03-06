--1. Dla każdego klienta pokaż datę oraz numer pierwszego złożonego zamówienia.
--(Tabela: dbo.Orders, Wynik: 89 rows)

--1.1)
Select Customers.CustomerID, avg(Orders.OrderID) as FstOrder, min(Orders.OrderDate) as FstOrderDate
from Orders
join Customers on Orders.CustomerID=Customers.CustomerID
group by Customers.CustomerID
order by Customers.CustomerID

--1.2)
select CustomerID,FstOrder,FstOrderDate
from (select Customers.CustomerID, 
	(select top 1 OrderID from Orders where CustomerID = Customers.CustomerID order by OrderDate asc) as FstOrder,
	(select top 1 OrderDate from Orders where CustomerID = Customers.CustomerID  order by OrderDate asc) as FstOrderDate
from Customers) subq
where FstOrderDate is not null

--1.3)
select c.CustomerID, 
	(select top 1 OrderID from Orders where CustomerID = c.CustomerID order by OrderDate asc) as FstOrder,
	(select top 1 OrderDate from Orders where CustomerID = c.CustomerID  order by OrderDate asc) as FstOrderDate
from Customers c
join Orders o on c.CustomerID=o.CustomerID
group by c.CustomerID


--2. Podsumuj pracę przewoźników: podlicz, ile zamówień obsłużyli w każdym roku. W wyniku zaznacz, na którym
--miejscu jest dany przewoźnik w ilości obsłużonych zamówień.
--(Tabele: dbo.Orders, dbo.Shippers, Wynik: 9 rows)

select ROW_NUMBER() OVER (ORDER BY YEAR(o.OrderDate) asc,COUNT(o.OrderID) desc) AS 'Nr',
s.CompanyName, YEAR(o.OrderDate) as Year, COUNT(o.OrderID) as orders
from Orders o
join Shippers s on o.ShipVia=s.ShipperID
group by s.CompanyName, YEAR(o.OrderDate)
order by Year asc, orders desc


--3. Dla wszystkich klientów z Stanów Zjednoczonych (USA) pokaż nazwę firmy, osobę kontaktową, numer telefonu
--oraz fax (jeśli istnieje), w formie jaką przedstawiono na screenie.
--(Tabela: dbo.Customers, Wynik: 7 rows)

select c.CompanyName, c.ContactName, 
case 
	when (c.Fax is not null) then CONCAT(c.Phone,', Fax: ', c.Fax)
	else c.Phone
end as 'Phone Number'
from Customers c
where c.Country like 'USA'

--4. Utwórz kwerendę, która policzy, ile jest się krajów klienckich (mają się nie powtarzać).
--(Tabela: dbo.Customers, Wynik: 21 rows)

select c.Country, ROW_NUMBER() OVER (ORDER BY c.Country asc) AS 'Nr'
from Customers c
group by c.Country


--5. Stwórz kwerendę, która zwróci nazwę firmy, kraj oraz miasto klientów oraz dostawców.
--(Tabele: dbo.Customers, dbo.Suppliers, Wynik: 120 rows)

select  q1.Type,q1.CompanyName, q1.Country,q1.City
from (
(select 'Customers' as 'Type', c.CompanyName,c.Country,c.City from Customers c)
union
(select 'Suppliers', s.CompanyName,s.Country,s.City from Suppliers s) 
) as q1
order by q1.Type asc , q1.Country asc, q1.City asc


--6. Utwórz zapytanie, które pokaże nr zamówienia, nazwę firmy zamawiającej oraz wartość zamówienia. Rozwiąż
--na dwa sposoby.
--(Tabele: dbo.Orders, dbo.Customers, dbo.Order Subtotals (widok), Wynik: 830 rows)
--select * from [Order Details] go

--6.1) select o.OrderID, c.CompanyName, convert(decimal(20,2),sum(od.Quantity*od.UnitPrice*(1-od.Discount)),2) as 'Subtotal'
--6.2) select o.OrderID, c.CompanyName, cast(sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as decimal(10,2)) as 'Subtotal'

select o.OrderID, c.CompanyName, cast(sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as decimal(10,2)) as 'Subtotal'
from Orders o
join [Order Details] od on o.OrderID=od.OrderID
join Customers c on o.CustomerID=c.CustomerID
group by o.OrderID, c.CompanyName
order by o.OrderID


--**********************************************************************************************************--
--**********************************************************************************************************--
--**********************************************************************************************************--
--1. Stwórz tabelę Klienci, zawierającą pola ID (typ identity, primary key), imię, nazwisko, miasto.
create table Klienci (
ID int identity(1,1),
imie varchar(32),
nazwisko varchar(32),
miasto varchar(32),
CONSTRAINT PK_Klienci PRIMARY KEY NONCLUSTERED (ID), 
)

--2. Stwórz drugą tabelę, Konta, zawierającą pola ID (klucz obcy do tabeli Klienci), NrKonta (dowolny 26-znakowy
--numer; primary key), Saldo.

create table Konta (
ID int not null,
NrKonta char(26),
Saldo money,
CONSTRAINT PK_Konta PRIMARY KEY NONCLUSTERED (NrKonta), 
CONSTRAINT FK_Klienci FOREIGN KEY (ID) 
    REFERENCES Klienci (ID) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
)

--3a. Wypełnij tabelę danymi.
insert into Klienci values ('mieszko', 'pierwszy', 'gniezno'),
('boleslaw','chrobry','krakow'),
('wladsylaw','lokeitek','jaskinia'),
('stefan','batory','warszawa'),
('piast','kolodziej','wioska')

--3b. Wypełnij tabelę danymi.

DECLARE @cnt INT = 20;
declare @accnum varchar(26)=''
declare @cnt2 int = 26
declare @rnum char=''
	
	
WHILE @cnt > 0 BEGIN
	while @cnt2>0	Begin
		set @rnum=convert(varchar(1),round(rand()*9,0))
		set @accnum=CONCAT(@accnum,@rnum)
		set @cnt2=@cnt2-1
	end
	insert into Konta values(rand()*4+1,@accnum,round(rand()*20000,2))
	set @accnum=''
	SET @cnt2 = 26;
	SET @cnt = @cnt - 1;
end

--4. Utwórz widok (BankView), który pokaże osoby z saldem 1000 lub mniejszym oraz osoby z saldem 10000 lub
--większym.

create view BankView as
select Klienci.imie, Klienci.nazwisko, Konta.Saldo as Saldo
from Klienci
join Konta on Klienci.ID=Konta.ID
Where Konta.Saldo<1000 or Konta.Saldo>10000

--5. Dodaj kolejnego klienta – Jan Nowak z saldem 31500. Miasto – Warszawa, nr konta:
--25025536548520147930286057.

insert into Klienci values('Jan','Nowak','Warszawa')
go

insert into Konta values(
	(select ID from Klienci where imie='Jan' and nazwisko='Nowak' and miasto='Warszawa'),
	'25025536548520147930286057',
	'31500')

--6. Do salda klienta z ID = 3 dodaj 300 zł.
--(*mial pare kont  to odjelo od wszytskich, a jak od konkretnego konta to trza by doprecyzowac w where)
update Konta 
set Saldo=Saldo+300
Where ID=3

--7. Usuń wszystkie dane z tableli.
delete from klienci
drop table Klienci
go
--delete from klienci

--8. Usuń tabelę.
delete from Konta
drop table Konta


