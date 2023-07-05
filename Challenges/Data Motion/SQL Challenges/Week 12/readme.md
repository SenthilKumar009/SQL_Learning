## Week 12

> Question 1:  Return a count of bookings for each month, sorted by month.

> Source: https://pgexercises.com/questions/date/bookingspermonth.html

> Solution: 

```
select date_trunc('month', starttime) as month, count(*)
	from cd.bookings
	group by month
	order by month 
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