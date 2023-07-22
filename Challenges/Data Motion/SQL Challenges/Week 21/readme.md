# Week 21

> Question 1:  Average Review Ratings [Amazon SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/sql-avg-review-ratings

> Solution: 

```
select mth, product_id as product, round(avg(stars),2) avg_stars
from
(
  SELECT date_part('month', submit_date) mth, product_id, stars
  FROM reviews
  order by mth, product_id
) x
group by mth, product_id
```

> Question 2:  Odd and Even Measurements [Google SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/odd-even-measurements

> Solution: 

```
WITH measure_rank AS(
  SELECT measurement_id, measurement_value, date(measurement_time) measurement_day,
         RANK() over(PARTITION BY date(measurement_time) order by measurement_time) rnk
  FROM measurements m
)
SELECT measurement_day,
       SUM(CASE 
               WHEN rnk % 2 != 0 THEN measurement_value 
               ELSE 0
           END) odd_sum,
       SUM(CASE 
               WHEN rnk % 2 = 0 THEN measurement_value 
               ELSE 0
           END) even_sum
FROM measure_rank
group by date(measurement_day)
order by measurement_day
```