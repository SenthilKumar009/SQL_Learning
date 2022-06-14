select * from trading.members;

SELECT * FROM trading.prices LIMIT 5;

SELECT * FROM trading.transactions LIMIT 5;

/* Step 2: */

/* Q1: Show only the top 5 rows from the trading.members table */
select * from trading.members limit 5;

/* Q2: Sort all the rows in the table by first_name in alphabetical order and show the top 3 rows*/
select * from trading.members order by first_name limit 3;

/*Q3: Which records from trading.members are from the United States region? */
select * from trading.members where region = 'United States';

/*Q4: Select only the member_id and first_name columns for members who are not from Australia */
select member_id, first_name from trading.members where region != 'Australia';

/*Q5: Return the unique region values from the trading.members table and sort the output by reverse alphabetical order */
select distinct region from trading.members order by region desc;

/*Q6: How many mentors are there from Australia or the United States? */
select count(member_id) from trading.members where region in ('Australia', 'United States');

/*Q7: How many mentors are not from Australia or the United States? */
select count(member_id) from trading.members where region not in ('Australia', 'United States');

/*Q8: How many mentors are there per region? Sort the output by regions with the most mentors to the least */
select region, count(member_id) 
from trading.members 
group by region
order by count(member_id) desc;

/*Q9: How many US mentors and non US mentors are there?*/
select 
	case 
		when region !='United States' then 'Non-US'
		else region
	end as member_region,
	count (*) as member_count
from trading.members
group by member_region
ORDER BY mentor_count DESC;

/*Q10: How many mentors have a first name starting with a letter before 'E'? */
select count(first_name)
from trading.members
where left(first_name,1) < 'E';

/* Step 3 */

SELECT * FROM trading.prices WHERE ticker = 'BTC' LIMIT 5;

SELECT * FROM trading.prices WHERE ticker = 'ETH' LIMIT 5;

/* Q1: How many total records do we have in the trading.prices table? */
select count(*) from trading.prices;

/* Q2: How many records are there per ticker value? */
select ticker, count(ticker) total_count
from trading.prices
group by ticker
order by total_count desc;

/* Q3: What is the minimum and maximum market_date values? */
select min(market_date) as min_market_date,
	   max(market_date) as max_market_date
from trading.prices;

/* Q4: Are there differences in the minimum and maximum market_date values for each ticker? */
select ticker,
	   min(market_date) as min_market_date,
	   max(market_date) as max_market_date
from trading.prices
group by ticker;

/* Q5: What is the average of the price column for Bitcoin records during the year 2020? */
select avg(price)
from trading.prices
where ticker = 'BTC' and  
	  market_date >='2020-01-01' and market_date <='2020-12-31';
/* Q6: What is the monthly average of the price column for Ethereum in 2020? Sort the output in chronological order 
	   and also round the average price value to 2 decimal places */
select 
	date_trunc('MON', market_date) as Month_Start,
	round(avg(price)::numeric, 2) as Average_price
from trading.prices
where extract(YEAR from market_date) = 2020
and ticker = 'ETH'
group by month_start
order by month_start;

/* Q7: Are there any duplicate market_date values for any ticker value in our table?*/
select ticker, count(market_date) total_count, count(distinct(market_date)) unique_count
from trading.prices
group by ticker;

/* Q8: How many days from the trading.prices table exist where the high price of Bitcoin is over $30,000?*/
select count(*) from trading.prices
where price > 30000
and ticker ='BTC';

/* Q9: How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker? */
select ticker, count(*) breakout_days
from trading.prices
where extract(YEAR from market_date)  = 2020
and  price > open
group by ticker;

/* Q10: How many "non_breakout" days were there in 2020 where the price column is less than the open column for each ticker? */
select ticker, count(*) non_breakout_days
from trading.prices
where extract(YEAR from market_date)  = 2020
and  price < open
group by ticker;

/*  Q11: What percentage of days in 2020 were breakout days vs non-breakout days? Round the percentages to 2 decimal places */
SELECT
  ticker,
  ROUND(
    SUM(CASE WHEN price > open THEN 1 ELSE 0 END)
      / COUNT(*)::NUMERIC,
    2
  ) AS breakout_percentage,
  ROUND(
    SUM(CASE WHEN price < open THEN 1 ELSE 0 END)
      / COUNT(*)::NUMERIC,
    2
  ) AS non_breakout_percentage
FROM trading.prices
WHERE market_date >= '2020-01-01' AND market_date <= '2020-12-31'
GROUP BY ticker;

/* Step 4 */

SELECT * FROM trading.transactions
WHERE member_id = 'c4ca42'
ORDER BY txn_time DESC
LIMIT 10;

/* Q1: How many records are there in the trading.transactions table? */
select count(*) from trading.transactions;

/* Q2: How many unique transactions are there? */
select distinct(count(*)) from trading.transactions;

/* Q3: How many buy and sell transactions are there for Bitcoin? */
select txn_type, count(txn_id) as TotalCount
from trading.transactions
where ticker = 'BTC'
group by txn_type;

/* Q4: For each year, calculate the following buy and sell metrics for Bitcoin: 
	   * total transaction count
	   * total quantity
	   * average quantity per transaction	
*/

select extract(year from txn_date) as TxnYear,
	   txn_type,
	   count(txn_id) as Total_Transaction,
	   round(sum(quantity)::NUMERIC, 2) as TotalQty,
	   round(avg(quantity)::NUMERIC, 2) as AvgQty
from trading.transactions
where ticker = 'BTC'
group by extract(year from txn_date), txn_type
order by extract(year from txn_date), txn_type;

/* Q5: What was the monthly total quantity purchased and sold for Ethereum in 2020? */
select 
		date_trunc('MON', txn_date)::DATE as CalendarMonth,
		sum(case when txn_type = 'BUY' then quantity else 0 end) BuyQuantity,
		sum(case when txn_type = 'SELL' then quantity else 0 end) SellQuantity
from trading.transactions
where ticker = 'ETH' and txn_date between '2020-01-01' and '2021-01-01'
group by CalendarMonth
order by CalendarMonth;

/* Q6: Summarise all buy and sell transactions for each member_id by generating 1 row for each member with the following additional columns:
	* Bitcoin buy quantity
	* Bitcoin sell quantity
	* Ethereum buy quantity
	* Ethereum sell quantity */

select member_id,
	   sum(case  
		   		when ticker = 'BTC' then
		   			 case when txn_type = 'BUY' then quantity else 0 end
		   end) as BTC_Buy_Qty,
		sum(case  
		   		when ticker = 'BTC' then
		   			 case when txn_type = 'SELL' then quantity else 0 end
		   end) as BTC_Sell_Qty,
		sum(case  
		   		when ticker = 'ETH' then
		   			 case when txn_type = 'BUY' then quantity else 0 end
		   end) as ETH_Buy_Qty,
		sum(case  
		   		when ticker = 'ETH' then
		   			 case when txn_type = 'SELL' then quantity else 0 end
		   end) as ETH_Sell_Qty
from trading.transactions
group by member_id
order by member_id;

/* Q7: What was the final quantity holding of Bitcoin for each member? Sort the output from the highest BTC holding to lowest */

select member_id,
	   sum(case  
		   		when ticker = 'BTC' then
		   			 case when txn_type = 'BUY' then quantity else 0 end
		   end) as BTC_Buy_Qty,
		sum(case  
		   		when ticker = 'BTC' then
		   			 case when txn_type = 'SELL' then quantity else 0 end
		    end) as BTC_Sell_Qty,
		sum(case  
		   		when ticker = 'BTC' then
		   			 case when txn_type = 'BUY' then quantity else 0 end
		    end) - 
		sum(case  
		   		when ticker = 'BTC' then
		   			 case when txn_type = 'SELL' then quantity else 0 end
		    end) as Remaining_BTC_Qty,
		sum(case  
		   		when ticker = 'ETH' then
		   			 case when txn_type = 'BUY' then quantity else 0 end
		    end) as ETH_Buy_Qty,
		sum(case  
		   		when ticker = 'ETH' then
		   			 case when txn_type = 'SELL' then quantity else 0 end
		   end) as ETH_Sell_Qty,
		sum(case  
		   		when ticker = 'ETH' then
		   			 case when txn_type = 'BUY' then quantity else 0 end
		    end) -
		sum(case  
		   		when ticker = 'ETH' then
		   			 case when txn_type = 'SELL' then quantity else 0 end
		   end) as Remaining_ETH_Qty
from trading.transactions
group by member_id
order by member_id;

/* Q8: Which members have sold less than 500 Bitcoin? Sort the output from the most BTC sold to least */
select * from trading.transactions;
select member_id,
	   sum(quantity) as Total_Sold_Qty
from trading.transactions
where ticker = 'BTC' and txn_type='SELL'
group by member_id
having sum(quantity) < 500
order by Total_Sold_Qty desc;

/* Q9:  What is the total Bitcoin quantity for each member_id owns after adding all of the BUY and SELL transactions 
		from the transactions table? Sort the output by descending total quantity*/

select member_id,
		sum(case  
		   		when ticker = 'BTC' then
		   			 case when txn_type = 'BUY' then quantity else 0 end
		    end) - 
		sum(case  
		   		when ticker = 'BTC' then
		   			 case when txn_type = 'SELL' then quantity else 0 end
		    end) as RemQty
from trading.transactions
where ticker = 'BTC'
group by member_id
order by RemQty desc;

select member_id,
	   sum(case when txn_type = 'BUY' then quantity
	       		when txn_type = 'SELL' then -quantity
		   end) as RemQuantity
from trading.transactions
where ticker = 'BTC'
group by member_id
order by RemQuantity desc;

/* Q10: Which member_id has the highest buy to sell ratio by quantity? */

select member_id,
	   sum(case when txn_type = 'BUY' then quantity end) /
	   sum(case when txn_type = 'SELL' then quantity end)
	   as Buy_Sell_Ratio
from trading.transactions
group by member_id
order by Buy_Sell_Ratio desc

/* Q11: For each member_id - which month had the highest total Ethereum quantity sold`? */

with cte_ranked as (
select  member_id,
		date_trunc('MON', txn_date)::DATE as CalendarMonth,
		sum(quantity) SoldQuantity,
		rank() over (partition by member_id order by sum(quantity) desc) as month_rank
from trading.transactions
where ticker = 'ETH' and txn_type = 'SELL'
group by member_id, CalendarMonth)
select member_id, CalendarMonth, SoldQuantity
from cte_ranked
where month_rank = 1
order by member_id, CalendarMonth;

/* Step 5 - Let the Data Analysis Begin */
select * from trading.prices;
select * from trading.members;
select * from trading.transactions;

/* Q1: What is the earliest and latest date of transactions for all members? */
select min(txn_date) as earliest_transaction,
	   max(txn_date) as latest_transaction
from trading.transactions;

/* Q2: What is the range of market_date values available in the prices data? */
select min(market_date) as earliest_transaction,
	   max(market_date) as latest_transaction
from trading.prices;

/* Q3: Which top 3 mentors have the most Bitcoin quantity as of the 29th of August? */
select m.first_name,
	   sum(case when t.txn_type = 'BUY' then t.quantity
	       		when t.txn_type = 'SELL' then -t.quantity
		   end) as RemQuantity
from trading.transactions t
join trading.members m
on t.member_id = m.member_id
where t.ticker = 'BTC'
group by m.first_name
order by RemQuantity desc
limit 3;

/* Q4: What is total value of all Ethereum portfolios for each region at the end date of our analysis? Order the output by descending portfolio value */
WITH cte_latest_price AS (
  SELECT
    ticker,
    price
  FROM trading.prices
  WHERE ticker = 'ETH'
  AND market_date = '2021-08-29'
)
SELECT
  members.region,
  SUM(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) * cte_latest_price.price AS ethereum_value,
  AVG(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) * cte_latest_price.price AS avg_ethereum_value
FROM trading.transactions
INNER JOIN cte_latest_price
  ON transactions.ticker = cte_latest_price.ticker
INNER JOIN trading.members
  ON transactions.member_id = members.member_id
WHERE transactions.ticker = 'ETH'
GROUP BY members.region, cte_latest_price.price
ORDER BY avg_ethereum_value DESC;

/* Q5: What is the average value of each Ethereum portfolio in each region? Sort this output in descending order */
WITH cte_latest_price AS (
  SELECT
    ticker,
    price
  FROM trading.prices
  WHERE ticker = 'ETH'
  AND market_date = '2021-08-29'
)
SELECT
  members.region,
  SUM(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) * cte_latest_price.price AS ethereum_value,
  AVG(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) * cte_latest_price.price AS avg_ethereum_value
FROM trading.transactions
INNER JOIN cte_latest_price
  ON transactions.ticker = cte_latest_price.ticker
INNER JOIN trading.members
  ON transactions.member_id = members.member_id
WHERE transactions.ticker = 'ETH'
GROUP BY members.region, cte_latest_price.price
ORDER BY avg_ethereum_value DESC;

/* Second way */
WITH cte_latest_price AS (
  SELECT
    ticker,
    price
  FROM trading.prices
  WHERE ticker = 'ETH'
  AND market_date = '2021-08-29'
),
cte_calculations AS (
SELECT
  members.region,
  SUM(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) * cte_latest_price.price AS ethereum_value,
  COUNT(DISTINCT members.member_id) AS mentor_count
FROM trading.transactions
INNER JOIN cte_latest_price
  ON transactions.ticker = cte_latest_price.ticker
INNER JOIN trading.members
  ON transactions.member_id = members.member_id
WHERE transactions.ticker = 'ETH'
GROUP BY members.region, cte_latest_price.price
)
-- final output
SELECT
  *,
  ethereum_value / mentor_count AS avg_ethereum_value
FROM cte_calculations
ORDER BY avg_ethereum_value DESC;

/* Step 6 - Planning Ahead for Data Analysis */
/* Q1:  Questions 1-4

What is the total portfolio value for each mentor at the end of 2020?

What is the total portfolio value for each region at the end of 2019?

What percentage of regional portfolio values does each mentor contribute at the end of 2018?

Does this region contribution percentage change when we look across both Bitcoin and Ethereum portfolios independently at the end of 2017? */

-- Create a base table
-- Step 1
-- Create a base table that has each mentor's name, region and end of year total quantity for each ticker

select * from trading.prices;
select * from trading.members;
select * from trading.transactions;

DROP TABLE IF EXISTS temp_portfolio_base;
CREATE TEMP TABLE temp_portfolio_base AS
with cte_joined_data as
(select
	  m.first_name,
	  m.region,
	  t.ticker,
 	  t.txn_date,
	  case when t.txn_type = 'SELL' then -t.quantity
	  	   	   else t.quantity
	  end as Adjusted_Quantity
from trading.transactions t
join trading.members m
on t.member_id = m.member_id
where t.txn_date <= '2020-12-31')
select first_name,
	   region,
	   (DATE_TRUNC('YEAR', txn_date) + INTERVAL '12 MONTHS' - INTERVAL '1 DAY') :: DATE as year_end, 
	   ticker,
	   sum(Adjusted_Quantity) Total_Qty
from cte_joined_data
group by first_name, region, year_end, ticker;

select 
	  year_end,
	  ticker,
	  total_qty as yearly_Qty
	  --cumulative_quantity
from temp_portfolio_base
where first_name ='Abe'
order by ticker, year_end;

select * from temp_portfolio_base

select 
	  year_end,
	  ticker,
	  total_qty as yearly_Qty,
	  sum(total_qty) 
	  OVER (partition by first_name, ticker
		    order by year_end
		    ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) as Cumulative_Qty
from temp_portfolio_base
where first_name ='Abe'
order by ticker;

ALTER TABLE temp_portfolio_base
ADD cumulative_quantity NUMERIC;

-- update new column with data
UPDATE temp_portfolio_base
SET (cumulative_quantity) = (
  SELECT
      SUM(total_qty) OVER (
    PARTITION BY first_name, ticker
    ORDER BY year_end
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  )
);

select 
	  year_end,
	  ticker,
	  total_qty as yearly_Qty,
	  cumulative_quantity
from temp_portfolio_base
where first_name ='Abe'
order by ticker, year_end;

DROP TABLE IF EXISTS temp_cumulative_portfolio_base;
CREATE TEMP TABLE temp_cumulative_portfolio_base AS
SELECT
  first_name,
  region,
  year_end,
  ticker,
  total_qty,
  SUM(total_qty) OVER (
    PARTITION BY first_name, ticker
    ORDER BY year_end
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_quantity
FROM temp_portfolio_base;

select 
	  year_end,
	  ticker,
	  total_qty as yearly_Qty,
	  cumulative_quantity
from temp_portfolio_base
where first_name ='Abe'
order by ticker, year_end;

SELECT * FROM temp_cumulative_portfolio_base LIMIT 20;

/* ROWS BETWEEN and UNBOUNDED PRECEDING & CURRENT ROW*/
select 
	  year_end,
	  ticker,
	  total_qty as yearly_Qty,
	  sum(total_qty) 
	  OVER (partition by first_name, ticker
		    order by year_end
		    ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) as Cumulative_Qty
from temp_portfolio_base
where first_name ='Abe'
order by ticker;

/* ROWS BETWEEN and UNBOUNDED PRECEDING & UNBOUNDED FOLLOWING*/
select 
	  year_end,
	  ticker,
	  total_qty as yearly_Qty,
	  sum(total_qty) 
	  OVER (partition by first_name, ticker
		    order by year_end
		    ROWS BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING) as Cumulative_Qty
from temp_portfolio_base
where first_name ='Abe'
order by ticker;

/* RANGE BETWEEN and UNBOUNDED PRECEDING & CURRENT ROW */
select 
	  year_end,
	  ticker,
	  total_qty as yearly_Qty,
	  sum(total_qty) 
	  OVER (partition by first_name, ticker
		    order by year_end
		    RANGE BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) as Cumulative_Qty
from temp_portfolio_base
where first_name ='Abe'
order by ticker;

/* RANGE BETWEEN and UNBOUNDED PRECEDING & UNBOUNDED FOLLOWING*/

select 
	  year_end,
	  ticker,
	  total_qty as yearly_Qty,
	  sum(total_qty) 
	  OVER (partition by first_name, ticker
		    order by year_end
		    RANGE BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING) as Cumulative_Qty
from temp_portfolio_base
where first_name ='Abe'
order by ticker;

/* Step 7 - Answering Data Questions */

select * from temp_cumulative_portfolio_base limit 10;
select * from trading.prices;

/* Q1: What is the total portfolio value for each mentor at the end of 2020? */

select base.first_name,
	   ROUND(sum(cumulative_quantity * price.price)) as portfolio_value
from temp_cumulative_portfolio_base as base
join trading.prices price
on base.ticker = price.ticker
and base.year_end = price.market_date
where base.year_end = '2020-12-31'
group by base.first_name
order by portfolio_value desc;

select round(12.98765, 2);

/* Q2: What is the total portfolio value for each region at the end of 2019? */
select base.region,
	   sum(base.cumulative_quantity  * p.price) as Portfolio_Value
from temp_cumulative_portfolio_base as base
join trading.prices p
on base.ticker = p.ticker
and base.year_end = p.market_date
where base.year_end = '2019-12-31'
group by base.region
order by Portfolio_value desc;

/* Q3: What percentage of regional portfolio values does each mentor contribute at the end of 2018? */

with cte_mentor_portfolio as
(select base.region,
	    base.first_name,
	    round(sum(base.cumulative_quantity  * p.price)) as Portfolio_Value
from temp_cumulative_portfolio_base as base
join trading.prices p
on base.ticker = p.ticker
and base.year_end = p.market_date
where base.year_end = '2018-12-31'
group by base.region, base.first_name),
cte_region_portfolio as
(select 
 	region,
 	first_name,
 	portfolio_value,
 	sum(portfolio_value) over (partition by region) as region_total
 from cte_mentor_portfolio
)
select
	region,
	first_name,
	portfolio_value,
	region_total,
	round(100 * portfolio_value / region_total) as Contribution_Percentage
from cte_region_portfolio
order by region_total desc, Contribution_Percentage desc;



