/* Sub queries and temporary tables */

/*find the average number of events for each channel. Average per day*/

SELECT channel, ROUND(AVG(events_number), 2) AS average_events
FROM (
	SELECT DATE_TRUNC('DAY', ocurred_at), channel, COUNT(*) AS events_number 
	FROM web_events
	GROUP BY 1, 2
	ORDER BY 3 DESC
) AS tbavg
GROUP BY channel;


/*list of orders happended at the first month in P&P history , ordered by occurred_at */

SELECT *
FROM orders
WHERE DATE_TRUNC ('MONTH', ocurred_at) = (
	SELECT DATE_TRUNC ('MONTH', ocurred_at)
	FROM orders
	ORDER BY 1
	LIMIT 1)
ORDER BY 3;


/*list of orders happended at the first day in P&P history , ordered by occurred_at */

SELECT *
FROM orders
WHERE DATE_TRUNC('DAY', ocurred_at) = (
	SELECT DATE_TRUNC('DAY', ocurred_at)
	FROM orders
	ORDER BY 1
	LIMIT 1)
ORDER BY 3;


/*average of paper quantity happended at the first month in P&P history*/

SELECT ROUND(AVG(standard_qty),2) AS avg_standard_quantity,
		ROUND(AVG(gloss_qty),2) AS avg_gloss_quantity,
		ROUND(AVG(poster_qty),2) AS avg_poster_quantity
FROM orders
WHERE DATE_TRUNC('MONTH', ocurred_at) = (
	SELECT DATE_TRUNC('MONTH', ocurred_at)
	FROM orders
	ORDER BY 1
	LIMIT 1);

		
/*account id,name and its most frequenet used channel*/

SELECT t3.account_id, t3.name, t3.channel, t3.usage
FROM (
	SELECT account_id, a.name, channel, COUNT(*) AS usage
	FROM web_events AS w
		INNER JOIN accounts AS a ON w.account_id = a.id
	GROUP BY 1, 2, 3
	ORDER BY 1) AS t3
INNER JOIN (SELECT t1.account_id, t1.name, MAX(usage) AS max_usage
		   	FROM(
				SELECT account_id, a.name, channel, COUNT(*) AS usage
				FROM web_events AS w
					INNER JOIN accounts AS a ON w.account_id = a.id
				GROUP BY 1, 2, 3
				ORDER BY 1) AS t1
			GROUP BY 1, 2
			ORDER BY 2
		   ) AS t2
	ON t3.account_id = t2.account_id
WHERE t3.usage = t2.max_usage	
ORDER BY 2;
	
	
/******************************************************************************/

/*sales rep total sales for each region*/

SELECT r.name AS region, s.name AS sales_rep, 
		SUM(total_amt_usd) AS total_sales
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id
GROUP BY 1, 2
ORDER BY 3 DESC;


/*maximum total sales in each region*/

SELECT tmaximum.region, MAX(tmaximum.total_sales) AS maximum_total_Sales
FROM (
		SELECT r.id AS id, r.name AS region, s.name AS sales_rep, 
				SUM(total_amt_usd) AS total_sales
		FROM orders AS o
			INNER JOIN accounts AS a ON o.account_id = a.id
			INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
			INNER JOIN region AS r ON s.region_id = r.id
		GROUP BY 1, 2, 3
		ORDER BY 3 DESC) AS tmaximum
GROUP BY 1
ORDER BY 2 DESC;
		
		
		
/*** Final ***/
/*1) Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.*/

SELECT t3.id, t3.region, t3.sales_rep, t3.total_sales
FROM (
		SELECT r.id AS id, r.name AS region, s.name AS sales_rep, 
				SUM(total_amt_usd) AS total_sales
		FROM orders AS o
			INNER JOIN accounts AS a ON o.account_id = a.id
			INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
			INNER JOIN region AS r ON s.region_id = r.id
		GROUP BY 1, 2, 3
		ORDER BY 3 DESC) AS t3
INNER JOIN ( 
		SELECT t1.id, t1.region, MAX(t1.total_sales) AS maximum
		FROM (
			SELECT r.id AS id, r.name AS region, s.name AS sales_rep, 
					SUM(total_amt_usd) AS total_sales
			FROM orders AS o
				INNER JOIN accounts AS a ON o.account_id = a.id
				INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
				INNER JOIN region AS r ON s.region_id = r.id
			GROUP BY 1, 2, 3
			ORDER BY 3 DESC
			) AS t1
		GROUP BY 1, 2
		ORDER BY 3 DESC
) AS t2
ON t3.id = t2.id
WHERE t3.total_sales = t2.maximum
ORDER BY 4 DESC;


/****************************************/
/*total numbers of orders per region */

SELECT r.name AS region, COUNT(*) AS total_orders
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id
GROUP BY 1;


/*** Final ***/
/*2) For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?*/

SELECT tmaximum.region, SUM(tmaximum.orders), MAX(tmaximum.total_sales) AS maximum_total_sales 
FROM (
		SELECT r.id AS id, r.name AS region, s.name AS sales_rep, 
				SUM(total_amt_usd) AS total_sales,
				COUNT(*) AS orders
		FROM orders AS o
			INNER JOIN accounts AS a ON o.account_id = a.id
			INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
			INNER JOIN region AS r ON s.region_id = r.id
		GROUP BY 1, 2, 3
		ORDER BY 3 DESC) AS tmaximum
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1;

/******************************************************/

/* account with largest standard paper orders */

SELECT a.name, SUM(standard_qty) AS standard_orders
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
WHERE standard_qty > 0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

	
/*********************************************/
/*For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
how many web_events did they have for each channel?*/

SELECT a.name, channel, COUNT(*) AS web_events_channel
FROM web_events AS w
	INNER JOIN accounts AS a ON w.account_id = a.id
WHERE account_id =(SELECT id FROM(
									SELECT a.id, a.name, SUM(total_amt_usd) AS customer_spent
									FROM orders AS o
										INNER JOIN accounts AS a ON o.account_id = a.id
									GROUP BY 1, 2
									ORDER BY 2 DESC
									LIMIT 1) AS tb1)
GROUP BY 1, 2 
ORDER BY 2;


/*What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?*/

SELECT a.name AS accounts, ROUND(AVG(total_amt_usd),2) AS average_amount
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
GROUP BY 1
ORDER BY 2
LIMIT 10;

/**********************************************/

/**** CTE Common Table Expressions ****/

/*find the average number of events for each channel per day.*/

WITH events AS (
	SELECT DATE_TRUNC('day', ocurred_at) AS day,
		channel, COUNT(*) AS events
	FROM web_events 
	GROUP BY 1, 2)
 
SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;




