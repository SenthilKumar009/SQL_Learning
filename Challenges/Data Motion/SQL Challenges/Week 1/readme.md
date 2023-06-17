### Question 1: How can you produce a list of facilities that charge a fee to members?

### Solution:
```
select * from cd.facilities where membercost > 0;
```

### Question 2: How can you produce a list of all facilities with the word 'Tennis' in their name?

### Solution:
```
select * from cd.facilities where name like '%Tennis%'
```

### Question 3: How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.

```
select * from cd.facilities where facid in (1,5)
```
### Question 4: 
### Find all Lyft drivers who earn either equal to or less than 30k USD or equal to or more than 70k USD.
### Output all details related to retrieved records.

```
select * from lyft_drivers 
where yearly_salary <= 30000 or yearly_salary >= 70000;
```

### Question 5: Count the number of movies that Abigail Breslin nominated for oscar

```
select count(*) from oscar_nominees
where nominee like '%Abigail Breslin';
```