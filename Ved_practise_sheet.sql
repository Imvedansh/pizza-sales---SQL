-- Retieve the total no. of order placed.

use  pizzahut;
SELECT COUNT(order_id) as order_total  FROM orders;

-- Total revenue generated from pizza sales
-- -> Approach Pizza * amount

SELECT 
ROUND(SUM(od.quantity * p.price),2) AS Revenue_from_sales
FROM orders_details AS od JOIN pizzas AS p
ON p.pizza_id = od.pizza_id;

-- Identify highest price pizza

SELECT pizza_id  AS Most_expensive_pizze 

FROM pizzas
Where price = (SELECT  MAX(price) FROM pizzas);
 -- OR
SELECT pt.name ,p.price
FROM pizza_types AS pt 
JOIN pizzas AS p
ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC LIMIT 1;

-- Identify the most common pizza size ordered.
  
 SELECT  p.size AS most_common_size,count(od.order_details_id) AS order_count
 FROM pizzas AS p
 JOIN orders_details AS od
 ON p.pizza_id = od.pizza_id
 GROUP BY p.size ORDER BY order_count desc ;
 
 
-- List the top 5 most ordered pizza types along with their quantities

SELECT pt.name ,SUM(od.quantity) AS odqnt
FROM pizza_types AS pt JOIN pizzas AS p
ON pt.pizza_type_id = p.pizza_type_id 
JOIN orders_details AS od 
ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY odqnt DESC LIMIT 5;


-- INTERMEDIATE LEVEL 

-- Find total quantity of each pizza category ordered

SELECT pt.category , SUM(od.quantity ) AS odqnt
FROM pizza_types AS pt JOIN pizzas AS p
ON pt.pizza_type_id = p.pizza_type_id
JOIN orders_details AS od 
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY odqnt DESC;

-- Determine the distribution of orders by hour of the day

SELECT hour(order_time) , COUNT(order_id) from orders
GROUP BY hour(order_time);


-- FIND the category wise ditribution of pizzas

SELECT category ,COUNT(name)
FROM pizza_types
GROUP BY category
ORDER BY COUNT(name) asc;


-- Group the orders by date and calculate the average no. of pizzas ordered per day
SELECT round(AVG (odqnt),0) 
FROM
(SELECT o.order_date , SUM(od.quantity) AS odqnt
FROM orders AS o JOIN
orders_details AS od
ON
od.order_id = o.order_id
GROUP BY order_date) AS per_day;

-- top 3 most ordered pizza types based on revenue


SELECT pizza_types.name,SUM(orders_details.quantity * pizzas.price) AS revenue
FROM pizza_types AS pt JOIN
pizzas AS p 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details 
ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name 
order by revenue desc LIMIT 3;


SELECT pizza_types.name,
SUM(od.quantity * p.price) AS Revenue
FROM orders_details AS od JOIN pizzas AS p
ON p.pizza_id = od.pizza_id
JOIN pizza_types AS pt 
ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pizza_types.name 
order by revenue desc limit 3;

DESCRIBE pizza_types;
SHOW COLUMNS FROM pizza_types;

SELECT pizza_types.name from pizza_types;


-- ADVANCED QUERIES

-- percentage contribution of each pizza type to total revenue

SELECT 
    pizza_types.category,
    SUM(orders_details.quantity * pizzas.price) / ( SELECT 
ROUND(SUM(od.quantity * p.price),2) 
FROM orders_details AS od JOIN pizzas AS p
ON p.pizza_id = od.pizza_id)*100 AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;



-- analyze the cumulative revenue generated over time

SELECT order_date,
SUM(sum_revenue) OVER(ORDER BY order_date) as cum_revenue
FROM
(SELECT orders.order_date , SUM( orders_details.quantity * pizzas.price) AS sum_revenue
FROM orders_details JOIN pizzas
ON orders_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = orders_details.order_id
GROUP BY orders.order_date) AS sales;

-- order top 3 pizza based upon revenue from the each  pizza category

SELECT pizza_types.category,
sum((order_details.quantity)* pizzas.price) as revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;

