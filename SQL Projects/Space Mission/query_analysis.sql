----- Query Analysis -------------

--- 1. Total No of Missions

select * from space_missions;

--- 2. Mission details based on the status

Select missionstatus, count(missionstatus) as status
from space_missions
group by missionstatus;

--- 3. Companies involved in launching

select distinct (company) from space_missions;

--- 4. Comapnies which has most success Count

with total_missions as
(select company, count(company) total_missions
from space_missions
group by company order by total_missions desc
),
success_mission as
(select company, (count(missionstatus)) as successful_missions
 from space_missions
 where missionstatus='Success'
 group by company, missionstatus
),
failed_mission as
(select company, (count(missionstatus)) as unsuccessful_missions
 from space_missions
 where missionstatus='Failure'
 group by company, missionstatus
)
select t.company, total_missions, successful_missions, unsuccessful_missions
from total_missions t
join success_mission s
on t.company = s.company
join failed_mission f
on t.company = f.company
order by t.total_missions desc;

--- 5. Comapnies which has most failure rate

--- 6. Which year has more mission

select date_part('year', mission_date) as mission_year, count(mission) total_mission
from space_missions
group by mission_year
order by mission_year asc;

--- 7. Successful mission by year

with total_missions as(
	select date_part('year', mission_date) as mission_year, count(mission) total_missions
	from space_missions
	group by mission_year
),
success_missions as(
	select date_part('year', mission_date) as mission_year, count(mission) successful_missions
	from space_missions
	where missionstatus='Success'
	group by mission_year
)
select t.mission_year, total_missions, successful_missions
from total_missions t
join success_missions s
on t.mission_year = s.mission_year
order by successful_missions desc;

--- 8. Failed mission by year

with total_missions as(
	select date_part('year', mission_date) as mission_year, count(mission) total_missions
	from space_missions
	group by mission_year
),
failed_missions as(
	select date_part('year', mission_date) as mission_year, count(mission) unsuccessful_missions
	from space_missions
	where missionstatus='Failure'
	group by mission_year
)
select t.mission_year, total_missions, unsuccessful_missions
from total_missions t
join failed_missions s
on t.mission_year = s.mission_year
order by unsuccessful_missions desc;

--- 9. Rocket's Status

with rocket_status as(
	select distinct rocket, rocketstatus
	from space_missions
	group by rocket, rocketstatus
	order by rocket;
)
select distinct rocket, rocketstatus
from space_missions
group by rocket, rocketstatus
order by rocket;


---10. 
