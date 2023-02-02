--- Create Tables

drop table if exists WorldCupMatches;

create table if not exists WorldCupMatches(
	Year int,
	Datetime varchar,
	Stage varchar,
	Stadium	varchar,
	City varchar,
	HomeTeamName varchar,
	HomeTeamGoals int, 
	AwayTeamGoals int, 
	AwayTeamName varchar,
	WinConditions varchar,
	Attendance int,
	HalftimeHomeGoals int,
	HalftimeAwayGoals int,
	Referee	varchar,
	Assistant1 varchar,
	Assistant2 varchar,
	RoundID	int,
	MatchID	int, 
	HomeTeamInitials varchar,
	AwayTeamInitials varchar
);

drop table if exists WorldCupPlayers;

create table if not exists WorldCupPlayers(
	RoundID	int,
	MatchID	int,
	TeamInitials varchar,
	CoachName varchar,
	Line_up	char(1),
	ShirtNumber int,
	PlayerName varchar,
	Position varchar,
	Event varchar
);

drop table if exists WorldCups;

create table WorldCups(
	Year int,
	Country varchar,
	Winner varchar,
	RunnersUp varchar,
	Third varchar,
	Fourth varchar,
	GoalsScored int,
	QualifiedTeams int,
	MatchesPlayed int,
	Attendance int
);

--- Load Data:
COPY WorldCupMatches(Year, Datetime, Stage, Stadium, City, HomeTeamName, HomeTeamGoals, 
	 AwayTeamGoals, AwayTeamName, WinConditions, Attendance, HalftimeHomeGoals,
	 HalftimeAwayGoals,	Referee, Assistant1, Assistant2, RoundID, MatchID, HomeTeamInitials, AwayTeamInitials)
FROM 'D:\Tech\Git Repositories\SQL_Learning\SQL Projects\FIFA\WorldCupMatches.csv'
DELIMITER ','
CSV HEADER;

COPY WorldCupPlayers(RoundID, MatchID, TeamInitials, CoachName, Line_up, ShirtNumber, PlayerName, Position, Event)
FROM 'D:\Tech\Git Repositories\SQL_Learning\SQL Projects\FIFA\WorldCupPlayers.csv'
DELIMITER ','
CSV HEADER;

COPY WorldCups(Year, Country, Winner, RunnersUp, Third, Fourth, GoalsScored, QualifiedTeams, MatchesPlayed, Attendance)
FROM 'D:\Tech\Git Repositories\SQL_Learning\SQL Projects\FIFA\WorldCups.csv'
DELIMITER ','
CSV HEADER;

-- View Data:

Select * from WorldCupMatches;
Select * from WorldCupPlayers;
select * from WorldCups;

---- Questions ---

-- 1. Total No of World Cup Held?
select count(*) total_world_cups from worldcups;

-- 2. Total Attendance in the history of Football?
select sum(attendance) total_attendance from worldcups;

-- 3. Display the Min and Max Attendance in the event with the year and country
select year, country, attendance from
worldcups where attendance in
(select max(attendance) attendance from worldcups)
union
select year, country, attendance from
worldcups where attendance in
(select min(attendance) attendance from worldcups);

-- 4. Which country conducted the event most number of times?

select country, count(*) total_events_by_Country, string_agg((year::varchar), ', ') year_conducted 
from worldcups
group by country
order by total_events_by_Country desc;

-- 5. Howmany time the event conducted country won the World Cup?
select count(*) from worldcups
where country = winner;

select year, country, winner
from worldcups
where country = winner;

-- 6. Which country won the World cup maximum number of times?

select winner county, count(winner) as total_world_cups
from worldcups 
group by winner
order by total_world_cups desc;

-- 7. Which country came 2nd maximum number of times?

select runnersup county, count(runnersup) as total_runner_ups
from worldcups 
group by runnersup
order by total_runner_ups desc;

-- 8. List out the teams who playes most world cup finals?
with world_cup_winners as
(
 select winner country, count(winner) as total_world_cups
 from worldcups 
 group by winner
 order by total_world_cups desc
),
world_cup_runners as
(
 select runnersup country, count(runnersup) as total_runner_ups
 from worldcups 
 group by runnersup
 order by total_runner_ups desc
)
select w.country, w.total_world_cups + r.total_runner_ups total_Finals, w.total_world_cups total_world_cup_won, r.total_runner_ups
from world_cup_winners w
join world_cup_runners r
on w. country = r.country


Country:

1. Total Number of Wolrd cups/ Participation Countries/ 
2. Which team won the most World Cups, and how many wins was that?
3. Which Finals or Semi-final games were decided by penalties?
4. Which years had the highest and lowest attendance to the World Cup games?
5. What is the average number of goals scored per World Cup?
6. How many countries qualified for the World Cup in 1930 compared to 2014?
7. Does history show more home-team wins or away-team wins?
8. Most Number of World Cup Winning Title
9. Number of Goal Per Countary
10. Attendance, Number of Teams, Goals, and Matches per Cup
11. Goals Per Team Per World Cup
12. Matches With Heihest Number Of Attendance
13. Stadium with Highest Average Attendance
14. Which countries had won the cup ?
15. Number of goal per country
16. Match outcome by home and away temas
