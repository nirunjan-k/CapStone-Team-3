DROP TABLE IF EXISTS STG_Products;
select * into STG_Products from
(select * from dbo.Products)a;
 
merge into Project.dbo.STG_Products sp
using Project.dbo.Products p on
sp.ProductID = p.ProductID
when matched and (sp.ProductID!=p.ProductID or 
sp.ProductName!=p.ProductName or 
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
sp.ProductID=p.ProductID, 
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
