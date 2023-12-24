-- Landing to Staging Suppliers

--DROP TABLE IF EXISTS STG_Suppliers;
select * into STG_Suppliers from
(select * from dbo.Suppliers)a;

merge into dbo.STG_Suppliers ss
using dbo.Suppliers s on
ss.SupplierID = s.SupplierID
when matched and (ss.CompanyName<>s.CompanyName or ss.ContactName<>s.ContactName or 
ss.ContactTitle<>s.ContactTitle or ss.Address<>s.Address or ss.City<>s.City or ss.Region<>s.Region 
or ss.PostalCode<>s.PostalCode or ss.Country<>s.Country or ss.Phone<>s.Phone or
ss.Fax<>s.Fax or ss.HomePage<>s.HomePage)
then update
set
ss.CompanyName=s.CompanyName, 
ss.ContactName=s.ContactName,
ss.ContactTitle=s.ContactTitle,
ss.Address=s.Address,
ss.City=s.City,
ss.Region=s.Region,
ss.PostalCode=s.PostalCode,
ss.Country=s.Country,
ss.Phone=s.Phone,
ss.Fax=s.Fax,
ss.HomePage=s.HomePage
when not matched
then insert values(s.SupplierID, s.CompanyName, s.ContactName, s.ContactTitle, s.Address, s.City,
s.Region,s.PostalCode, s.Country,s.Phone,s.Fax,s.HomePage)
when not matched by source
then delete;

select * from STG_Suppliers;

-- Dim for DW layer

Drop table IF EXISTS Supplier_Dim;
CREATE TABLE Supplier_Dim (
  SupplierKey INT NOT NULL IDENTITY ,
  SupplierID int,
  CompanyName varchar(50),
  ContactName varchar(50),
  ContactTitle varchar(50),
  Address varchar(50),
  City varchar(50),
  Region varchar(50),
  PostalCode varchar(50),
  Country varchar(50),
  Phone varchar(50),
  Fax varchar(50),
  HomePage nvarchar(max));


--SCD for DW layer (Type - 1)

merge into dbo.Supplier_dim ss
using dbo.STG_Suppliers s on
ss.SupplierID = s.SupplierID
when matched and (ss.CompanyName<>s.CompanyName or ss.ContactName<>s.ContactName or ss.ContactTitle<>s.ContactTitle or
ss.Address<>s.Address or ss.City<>s.City or ss.Region<>s.Region or ss.PostalCode<>s.PostalCode or ss.Country<>s.Country 
or ss.Phone<>s.Phone or
ss.Fax<>s.Fax or ss.HomePage<>s.HomePage)
then update
set
ss.CompanyName=s.CompanyName, 
ss.ContactName=s.ContactName,
ss.ContactTitle=s.ContactTitle,
ss.Address=s.Address,
ss.City=s.City,
ss.Region=s.Region,
ss.PostalCode=s.PostalCode,
ss.Country=s.Country,
ss.Phone=s.Phone,
ss.Fax=s.Fax,
ss.HomePage=s.HomePage
when not matched
then insert values(s.SupplierID, s.CompanyName, s.ContactName, s.ContactTitle, s.Address, s.City,s.Region,s.PostalCode, 
s.Country,s.Phone,s.Fax,s.HomePage)
when not matched by source
then delete;

select * from Supplier_Dim;

