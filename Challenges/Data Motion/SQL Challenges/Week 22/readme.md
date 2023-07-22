# Week 22

> Question 1:  Pharmacy Analytics (Part 1) [CVS Health SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/top-profitable-drugs

> Solution:

```
SELECT drug, SUM(total_sales-cogs) total_profit
FROM pharmacy_sales
GROUP BY drug
ORDER BY total_profit DESC
limit 3

select drug, total_profit
FROM(
      SELECT drug, SUM(total_sales-cogs) total_profit,
             RANK() OVER( ORDER BY SUM(total_sales-cogs) DESC) as rnk
      FROM pharmacy_sales 
      GROUP BY drug
    ) m
where rnk < 4
```
> Question 2:  Pharmacy Analytics (Part 2) [CVS Health SQL Interview Question]

> Source: datalemur; https://datalemur.com/questions/non-profitable-drugs


> Solution:

```
SELECT manufacturer,COUNT(drug),SUM(cogs-total_sales) AS total_loss 
FROM pharmacy_sales
WHERE cogs>total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;
```