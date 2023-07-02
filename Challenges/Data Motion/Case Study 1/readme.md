# SQL Case Study: Tiny Shop Sales

### DDL Queries: 

> Create tables
```
CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);
```
> Insert data
```
INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);
```

-- Case Study Questions

--1) Which product has the highest price? Only return a single row.
```
select * from products where price in (select max(price) from products)
```

--2) Which customer has made the most orders?
```
with order_details as(
    select c.customer_id, count(o.order_id) total_orders
	from orders o
	join customers c
	on o.customer_id = c.customer_id
	group by c.customer_id 
	order by total_orders desc
),
rank_data as(select first_name, last_name, total_orders,
	   		 rank() over (order by o.total_orders desc) as rank
		     from order_details o
			 join customers c
			 on o.customer_id = c.customer_id
)
select first_name, last_name, total_orders 
from rank_data
where rank = 1

```

--3) What’s the total revenue per product?
```
select p.product_name, sum(o.quantity) as total_quantity,
	   sum(o.quantity * p.price) as total_revenue
from order_items o
join products p
on o.product_id = p.product_id
group by p.product_name
order by p.product_name
```

--4) Find the day with the highest revenue.
```
  	select o.order_date, sum(oi.quantity * p.price) as total_revenue
    from order_items oi
	join products p
	on oi.product_id = p.product_id
	join orders o
	on oi.order_id = o.order_id
	group by o.order_date
	order by total_revenue desc
```

--5) Find the first order (by date) for each customer.

```
select customer_id, order_date
from(
  	select c.customer_id, o.order_id, o.order_date,
	   rank() over (partition by c.customer_id order by o.order_date) as order_seq
	from orders o
	join customers c
	on o.customer_id = c.customer_id
	order by c.customer_id, o.order_date) as t
    where t.order_seq = 1;
```

--6) Find the top 3 customers who have ordered the most distinct products

```
with prod_count as (
  	select DISTINCT product_name, c.customer_id
	from order_items oi
	join products p
	on oi.product_id = p.product_id
	join orders o
	on oi.order_id = o.order_id
	join customers c
	on c.customer_id = o.customer_id
	order by c.customer_id
)
select c.customer_id, c.first_name, c.last_name, count(c.customer_id) total_unique_products_ordered
from prod_count p
join customers c
on c.customer_id = p.customer_id
group by c.customer_id
limit 3
```

--7) Which product has been bought the least in terms of quantity?

```
with rank_product_purchase as(
   	select product_name, count(product_name) total_buy,
    	   rank () over (order by count(product_name)) rank
	from order_items oi
	join products p
	on oi.product_id = p.product_id
	join orders o
	on oi.order_id = o.order_id
	join customers c
	on c.customer_id = o.customer_id
    group by product_name
)
select product_name, total_buy
from rank_product_purchase
where rank = 1
```

--8) What is the median order total?

```
with order_total as(
    select o.order_id, sum(o.quantity * p.price) total
    from order_items o
    join products p
    on o.product_id = p.product_id
    group by 1
    order by 2
)
select percentile_cont(0.5) within group (order by total) as median_order
from order_total
```

--9) For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
```
with order_total as(
    select o.order_id, sum(o.quantity * p.price) total
    from order_items o
    join products p
    on o.product_id = p.product_id
    group by 1
    order by 1
)
select order_id, total,
	   case when total > 300 then 'Expensive'
       		when total > 100 then 'Affordable'
            else 'Cheap'
       end as Order_status
from order_total
```

--10) Find customers who have ordered the product with the highest price.
```
select oi.order_id, p.product_id, oi.quantity, p.product_name, p.price, 
	   c.customer_id, c.first_name || ' ' || c.last_name customer_name
from order_items oi
join products p
on oi.product_id = p.product_id
join orders o
on oi.order_id = o.order_id
join customers c
on c.customer_id = o.customer_id
where p.price = (select max(price) from products)
order by o.order_date
```