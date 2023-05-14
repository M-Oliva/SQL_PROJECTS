/***** SQL aggregations *****/


/*Find the total units in the sales table.*/

SELECT SUM(units) AS total_units
FROM sales;


/*Find the product_price per unit of product_cost. 
Your solution should use both an aggregation and a 
mathematical operator.*/

SELECT SUM(product_cost)/SUM(product_price)
FROM products;

/* When did the first store open? 
You only need to return the date.*/

SELECT MIN(store_open_date) AS store_open
FROM stores;


/*Try performing the same query as in question 1 without using an aggregation function.*/

SELECT store_open_date
FROM stores
ORDER BY 1
LIMIT 1;

/*When did the most recent (latest) store open?*/

SELECT MAX(store_open_date) AS store_open
FROM stores;


/*Try to perform the result of the previous query without using an aggregation function.*/
 
SELECT store_open_date
FROM stores
ORDER BY 1 DESC
LIMIT 1;


/*Find the mean (AVERAGE) amount spent per product category. */

SELECT product_category, ROUND(AVG(product_cost), 2) AS avg_cost, 
		ROUND(AVG(product_price),2) AS avg_product
FROM products
GROUP BY 1;


/* what is the MEDIAN product_cost spent on all products?*/

SELECT * 
FROM (
	SELECT product_cost
	FROM products
	ORDER BY 1
	LIMIT ((SELECT COUNT(*) FROM products)/2)) AS tb1
ORDER BY product_cost DESC
LIMIT 2;


/*Which product (by name) placed the earliest sales? */

SELECT DISTINCT p.product_name, s.date
FROM sales AS s
	INNER JOIN products AS p USING (product_id)
WHERE s.date = (SELECT MIN(date) FROM sales);


/*Find the total number of times each products was sold. */

SELECT DISTINCT p.product_name, COUNT(s.*) AS number_of_times
FROM sales AS s
	INNER JOIN products AS p USING (product_id)
GROUP BY 1;


/*What was the store that opened first? */

SELECT store_name, store_open_date
FROM stores
ORDER BY 1
LIMIT 1;


/*What was the smallest sales placed by each product. */

SELECT p.product_name,MIN(s.units) AS small_order
FROM sales AS s
	INNER JOIN products AS p USING (product_id)
GROUP BY 1
ORDER BY 2;


/*For each product category, determine the average amount of product price */

SELECT p.product_category, ROUND(AVG(product_price),2) AS avg_amount
FROM products AS p
GROUP BY 1
ORDER BY 1;


/*Which store has the most stocks?*/

SELECT st.store_name, SUM(i.stock_on_hand) AS stock
FROM inventory AS i
	INNER JOIN stores AS st USING(store_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


/*Which store has less than 400 products in its inventory? */

SELECT st.store_name, SUM(i.stock_on_hand) AS stock
FROM inventory AS i
	INNER JOIN stores AS st USING(store_id)
GROUP BY 1
HAVING SUM(i.stock_on_hand) < 400
ORDER BY 1 DESC;


/*What product has had more than 50000 units sold?*/

SELECT p.product_name, COUNT(s.*) AS sales
FROM sales AS s
	INNER JOIN products AS p USING(product_id)
GROUP BY 1
HAVING COUNT(s.*) > 50000
ORDER BY 2 DESC;


/* Total sales in terms of dollars */

SELECT p.product_id, p.product_price, s.product_id, 
		s.units, p.product_price * s.units AS total_sales
FROM sales AS s
	INNER JOIN products AS p USING(product_id)
ORDER BY total_sales DESC
	

/*Which year did the company have the greatest sales? */

SELECT EXTRACT(YEAR FROM date) AS years, COUNT(*) AS total_orders
FROM sales
GROUP BY 1
ORDER BY 2 DESC;


/*Which month did the company have the greatest sales? */

SELECT EXTRACT(MONTH FROM date) AS months, COUNT(*) AS total_orders
FROM sales
GROUP BY 1
ORDER BY 2 DESC;


/*In which month of which year did Barrel O' Slime had the most on units?*/

SELECT p.product_name, EXTRACT(YEAR FROM date) AS año, 
		EXTRACT(MONTH FROM date) AS mes,
		SUM(units) AS total_units
FROM sales AS s
	INNER JOIN products AS p ON s.product_id = p.product_id
WHERE p.product_name ~* 'barrel'
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT 1;


/*Write a query to display for each product, the name, price, and the level of the order - ‘Large’ or ’Small’
- depending on if the price is $19.99 or more, or smaller than that.*/

SELECT product_name, product_price AS total_amount, 
		CASE 
			WHEN product_price >= 19.99 THEN 'Great'
		ELSE
			'Small'
		END AS level_of_the_order
FROM products
ORDER BY 2;


/*Write a query to display the number of units in each of three categories. 
The three categories are: 'At Least 5000', 'Between 1000 and 5000' and 'Less than 1000'.*/

SELECT sales_id, COUNT(*) AS number_of_sales,
		CASE 
			WHEN units >= 5000 THEN 'At least'
			WHEN units BETWEEN 1000 AND 5000 THEN 'Between'
		ELSE
			'Less'
		END AS categories
FROM sales
GROUP BY 1;


/*We would now like to perform a similar calculation to the first, 
but we want to obtain the total units only in 2016 and 2017. */

SELECT st.store_name, SUM(units) AS total_sales,
		CASE
			WHEN SUM(units) > 15000 THEN 'Top Level'
			WHEN SUM(units) BETWEEN 10000 AND 15000 THEN 'Second Level'
		ELSE
			'Lowest Level'
		END AS level_of_stores
FROM sales AS s
	INNER JOIN stores AS st USING (store_id)
WHERE EXTRACT(YEAR FROM date) IN (2016, 2017)
GROUP BY 1
ORDER BY 2 DESC;

















