# Week 27

> Question 1: Rank members by (rounded) hours used

> Source: https://pgexercises.com/questions/aggregates/rankmembers.html

> Solution:

```
select firstname, surname,
	((sum(bks.slots)+10)/20)*10 as hours,
	rank() over (order by ((sum(bks.slots)+10)/20)*10 desc) as rank

	from cd.bookings bks
	inner join cd.members mems
		on bks.memid = mems.memid
	group by mems.memid
order by rank, surname, firstname;
```

