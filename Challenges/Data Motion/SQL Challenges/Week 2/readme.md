### Source: https://platform.stratascratch.com/coding/10183-total-cost-of-orders?code_type=1
### Question 1: Total Cost Of Orders

### Solution:

```
select c.id, c.first_name, sum(o.total_order_cost) total_order_cost
from orders o
join customers c
on c.id = o.cust_id
group by c.id, c.first_name;
```

### Source: https://platform.stratascratch.com/coding/10156-number-of-units-per-nationality?code_type=1
### Question 2: Number Of Units Per Nationality
-- Find the number of apartments per nationality that are owned by people under 30 years old.
-- Output the nationality along with the number of apartments.
-- Sort records by the apartments count in descending order.

### Solution:

```
select ah.nationality, count(ah.host_id) total_units
from airbnb_hosts ah
join airbnb_units au
on ah.host_id = au.host_id
where age < 30
group by nationality
order by total_units desc;
```