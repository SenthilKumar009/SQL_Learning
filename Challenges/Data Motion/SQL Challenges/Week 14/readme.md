## Week 14

> Question 1:  Duplicate Emails

> Source: LeetCode: 182; https://leetcode.com/problems/duplicate-emails/

> Solution: 

```
select email
from person
group by email
having count(email) > 1
```

> Question 2:  Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.

> Source: https://pgexercises.com/questions/aggregates/nbooking.html

> Solution: 

```
select m.surname, m.firstname, m.memid, min(b.starttime) starttime
from cd.members m
join cd.bookings b
on m.memid = b.memid
where b.starttime >= '2012-09-01'
group by surname, firstname, m.memid
order by 3
```

> Question 3:  Duplicate Emails

> Source: LeetCode: 595; https://leetcode.com/problems/big-countries/

> Solution: 

```
select name, population, area from world
where population >= 25000000 
or area > 3000000
```
