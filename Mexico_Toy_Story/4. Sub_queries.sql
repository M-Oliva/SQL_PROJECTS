/***** SUB QUERIES *****/


/*find the average number of sales for each product. Average per day*/

SELECT product_name, ROUND(AVG(sales), 2) AS average_sales
FROM (
	SELECT DATE_TRUNC('DAY', date), product_name, COUNT(*) AS sales 
	FROM sales
		INNER JOIN products AS p USING (product_id)
	GROUP BY 1, 2
	ORDER BY 3 DESC
) AS tbavg
GROUP BY 1;


/*list of products sold on the first month, ordered by date */

SELECT *
FROM sales
WHERE DATE_TRUNC('MONTH', date) = (
	SELECT DATE_TRUNC('MONTH', date)
	FROM sales
	ORDER BY 1
	LIMIT 1)
ORDER BY 2;


/*list of products sold on the first day, ordered by date */

SELECT *
FROM sales
WHERE DATE_TRUNC('DAY', date) = (
	SELECT DATE_TRUNC('DAY', date)
	FROM sales
	ORDER BY 1
	LIMIT 1)
ORDER BY 2;

		
/*store id, name and its most frequenet product */

SELECT t3.store_id, t3.store_name, t3.product_name, t3.usage
FROM (
	SELECT st.store_id, st.store_name, product_name, COUNT(*) AS usage
	FROM sales AS s
		INNER JOIN stores AS st USING (store_id)
		INNER JOIN products AS p USING (product_id)
	GROUP BY 1, 2, 3
	ORDER BY 1) AS t3
INNER JOIN (SELECT t1.store_id, t1.store_name, MAX(usage) AS max_usage
		   	FROM(
				SELECT st.store_id, st.store_name, product_name, COUNT(*) AS usage
				FROM sales AS s
					INNER JOIN stores AS st USING (store_id)
					INNER JOIN products AS p USING (product_id)
				GROUP BY 1, 2, 3
				ORDER BY 1) AS t1
			GROUP BY 1, 2
			ORDER BY 2
		   ) AS t2
	ON t3.store_id = t2.store_id
WHERE t3.usage = t2.max_usage	
ORDER BY 2;
	

/******************************************************************************/

/*inventory for each city*/

SELECT st.store_name, st.store_city, 
		SUM(stock_on_hand) AS total_inventory
FROM inventory AS i
	INNER JOIN stores AS st USING (store_id)
GROUP BY 1, 2
ORDER BY 3 DESC;


/*maximum total inventory in each city*/

SELECT t1.store_city, MAX(t1.total_inventory) AS maximum_inventory
FROM (
		SELECT st.store_name, st.store_city, 
				SUM(stock_on_hand) AS total_inventory
		FROM inventory AS i
			INNER JOIN stores AS st USING (store_id)
		GROUP BY 1, 2
		ORDER BY 3 DESC
) AS t1
GROUP BY 1
ORDER BY 2 DESC;


/**********************************************/

/**** CTE Common Table Expressions ****/

/*find the average number of events for each channel per day.*/

WITH events AS (
	SELECT DATE_TRUNC('day', date) AS day,
		product_id, COUNT(*) AS conteo
	FROM sales 
	GROUP BY 1, 2)
 
SELECT product_id, AVG(conteo) AS average_events
FROM events
GROUP BY 1
ORDER BY 2 DESC;































