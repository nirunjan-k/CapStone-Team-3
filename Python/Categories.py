DROP TABLE IF EXISTS STG_Categories; 
select * into STG_Categories from
(select * from dbo.Categories)a;
 
merge into Project.dbo.STG_Categories sc  
using Project.dbo.Categories c on
sc.CategoryID = c.CategoryID
when matched and (sc.CategoryName<>c.CategoryName  or sc.Description<>c.Description)
then update
set
sc.CategoryName = c.CategoryName,
sc.Description = c.Description
when not matched
then insert values(c.CategoryID,c.CategoryName,c.Description)
when not matched by source
then delete;
 
 
select * from STG_Categories;
