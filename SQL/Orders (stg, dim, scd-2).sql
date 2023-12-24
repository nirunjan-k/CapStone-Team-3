-- Landing to Staging ORDERS

--DROP TABLE IF EXISTS STG_Orders;
--select * into STG_orders from
--(select * from dbo.Orders)a;

merge into Project.dbo.STG_Orders os
using Project.dbo.Orders o on
os.OrderID = o.OrderID
when matched and (os.CustomerID<>o.CustomerID or
os.EmployeeID<>o.EmployeeID or
os.OrderDate<>o.OrderDate or
os.RequiredDate<>o.RequiredDate or
os.ShippedDate<>o.ShippedDate or
os.ShipVia<>o.ShipVia or
os.Freight<>o.Freight or
os.ShipName<>o.ShipName or
os.ShipAddress<>o.ShipAddress or
os.ShipCity<>o.ShipCity or
os.ShipRegion<>o.ShipRegion or
os.ShipPostalCode<>o.ShipPostalCode or
os.ShipCountry<>o.ShipCountry)
then update
set
os.CustomerID=o.CustomerID,
os.EmployeeID=o.EmployeeID,
os.OrderDate=o.OrderDate,
os.RequiredDate=o.RequiredDate,
os.ShippedDate=o.ShippedDate,
os.ShipVia=o.ShipVia,
os.Freight=o.Freight,
os.ShipName=o.ShipName,
os.ShipAddress=o.ShipAddress,
os.ShipCity=o.ShipCity,
os.ShipRegion=o.ShipRegion,
os.ShipPostalCode=o.ShipPostalCode,
os.ShipCountry=o.ShipCountry
when not matched
then insert values(o.OrderID,o.CustomerID,o.EmployeeID,o.OrderDate,o.RequiredDate, o.ShippedDate,o.ShipVia, o.Freight,
o.ShipName,o.ShipAddress,o.ShipCity,o.ShipRegion,o.ShipPostalCode, o.ShipCountry)
when not matched by source
then delete;



