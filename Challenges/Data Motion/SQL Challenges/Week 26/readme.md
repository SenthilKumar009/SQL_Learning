# Week 26

> Question 1: Calculate Special Bonus

> Source: LeetCode: 1873; https://leetcode.com/problems/calculate-special-bonus/

> Solution:

```
WITH check_consecutive AS
(SELECT ROW_NUMBER() OVER(ORDER BY id) AS rownumber, id, visit_date, people
FROM Stadium
WHERE people >= 100)

SELECT id, visit_date, people
FROM check_consecutive
WHERE id-rownumber IN
(SELECT (id - rownumber)
FROM check_consecutive
GROUP BY (id - rownumber)
HAVING COUNT(*) >= 3);
```

> Question 2: Recyclable and Low Fat Products

> Source: LeetCode: 1757; https://leetcode.com/problems/recyclable-and-low-fat-products/

> Solution:

```
select product_id
from products
where low_fats = 'Y' and recyclable ='Y'
```