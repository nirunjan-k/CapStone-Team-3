
-- CUSTOMER_EMPLOYEE Fact Table for DW Layer 

drop table if exists CustomerEmployee_Fact;
Create table CustomerEmployee_Fact
(customerkey int ,
Employeekey int,
calendarkey int,
orderid varchar(max),
Sales money);


INSERT INTO CustomerEmployee_Fact(CustomerKey, EmployeeKey, CalendarKey, OrderID, Sales)
SELECT
    c.CustomerKey,
    e.EmployeeKey,
    cal.CalendarKey,
    o.OrderID,
    sales = (select sum(UnitPrice*Quantity) from OrderDetails where OrderID = o.OrderID)
FROM
    STG_Orders o
    JOIN Calendar_Dim cal ON o.OrderDate = cal.FullDate
    JOIN Employee_Dim e ON o.EmployeeID = e.EmployeeID
    JOIN Customer_Dim c ON o.CustomerID = c.CustomerID
 
 select * from CustomerEmployee_Fact;