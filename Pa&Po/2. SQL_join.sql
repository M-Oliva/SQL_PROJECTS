/* SQL JOIN */

/*Try pulling all the data from the accounts table, and all 
the data from the orders table.*/

SELECT a.*, o.*
FROM accounts AS a
	INNER JOIN orders AS o ON a.id = o.account_id;
	
	
/*Try pulling standard_qty, gloss_qty, and poster_qty from the
orders table, and the website and the primary_poc from the 
accounts table.*/

SELECT standard_qty, gloss_qty, poster_qty, website, primary_poc
FROM orders AS o
	INNER JOIN accounts AS a ON a.id = o.account_id;
	

/*Provide a table for all web_events associated with account 
name of Walmart. There should be three columns. Be sure to 
include the primary_poc, time of the event, and the channel 
for each event. Additionally, you might choose to add a 
fourth column to assure only Walmart events were chosen.*/

SELECT a.primary_poc, w.ocurred_at, w.channel, a.name
FROM web_events AS w
	INNER JOIN accounts AS a ON w.account_id = a.id
WHERE name ~* 'Walmart';


/*Provide a table that provides the region for each sales_rep
along with their associated accounts. Your final table should
include three columns: the region name, the sales rep name, 
and the account name. Sort the accounts alphabetically (A-Z)
according to account name.*/


SELECT r.name AS region, s.name AS sales, a.name AS account
FROM accounts AS a
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id
ORDER BY a.name;

/*Provide the name for each region for every order, as well 
as the account name and the unit price they paid 
(total_amt_usd/total) for the order. Your final table should 
have 3 columns: region name, account name, and unit price.*/

SELECT r.name AS region, a.name AS account, 
		(o.total_amt_usd/o.total) AS unit_price
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id;

/*Provide a table that provides the region for each sales_rep 
along with their associated accounts. This time only for the 
Midwest region. Your final table should include three columns:
the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account 
name.*/

SELECT r.name AS region, s.name AS sales, a.name AS account
FROM accounts AS a
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id
WHERE r.name ~* 'Midwest'
ORDER BY a.name;


/*Provide a table that provides the region for each sales_rep 
along with their associated accounts. This time only for 
accounts where the sales rep has a first name starting with 
S and in the Midwest region.*/

SELECT r.name AS region, s.name AS sales, a.name AS account
FROM accounts AS a
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id
WHERE r.name ~* 'Midwest' AND s.name ~* '^s'
ORDER BY a.name;

/*Provide a table that provides the region for each sales_rep 
along with their associated accounts. This time only for 
accounts where the sales rep has a last name starting with 
K and in the Midwest region. */

SELECT r.name AS region, s.name AS sales, a.name AS account
FROM accounts AS a
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id
WHERE r.name ~* 'Midwest' AND s.name ~* '.* k' 
ORDER BY a.name;

/*Provide the name for each region for every order, as well
as the account name and the unit price they paid 
(total_amt_usd/total) for the order. However, you should only 
provide the results if the standard order quantity exceeds 
100. */
SELECT r.name AS region, a.name AS account, 
		(o.total_amt_usd/(o.total+0.01)) AS unit_price
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id
WHERE standard_qty > 100;

/*Provide the name for each region for every order, as well
as the account name and the unit price they paid 
(total_amt_usd/total) for the order. However, you should only
provide the results if the standard order quantity exceeds 100 
and the poster order quantity exceeds 50. */

SELECT r.name AS region, a.name AS account, 
		(o.total_amt_usd/(o.total+0.01)) AS unit_price
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
	INNER JOIN sales_reps AS s ON a.sales_rep_id = s.id
	INNER JOIN region AS r ON s.region_id = r.id
WHERE standard_qty > 100
	AND poster_qty > 50;


/*What are the different channels used by account id 1001? */

SELECT DISTINCT w.channel AS chanel, a.name AS account
FROM web_events AS w
	INNER JOIN accounts AS a ON w.account_id = a.id
WHERE a.id = 1001;

/*Find all the orders that occurred in 2015. */

SELECT a.name AS account, o.ocurred_at, o.total, 
		o.total_amt_usd
FROM orders AS o
	INNER JOIN accounts AS a ON o.account_id = a.id
WHERE ocurred_at BETWEEN '2015-01-01' AND '2015-12-31'
ORDER BY ocurred_at DESC;





