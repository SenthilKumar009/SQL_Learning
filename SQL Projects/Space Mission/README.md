
# This file analyze All space missions from 1957 to August 2022.

Part of this porject I am using a dataset from Maven Analytics and Postgresql Tool.

### Create Database:

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


-- Create Schemas

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


-- load data from CSV files

COPY space_mission_data_directory(Field,Description)
FROM 'D:\Tech\Datasets for Data Engineering\Maven Analytics\SpaceMissions\space_missions_data_dictionary.csv'
DELIMITER ','
CSV HEADER;

COPY space_missions(Company,place,mission_Date,mission_Time,Rocket, Mission, RocketStatus, Price, MissionStatus)
FROM 'D:\Tech\Datasets for Data Engineering\Maven Analytics\SpaceMissions\space_missions.csv'
DELIMITER ','
CSV HEADER;

---- Check Data

Select * from space_mission_data_directory;

select * from space_missions;

----------------------------------------------------------

## Data Analysis


