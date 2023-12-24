 
DROP TABLE IF EXISTS STG_Customers;
select * into STG_Customers from
(select * from dbo.Customers)a;
 
merge into Project.dbo.STG_Customers scust
using Project.dbo.Customers cust on
scust.CustomerID = cust.CustomerID
when matched and (scust.CustomerID!=cust.CustomerID or 
scust.CompanyName!=cust.CompanyName or
scust.ContactName!=cust.ContactName or 
scust.ContactTitle!=cust.ContactTitle or 
scust.Address!=cust.Address or
scust.City!=cust.City or 
scust.Region!=cust.Region or 
scust.PostalCode!=cust.PostalCode or 
scust.Country!=cust.Country or 
scust.Phone!=cust.Phone or
scust.Fax!=cust.Fax)
then update
set
scust.CustomerID=cust.CustomerID, 
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
