-- Landing to Staging Employees

--DROP TABLE IF EXISTS STG_Employees;
select * into STG_Employees from 
(select * from dbo.Employees)a;




merge into dbo.STG_Employees es
using dbo.Employees e on
es.EmployeeID = e.EmployeeID
when matched and (es.LastName<>e.LastName or es.FirstName<>e.FirstName or es.Title<> e.Title
or es.TitleOfCourtesy<>e.TitleOfCourtesy or es.BirthDate<>e.BirthDate or es.HireDate<>e.HireDate or 
es.Address<>e.Address or es.Country<>e.Country or es.Region<>e.Region or
es.City<>e.City or es.PostalCode<>e.PostalCode or es.HomePhone<>e.HomePhone or es.Extension<>e.Extension 
or es.Notes<>e.Notes or es.ReportsTo<>e.ReportsTo or  es.PostalCode<>e.PostalCode or  
es.PhotoPath<>e.PhotoPath)
then update
set
es.LastName=e.LastName, es.FirstName=e.FirstName,
es.Title=e.Title,
es.TitleOfCourtesy=e.TitleOfCourtesy,
es.BirthDate=e.BirthDate,
es.HireDate=e.HireDate,
es.Address=e.Address,
es.Country=e.Country,
es.Region=e.Region, es.City=e.City,
es.PostalCode=e.PostalCode,
es.HomePhone=e.HomePhone,
es.Extension=e.Extension, es.Notes=e.Notes,
es.ReportsTo=e.ReportsTo, es.PhotoPath=e.PhotoPath
when not matched
then insert values(e.EmployeeID,e.LastName,e.FirstName, e.Title, e.TitleOfCourtesy, e.BirthDate, 
e.HireDate,e.Address,e.City,e.Region,e.PostalCode,e.Country
,e.HomePhone,e.Extension ,e.Photo,e.Notes,e.ReportsTo,e.PhotoPath)
when not matched by source
then delete;

select * from STG_Employees;

-- Dim for DW layer
Drop Table If exists Employee_Dim;
CREATE TABLE Employee_Dim 
(EmployeeKey INT NOT NULL IDENTITY,
EmployeeID int,
LastName varchar(20),
FirstName varchar(10),
BirthDate datetime,
HireDate datetime,
Region varchar(15),
Country varchar(15),
VersionNumber integer not null default 0
);




-- SCD for DW layer (Type - 2)

merge into dbo.Employee_Dim ed
using dbo.STG_Employees e on
ed.EmployeeID = e.EmployeeID
when matched and (ed.LastName<>e.LastName or
ed.Firstname<>e.FirstName or
ed.BirthDate<>e.BirthDate or
ed.HireDate<>e.HireDate or
ed.Region<>e.Region or
ed.Country<>e.Country)
then update
set
ed.VersionNumber = ed.VersionNumber-1
when not matched
then insert values(e.EmployeeID,
e.LastName,
e.FirstName,
e.BirthDate,
e.HireDate,
e.Region,
e.Country, 0);

-- insert complete updated row from orders to orders_dim with versionNumber 0
INSERT INTO Employee_dim (EmployeeID,LastName,FirstName,BirthDate,HireDate,Region,Country)
(
SELECT e.EmployeeID, e.LastName, e.FirstName, e.BirthDate, e.HireDate, e.Region, e.Country
FROM STG_Employees AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM Employee_dim AS ed
    WHERE ed.EmployeeID = e.EmployeeID
    AND (ed.LastName=e.LastName and ed.Firstname=e.FirstName and ed.BirthDate=e.BirthDate and
ed.HireDate=e.HireDate and ed.Region=e.Region and ed.Country=e.Country )
));

select * from Employee_Dim;




 