### Here I am tracking my LeetCode - 50 SQL study plan.

> 1. 1757. Recyclable and Low Fat Products
```
select product_id
from products
where low_fats = 'Y' and recyclable ='Y'
```

> 2. 584. Find Customer Referee
```
select name
from customer
where referee_id != 2 or referee_id is null
```

> 3. 595. Big Countries

```
select name, population, area from world
where population >= 25000000 
or area > 3000000
```

> 4. 1148. Article Views I

```
select distinct author_id as id
from views
where author_id = viewer_id
order by author_id asc
```

> 5. 1683. Invalid Tweets

```
select tweet_id
from tweets
where length(content) > 15
```

> 6. 1378. Replace Employee ID With The Unique Identifier

```
select u.unique_id,
       e.name
from employees e
left outer join employeeuni u
on e.id = u.id
```

> 7. 1068. Product Sales Analysis I

```
select p.product_name, s.year, s.price
from product p
inner join sales s
on p.product_id = s.product_id
```

> 8. 1581. Customer Who Visited but Did Not Make Any Transactions

```
select v.customer_id, count(v.customer_id) count_no_trans  -- v.visit_id, t.transaction_id
from visits v
left outer join transactions t
on v.visit_id = t.visit_id
where t.transaction_id is null
group by v.customer_id
order by count_no_trans desc
```

> 9. 197. Rising Temperature

```
SELECT DISTINCT a.Id
FROM Weather a,Weather b
WHERE a.Temperature > b.Temperature
AND DATEDIFF(a.Recorddate,b.Recorddate) = 1
```

> 10. 1661. Average Time of Process per Machine

```
select a1.machine_id, round(avg(a2.timestamp - a1.timestamp),3) processing_time
from activity a1
inner join activity a2
on a1.machine_id = a2.machine_id and a1.process_id = a2.process_id
and a1.activity_type = 'start' and a2.activity_type = 'end'
group by a1.machine_id
```

> 11. 577. Employee Bonus

```
select name, bonus
from employee e
left outer join bonus b
on e.empid = b.empid
where bonus is null or bonus < 1000
```

> 12. 1280. Students and Examinations

```
select s.student_id, s.student_name, sn.subject_name, COALESCE(COUNT(e.student_id), 0) AS attended_exams
from students s
cross join subjects sn  
left join examinations e
on e.student_id = s.student_id and e.subject_name = sn.subject_name
group by s.student_id, sn.subject_name
order by 1, 3
```

> 13. 570. Managers with at Least 5 Direct Reports

```
select name 
from employee t1
join
(select managerid
 from employee
 group by managerid
 having count(managerid >= 5)) t2
 on t1.id = t2.managerid
```

> 14. 
