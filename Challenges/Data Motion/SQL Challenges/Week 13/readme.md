## Week 13

> Question 1:  Combine Two Tables

> Source: LeetCode: 175; https://leetcode.com/problems/combine-two-tables/description/

> Solution: 

```
select FirstName, LastName, City, State
from Person
left outer join Address
on Person.PersonId = Address.PersonId;
```

> Question 2:  Employees Earning More Than Their Managers

> Source: LeetCode 181; https://leetcode.com/problems/employees-earning-more-than-their-managers/

> Solution: 

```
select e.name as employee
from employee e, employee m
where e.managerid = m.id and e.salary > m.salary
```

> Question 3:  Customers Who Never Order

> Source: LeetCode 183; https://leetcode.com/problems/customers-who-never-order/

> Solution: 

```
select name as customers
from customers
where id not in
(select c.id 
 from customers c
 join orders o
 on c.id = o.customerid
)
```