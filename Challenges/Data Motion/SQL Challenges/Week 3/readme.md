### Question 1: Total Cost Of Orders.
### Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost. Order records by customer's first name alphabetically.
### Source: https://platform.stratascratch.com/coding/10183-total-cost-of-orders?code_type=1 

```
select c.id, c.first_name, sum(o.total_order_cost) total_order_cost
from orders o
join customers c
on c.id = o.cust_id
group by c.id, c.first_name
order by c.first_name;
```

### Question 2: Cities With The Most Expensive Homes
### Write a query that identifies cities with higher than average home prices when compared to the national average. Output the city names.
### Source: https://platform.stratascratch.com/coding/10315-cities-with-the-most-expensive-homes?code_type=1

```
select city, avg(mkt_price) avg_price
from zillow_transactions
group by city
having avg(mkt_price) > (select avg(mkt_price) from zillow_transactions);
```

### Question 3: Reviews of Hotel Arena
### Find the number of rows for each review score earned by 'Hotel Arena'. Output the hotel name (which should be 'Hotel Arena'), review score along with the corresponding number of rows with that score for the specified hotel.
### Source: https://platform.stratascratch.com/coding/10166-reviews-of-hotel-arena?code_type=1

```
select hotel_name, reviewer_score, count(reviewer_score) count
from hotel_reviews
where hotel_name = 'Hotel Arena'
group by hotel_name, reviewer_score;
```