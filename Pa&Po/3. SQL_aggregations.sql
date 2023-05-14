/* Agregaciones SQL */

/*Find the total amount of poster_qty paper ordered in the 
orders table.*/

SELECT SUM(poster_qty)
FROM orders;


/*Find the total amount of standard_qty paper ordered in the
orders table.*/

SELECT SUM(standard_qty)
FROM orders;

/*Find the total dollar amount of sales using the 
total_amt_usd in the orders table.*/

SELECT SUM(total_amt_usd)
FROM orders;

/*Find the total amount spent on standard_amt_usd and 
gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the table.*/

SELECT standard_amt_usd + gloss_amt_usd AS total_amount
FROM orders;

/*Find the standard_amt_usd per unit of standard_qty paper. 
Your solution should use both an aggregation and a 
mathematical operator.*/

SELECT SUM(standard_amt_usd)/SUM(standard_qty)
FROM orders;

/*When was the earliest order ever placed? 
You only need to return the date.*/

SELECT MIN(ocurred_at)
FROM orders;
----------------------------------------------------

/*Try performing the same query as in question 1 without using an aggregation function.*/

SELECT ocurred_at
FROM orders
ORDER BY ocurred_at
LIMIT 1;

/*When did the most recent (latest) web_event occur?*/

SELECT MAX(ocurred_at)
FROM web_events;

/*Try to perform the result of the previous query without using an aggregation function.*/

SELECT ocurred_at
FROM web_events
ORDER BY ocurred_at DESC
LIMIT 1;


/*Find the mean (AVERAGE) amount spent per order on each paper type, as well as 
the mean amount of each paper type purchased per order. */

SELECT AVG(standard_qty), AVG(gloss_qty), AVG(poster_qty),
		AVG(standard_amt_usd), AVG(gloss_amt_usd), AVG(poster_amt_usd)
FROM orders;


/* what is the MEDIAN total_usd spent on all orders?*/

SELECT * 
FROM (
	SELECT total_amt_usd
	FROM orders
	ORDER BY total_amt_usd
	LIMIT ((SELECT COUNT(*) FROM orders)/2)) AS tb1
ORDER BY total_amt_usd DESC
LIMIT 2;


/*Which account (by name) placed the earliest order? */

SELECT a.name, o.ocurred_at
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
WHERE o.ocurred_at = (SELECT MIN(ocurred_at) FROM orders);


/*Via what channel did the most recent (latest) web_event occur, 
which account was associated with this web_event? */

SELECT a.name, w.channel, w.ocurred_at
FROM web_events AS w
	INNER JOIN accounts AS a ON w.account_id = a.id
WHERE w.ocurred_at = (SELECT MAX(ocurred_at) FROM web_events);


/*Find the total number of times each type of channel from the web_events was used. */

SELECT channel, COUNT(*) AS number_of_time
FROM web_events
GROUP BY channel;


/*Who was the Sales Rep associated with the earliest web_event?*/

SELECT s.name AS sales_rep_associated, w.ocurred_at
FROM web_events AS w
	INNER JOIN accounts AS a ON w.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
ORDER BY 2
LIMIT 1;


/*Who was the primary contact associated with the earliest web_event?*/

SELECT a.primary_poc AS sales_rep_associated, w.ocurred_at
FROM web_events AS w
	INNER JOIN accounts AS a ON w.account_id = a.id
ORDER BY 2
LIMIT 1;


/*What was the smallest order placed by each account in terms of total usd. 
Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.*/

SELECT a.name,MIN(o.total) AS small_order
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
GROUP BY a.name
ORDER BY 2;


/*Find the number of sales reps in each region. 
Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.*/

SELECT r.name, COUNT(s.id) AS number_of_sales_reps
FROM sales_reps AS s
	INNER JOIN region AS r ON s.region_id = r.id
GROUP BY r.name
ORDER BY 2;


/*For each account, determine the average amount of each type of paper they purchased across their orders */

SELECT a.name, AVG(standard_qty) AS standard, AVG(gloss_qty) AS gloss,
		AVG(poster_qty) AS poster
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
GROUP BY a.id
ORDER BY 1;

/*Determine the number of times a particular channel was used in the web_events table for each sales rep. 
Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/

SELECT s.name, channel, COUNT(*) AS number_of_times
FROM web_events AS w
	INNER JOIN accounts AS a ON w.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
GROUP BY s.id, channel
ORDER BY 3 DESC;


/*Determine the number of times a particular channel was used in the web_events table for each region. */

SELECT r.name, channel, COUNT(*) AS number_of_times
FROM web_events AS w
	INNER JOIN accounts AS a ON w.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id
GROUP BY r.name, channel
ORDER BY 3 DESC;


/*Have any sales reps worked on more than one account?*/

SELECT DISTINCT s.name, COUNT(a.name)
FROM sales_reps AS s
	INNER JOIN accounts AS a ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY 1;

-- Si, usualmente suelen trabajar en varias cuentas 


/*How many of the sales reps have more than 5 accounts that they manage?*/

SELECT COUNT(*)
FROM (SELECT DISTINCT s.name, COUNT(a.name) AS accounts_for_sales_reps
		FROM sales_reps AS s
			INNER JOIN accounts AS a ON s.id = a.sales_rep_id
		GROUP BY 1
		HAVING COUNT(a.name) > 5
		ORDER BY 1) AS tb1;


/*How many accounts have more than 20 orders?*/

SELECT COUNT(*) AS how_many_accounts
FROM (
	SELECT a.name, COUNT(o.*) AS conteoo
	FROM orders AS o
		INNER JOIN accounts AS a ON o.account_id = a.id
	GROUP BY 1
	HAVING COUNT(o.*) > 20
	ORDER BY 2) AS tb2;


/*Which account has the most orders?*/

SELECT a.name, COUNT(o.*) AS conteoo
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


/*Which accounts spent more than 30,000 usd total across all orders?*/

SELECT a.name, SUM(o.total_amt_usd) AS total
FROM accounts AS a
	INNER JOIN orders AS o ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY a.name;


/*Which accounts spent less than 1,000 usd total across all orders?*/

SELECT a.name, SUM(o.total_amt_usd) AS total
FROM accounts AS a
	INNER JOIN orders AS o ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY a.name;


/*Which accounts used facebook as a channel to contact customers more than 6 times?*/

SELECT a.name, COUNT(w.channel) AS facebook_channel
FROM accounts AS a
	INNER JOIN web_events AS w ON a.id = w.account_id
WHERE w.channel ILIKE 'FACEBOOK'
GROUP BY 1
HAVING COUNT(w.channel) > 6
ORDER BY 2 DESC;


/*Which channel was most frequently used by most accounts?*/

SELECT channel, COUNT(*) AS count_of_channel
FROM web_events
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


/*Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
Do you notice any trends in the yearly sales totals?*/

SELECT EXTRACT(YEAR FROM ocurred_at) AS years, 
		SUM(total_amt_usd) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


/*Which month did Parch & Posey have the greatest sales in terms of total dollars? 
Are all months evenly represented by the dataset?*/

SELECT EXTRACT(MONTH FROM ocurred_at) AS months, 
		SUM(total_amt_usd) AS total_orders
FROM orders
WHERE DATE_PART('year', ocurred_at) NOT IN (2013, 2017)
GROUP BY 1
ORDER BY 2 DESC;

/* Las mayores ventas son en diciembre, adicional, los meses de septiembre, octubre y 
noviembre tienen grandes ventas, quiere decir que la temporada de mayor venta de papel 
es a fin de año */


/*Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all years evenly represented by the dataset?*/

SELECT EXTRACT(YEAR FROM ocurred_at) AS years, 
		COUNT(*) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/* El año que tiene el numero mas alto de ordenes es 2016 con un total de 3757, más del 
doble de ordenes que el año anterior, teniendo un incremento del 54,1%. Por otra parte,
no se puede considerar que todos los años son representados por el dataset, porque 
realizando un analisis de mes a mes, se halla que para el 2013 solo tiene en cuenta el 
mes de diciembre, y para el 2017 el mes de enero, asi que realmente no es viable tener
en cuenta estos años. Adicional a esto, es notorio que las cantidades ordenadas en 2013 
son mayores que el 2017, teniendo en cuenta que solo tienen un mes para analizar, es 
posible justificarlo porque el mes de diciembre (para el año 2013), se considera 
temporada en lo que respecta a la venta de papel */


/*Which month did Parch & Posey have the greatest sales in terms of total number of 
orders? */

SELECT EXTRACT(MONTH FROM ocurred_at) AS months, COUNT(*) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


/*In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/
-- Account, año, mes, gloss_amt_usd

SELECT a.name AS account, EXTRACT(YEAR FROM ocurred_at) AS año, 
		EXTRACT(MONTH FROM ocurred_at) AS mes,
		SUM(gloss_amt_usd) AS gloss_paper_spend
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
WHERE a.name ~* 'WALMART'
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT 1;


/*Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’
- depending on if the order is $3000 or more, or smaller than $3000.*/

SELECT account_id, total_amt_usd AS total_amount, 
		CASE 
			WHEN total_amt_usd >= 3000 THEN 'Large'
		ELSE
			'Small'
		END AS level_of_the_order
FROM orders;


/*Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.*/

SELECT COUNT(*) AS number_of_orders, total,
		CASE 
			WHEN total >= 2000 THEN 'At least'
			WHEN total BETWEEN 1000 AND 2000 THEN 'Between'
		ELSE
			'Less'
		END AS categories
FROM orders
GROUP BY total;


/*We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
The second level is between 200,000 and 100,000 usd. 
The lowest level is anyone under 100,000 usd. 
Provide a table that includes the level associated with each account */

SELECT a.name, SUM(total_amt_usd) AS total_sales,
		CASE
			WHEN SUM(total_amt_usd) > 200000 THEN 'Top Level'
			WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Second Level'
		ELSE
			'Lowest Level'
		END AS level_of_customers
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
GROUP BY a.name
ORDER BY 2 DESC;


/*We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only in 2016 and 2017. 
Keep the same levels as in the previous question. Order with the top spending customers listed first.*/

SELECT a.name, SUM(total_amt_usd) AS total_sales,
		CASE
			WHEN SUM(total_amt_usd) > 200000 THEN 'Top Level'
			WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Second Level'
		ELSE
			'Lowest Level'
		END AS level_of_customers
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
WHERE EXTRACT(YEAR FROM ocurred_at) IN (2016, 2017)
GROUP BY a.name
ORDER BY 2 DESC;


/*We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, 
and a column with top or not depending on if they have more than 200 orders. */

SELECT s.name, COUNT(*) AS total_orders,
		CASE
			WHEN COUNT(*) > 200 THEN 'Top'
			ELSE 'Normal'
		END AS performing_sales_reps
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 2 DESC;


/*The previous didn't account for the middle, nor the dollar amount associated with the sales. 
Management decides they want to see these characteristics represented as well. 

We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders 
or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. 

Create a table with the sales rep name, the total number of orders, total sales across all orders, 
and a column with top, middle, or low depending on this criteria. 

Place the top sales people based on dollar amount of sales first in your final table. 
You might see a few upset sales people by this criteria!*/

SELECT s.name, COUNT(*) AS total_orders, SUM(total_amt_usd) AS total_spend,
		CASE
			WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 750000 THEN 'Top'
			WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 500000 THEN 'Middle'
			ELSE 'Low'
		END AS performing_sales_reps
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 4 DESC;

