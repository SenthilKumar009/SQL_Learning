select * from pizza_runner.customer_orders;

select * from pizza_runner.runner_orders;


select order_id, customer_id, count(order_id) as Total_Pizzas
from pizza_runner.customer_orders
group by order_id, customer_id
order by order_id;


select order_id, distance,
case when duration <> 'null' then substring(duration, 0,3)
	 else duration
end as travel_duration
from pizza_runner.runner_orders;

select c.order_id, c.customer_id, count(c.order_id) as Total_pizzas, r.distance,
case when r.duration <> 'null' then substring(r.duration, 0,3)
	 else r.duration
end as travel_duration
from pizza_runner.customer_orders c
join pizza_runner.runner_orders r
on c.order_id = r.order_id
group by c.order_id, c.customer_id
order by c.order_id;


with pizza_count as
(
	select order_id, customer_id, count(order_id) as Total_Pizzas
	from pizza_runner.customer_orders
	group by order_id, customer_id
	order by order_id
)
select p.order_id, p.customer_id, p.total_pizzas, r.distance,
case when r.duration <> 'null' then substring(r.duration, 0,3)
else r.duration
end as travel_duration
from pizza_count p
join pizza_runner.runner_orders r
on p.order_id = r.order_id
where r.distance is not null

with pizza_count as
(
	select order_id, customer_id
	from pizza_runner.customer_orders
	group by order_id, customer_id
	order by order_id
),
distance_covered as
(
	select order_id,
	case when duration <> 'null' then cast(substring(duration, 0,3) as INTEGER)
	else 0
	end as travel_duration
	from pizza_runner.runner_orders
) 
select p.customer_id, round(avg(d.travel_duration), 2)
from pizza_count p
join distance_covered d
on p.order_id = d.order_id
group by p.customer_id

avg(case when r.duration <> 'null' then substring(r.duration, 0,3)
else r.duration
end) as travel_duration
from pizza_count p
join pizza_runner.runner_orders r
on p.order_id = r.order_id

select order_id, distance,
case when duration <> 'null' then substring(duration, 0,3)
	 else duration
end as travel_duration
from pizza_runner.runner_orders;

select * from pizza_runner.runner_orders where duration <> 'null';

with pizza_count as
(
	select order_id, customer_id
	from pizza_runner.customer_orders
	group by order_id, customer_id
	order by order_id
),
distance_covered as
(
	select order_id,
	case when duration <> 'null' then cast(substring(duration, 0,3) as INTEGER)
	else 0
	end as travel_duration
	from pizza_runner.runner_orders
	where duration <> 'null'
) 
select max(d.travel_duration) longest_distance_covered, 
	   min(d.travel_duration) shortest_distance_covered,
	   max(d.travel_duration) - min(d.travel_duration) difference_bw_max_min
from pizza_count p
join distance_covered d
on p.order_id = d.order_id

select * from pizza_runner.runner_orders

with successful_order as
(
	select runner_id, count(runner_id) total_successful_order
	from pizza_runner.runner_orders
	where duration <> 'null'
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
on s.runner_id = t.runner_id

select runner_id, count(runner_id) as total_order
from pizza_runner.runner_orders
group by runner_id


with distance_covered as
(
	select order_id, runner_id,
	case when distance <> null then case(su)
	case when duration <> 'null' then cast(substring(duration, 0,3) as INTEGER)
	else 0
	end as travel_duration
	from pizza_runner.runner_orders
)
SELECT runner_id,
ROUND(AVG(distance/NULLIF(duration, 0)),2)AS "Average speed" 
FROM pizza_runner.runner_orders
GROUP BY runner_id
ORDER BY runner_id;


select * from pizza_runner.pizza_recipes
select * from pizza_runner.pizza_toppings
select * from pizza_runner.pizza_names

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
order by mostly_excluded_ingredient desc;


select * from pizza_runner.customer_orders;
select * from pizza_runner.pizza_names
select * from pizza_runner.runner_orders

SELECT order_id,
pizza_name,
CASE
	WHEN pizza_id=1 AND (extras='0') AND (exclusions='0') THEN 'Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=2 AND (extras='0') AND (exclusions='0')THEN 'Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
	WHEN (pizza_id=2) AND (extras='1') AND (exclusions='0') THEN '2XCheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
	WHEN (pizza_id=1) AND (extras='1') AND (exclusions='0') THEN '2xBacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN (pizza_id=1) AND (extras='1, 5') AND (exclusions='4') THEN '2xBacon, BBQ Sauce, Beef, 2xChicken, Mushrooms, Pepperoni, Salami'
	WHEN (pizza_id=1) AND (extras='1, 4') AND (exclusions='2, 6') THEN '2xBacon, Beef, 2xCheese, Chicken, Pepperoni, Salami'
	WHEN pizza_id=1 AND (extras='0') AND (exclusions='4') THEN 'Bacon, BBQ Sauce, Beef, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=2 AND (extras='0') AND (exclusions='4')THEN 'Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
END ingredients,
exclusions
FROM pizza_runner.customer_orders
NATURAL JOIN pizza_runner.pizza_names
NATURAL JOIN pizza_runner.pizza_recipes

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
	where ro.pickup_time <> 'null'
	group by od.order_id, ro.runner_id
)
select runner_id, count(order_id) total_order, sum(order_amount) grand_order_toal 
from order_amount
group by runner_id
order by runner_id

select * from pizza_runner.customer_orders

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
	where ro.pickup_time <> 'null'
	group by od.order_id, ro.runner_id
)
select runner_id, count(order_id) total_order, sum(total_order_amount) grand_order_toal 
from order_amount
group by runner_id
order by runner_id




























