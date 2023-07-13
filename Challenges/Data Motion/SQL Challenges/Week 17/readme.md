## Week 17

> Question 1:  Rearrange Products Table

> Source: LeetCode: 1795; https://leetcode.com/problems/rearrange-products-table/description/

> Solution: 

```
select product_id, 'store1' as store, store1 as price from products where store1 is not null
union
select product_id, 'store2' as store, store2 as price from products where store2 is not null
union
select product_id, 'store3' as store, store3 as price from products where store3 is not null
```

> Question 2:  The Latest Login in 2020

> Source: LeetCode: 1890; https://leetcode.com/problems/the-latest-login-in-2020/

> Solution: 

```
select u.user_id as buyer_id, u.join_date, count(o.order_id) orders_in_2019
from users u
left outer join orders o
on u.user_id = o.buyer_id
and year(o.order_date) = 2019
group by user_id
```