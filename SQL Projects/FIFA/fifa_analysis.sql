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

-- 9. Which Finals or Semi-final games were decided by penalties?
Select year, stage, hometeamname, awayteamname, concat(hometeamgoals, ' - ', awayteamgoals) goals, winconditions
from WorldCupMatches
where winconditions like '%penalties%'
and stage in ('Final', 'Semi-Finals');

-- 10. What is the average number of goals scored per World Cup?
select count(year) total_world_cups, sum(goalsscored) total_goals_scored, sum(goalsscored)/count(year) avg_goals_per_worldcup
from worldcups;

-- 11. How many countries qualified for the World Cup in 1930 compared to 2014?
select year, qualifiedteams from worldcups
where year in(1930, 2014)

-- 12. Does history show more home-team wins or away-team wins?
select year, stage, hometeamname, awayteamname, hometeamgoals, awayteamgoals, winconditions
from worldcupmatches
where year is not null;




-- 13. Number of Goal Per Countary
with home_team_goals as
(
	select hometeamname country, sum(hometeamgoals) goals
	from worldcupmatches
	where year is not null
	group by hometeamname
),
away_team_goals as
(
	select awayteamname country, sum(awayteamgoals) goals
	from worldcupmatches
	where year is not null
	group by awayteamname
)
select a.country, a.goals + h.goals goals_Scored
from home_team_goals h
join away_team_goals a
on a.country = h.country
order by goals_Scored desc;

-- 14. Goals Per Team Per World Cup

with goals_scored as(
	select year, hometeamname country, sum(hometeamgoals) goals
	from worldcupmatches
	where year is not null
	group by year, hometeamname
	union
	select year, awayteamname country, sum(awayteamgoals) goals
	from worldcupmatches
	where year is not null
	group by year, awayteamname
)
select year, country, sum(goals) goals_Scored
from goals_scored
group by year, country
order by year, country

-- 15. Matches With Heihest Number Of Attendance
select * from worldcupmatches
where year is not null and attendance is not null
order by attendance desc;

-- 16. Stadium with Highest Average Attendance
select stadium, count(datetime) total_matches, sum(attendance) total_attendance, round(avg(attendance),2) avg_attendance
from worldcupmatches
where stadium is not null
group by stadium
order by stadium asc;

-- 19. Match outcome by home and away temas
select * from worldcupmatches
