
SELECT * FROM city;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

--Report Analysis

--Q1: Coffee Consumers Count
--How many people in each city are estimated to consume coffee, given that 25% of the population does?

SELECT city_name, (population * 0.25) as coffee_consuming_population
FROM city;

--Q2:Total Revenue from Coffee related Sales
--What is the total revenue generated from coffee related sales across all cities in the last quarter of 2023?

WITH annual_sales AS
	( SELECT *, EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(quarter FROM sale_date) as quarter
	FROM sales s JOIN products p
	ON s.product_id = p.product_id
	)
	
SELECT SUM(total) as total_revenue_coffee
FROM annual_sales
WHERE product_name LIKE '%Coffee%' AND year = 2023 AND quarter = 4;

--3. Sales Count for Each Product
--How many units of each coffee product have been sold?

SELECT s.product_id, p.product_name,
COUNT(s.sale_id) as unit_product_sold
FROM sales s LEFT JOIN products p 
ON s.product_id = p.product_id
GROUP BY s.product_id , p.product_name
ORDER BY unit_product_sold DESC


/*Overall, most demanded top 5 iteams are:
1.Cold Brew Coffee Pack (6 Bottles)"
2. Ground Espresso Coffee (250g)"
3. Instant Coffee Powder (100g)"
4. Coffee Beans (500g)"
5. Tote Bag with Coffee Design*/

--4. Average Sales Amount per City
--What is the average sales amount per customer in each city?
WITH citywise_sales AS (SELECT c.customer_id,s.sale_id, c.city_id, ci.city_name, s.total
FROM sales s LEFT JOIN customers c ON s.customer_id = c.customer_id
LEFT JOIN city ci ON c.city_id = ci.city_id)

SELECT city_name, ROUND(SUM(total)::numeric/COUNT(customer_id),2) as average_sales_amount_per_customer
FROM citywise_sales
GROUP BY city_id, city_name
ORDER BY average_sales_amount_per_customer DESC



