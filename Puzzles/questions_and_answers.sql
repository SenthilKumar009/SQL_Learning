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
group by CustomerID;

--- Puzzle 6
Select * from WorkflowSteps;

WITH CTE1 as
(select Workflow, 
	   COUNT(StepNumber) as TotalSteps,
	   COUNT(CompletionDate) as TotalStepsCompleted
 from WorkflowSteps
 group by Workflow)
Select Workflow
from CTE1
where TotalSteps - TotalStepsCompleted != 0;

--- Puzzle 7
Select * from Candidates;
Select * from Requirements;

select distinct CandidateID, Occupation as Requirement
from Candidates
where Occupation in (select * from Requirements)

--- Puzzle 8
select * from WorkflowCases;

select Workflow, sum(Case1) + sum(Case2) + sum(Case3) as Passed
from WorkflowCases
group by Workflow

-- Puzzle 9

with cte_EmpCount as
(select EmployeeID, count(*) LicenseCount
 from Employees
 group by EmployeeID
),
cte_LicenseCombined as
(SELECT a.EmployeeID as EmployeeID1, 
	   b.EmployeeID as EmployeeID2,  
	   count(*) LicenseCountCombo
 FROM Employees a INNER JOIN Employees b
 ON a.License = b.License
 where a.EmployeeID <> b.EmployeeID
 group by a.EmployeeID, b.EmployeeID
)
Select EmployeeID1, EmployeeID2, LicenseCountCombo 
from cte_LicenseCombined a
inner join cte_EmpCount b
ON a.EmployeeID1 <> b.EmployeeID
AND b.LicenseCount = a.LicenseCountCombo

-- Puzzle 10
Select * from SampleData order by IntegerValue asc;

select avg(IntegerValue) as Mean,
	   ((SELECT TOP 1 IntegerValue
	     FROM 
			(SELECT TOP 50 PERCENT IntegerValue 
			 from SampleData 
			 ORDER BY IntegerValue
			) as BottomHalf
		 ORDER BY IntegerValue DESC)
	    +
		(SELECT TOP 1 IntegerValue
		 FROM
			(SELECT TOP 50 PERCENT IntegerValue 
			 from SampleData 
			 ORDER BY IntegerValue DESC
			) as TopHalf
		 ORDER BY IntegerValue ASC)
	    ) * 1 / 2 as "Median",
	   max(IntegerValue) - min(IntegerValue) as "Range",
	   (SELECT TOP 1 IntegerValue as Mode
		FROM
			(SELECT IntegerValue, count(IntegerValue) CountValue
			 FROM SampleData
			 GROUP BY INTEGERVALUE
			) as TopCount
		ORDER BY CountValue DESC) as Mode
from SampleData;

-- Puzzle 11

-- Puzzle 12

-- Puzzle 13

-- Puzzle 14

-- Puzzle 15

-- Puzzle 16

-- Puzzle 17

-- Puzzle 18

-- Puzzle 19

-- Puzzle 20