--Landing to Staging Products
 
--DROP TABLE IF EXISTS STG_Products;
--select * into STG_Products from
--(select * from dbo.Products)a;
 
merge into Project.dbo.STG_Products sp
using Project.dbo.Products p on
sp.ProductID = p.ProductID
when matched and (sp.ProductName!=p.ProductName or 
sp.SupplierID!=p.SupplierID or
sp.CategoryID!=p.CategoryID or
sp.QuantityPerUnit!=p.QuantityPerUnit or 
sp.UnitPrice!=p.UnitPrice or 
sp.UnitsInStock!=p.UnitsInStock or 
sp.UnitsOnOrder!=p.UnitsOnOrder or 
sp.ReorderLevel!=p.ReorderLevel or 
sp.Discontinued!=p.Discontinued)
then update
set
sp.ProductName=p.ProductName, 
sp.SupplierID=p.SupplierID, 
sp.CategoryID=p.CategoryID, 
sp.QuantityPerUnit=p.QuantityPerUnit, 
sp.UnitPrice=p.UnitPrice, 
sp.UnitsInStock=p.UnitsInStock, 
sp.UnitsOnOrder=p.UnitsOnOrder, 
sp.ReorderLevel=p.ReorderLevel, 
sp.Discontinued=p.Discontinued
when not matched
then insert values(p.ProductID, p.ProductName, p.SupplierID, p.CategoryID, 
p.QuantityPerUnit, p.UnitPrice, p.UnitsInStock, p.UnitsOnOrder, p.ReorderLevel, p.Discontinued)
when not matched by source
then delete;

select * from STG_Products;

-- Product Dim Table DW Layer
drop table if exists Product_Dim;


create table Product_Dim (
  ProductKey  int NOT NULL IDENTITY,
  ProductID varchar(5),
  ProductName varchar(100),
  SupplierID int ,
	CategoryID int ,
	QuantityPerUnit nvarchar(20) ,
  UnitPrice float(2),
  UnitsInStock int ,
	UnitsOnOrder int ,
	ReorderLevel int ,
  Discontinued int,
  VersionNumber int not null default 0
);




--SCD for DW Layer (Type2) 

merge into dbo.Product_dim pd
using dbo.STG_Products p on
pd.ProductID = p.ProductID
when matched and (
pd.ProductName<>p.ProductName or 
pd.SupplierID<>p.SupplierID or
pd.CategoryID<>p.CategoryID or
pd.QuantityPerUnit<>p.QuantityPerUnit or
pd.UnitPrice<>p.UnitPrice or 
pd.UnitsInStock<>p.UnitsInStock or
pd.UnitsOnOrder<>p.UnitsOnOrder or
pd.ReorderLevel<>p.ReorderLevel or
pd.Discontinued<>p.Discontinued)
then update
set
pd.VersionNumber = pd.VersionNumber-1
when not matched
then insert values(p.ProductID, p.ProductName,p.SupplierID,p.CategoryID,p.QuantityPerUnit,
p.UnitPrice,p.UnitsInStock, p.UnitsOnOrder,p.ReorderLevel,p.Discontinued, 0);


-- insert complete updated row from products to product_dim with versionNumber 0
INSERT INTO Product_dim(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,
UnitPrice,UnitsInStock, UnitsOnOrder,ReorderLevel,Discontinued)
(
SELECT p.ProductID, p.ProductName,p.SupplierID,p.CategoryID,p.QuantityPerUnit,
p.UnitPrice,p.UnitsInStock, p.UnitsOnOrder,p.ReorderLevel,p.Discontinued
FROM STG_Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM Product_dim AS pd
    WHERE pd.ProductID = p.ProductID
    AND (pd.ProductName=p.ProductName and
pd.SupplierID=p.SupplierID and 
pd.CategoryID=p.CategoryID and
pd.QuantityPerUnit=p.QuantityPerUnit and 
pd.UnitPrice=p.UnitPrice and
pd.UnitsInStock=p.UnitsInStock and 
pd.UnitsOnOrder=p.UnitsOnOrder and 
pd.ReorderLevel=p.ReorderLevel and 
pd.Discontinued=p.Discontinued )
));

select * from Product_Dim;