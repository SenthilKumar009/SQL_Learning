
/* Queries: */

/*
1. From the imdb dataset, print the title and rating of those movies which have a genre starting from C released in 2014 
with the budget higher than 4 crore.
*/

-- Solution:

select i.title, i.rating
from imdb i
join genre g
on i.movie_id = g.movie_id
where g.genre like 'C%' and i.title like '%2014%' and i.budget > 40000000;

/* 2. Print the title and ratings of the movies released in 2012 whose metacritic rating is more than 60 and the domestic collections exceed 10c */

-- Solution:

select i.title, i.rating
from imdb i
join earning e
on e.movie_id = i.movie_id
where i.title like '%2012%' and i.metacritic > 60 and e.domestic > 100000000;


/* 3. Print the genre and net profit [(e.domestic + e.worldwide) - i.budget)] among all movies of that genre released in 2012 per genre.*/

select g.genre, max((e.domestic + e.worldwide) - i.budget) as net_profit
	from imdb i
	join genre g
	on i.movie_id = g.movie_id
	join earning e
	on e.movie_id = i.movie_id
	where i.title like '%2012%' and genre is not null
	group by g.genre
	
	
/* 4. Print the genre and maximum weighted rating among all the movies of the genre released in 2014 per genre. */

select g.genre, max(round((i.rating + COALESCE(i.metacritic,0)/10.0)/2,2)) as weighted_rating
from imdb i
join genre g
on i.movie_id = g.movie_id
where i.title like '%2014%' and genre is not null
group by g.genre
order by g.genre

select  genre ,max((Rating + MetaCritic/10 )/2) weighted_rating
from IMDB i inner join genre g on g.Movie_id=i.Movie_id 
where genre is not null and title like '%(2014)%' 
group by genre 
order by genre  

/* 5. Swap Sex*/

select * from salary;

update salary 
set sex = case when sex  = 'f' then 'm' else  'f' end;

select * from salary;

/* 6. Write a SQL solution to output big countries' name, population, and area */

select * from world;

select name, population, area
from world 
where area > 3000000 or population > 25000000;

/* 7. Find the second highest salary*/

with rank_salary as(
    select s.*,
    row_number() over (order by salary desc) as rnk
    from employee s
)
select salary
from rank_salary where rnk = 2
