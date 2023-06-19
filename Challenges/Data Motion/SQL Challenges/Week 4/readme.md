
### Source: https://pgexercises.com/questions/basic/classify.html
### Question:  How can you produce a list of facilities, with each labelled as 'cheap' or 'expensive' depending on if their monthly maintenance cost is more than $100? Return the name and monthly maintenance of the facilities in question

> Solution:

```
select name,
	   case 
	   		when monthlymaintenance > 100 then 'expensive'
			else 'cheap'
	   end as cost
	   from cd.facilities
```

### Source: https://pgexercises.com/questions/basic/date.html
### Question: How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question

> Solution: 
```
select memid, surname, firstname, joindate
from cd.members
where joindate >= '2012-09-01'
```

### Source: https://pgexercises.com/questions/joins/simplejoin.html
### Question: How can you produce a list of the start times for bookings by members named 'David Farrell'?

> Solution

```
select starttime
from cd.bookings b
join cd.members m
on b.memid = m.memid
where firstname = 'David' and surname ='Farrell'
```