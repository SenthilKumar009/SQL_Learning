### Source: https://pgexercises.com/questions/aggregates/count2.html
### Question:  Produce a count of the number of facilities that have a cost to guests of 10 or more.

> Solution:

```
select count(*) from cd.facilities where guestcost > 10;
```

### Source: https://pgexercises.com/questions/aggregates/count3.html
### Question:  Produce a count of the number of recommendations each member has made. Order by member ID.

> Solution:

```
select recommendedby, count(recommendedby) count
from cd.members
where recommendedby is not null
group by recommendedby
order by recommendedby;
```

### Source: https://pgexercises.com/questions/aggregates/fachours1a.html
### Question:  Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and slots, sorted by facility id.

> Solution:

```
select facid, sum(slots) as "total slots" from cd.bookings
group by facid
having sum(slots) > 1000
order by facid;
```
