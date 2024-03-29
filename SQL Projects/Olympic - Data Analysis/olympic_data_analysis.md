
<H3> Olympic Data Analysis </H3>

<H4> Tables Creation </H4>

```
DROP TABLE IF EXISTS OLYMPICS_HISTORY;
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY
(
    id          INT,
    name        VARCHAR,
    sex         VARCHAR,
    age         VARCHAR,
    height      VARCHAR,
    weight      VARCHAR,
    team        VARCHAR,
    noc         VARCHAR,
    games       VARCHAR,
    year        INT,
    season      VARCHAR,
    city        VARCHAR,
    sport       VARCHAR,
    event       VARCHAR,
    medal       VARCHAR
);

DROP TABLE IF EXISTS OLYMPICS_HISTORY_NOC_REGIONS;
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY_NOC_REGIONS
(
    noc         VARCHAR,
    region      VARCHAR,
    notes       VARCHAR
);
```

<h4> Load Data </h4>

```
COPY OLYMPICS_HISTORY (id, name, sex, age, height, weight, team, noc, games, year, season, city, sport, event, medal)
FROM '\..\Olympic-Data\athlete_events.csv'
DELIMITER ','
CSV HEADER;

COPY OLYMPICS_HISTORY_NOC_REGIONS (noc, region, notes)
from '\..\Olympic-Data\noc_regions.csv'
DELIMITER ','
CSV HEADER;
```

<h4> View Data </h4>

```
select * from OLYMPICS_HISTORY;
select * from OLYMPICS_HISTORY_NOC_REGIONS;
```

Q1: How many olympics games have been held? 
	     Problem Statement: Write a SQL query to find the total no of Olympic Games held as per the dataset
```
select count(distinct(games)) as Total_Olympics from olympics_history
```

Q2: List down all Olympics games held so far. 
	   Problem Statement: Write a SQL query to list down all the Olympic Games held so far.
```
select distinct (year, season), city
from olympics_history

select distinct year, season, city
from olympics_history
order by year;
```

Q3: Mention the total no of nations who participated in each olympics game? 
	   Problem Statement: SQL query to fetch total no of countries participated in each olympic games.
```
select distinct games,
	   count(distinct(noc))
from olympics_history
group by games
order by games;
```

Q4: Which year saw the highest and lowest no of countries participating in olympics? 
	   Problem Statement: Write a SQL query to return the Olympic Games which had the highest participating countries and the lowest participating countries.

1. Coutries Particiapted in each of the olympics games
2. Find the total countries from each olympics games
3. Get the first and last value from the result

```
with all_countries as
     	(select games, nr.region
      	 from olympics_history oh
      	 join olympics_history_noc_regions nr ON nr.noc=oh.noc
      	 group by games, nr.region
		 order by games), 
	 tot_countries as
     	(select games, count(1) as total_countries
         from all_countries
         group by games)
     select distinct
     concat(first_value(games) over(order by total_countries), ' - ' , first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
     concat(first_value(games) over(order by total_countries desc), ' - ', first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
     from tot_countries
     order by 1;
```
Q5: Which nation has participated in all of the olympic games? 
	   Problem Statement: SQL query to return the list of countries who have been part of every Olympics games.

1. Find the total no of Olympic Games
2. Find the list of countries participated in each Olympic Games
3. Get the number of countries participated in each Olympic Games
4. Compare 1 and 3

```
with tot_games as
              (select count(distinct games) as total_games
               from olympics_history),
     countries as
              (select games, nr.region as country
               from olympics_history oh
               join olympics_history_noc_regions nr ON nr.noc=oh.noc
               group by games, nr.region
			   order by games),
     countries_participated as
              (select country, count(1) as total_participated_games
               from countries
               group by country)
      select cp.*
      from countries_participated cp
      join tot_games tg on tg.total_games = cp.total_participated_games
      order by 1;
```

Q6. Identify the sport which was played in all summer olympics. 
	   Problem Statement: SQL query to fetch the list of all sports which have been part of every olympics.

1. Find total no of summer olympic games
2. Find for each sport, how many games where they playedd in
3. Compare 1 and 2

```
with summer_olympics as
(select count(distinct games) as total_summer_games
 from olympics_history
 where season = 'Summer'
),
summer_olympic_games as
(select distinct sport, games
 from olympics_history
 where season = 'Summer'
 order by games
),
summer_games as
(select sport, count(games) no_of_games
 from summer_olympic_games
 group by sport)
select *
from summer_games
join summer_olympics
on summer_games.no_of_games = summer_olympics.total_summer_games;
```

Q7. Which Sports were just played only once in the olympics. 
	   Problem Statement: Using SQL query, Identify the sport which were just played once in all of olympics.
1. List out the sport played in all the games
2. Count the occurance of each events across the years

```
with t1 as
(select sport,
	    year,
	    games
from olympics_history
order by sport, year),
t2 as 
(select sport,
	   count(distinct(year)) no_of_games
 from t1
 group by sport
 having count(distinct(year)) = 1)
select distinct t2.*,
	   games
from t2
join olympics_history oh
on oh.sport = t2.sport
order by t2.sport
```
Q8. Fetch the total no of sports played in each olympic games. 
	   Problem Statement: Write SQL query to fetch the total no of sports played in each olympics. */

1. List out the sports played in every olympic games
2. Count the total sports by every olympic games

```
with t1 as
(select games,
 	    sport
 from olympics_history
 group by games, sport
 order by games)
 select games,
 	    count(sport) as total_sports
 from t1
 group by games
 order by total_sports desc, games
```

Q9. Fetch oldest athletes to win a gold medal 
	   Problem Statement: SQL Query to fetch the details of the oldest athletes to win a gold medal at the olympics.

1. Get the details of athlets who won the Gold medal
2. Get the oldest athlets who won the Gold Medal

```
with t1 as
(select name,
	   sex,
	   cast(case when age = 'NA' then '0' else age end as int) as age,
	   team, games, city, sport, event, medal
 from olympics_history
 where medal ='Gold')
select * from t1
where age = (select max(age) from t1)

with temp as
     (select name,
	  		 sex,
	  		 cast(case when age = 'NA' then '0' else age end as int) as age,
             team, games, city, sport, event, medal
      from olympics_history),
ranking as 
	 (select *, 
	  		 rank() over(order by age desc) as rnk
      from temp
      where medal='Gold')
select *					
from ranking
where rnk = 1;
```

Q10. Find the Ratio of male and female athletes participated in all olympic games. 
		Problem Statement: Write a SQL query to get the ratio of male and female participants

```
with sex_count as
(select sex,
	   count(case when sex = 'M' then 1 else 0 end) as total
	   --count(case when sex = 'F' then 1 else 0 end) as female
 from olympics_history
 group by sex
)
select concat((min(total)/ min(total)),':', (round((max(total)*1.0)/ (min(total)*1.0), 2)))
from sex_count;
```

Q11. Fetch the top 5 athletes who have won the most gold medals.

1. List the athlets who won the gold medals
2. Apply Ranking
3. Print the top 5

```
with t1 as
(select name,
	   team,
	   count(medal) total_medal
from olympics_history
where medal = 'Gold'
group by name, team
order by total_medal desc),
t2 as
(select * , dense_rank() over( order by total_medal desc) ranking
 from t1
)
select * from t2 where ranking < 6;
```

Q12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).  
		Problem Statement: SQL Query to fetch the top 5 athletes who have won the most medals (Medals include gold, silver and bronze).

1. List the athlets who won the gold/Silver/Bronze medals
2. Apply Ranking
3. Print the top 5

```
with t1 as
(select name,
	   team,
	   count(medal) total_medal
from olympics_history
where medal = 'Gold' or medal ='Silver' or medal = 'Bronze'
group by name, team
order by total_medal desc),
t2 as
(select * , dense_rank() over( order by total_medal desc) ranking
 from t1
)
select * from t2 where ranking < 6;
```

Q13. Fetch the top 5 most successful countries in olympics. Success is defined by numbers of medals won.
		Problem Statement: Write a SQL query to fetch the top 5 most successful countries in olympics. (Success is defined by no of medals won)

1. Count the medals based on the NOC
2. Match the NOC with region
3. Display the top 5 countries

```
with t1 as
(select noc,
	   count(medal) total_medals,
 	   dense_rank() over(order by count(medal) desc) as ranking
 from olympics_history
 where medal <> 'NA'
 group by noc)
select rn.region,
	   total_medals,
	   ranking
from t1
join olympics_history_noc_regions rn
on t1.noc = rn.noc
where ranking < 6
order by total_medals desc;
```

Q14. List down total gold, silver and bronze medals won by each country.
		Problem Statement: Write a SQL query to list down the  total gold, silver and bronze medals won by each country.

1. List the countries which won the medals
2. Find the total medals won by countries in each category
3. Merge the output with Region to get the country name
4. Pivot the output

```
select nr.region as country,
	   	  medal, count(1) as total_medals
 		  from olympics_history oh
 		  join olympics_history_noc_regions nr
 		  on nr.noc = oh.noc
 		  where medal <> 'NA'
 		  group by nr.region, medal
 		  order by nr.region, total_medals

CREATE EXTENSION tablefunc;

select country,
	   coalesce(gold,0) as gold,
	   coalesce(silver,0) as silver,
	   coalesce(bronze,0) as bronze
from
crosstab('select nr.region as country,
	   	  medal, count(1) as total_medals
 		  from olympics_history oh
 		  join olympics_history_noc_regions nr
 		  on nr.noc = oh.noc
 		  where medal <> ''NA''
 		  group by nr.region, medal
 		  order by nr.region, total_medals',
		  'values(''Bronze''), (''Gold''), (''Silver'')')
		as result(country varchar,
				  bronze bigint,
				  gold bigint,
				  silver bigint)
order by gold desc, silver desc, bronze desc;
```

Q15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
		Problem Statement: Write a SQL query to list down the  total gold, silver and bronze medals won by each country corresponding to each olympic games.

1. List the countries which won the medals
2. Find the total medals won by countries in each category
3. Merge the output with Region to get the country name
4. Pivot the output
5. Display the games and country and disply medal details respective to the countries

```
select oh.games,
	   nr.region as country,
	   oh.medal,
	   count(1) as total_medals
	   from olympics_history oh
	   join olympics_history_noc_regions nr
	   on nr.noc = oh.noc
	   where oh.medal <> 'NA'
	   group by oh.games, nr.region, oh.medal
	   order by oh.games

CREATE EXTENSION tablefunc;

select
	   substring(games, 1, position('-' in games) -1 ) as games,
	   substring(games, position('-' in games) + 2) as country,
	   coalesce(gold,0) as gold,
	   coalesce(silver,0) as silver,
	   coalesce(bronze,0) as bronze
from crosstab
		('select concat(oh.games, '' - '', nr.region) as games,
	   	  		 oh.medal, 
		 		 count(1) as total_medals
		  from olympics_history oh
		  join olympics_history_noc_regions nr
		  on nr.noc = oh.noc
		  where oh.medal <> ''NA''
		  group by oh.games, nr.region, oh.medal
		  order by oh.games',
		  'values(''Bronze''), (''Gold''), (''Silver'')')
		  as result(games varchar,
				    bronze bigint,
					gold bigint,
					silver bigint)
order by games;


SELECT substring(games,1,position(' - ' in games) - 1) as games
        , substring(games,position(' - ' in games) + 3) as country
        , coalesce(gold, 0) as gold
        , coalesce(silver, 0) as silver
        , coalesce(bronze, 0) as bronze
    FROM CROSSTAB('SELECT concat(games, '' - '', nr.region) as games
                , medal
                , count(1) as total_medals
                FROM olympics_history oh
                JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
                where medal <> ''NA''
                GROUP BY games,nr.region,medal
                order BY games,medal',
            'values (''Bronze''), (''Gold''), (''Silver'')')
    AS FINAL_RESULT(games text, bronze bigint, gold bigint, silver bigint);
```
Q16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.
		Problem Statement: Write SQL query to display for each Olympic Games, which country won the highest gold, silver and bronze medals.

```
with temp as
(select
	   substring(games, 1, position('-' in games) -1 ) as games,
	   substring(games, position('-' in games) + 2) as country,
	   coalesce(gold,0) as gold,
	   coalesce(silver,0) as silver,
	   coalesce(bronze,0) as bronze
 from crosstab
		('select concat(oh.games, '' - '', nr.region) as games,
	   	  		 oh.medal, 
		 		 count(1) as total_medals
		  from olympics_history oh
		  join olympics_history_noc_regions nr
		  on nr.noc = oh.noc
		  where oh.medal <> ''NA''
		  group by oh.games, nr.region, oh.medal
		  order by oh.games, nr.region, oh.medal',
		  'values(''Bronze''), (''Gold''), (''Silver'')')
		  as result(games varchar,
				    bronze bigint,
					gold bigint,
					silver bigint)
 order by games)
 select distinct games,
 		concat(
			   first_value(gold) over(partition by games order by gold desc), ' - ', first_value(country) over(partition by games order by gold desc)
		      )as Gold,
		concat(
			   first_value(silver) over(partition by games order by silver desc), ' - ', first_value(country) over(partition by games order by silver desc)	
			  )as Silver,
		concat(
			   first_value(bronze) over(partition by games order by bronze desc), ' - ', first_value(country) over(partition by games order by bronze desc)	
			  )as Bronze
 from temp
 order by games;
```
Q17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
		Problem Statement: Similar to the previous query, identify during each Olympic Games, which country won the highest gold, silver and bronze medals.
		Along with this, identify also the country with the most medals in each olympic games. 
```
with temp as
(select
	   substring(games, 1, position('-' in games) -1 ) as games,
	   substring(games, position('-' in games) + 2) as country,
	   coalesce(gold,0) as gold,
	   coalesce(silver,0) as silver,
	   coalesce(bronze,0) as bronze
 from crosstab
		('select concat(oh.games, '' - '', nr.region) as games,
	   	  		 oh.medal, 
		 		 count(1) as total_medals
		  from olympics_history oh
		  join olympics_history_noc_regions nr
		  on nr.noc = oh.noc
		  where oh.medal <> ''NA''
		  group by oh.games, nr.region, oh.medal
		  order by oh.games, nr.region, oh.medal',
		  'values(''Bronze''), (''Gold''), (''Silver'')')
		  as result(games varchar,
				    bronze bigint,
					gold bigint,
					silver bigint)
 order by games),
 t2 as
 (select games,
 		country,
		gold,
		silver,
		bronze,
		gold + silver + bronze as Total_medals
 from temp)
 select distinct games,
 		concat(
			   first_value(gold) over(partition by games order by gold desc), ' - ', first_value(country) over(partition by games order by gold desc)
		      )as MAx_Gold,
		concat(
			   first_value(silver) over(partition by games order by silver desc), ' - ', first_value(country) over(partition by games order by silver desc)	
			  )as Max_Silver,
		concat(
			   first_value(bronze) over(partition by games order by bronze desc), ' - ', first_value(country) over(partition by games order by bronze desc)	
			  )as Max_Bronze,
		concat(
			   first_value(Total_medals) over(partition by games order by Total_medals desc), ' - ', first_value(country) over(partition by games order by Total_medals desc)	
			  )as Max_Medals
 from t2
 order by games;
```

Q18. Which countries have never won gold medal but have won silver/bronze medals?
Problem Statement: Write a SQL Query to fetch details of countries which have won silver or bronze medal but never won a gold medal.

```
with t1 as
(select
	   country,
	   coalesce(gold,0) as gold,
	   coalesce(silver,0) as silver,
	   coalesce(bronze,0) as bronze
from crosstab
('select nr.region as country,
	   oh.medal, 
	   count(1) as total_medals
 from olympics_history oh
 join olympics_history_noc_regions nr
 on nr.noc = oh.noc
 where oh.medal <> ''NA''
 group by nr.region, oh.medal
 order by nr.region',
 'values(''Bronze''), (''Gold''), (''Silver'')')
 as result(country varchar,
		   bronze bigint,
		   gold bigint,
		   silver bigint))
select * from t1
where gold = 0
order by silver asc, bronze desc
```

Q19. In which Sport/event, India has won highest medals.
Problem Statement: Write SQL Query to return the sport which has won India the highest no of medals.

```
select oh.event, oh.sport, 
	   count(1) as total_medals
from olympics_history oh
join olympics_history_noc_regions nr
on oh.noc = nr.noc
where nr.region = 'India' and medal <> 'NA'
group by oh.sport, oh.event
order by total_medals desc;
```

Q20. Break down all olympic games where India won medal for Hockey and how many medals in each olympic games
Problem Statement: Write an SQL Query to fetch details of all Olympic Games where India won medal(s) in hockey.

```
select team, sport, games, medal,
	   count(1) as total_medals	
from olympics_history
where medal <> 'NA' and
	  NOC = 'IND'
group by team, sport, medal, games
order by total_medals desc;

```
