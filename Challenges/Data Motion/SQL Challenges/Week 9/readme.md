## Week 9

> Question 1:  Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and slots, sorted by facility id

> Source: https://pgexercises.com/questions/aggregates/fachours1a.html

> Solution: 

```
select facid, sum(slots) as "total slots" from cd.bookings
group by facid
having sum(slots) > 1000
order by facid;
```

> Question 2:  Produce a list of facilities along with their total revenue. The output table should consist of facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!

> Source: https://pgexercises.com/questions/aggregates/facrev.html

> Solution: 

```
select f.name, sum(
  					b.slots * case
  									when b.memid = 0 then f.guestcost
  									else f.membercost
  							  end	
  				  ) as revenue
from cd.facilities f
join cd.bookings b
on f.facid = b.facid
group by f.name
order by revenue

```