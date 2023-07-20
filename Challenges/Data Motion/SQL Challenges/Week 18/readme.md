## Week 18

> Question 1:  Market Analysis I

> Source: LeetCode: 1158; https://leetcode.com/problems/market-analysis-i/description/

> Solution: 

```
select u.user_id as buyer_id, u.join_date, count(o.order_id) orders_in_2019
from users u
left outer join orders o
on u.user_id = o.buyer_id
and year(o.order_date) = 2019
group by user_id
```

> Question 2:  Capital Gain/Loss

> Source: LeetCode: 1393; https://leetcode.com/problems/capital-gainloss/

> Solution: 

```
with buy_data as
  (select stock_name, sum(price) buy_value 
   from stocks
   where operation = 'Buy'
   group by stock_name),
sell_data as
  (select stock_name, sum(price) sell_value 
   from stocks
   where operation = 'sell'
   group by stock_name)
select b.stock_name, sell_value - buy_value as capital_gain_loss 
from buy_data b
inner join sell_data s
on b.stock_name = s.stock_name
```