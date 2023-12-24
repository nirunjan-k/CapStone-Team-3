-- ProductInStock Fact
drop table if exists ProductInStock_Fact;
create table ProductInStock_Fact(
CalendarKey int,
productKey int,
CategoriesKey int,
SupplierKey int,
UnitsInStock int , UnitsOnOrder int,
ReorderLevel int, TotalQuantity int,
OrderId varchar(max)
)

INSERT INTO ProductInStock_Fact (
    CalendarKey,productKey, CategoriesKey, SupplierKey,UnitsInStock, UnitsOnOrder, ReorderLevel, TotalQuantity,OrderId)
SELECT
    cd.CalendarKey, pd.ProductKey,cat.CategoriesKey, sd.SupplierKey,pd.UnitsInStock,
    pd.UnitsOnOrder,pd.ReorderLevel,(pd.UnitsInStock + pd.UnitsOnOrder) AS TotalQuantity, o.OrderId
FROM
	Orders o
	join OrderDetails od
	on o.OrderID = od.OrderID
	join Product_Dim pd
	on od.ProductID = pd.ProductID
	join Calendar_Dim cd
	on o.OrderDate = cd.FullDate
	join Categories_Dim cat 
	on cat.CategoryID = pd.CategoryID
    join Supplier_Dim sd
	on sd.SupplierID = pd.SupplierID;



select * from ProductInStock_Fact;



