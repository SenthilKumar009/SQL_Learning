# Week 23

> Question 1:  Top 5 Artists [Spotify SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/top-fans-rank

> Solution:

```
with artist_rank_data as
(SELECT a.artist_name, s.song_id, g.day, g.rank
 FROM artists a
 join songs s
 on a.artist_id = s.artist_id
 join global_song_rank g
 on s.song_id = g.song_id
 where g.rank <=10
 group by a.artist_name, s.song_id, g.day, g.rank  
 order by g.day, g.rank),
rank_data as
(select artist_name, count(artist_name) artist_rank
 from artist_rank_data
 group by artist_name
 order by artist_rank DESC)
SELECT artist_name, 
       DENSE_RANK() OVER(ORDER BY artist_rank DESC) as artist_rank
FROM rank_data r
limit 6
```

> Question 2:  Signup Activation Rate [TikTok SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/signup-confirmation-rate

> Solution:

```
with total_user as
(SELECT COUNT(*) total_count FROM emails),
total_confirmed AS
(select count(*) total_conf from texts
 where signup_action = 'Confirmed')
 select round((total_conf*1.0) /(total_count * 1.0),2) activation_rate
 from total_user, total_confirmed
```