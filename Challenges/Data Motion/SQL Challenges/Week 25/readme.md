# Week 25

> Question 1: Calculate Special Bonus

> Source: LeetCode: 1873; https://leetcode.com/problems/calculate-special-bonus/

> Solution:

```
select employee_id,
       case when mod(employee_id, 2) != 0  and (name not like 'M%') then salary
            else 0
        end bonus
from employees
order by employee_id asc
```

> Question 2: Employees Whose Manager Left the Company

> Source: LeetCode: 1978; https://leetcode.com/problems/employees-whose-manager-left-the-company/description/

> Solution:

```
select employee_id
from employees
where salary < 30000 and manager_id not in (select employee_id from Employees)
order by employee_id
```