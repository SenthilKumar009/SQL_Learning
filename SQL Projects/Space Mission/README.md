
# This file analyze All space missions from 1957 to August 2022.

Part of this porject I am using a dataset from Maven Analytics and Postgresql Tool.

### Create Database:

```
-- DROP DATABASE IF EXISTS spacemission;

CREATE DATABASE spacemission
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```

-- Create Schemas
```
create table space_mission_data_directory(
	Field varchar(100),
	Description varchar(200)
);


drop table space_missions;

create table space_missions(
	Company	varchar(50),
	place varchar(100),
	mission_Date date,
	mission_Time time,
	Rocket varchar(50),
	Mission varchar(100),
	RocketStatus varchar(50),
	Price numeric(10,2),
	MissionStatus varchar(20)
);
```

-- load data from CSV files
```
COPY space_mission_data_directory(Field,Description)
FROM 'D:\Tech\Datasets for Data Engineering\Maven Analytics\SpaceMissions\space_missions_data_dictionary.csv'
DELIMITER ','
CSV HEADER;

COPY space_missions(Company,place,mission_Date,mission_Time,Rocket, Mission, RocketStatus, Price, MissionStatus)
FROM 'D:\Tech\Datasets for Data Engineering\Maven Analytics\SpaceMissions\space_missions.csv'
DELIMITER ','
CSV HEADER;
```
---- Check Data
```
Select * from space_mission_data_directory;

select * from space_missions;
```
----------------------------------------------------------

## Data Analysis

--- 1. Total No of Missions
```
select * from space_missions;
```

--- 2. Mission details based on the status
```
Select missionstatus, count(missionstatus) as status
from space_missions
group by missionstatus;
```

--- 3. Companies involved in launching
```
select distinct (company) from space_missions;
```
--- 4. Companies which has most success Count
--- 5. Comapnies which has most failure rate
```
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
```

--- 6. Which year has more mission

```
select date_part('year', mission_date) as mission_year, count(mission) total_mission
from space_missions
group by mission_year
order by mission_year asc;
```

--- 7. Successful mission by year

```
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
```
--- 8. Failed mission by year
```
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
```
--- 9. Rocket's Status
```
with rocket_status as(
	select distinct rocket, rocketstatus
	from space_missions
	group by rocket, rocketstatus
	order by rocket
)
select 
	case when rocketstatus = 'Active' then count(rocketstatus) end as ActiveStatus,
	case when rocketstatus = 'Retired' then count(rocketstatus) end as RetiredStatus
from rocket_status
group by rocketstatus;
```

---10. Rocket Launch Status
```
select rocket, 
	   count(case when missionstatus = 'Success' then 1 end) as MissionSuccess,
	   count(case when missionstatus = 'Failure' then 1 end) as MissionFailed
from space_missions
group by rocket;
```
---11. Most money spend for a launch
```
select mission, rocket, price
from space_missions
where price is not null
order by price desc;
```

---12. Which Place has most lauching
```
select place, count(place) total_launches
from space_missions
group by place
order by total_launches desc;
```
---13. Total Lauches by places
```
with mission_place as(
	select split_part(place, ',', 3) place, mission
	from space_missions
)
select place, count(place) as total_mission
from mission_place
group by place
order by total_mission desc;
```
