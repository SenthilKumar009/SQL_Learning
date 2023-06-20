> Source: https://pgexercises.com/questions/joins/threejoin2.html

> Question:  Produce a count of the number of facilities that have a cost to guests of 10 or more.
> How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the 
> listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, 
> and the cost. Order by descending cost, and do not use any subqueries.

> Solution:

```
select m.firstname || ' ' || m.surname as member, 
	f.name as facility, 
	case 
		when m.memid = 0 then
			b.slots*f.guestcost
		else
			b.slots*f.membercost
	end as cost
        from
                cd.members m                
                inner join cd.bookings b
                        on m.memid = b.memid
                inner join cd.facilities f
                        on b.facid = f.facid
        where
		b.starttime >= '2012-09-14' and 
		b.starttime < '2012-09-15' and (
			(m.memid = 0 and b.slots*f.guestcost > 30) or
			(m.memid != 0 and b.slots*f.membercost > 30)
		)
order by cost desc;   
```

> Source: https://pgexercises.com/questions/aggregates/fachoursbymonth.html

> Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.

```
select facid, sum(slots) totalslots from cd.bookings
where starttime >='2012-09-01' and starttime < '2012-10-01'
group by facid
order by totalslots
```