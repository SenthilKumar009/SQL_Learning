## Week 20

> Question 1:  App Click-through Rate (CTR) [Facebook SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/click-through-rate

> Solution: 

```
SELECT 
 app_id,
  --sum(case WHEN event_type = 'impression' then 1 ELSE 0 END) as impression_count,
  --sum(case WHEN event_type = 'click' then 1 ELSE 0 END) as click_count,
 ROUND(100.0 *
    sum(case WHEN event_type = 'click' then 1 ELSE 0 END) / 
    sum(case WHEN event_type = 'impression' then 1 ELSE 0 END),2) as ctr
FROM events
WHERE timestamp BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY app_id;;
```

> Question 2:  Cities With Completed Trades [Robinhood SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/completed-trades

> Solution: 

```
SELECT u.city, count(t.status) total_orders 
FROM trades t
join users u
on t.user_id = u.user_id
where t.status = 'Completed'
group by u.city, t.status
order by total_orders desc
limit 3
```