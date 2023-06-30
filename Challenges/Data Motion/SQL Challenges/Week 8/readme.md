## Week 8

> Question 1:  You'd like to get the first and last name of the last member(s) who signed up - not just the date. How can you do that?

> Source: https://pgexercises.com/questions/basic/agg2.html

> Solution:

```
select firstname, surname, joindate
from cd.members
where joindate = (select max(joindate) from cd.members)
```

> Question 2:  How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).

> Source: https://pgexercises.com/questions/joins/self2.html

> Solution:

```

```