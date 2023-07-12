## Week 15

> Question 1:  Not Boring Movies

> Source: LeetCode: 620; https://leetcode.com/problems/not-boring-movies/

> Solution: 

```
select * from cinema
where mod(id,2) = 1 and description <> 'Boring'
order by rating desc
```

> Question 2:  Sales Person

> Source: LeetCode: 607; https://leetcode.com/problems/sales-person/

> Solution: 

```
select name
from
salesperson
where sales_id not in
(select sales_id
 from orders o
 left join company c
 on o.com_id = c.com_id
 where c.name = 'RED')
```