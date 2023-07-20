## Week 19

> Question 1:  Sending vs. Opening Snaps [Snapchat SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/time-spent-snaps

> Solution: 

```
SELECT age_bucket, 
    ROUND(100.0 * SUM(CASE WHEN activity_type = 'send' THEN time_spent END) / 
    SUM(time_spent), 2) AS send_perc,
    ROUND(100.0 * SUM(CASE WHEN activity_type = 'open' THEN time_spent END) / 
    SUM(time_spent), 2) AS open_perc
FROM age_breakdown JOIN activities
ON age_breakdown.user_id = activities.user_id
WHERE activity_type IN ('send', 'open')
GROUP BY age_bucket
```

> Question 2:  Page With No Likes [Facebook SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/sql-page-with-no-likes

> Solution: 

```
select p.page_id
from pages p
left join page_likes l
on p.page_id = l.page_id
where liked_date is null
order by page_id
```