-- Q1) DISCONTINUED PRODUCT REPORT


select od.OrderID, cu.CustomerID,cu.CompanyName ,p.ProductID, p.ProductName, (od.Quantity * od.UnitPrice) sales
from Product_dim p 
inner join dbo.OrderDetails od
on p.ProductID = od.ProductID
inner join dbo.Orders o
on od.OrderID = o.OrderID
inner join Calendar_Dim c
on c.FullDate = o.OrderDate
inner join Customer_dim cu
on o.CustomerID = cu.CustomerID
where p.Discontinued = 1
order by p.ProductID;



-- Q2) Best and least selling product in each category:


create or alter procedure Best_and_least_selling_product_in_each_category
as
begin
with RankedProducts as(
select 
p.ProductID, p.ProductName, c.CategoryName, 
sum(pf.TotalQuantity) as TotalSales,
Rank() over (partition by c.CategoryId order by sum(pf.TotalQuantity) desc) as SalesRankAsc,
rank() over (partition by c.CategoryId order by sum(pf.TotalQuantity)) as SalesRankDesc
from ProductInStock_Fact pf
join Product_dim p
on pf.ProductKey=p.ProductKey
join Categories_Dim c
on c.CategoriesKey= pf.CategoriesKey
join OrderDetails od
on od.OrderID = pf.orderId
group by p.ProductID, p.ProductName,c.CategoryName, c.CategoryId
)
select 
CategoryName,
Max(case when SalesRankAsc = 1 then ProductName else null end) as BestSellingProduct,
max(case when SalesRankDesc = 1 then ProductName else null end) as LeastSellingProduct
from RankedProducts
Group by CategoryName;
end

exec Best_and_least_selling_product_in_each_category;





 -- Q3) min max avg customer billing


  select c.CompanyName,c.CustomerID,cal.Year,
  min(f.Sales) as Minimum_Bill , max(f.Sales) as Maximum_Bill, AVG(f.Sales) as Average_Bill
  from CustomerEmployee_Fact f
  inner join Customer_Dim c
  on c.CustomerKey=f.customerkey
  inner join Calendar_Dim cal
  on cal.CalendarKey=f.calendarkey
  group by c.CompanyName, cal.Year, c.CustomerID
  order by c.CompanyName, c.CustomerID;



 -- Q4) best Salesperson


 select em.FirstName, em.LastName, em.EmployeeID, cal.Year,sum(f.Sales)  Total 
 from CustomerEmployee_Fact f
 inner join Employee_Dim em
 on em.EmployeeID=f.Employeekey
 inner join Calendar_Dim cal
 on cal.CalendarKey=f.calendarkey
 group by em.FirstName, em.LastName, em.Region, em.EmployeeID, cal.Year
 order by em.FirstName, em.LastName, em.EmployeeID;

 