'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
Difficulty: Easy

Given a table of candidates and their skills, you are tasked with finding the candidates best suited for an open Data Science job. 
You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

Assumption:
	There are no duplicates in the candidates table.

candidates Table:
	Column Name	Type
	candidate_id	integer
	skill	varchar

candidates Example Input:

candidate_id	skill
123	Python
123	Tableau
123	PostgreSQL
234	R
234	PowerBI
234	SQL Server
345	Python
345	Tableau

Example Output:
candidate_id
123

Explanation:
Candidate 123 is displayed because they have Python, Tableau, and PostgreSQL skills. 
345 is nott included in the output because they are missing one of the required skills: PostgreSQL.

The dataset you are querying against may have different input & output - this is just an example!
'''
-- Solution:
SELECT DISTINCT(candidate_id) 
FROM candidates 
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having COUNT(skill)= 3;
-------------------------------------------------------------------------------------------------------------------------------

'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
Difficulty: Easy
Teams Power Users [Microsoft SQL Interview Question]

Write a query to find the top 2 power users who sent the most messages on Microsoft Teams in August 2022. 
Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending count of the messages.

Assumption:
	No two users has sent the same number of messages in August 2022.

messages Table:

Column Name	Type
message_id	integer
sender_id	integer
receiver_id	integer
content	varchar
sent_date	datetime

messages Example Input:

message_id	sender_id	receiver_id	content	sent_date
901	3601	4500	You up?	08/03/2022 00:00:00
902	4500	3601	Only if you're buying	08/03/2022 00:00:00
743	3601	8752	Let's take this offline	06/14/2022 00:00:00
922	3601	4500	Get on the call	08/10/2022 00:00:00

Example Output:
sender_id	message_count
3601	2
4500	1
'''
-- Solution:
SELECT sender_id, count(sender_id) as message_count
FROM messages
where sent_date between '08/01/2022' and '08/31/2022'
group by sender_id
order by message_count DESC
limit 2;

-------------------------------------------------------------------------------------------------------------------------------
'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
Difficulty: Easy
Compressed Mean [Alibaba SQL Interview Question]

You are trying to find the mean number of items bought per order on Alibaba, rounded to 1 decimal place.

However, instead of doing analytics on all Alibaba orders, you have access to a summary table, which describes how many items were in an order (item_count), 
and the number of orders that had that many items (order_occurrences).

items_per_order Table:
Column Name	Type
item_count	integer
order_occurrences	integer

items_per_order Example Input:
item_count	order_occurrences
1	500
2	1000
3	800
4	1000

There are 500 orders with 1 item in each order; 1000 orders with 2 items in each order; 800 orders with 3 items in each order.

Example Output:
mean
2.7
Explanation
Lets calculate the arithmetic average:

Total items = (1*500) + (2*1000) + (3*800) + (4*1000) = 8900

Total orders = 500 + 1000 + 800 + 1000 = 3300

Mean = 8900 / 3300 = 2.7
'''

--- Solution:
SELECT round((sum(order_occurrences * item_count*1.0) / sum(order_occurrences*1.0)),1) as mean
FROM items_per_order;

-------------------------------------------------------------------------------------------------------------------------------
'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
Laptop vs. Mobile Viewership [New York Times SQL Interview Question]
Difficulty: Easy

Assume that you are given the table below containing information on viewership by device type (where the three types are laptop, tablet, and phone). 
Define “mobile” as the sum of tablet and phone viewership numbers. Write a query to compare the viewership on laptops versus mobile devices.

Output the total viewership for laptop and mobile devices in the format of "laptop_views" and "mobile_views".

viewership Table:
Column Name	Type
user_id	integer
device_type	string ('laptop', 'tablet', 'phone')
view_time	timestamp

viewership Example Input:
user_id	device_type	view_time
123	tablet	01/02/2022 00:00:00
125	laptop	01/07/2022 00:00:00
128	laptop	02/09/2022 00:00:00
129	phone	02/09/2022 00:00:00
145	tablet	02/24/2022 00:00:00

Example Output:
laptop_views	mobile_views
2	3
Explanation: Given the example input, there are 2 laptop views and 3 mobile views.

'''

--- Solution:
SELECT 
  count(case when device_type = 'laptop' then 1 end) as laptop_views,
  count(case when device_type = 'tablet' or device_type = 'phone' then 1 end) as mobile_views
FROM viewership;

-------------------------------------------------------------------------------------------------------------------------------
'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
Average Post Hiatus (Part 1) [Facebook SQL Interview Question]
Difficulty: Easy

Given a table of Facebook posts, for each user who posted at least twice in 2021, 
write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. 
Output the user and number of the days between each users first and last post.

posts Table:
Column Name	Type
user_id	integer
post_id	integer
post_date	timestamp
post_content	text

posts Example Input:
user_id	post_id	post_date	post_content
151652	599415	07/10/2021 12:00:00	Need a hug
661093	624356	07/29/2021 13:00:00	Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day thats gonna fly by. I miss my girlfriend
004239	784254	07/04/2021 11:00:00	Happy 4th of July!
661093	442560	07/08/2021 14:00:00	Just going to cry myself to sleep after watching Marley and Me.
151652	111766	07/12/2021 19:00:00	I am so done with covid - need travelling ASAP!

Example Output:
user_id	days_between
151652	2
661093	21
'''

-- Solution:
SELECT user_id, MAX(date(post_date)) - MIN(date(post_date)) as days_between
FROM posts
WHERE DATE_PART('year', post_date) = 2021
GROUP BY user_id
having count(user_id) >= 2;

-------------------------------------------------------------------------------------------------------------------------------
'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
Patient Support Analysis (Part 2) [UnitedHealth SQL Interview Question]
Difficulty: Easy

UnitedHealth Group has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs 
– whether thats behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.

Calls to the Advocate4Me call centre are categorised, but sometimes they can not fit neatly into a category. 
These uncategorised calls are labelled “n/a”, or are just empty (when a support agent enters nothing into the category field).

Write a query to find the percentage of calls that cannot be categorised. Round your answer to 1 decimal place.

callers Table:
Column Name	Type
policy_holder_id	integer
case_id	varchar
call_category	varchar
call_received	timestamp
call_duration_secs	integer
original_order	integer

callers Example Input:
policy_holder_id	case_id	call_category	call_received	call_duration_secs	original_order
52481621	a94c-2213-4ba5-812d		01/17/2022 19:37:00	286	161
51435044	f0b5-0eb0-4c49-b21e	n/a	01/18/2022 2:46:00	208	225
52082925	289b-d7e8-4527-bdf5	benefits	01/18/2022 3:01:00	291	352
54624612	62c2-d9a3-44d2-9065	IT_support	01/19/2022 0:27:00	273	358
54624612	9f57-164b-4a36-934e	claims	01/19/2022 6:33:00	157	362

Example Output:
call_percentage
40.0

Explanation:
A total of 5 calls were registered. Out of which 2 calls were not categorised. That makes 40.0% (2/5 x 100.0) of the calls uncategorised.
'''
--- Solution:
SELECT 
round((sum
  (case 
      when call_category is null or call_category = 'n/a' then 1 else 0 
   end
  ) * 1.0 / count(case_id) * 1.0) * 100, 1)
FROM callers

-------------------------------------------------------------------------------------------------------------------------------
'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
Top 5 Artists [Spotify SQL Interview Question]
Difficulty: Medium

Assume there are three Spotify tables containing information about the artists, songs, and music charts. 
Write a query to determine the top 5 artists whose songs appear in the Top 10 of the global_song_rank table the highest number of times. From now on, 
we will refer to this ranking number as "song appearances".

Output the top 5 artist names in ascending order along with their song appearances ranking (not the number of song appearances, 
but the rank of who has the most appearances). The order of the rank should take precedence.

For example:
Ed Sheeran songs appeared 5 times in Top 10 list of the global song rank table; this is the highest number of appearances, so he is ranked 1st. 
Bad Bunnys songs appeared in the list 4, so he comes in at a close 2nd.

Assumptions:

If two artists songs have the same number of appearances, the artists should have the same rank.
The rank number should be continuous (1, 2, 2, 3, 4, 5) and not skipped (1, 2, 2, 4, 5).

artists Table:

Column Name	Type
artist_id	integer
artist_name	varchar

artists Example Input:
artist_id	artist_name
101	Ed Sheeran
120	Drake

songs Table:

Column Name	Type
song_id	integer
artist_id	integer

songs Example Input:
song_id	artist_id
45202	101
19960	120

global_song_rank Table:
Column Name	Type
day	integer (1-52)
song_id	integer
rank	integer (1-1,000,000)

global_song_rank Example Input:
day	song_id	rank
1	45202	5
3	45202	2
1	19960	3
9	19960	15

Example Output:
artist_name	artist_rank
Ed Sheeran	1
Drake	2

Explanation:
Ed Sheerans song appeared twice in the Top 10 list of global song rank while Drakes song is only listed once. 
Therefore, Ed is ranked #1 and Drake is ranked #2.

'''
--Solution:

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
limit 6;
-------------------------------------------------------------------------------------------------------------------------------
'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
Second Day Confirmation [TikTok SQL Interview Question]
Difficulty: Easy

New TikTok users sign up with their emails and each user receives a text confirmation to activate their account. 
Assume you are given the below tables about emails and texts.

Write a query to display the ids of the users who did not confirm on the first day of sign-up, but confirmed on the second day.

Assumption:
action_date is the date when the user activated their account and confirmed their sign-up through the text.

emails Table:
Column Name	Type
email_id	integer
user_id	integer
signup_date	datetime

emails Example Input:
email_id	user_id	signup_date
125	7771	06/14/2022 00:00:00
433	1052	07/09/2022 00:00:00

texts Table:
Column Name	Type
text_id	integer
email_id	integer
signup_action	string ('Confirmed', 'Not confirmed')
action_date	datetime

texts Example Input:
text_id	email_id	signup_action	action_date
6878	125	Confirmed	06/14/2022 00:00:00
6997	433	Not Confirmed	07/09/2022 00:00:00
7000	433	Confirmed	07/10/2022 00:00:00

Example Output:
user_id
1052

Explanation:
User 1052 is the only user who confirmed their sign up on the second day.
'''

-- Solution:
SELECT user_id
FROM emails LEFT JOIN texts USING(email_id)
GROUP BY user_id
HAVING DATE_PART('day',MAX(action_date)) - DATE_PART('day',MIN(action_date)) :: NUMERIC = 1

-------------------------------------------------------------------------------------------------------------------------------
'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: HackerRank
Weather Observation Station
Difficulty: Easy

Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). 
If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
The STATION table is described as follows:
'''

-- Solution:
(select city, length(city) city_length
from station
order by city_length asc, city asc
limit 1)
union
(select city, length(city) city_length
from station
order by city_length desc, city asc
limit 1)

-------------------------------------------------------------------------------------------------------------------------------
'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
626. Exchange Seats
Level : Medium

Table: Seat

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the name and the ID of a student.
id is a continuous increment.
 
Write an SQL query to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.

Return the result table ordered by id in ascending order.

The query result format is in the following example.

Example 1:

Input: 
Seat table:
+----+---------+
| id | student |
+----+---------+
| 1  | Abbot   |
| 2  | Doris   |
| 3  | Emerson |
| 4  | Green   |
| 5  | Jeames  |
+----+---------+
Output: 
+----+---------+
| id | student |
+----+---------+
| 1  | Doris   |
| 2  | Abbot   |
| 3  | Green   |
| 4  | Emerson |
| 5  | Jeames  |
+----+---------+
Explanation: 
Note that if the number of students is odd, there is no need to change the last ones seat.
'''

-- Solution:
select 
       case 
            when id % 2 = 0 then
                 id - 1
            when id % 2 = 1 and id + 1 not in (select id from seat) then
                 id
            else 
                 id + 1
       end as id,
       student
from seat
order by id;

-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------


'''
Date  : 01-Feb-2023
Author: Senthil Kumar ("The Alien") Kanagaraj

Platform: LeedCode
262. Trips and Users
Difficulty: Hard

Table: Trips

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| client_id   | int      |
| driver_id   | int      |
| city_id     | int      |
| status      | enum     |
| request_at  | date     |     
+-------------+----------+
id is the primary key for this table.
The table holds all taxi trips. Each trip has a unique id, while client_id and driver_id are foreign keys to the users_id at the Users table.
Status is an ENUM type of ('completed', 'cancelled_by_driver', 'cancelled_by_client').
 

Table: Users

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| users_id    | int      |
| banned      | enum     |
| role        | enum     |
+-------------+----------+
users_id is the primary key for this table.
The table holds all users. Each user has a unique users_id, and role is an ENUM type of ('client', 'driver', 'partner').
banned is an ENUM type of ('Yes', 'No').
 

The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by the total number of requests with unbanned users on that day.

Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03". Round Cancellation Rate to two decimal points.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Trips table:
+----+-----------+-----------+---------+---------------------+------------+
| id | client_id | driver_id | city_id | status              | request_at |
+----+-----------+-----------+---------+---------------------+------------+
| 1  | 1         | 10        | 1       | completed           | 2013-10-01 |
| 2  | 2         | 11        | 1       | cancelled_by_driver | 2013-10-01 |
| 3  | 3         | 12        | 6       | completed           | 2013-10-01 |
| 4  | 4         | 13        | 6       | cancelled_by_client | 2013-10-01 |
| 5  | 1         | 10        | 1       | completed           | 2013-10-02 |
| 6  | 2         | 11        | 6       | completed           | 2013-10-02 |
| 7  | 3         | 12        | 6       | completed           | 2013-10-02 |
| 8  | 2         | 12        | 12      | completed           | 2013-10-03 |
| 9  | 3         | 10        | 12      | completed           | 2013-10-03 |
| 10 | 4         | 13        | 12      | cancelled_by_driver | 2013-10-03 |
+----+-----------+-----------+---------+---------------------+------------+
Users table:
+----------+--------+--------+
| users_id | banned | role   |
+----------+--------+--------+
| 1        | No     | client |
| 2        | Yes    | client |
| 3        | No     | client |
| 4        | No     | client |
| 10       | No     | driver |
| 11       | No     | driver |
| 12       | No     | driver |
| 13       | No     | driver |
+----------+--------+--------+
Output: 
+------------+-------------------+
| Day        | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 | 0.33              |
| 2013-10-02 | 0.00              |
| 2013-10-03 | 0.50              |
+------------+-------------------+
Explanation: 
On 2013-10-01:
  - There were 4 requests in total, 2 of which were canceled.
  - However, the request with Id=2 was made by a banned client (User_Id=2), so it is ignored in the calculation.
  - Hence there are 3 unbanned requests in total, 1 of which was canceled.
  - The Cancellation Rate is (1 / 3) = 0.33
On 2013-10-02:
  - There were 3 requests in total, 0 of which were canceled.
  - The request with Id=6 was made by a banned client, so it is ignored.
  - Hence there are 2 unbanned requests in total, 0 of which were canceled.
  - The Cancellation Rate is (0 / 2) = 0.00
On 2013-10-03:
  - There were 3 requests in total, 1 of which was canceled.
  - The request with Id=8 was made by a banned client, so it is ignored.
  - Hence there are 2 unbanned request in total, 1 of which were canceled.
  - The Cancellation Rate is (1 / 2) = 0.50
'''
-- Solution:

drop table trips;

create table trips(
	id int,
	client_id int,
	driver_id int, 
	city_id int,
	status varchar,
	request_at date,
	primary key (id),
	FOREIGN KEY(client_id) REFERENCES users(users_id),
	FOREIGN KEY(driver_id) REFERENCES users(users_id)
);

insert into trips values
(1, 1, 10, 1, 'completed', '2013-10-01'),
(2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'),
(3, 3, 12, 6, 'completed', '2013-10-01'),
(4, 4, 13, 6, 'cancelled_by_client', '2013-10-01'),
(5, 1, 10, 1, 'completed', '2013-10-02'),
(6, 2, 11, 6, 'completed', '2013-10-02'),
(7, 3, 12, 6, 'completed', '2013-10-02'),
(8, 2, 12, 12, 'completed', '2013-10-03'),
(9, 3, 10, 12, 'completed', '2013-10-03'),
(10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03');

insert into trips values(11, 1, 10, 1, 'cancelled_by_client', '2013-10-04');

create table users(
	users_id int,
	banned varchar,
	role varchar,
	primary key (users_id)
);

insert into users values
(1, 'No', 'client'),
(2, 'Yes', 'client'),
(3, 'No', 'client'),
(4, 'No', 'client'),
(10, 'No', 'driver'),
(11, 'No', 'driver'),
(12, 'No', 'driver'),
(13, 'No', 'driver')

select * from users;
select * from trips;

with total_trips as
(
	select request_at, count(request_at) daily_trip_count
	from trips
	where client_id not in (select users_id from users where banned = 'Yes') and 
		  driver_id not in (select users_id from users where banned = 'Yes') and
		  request_at >= '2013-10-01' and request_at <='2013-10-03'
	group by request_at
),
total_cancel_trip as
(
	select request_at, 
	count(request_at) as total_cancel_Trip
	from trips
	where status like 'cancelled%' and client_id not in (select users_id from users where banned = 'Yes')
								   and driver_id not in (select users_id from users where banned = 'Yes')
	group by request_at
)
select tt.request_at Day1, daily_trip_count, total_cancel_trip,
	   case when total_cancel_Trip is not null then
	   			 round(((total_cancel_Trip * 1.0) / (daily_trip_count * 1.0)), 2)
		    else 0.0
	   end Cancellation_Rate
from total_trips tt
left join total_cancel_trip tct
on tt.request_at = tct.request_at
order by tt.request_at
-------------------------------------------------------------------------------------------------------------------------------