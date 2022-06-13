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

/* Q9:  */
