# Week 24

> Question 1:  Rearrange Products Table

> Source: LeetCode: 1795; https://leetcode.com/problems/rearrange-products-table/

> Solution:

```
select product_id, 'store1' as store, store1 as price from products where store1 is not null
union
select product_id, 'store2' as store, store2 as price from products where store2 is not null
union
select product_id, 'store3' as store, store3 as price from products where store3 is not null
```

> Question 2:  Product Sales Analysis I

> Source: LeetCode: 1068; https://leetcode.com/problems/product-sales-analysis-i/

> Solution:

```
select p.product_name, s.year, s.price
from product p
inner join sales s
on p.product_id = s.product_id
```