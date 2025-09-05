CREATE DATABASE business_db;
USE business_db;
select *from pizza_sales
CREATE TABLE pizza_sales_backup AS
SELECT * FROM pizza_sales;

ALTER TABLE pizza_sales
    MODIFY pizza_id INT,
    MODIFY order_id INT,
    MODIFY pizza_name_id VARCHAR(50),
    MODIFY quantity TINYINT,
    MODIFY order_time TIME,
    MODIFY unit_price FLOAT,
    MODIFY total_price FLOAT,
    MODIFY pizza_size VARCHAR(50),
    MODIFY pizza_category VARCHAR(50),
    MODIFY pizza_ingredients VARCHAR(200),
    MODIFY pizza_name VARCHAR(50);

ALTER TABLE pizza_sales MODIFY order_date DATE;
SELECT order_date FROM pizza_sales LIMIT 10;
-- 0 when want to modify
SET SQL_SAFE_UPDATES = 1;

UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

DESCRIBE pizza_sales;

select sum(total_price) AS Total_Revenue from pizza_sales

select sum(total_price) / count(distinct order_id) as Average_ORDER_VALUE from pizza_sales

select sum(quantity) as Total_Pizzas_Sold from pizza_sales

select count(distinct order_id) as Total_Orders from pizza_sales

select cast(cast(sum(quantity) as decimal(10,2)) / cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) as AVG_Pizzas_per_order from pizza_sales

-- daily trend for orders
-- select dayname(dw,order_date) as Order_DAY , count(distinct order_id) as TOTAL_ORDERS from pizza_sales group by dayname(dw,oder_date)

SELECT DAYNAME(order_date) AS Order_DAY,
       COUNT(DISTINCT order_id) AS TOTAL_ORDERS
FROM pizza_sales
GROUP BY DAYNAME(order_date)
ORDER BY TOTAL_ORDERS;

-- hourly trend
-- select datepart(hour,order_time) as ORDER_HOURS ,COUNT(DISTINCT order_id) AS TOTAL_ORDERS 
-- from pizza_sales
-- group by datepart(hour,order_time)
-- order by datepart(hour,order_time)

SELECT 
    HOUR(order_time) AS ORDER_HOURS,
    COUNT(DISTINCT order_id) AS TOTAL_ORDERS
FROM 
    pizza_sales
GROUP BY 
    HOUR(order_time)
ORDER BY 
    ORDER_HOURS;


-- %age of sales by pizza category
select pizza_category , sum(total_price) * 100 / (select sum(total_price) from pizza_sales) as perc_Total_SALES
from pizza_sales
group by pizza_category

-- display total sales as well
select pizza_category , sum(total_price) as Total_SALES, sum(total_price) * 100 / (select sum(total_price) from pizza_sales) as perc_Total_SALES
from pizza_sales
group by pizza_category

-- for month of january only
select pizza_category , sum(total_price) as Total_SALES, sum(total_price) * 100 / 
(select sum(total_price) from pizza_sales where month(order_date) = 1) as perc_Total_SALES
from pizza_sales
where month(order_date) = 1
group by pizza_category


-- %age of sales by pizza sale
select pizza_size , sum(total_price) as TOTAL_SALES, sum(total_price) * 100 /
(select sum(total_price) from pizza_sales) as perc_Total_SALES
from pizza_sales
group by pizza_size
order by perc_Total_SALES DESC

-- see for only 2 decimal points
select pizza_size , sum(total_price) as TOTAL_SALES, CAST(sum(total_price) * 100 /
(select sum(total_price) from pizza_sales WHERE QUARTER(order_date) = 1) as decimal(10,2)) as perc_Total_SALES
from pizza_sales
-- for first quanter
-- where DATEPART(quarter,order_date)=1
WHERE QUARTER(order_date) = 1
group by pizza_size
order by perc_Total_SALES DESC

-- toal pizzas sold by pizza categoy
select pizza_category, sum(quantity) as Total_Pizzas_SOLD
 from pizza_sales
 group by pizza_category
 
 
-- top 5 best seller by total pizzas sold 
select pizza_name,sum(quantity) as Total_Pizzas_Sold
from pizza_sales
group by pizza_name
order by Total_Pizzas_Sold DESC
limit 5

