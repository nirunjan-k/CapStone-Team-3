-- Landing to Staging Customers

--DROP TABLE IF EXISTS STG_Customers;
select * into STG_Customers from
(select * from dbo.Customers)a;
 
merge into dbo.STG_Customers scust
using dbo.Customers cust on
scust.CustomerID = cust.CustomerID
when matched and (scust.CompanyName!=cust.CompanyName or
scust.ContactName!=cust.ContactName or 
scust.ContactTitle!=cust.ContactTitle or 
scust.Address!=cust.Address or
scust.City!=cust.City or scust.Region!=cust.Region or 
scust.PostalCode!=cust.PostalCode or 
scust.Country!=cust.Country or 
scust.Phone!=cust.Phone or scust.Fax!=cust.Fax)
then update
set
scust.CompanyName=cust.CompanyName, 
scust.ContactName=cust.ContactName, 
scust.ContactTitle=cust.ContactTitle, 
scust.Address=cust.Address, 
scust.City=cust.City, 
scust.Region=cust.Region, 
scust.PostalCode=cust.PostalCode, 
scust.Country=cust.Country, 
scust.Phone=cust.Phone, 
scust.Fax=cust.Fax
when not matched
then insert values(cust.CustomerID, cust.CompanyName, cust.ContactName, cust.ContactTitle, 
cust.Address, cust.City, cust.Region, cust.PostalCode, cust.Country, cust.Phone, cust.Fax)
when not matched by source
then delete;

select * from STG_Customers;


-- Dim for the DW layer
Drop table IF exists Customer_Dim;
CREATE TABLE Customer_Dim (
  CustomerKey INT NOT NULL IDENTITY ,
  CustomerID varchar(10),
  CompanyName char(50),
  ContactName char(50),
  ContactTitle char(50),
  Address varchar(60),
  City varchar(20),
Region varchar(20),
  PostalCode varchar(20),
  Country varchar(20),
  Phone varchar(20));




-- SCD for DW layer (Type - 1)

merge into dbo.Customer_dim scust
using dbo.STG_Customers cust on
scust.CustomerID = cust.CustomerID
when matched and (scust.CompanyName!=cust.CompanyName or
scust.ContactName!=cust.ContactName or 
scust.ContactTitle!=cust.ContactTitle or 
scust.Address!=cust.Address or
scust.City!=cust.City or scust.Region!=cust.Region or 
scust.PostalCode!=cust.PostalCode or 
scust.Country!=cust.Country or scust.Phone!=cust.Phone)
then update
set
scust.CompanyName=cust.CompanyName, 
scust.ContactName=cust.ContactName, 
scust.ContactTitle=cust.ContactTitle, 
scust.Address=cust.Address, 
scust.City=cust.City, 
scust.Region=cust.Region, 
scust.PostalCode=cust.PostalCode, 
scust.Country=cust.Country, 
scust.Phone=cust.Phone
when not matched
then insert values(cust.CustomerID, cust.CompanyName, cust.ContactName, cust.ContactTitle, 
cust.Address, cust.City, cust.Region, cust.PostalCode, cust.Country, cust.Phone)
when not matched by source
then delete;

select * from customer_dim;