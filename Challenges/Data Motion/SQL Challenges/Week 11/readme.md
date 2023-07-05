## Week 11

> Question 1:  The telephone numbers in the database are very inconsistently formatted. You'd like to print a list of member ids and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.

> Source: https://pgexercises.com/questions/string/translate.html

> Solution: 

```
select memid, translate(telephone, '-() ', '') as telephone
    from cd.members
    order by memid;
```

> Question 2:  Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID

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