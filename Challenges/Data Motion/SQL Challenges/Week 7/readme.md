## Week 7

> Question 1:  Produce a count of the number of facilities that have a cost to guests of 10 or more.
> Find the result of subtracting the timestamp '2012-07-30 01:00:00' from the timestamp '2012-08-31 01:00:00'

> Source: https://pgexercises.com/questions/joins/threejoin2.html

> Solution:

```
select timestamp '2012-08-31 01:00:00' - timestamp '2012-07-30 01:00:00' as interval; 
```

> Question 2: Return a count of bookings for each month, sorted by month

> Source: https://pgexercises.com/questions/date/bookingspermonth.html

> Solution:

```
select date_trunc('month', starttime) as month, count(*)
	from cd.bookings
	group by month
	order by month 
```
