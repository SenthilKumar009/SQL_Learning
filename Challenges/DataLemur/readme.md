## Question 1:
Refer the below link for detailed question
### https://datalemur.com/questions/sql-histogram-tweets

### Solution:
```
WITH tweet_details AS(
  select DISTINCT user_id, tweet_year, count(user_id) total_tweets
  FROM
    (SELECT tweet_id, user_id, EXTRACT(year from tweet_Date) tweet_year 
     from tweets) as t
  group by user_id, tweet_year  
)
select total_tweets as tweet_bucket,
       count(total_tweets) as users_num
from tweet_details
where tweet_year = 2022
GROUP BY total_tweets
```
<img width="763" height="150" alt="image" src="https://github.com/SenthilKumar009/SQL_Learning/assets/24444578/a7c331e2-72e4-4104-8f66-98dde5e6eaaf">
