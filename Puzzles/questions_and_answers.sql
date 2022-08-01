use PRACTICE;
GO

-- Puzzle 1

Select isnull(dbo.cart1.Item, '') as 'Item Cart 1', isnull(dbo.cart2.Item, '') as 'Item Cart 2' 
from dbo.cart1
full outer join dbo.cart2 on dbo.cart1.item = dbo.cart2.item;

select * from Employees;

--- Puzzle 2

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

--- Puzzle 3

--- Puzzle 4
Select * from Orders;

with CTE1 as
(select CustomerID, OrderID, DeliveryState, Amount
 from Orders
 where DeliveryState in ('CA'))
select O.CustomerID, O.OrderID, O.DeliveryState, O.Amount
from Orders O
join CTE1
on CTE1.customerID = O.customerID
where O.DeliveryState = 'TX'

--- Puzzle 5
Select * from PhoneDirectory;

WITH CTE1 as
(select CustomerID,
	   CASE 
		WHEN Type = 'Cellular' THEN PhoneNumber
		ELSE NULL
	   END as 'Cellular',
	   CASE 
		WHEN Type = 'Home' THEN PhoneNumber
		ELSE NULL
	   END as 'Home',
	   CASE 
		WHEN Type = 'Work' THEN PhoneNumber
		ELSE NULL
	   END as 'Work'
 from PhoneDirectory)
select CustomerID, 
	   Max(Cellular) as Cellular, 
	   Max(Home) as Home,
	   Max(Work) as Work 
from CTE1
group by CustomerID