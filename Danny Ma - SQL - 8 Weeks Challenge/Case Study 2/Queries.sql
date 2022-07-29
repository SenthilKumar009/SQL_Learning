---------Data Cleaning				
---------Cleaning extras column
SELECT * FROM pizza_runner.customer_orders;

UPDATE pizza_runner.customer_orders
SET extras = CASE
					WHEN extras='' THEN '0'
					WHEN extras IS NULL THEN '0'
					WHEN extras='null' THEN '0'
					ELSE extras
				END;

---------Cleaning exclusions column
UPDATE pizza_runner.customer_orders
SET exclusions = CASE
					WHEN exclusions='' THEN '0'
					WHEN exclusions IS NULL THEN '0'
					WHEN exclusions='null' THEN '0'
					ELSE exclusions
				END;

---------Cleaning cancellation column
UPDATE pizza_runner.runner_orders
SET cancellation = CASE
					WHEN cancellation='' THEN '0'
					WHEN cancellation IS NULL THEN '0'
					WHEN cancellation='null' THEN '0'
					ELSE cancellation
				END;

---------Cleaning pickup_time column
UPDATE pizza_runner.runner_orders
SET pickup_time = CASE
					WHEN pickup_time IS NULL THEN '1970-01-01'
					WHEN pickup_time='null' THEN '1970-01-01'
					ELSE pickup_time
				END;

--changing data type of pickup_time  column
ALTER TABLE pizza_runner.runner_orders
ALTER pickup_time DROP DEFAULT,
ALTER COLUMN pickup_time
TYPE timestamp USING pickup_time::timestamp,
ALTER pickup_time SET DEFAULT '1970-01-01 01:00:00'::timestamp;

---------Cleaning distance column
UPDATE pizza_runner.runner_orders
SET distance = CASE
					WHEN distance='null' THEN '0'
					ELSE distance
				END;

UPDATE pizza_runner.runner_orders 
SET distance=REPLACE(distance,'km','');

ALTER TABLE pizza_runner.runner_orders 
ALTER COLUMN distance
TYPE decimal USING distance::decimal;

---------Cleaning duration column
UPDATE pizza_runner.runner_orders
SET duration = CASE
					WHEN duration='null' THEN '0'
					ELSE duration
				END;
				
UPDATE pizza_runner.runner_orders 
SET duration=REPLACE(duration,'minutes','');

UPDATE pizza_runner.runner_orders 
SET duration=REPLACE(duration,'minute','');

UPDATE pizza_runner.runner_orders 
SET duration=REPLACE(duration,'mins','');

UPDATE pizza_runner.runner_orders 
SET duration=REPLACE(duration,'s','');

--changing data type of duration column
ALTER TABLE pizza_runner.runner_orders 
ALTER COLUMN duration
TYPE decimal USING duration::decimal;




select * from pizza_runner.customer_orders;

select * from pizza_runner.runner_orders;

select runner_id, count(runner_id) 
	from pizza_runner.runner_orders 
	group by runner_id
	order by runner_id;
	
select p.pizza_name, count(c.pizza_id)
	from pizza_runner.customer_orders c
	join pizza_runner.pizza_names p on p.pizza_id = c.pizza_id
	join pizza_runner.runner_orders r on c.order_id = r.order_id
	WHERE cancellation!='Restaurant Cancellation' AND cancellation!='Customer Cancellation'
	group by p.pizza_name;
	
select c.customer_id, p.pizza_name, count(p.pizza_id)
	from pizza_runner.customer_orders c
	join pizza_runner.pizza_names p 
	on c.pizza_id = p.pizza_id
	group by c.customer_id, p.pizza_name
	order by c.customer_id;

select c.order_id, count(p.pizza_id)
	from pizza_runner.customer_orders c
	join pizza_runner.pizza_names p 
	on c.pizza_id = p.pizza_id
	join pizza_runner.runner_orders r
	on r.order_id = c.order_id
	where r.distance >0
	group by c.order_id
	order by c.order_id;
	
select c.customer_id,
sum(
	CASE WHEN c.exclusions <> '0' OR c.extras <> '0' THEN 1
	ELSE 0
	END) as at_least_1_change,
sum(
	CASE WHEN c.exclusions = '0' OR c.extras = '0' THEN 1
	ELSE 0
	END) as no_change
from pizza_runner.customer_orders c
join pizza_runner.runner_orders r
on c.order_id = r.order_id
where r.distance > 0
group by c.customer_id
order by c.customer_id;

select * from pizza_runner.customer_orders 
where exclusions != '0' and extras != '0';

select EXTRACT(HOUR from order_time) as hour_of_day, count(EXTRACT(HOUR from order_time))
from pizza_runner.customer_orders
group by hour_of_day
order by hour_of_day;

with week_day as
	(select EXTRACT(DOW from order_time) as day_of_day, 
			count(EXTRACT(HOUR from order_time)) as Total_orders
	from pizza_runner.customer_orders
	group by day_of_day
	order by day_of_day
	)
	select 
		CASE 
			WHEN week_day.day_of_day = 1 THEN 'Sunday'
			WHEN week_day.day_of_day = 2 THEN 'Monday'
			WHEN week_day.day_of_day = 3 THEN 'Tueday'
			WHEN week_day.day_of_day = 4 THEN 'Wednesday'
			WHEN week_day.day_of_day = 5 THEN 'Thursday'
			WHEN week_day.day_of_day = 6 THEN 'Friday'
			ELSE 'Saturday'
		END as WeekDay,
		Total_Orders
	from week_day;

WITH CTE AS
(SELECT COUNT(runner_id) AS "No. of runners signed up for 1st week period(2020-12-31 to 2021-01-08)" 
FROM pizza_runner.runners
WHERE registration_date BETWEEN '2020-12-31' AND '2021-01-08') 
,CTE1 AS
(SELECT COUNT(runner_id) AS "No. of runners signed up for 2nd week period(2021-01-08 AND 2021-01-14)" 
FROM pizza_runner.runners
WHERE registration_date BETWEEN '2021-01-08' AND '2021-01-14') 
SELECT * 
FROM CTE
NATURAL JOIN CTE1;

with cte_avg_time as
(select runner_id, 
 		pickup_time-order_time as "time_taken"
 from pizza_runner.runner_orders r
 join pizza_runner.customer_orders c
 on r.order_id = c.order_id
 where r.cancellation = '0')
select runner_id,
       avg(time_taken) as "avg time taken"
from cte_avg_time
group by runner_id

with pizza_count as
(
	select order_id, customer_id, count(order_id) as Total_Pizzas
	from pizza_runner.customer_orders
	group by order_id, customer_id
	order by order_id
)
select p.order_id, p.customer_id, p.total_pizzas, r.distance, r.duration
from pizza_count p
join pizza_runner.runner_orders r
on p.order_id = r.order_id

select customer_id,
	   round(avg(distance), 2) as "Average distance Travelled"
from pizza_runner.customer_orders c
join pizza_runner.runner_orders r
on c.order_id = r.order_id
group by c.customer_id

select MIN(duration) as "shortest delivery",
	   MAX(duration) as "longest delivery"
from pizza_runner.runner_orders
where cancellation ='0'

SELECT runner_id,
ROUND(AVG(distance/NULLIF(duration, 0)),2)AS "Average speed" 
FROM pizza_runner.runner_orders
GROUP BY runner_id
ORDER BY runner_id;

with successful_order as
(
	select runner_id, count(runner_id) total_successful_order
	from pizza_runner.runner_orders
	where duration > 0
	group by runner_id
	order by runner_id
),
total_order as
(
	select runner_id, count(runner_id) as total_order
	from pizza_runner.runner_orders
	group by runner_id
	order by runner_id
)
select s.runner_id, t.total_order, s.total_successful_order, 
	   (cast(s.total_successful_order as DOUBLE PRECISION)/cast(t.total_order as DOUBLE PRECISION))*100 success_percentage
from successful_order s
join total_order t
on s.runner_id = t.runner_id;

select order_id, customer_id, count(order_id) as Total_Pizzas
from pizza_runner.customer_orders
group by order_id, customer_id
order by order_id;

SELECT DISTINCT(pizza_name),
toppings
FROM pizza_runner.pizza_names AS pn
NATURAL JOIN pizza_runner.pizza_recipes AS pr;

with added_extras as
(
	select order_id,
	cast(regexp_split_to_table(extras, E',') as INTEGER) as extras
	from pizza_runner.customer_orders
)
select extras, count(extras) as mostly_added_extras
from added_extras
where extras <> 0
group by extras
order by mostly_added_extras desc;

with exclusions_data as
(
	select order_id,
	cast(regexp_split_to_table(exclusions, E',') as INTEGER) as exclusions
	from pizza_runner.customer_orders
)
select exclusions, count(exclusions) as mostly_excluded_ingredient
from exclusions_data
where exclusions <> 0
group by exclusions
order by mostly_excluded_ingredient desc

with order_details as
(
	select c.order_id, c.pizza_id, p.pizza_name,
	case when p.pizza_id = 1 then 10
		 else 12
	end as amount
	from pizza_runner.customer_orders c
	join pizza_runner.pizza_names p
	on c.pizza_id = p.pizza_id
	order by c.order_id
),
order_amount as
(
	select od.order_id, ro.runner_id, sum(od.amount) as order_amount
	from order_details od
	join pizza_runner.runner_orders ro
	on od.order_id = ro.order_id
	--where ro.pickup_time <> ''
	group by od.order_id, ro.runner_id
)
select runner_id, sum(order_amount)
from order_amount
group by runner_id
order by runner_id

with order_details as
(
	select c.order_id, c.pizza_id, p.pizza_name,
	case when p.pizza_id = 1 then 10
		 else 12
	end as amount,
	case when extras = '1' then 1
		 when length(extras) > 1 then 2
		 else 0
	end as add_amount
	from pizza_runner.customer_orders c
	join pizza_runner.pizza_names p
	on c.pizza_id = p.pizza_id
	order by c.order_id
),
order_amount as
(
	select od.order_id, ro.runner_id, sum(od.amount) + sum(add_amount) as total_order_amount
	from order_details od
	join pizza_runner.runner_orders ro
	on od.order_id = ro.order_id
	--where ro.pickup_time <> 'null'
	group by od.order_id, ro.runner_id
)
select runner_id, count(order_id) total_order, sum(total_order_amount) grand_order_toal 
from order_amount
group by runner_id
order by runner_id


DROP TABLE IF EXISTS pizza_runner.ratings;
CREATE TABLE pizza_runner.ratings (
  "order_id" INTEGER,
  "rating" DECIMAL
);
INSERT INTO pizza_runner.ratings
  ("order_id", "rating")
VALUES
  (1, 5),
  (2, 5),
  (3, 4.5),
  (4, 5),
  (5, 4),
  (7, 3.5),
  (8, 5),
  (10,4);

select * from pizza_runner.ratings;

select * from pizza_runner.runner_orders

WITH CTE AS(
SELECT runner_id,
	ROUND(AVG(distance/NULLIF(duration, 0)),2) AS "Average speed" 
FROM pizza_runner.runner_orders
GROUP BY runner_id
ORDER BY runner_id)
SELECT customer_id, 
	c.order_id,
	runner_id,
	r.rating,
	c.order_time,
	pickup_time,
	pickup_time-order_time AS "Time between order and pickup",
	duration AS "Delivery duration",
	"Average speed"
FROM pizza_runner.customer_orders AS c
NATURAL JOIN pizza_runner.runner_orders 
NATURAL JOIN pizza_runner.ratings AS r
NATURAL JOIN CTE

select * from pizza_runner.customer_orders

alter table pizza_runner.customer_orders
add column pizza_cost double precision;

update pizza_runner.customer_orders
set pizza_cost = case 
					when pizza_id = 1 then 12
	 				else 10
				 end; 

select * from pizza_runner.runner_orders
select * from pizza_runner.customer_orders

select order_id, sum(pizza_cost) as total_order_cost
from pizza_runner.customer_orders
group by order_id

with CTE1 as
(select order_id, runner_id, sum(distance) * 0.5 as "distance covered amount"
 from pizza_runner.runner_orders
 where runner_orders.cancellation != 'Restaurant Cancellation' or runner_orders.cancellation = 'Customer Cancellation'
 group by order_id, runner_id)
select CTE1.runner_id, sum(c.pizza_cost) as "total_amount"
from CTE1
join pizza_runner.customer_orders c
on CTE1.order_id = c.order_id
group by CTE1.runner_id

select runner_id, sum(distance) * 0.50 + c.pizza_cost as "total_amount"
from pizza_runner.customer_orders c
join pizza_runner.runner_orders r
on c.order_id = r.order_id
where r.cancellation != 'Restaurant Cancellation' or r.cancellation = 'Customer Cancellation'
group by runner_id














