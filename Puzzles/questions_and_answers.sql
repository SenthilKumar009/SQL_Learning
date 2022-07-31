use PRACTICE;
GO

Select isnull(dbo.cart1.Item, '') as 'Item Cart 1', isnull(dbo.cart2.Item, '') as 'Item Cart 2' 
from dbo.cart1
full outer join dbo.cart2 on dbo.cart1.item = dbo.cart2.item;

select * from Employees;

--Recursion
WITH cte_Recursion AS
(
SELECT  EmployeeID, ManagerID, JobTitle, Salary, 0 AS Depth
FROM    Employees a
WHERE   ManagerID IS NULL
UNION ALL
SELECT  b.EmployeeID, b.ManagerID, b.JobTitle, b.Salary, a.Depth + 1 AS Depth
FROM    cte_Recursion a INNER JOIN 
        Employees b ON a.EmployeeID = b.ManagerID
)
SELECT  EmployeeID, ManagerID, JobTitle, Salary, Depth
FROM    cte_Recursion;
