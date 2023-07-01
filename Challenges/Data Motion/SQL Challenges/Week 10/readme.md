## Week 10

> Question 1:  The telephone numbers in the database are very inconsistently formatted. You'd like to print a list of member ids and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.

> Source: https://pgexercises.com/questions/string/translate.html

> Solution: 

```
select memid, translate(telephone, '-() ', '') as telephone
    from cd.members
    order by memid;
```

> Question 2:  Output the names of all members, formatted as 'Surname, Firstname'

> Source: https://pgexercises.com/questions/string/concat.html

> Solution: 

```
select surname || ', ' || firstname from cd.members
```