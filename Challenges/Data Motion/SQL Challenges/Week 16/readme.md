## Week 16

> Question 1:  Article Views I

> Source: LeetCode: 1148; https://leetcode.com/problems/article-views-i/

> Solution: 

```
select distinct author_id as id
from views
where author_id = viewer_id
order by author_id asc
```

> Question 2:  Sales Analysis III

> Source: LeetCode: 1084; https://leetcode.com/problems/sales-analysis-iii/

> Solution: 

```
select p.product_id, p.product_name
from product p
inner join sales s
on p.product_id = s.product_id
group by s.product_id
having min(sale_date) >= '2019-01-01' and max(sale_date) <= '2019-03-31'
```