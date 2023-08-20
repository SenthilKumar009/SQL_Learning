select product_id, sum(quantity) total_order_quantity,
	   rank() over (partition by product_id order by sum(quantity) desc) as rnk
from orders
group by product_id;

select * from orders;

with total_orders as
(
	select product_id, sum(quantity) total_order_quantity
	from orders
	group by product_id	
)
select product_id, total_order_quantity,
	   rank() over (order by total_order_quantity desc)
from total_orders;


select * from weather;

select country_id, weather_state, day, 
	   lag(weather_state) over (partition by country_id order by day) as pre_temp
from weather;

select country_id, weather_state, day, 
	   avg(weather_state) over (partition by country_id order by day rows between 1 preceding and current row ) as avg_2_temp
from weather;

select * from delivery;


