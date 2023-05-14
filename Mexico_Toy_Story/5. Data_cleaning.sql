/***** DATA CLEANING *****/

/*1) In the stores table, there is a column holding the name for each store.
The last digit specify what type of store is. */

SELECT RIGHT(store_name, 1) AS name_number, COUNT(*)
FROM stores
GROUP BY 1
ORDER BY 2 DESC;


/*2) There is much debate about how much the name (or even the first letter of a product name) matters. 
Use the products table to pull the first letter of each product name to see 
the distribution of products names that begin with each letter (or number).*/

SELECT LEFT(product_name, 1) AS first_letter, COUNT(*)
FROM products
GROUP BY 1
ORDER BY 2 DESC;


/*3) Consider vowels as a, e, i, o, and u. 
What proportion of city names start with a vowel, and what percent start with anything else?*/

SELECT ROUND(SUM(vocal)*100/SUM(conteo),1) AS vowel, 
		ROUND(SUM(consonante)*100/SUM(conteo),1) AS consonant
FROM (	
	SELECT product_name, COUNT(*) AS conteo,
			CASE
				WHEN LEFT(LOWER(product_name), 1) IN ('a','e','i','o','u') THEN 1
				ELSE 0
			END AS vocal,
			CASE
				WHEN LEFT(LOWER(product_name), 1) NOT IN ('a','e','i','o','u') THEN 1
				ELSE 0
			END AS consonante
	FROM products
	GROUP BY 1) AS tb1;


/****** POSITION & STRPOS *************/

/*1)Use the stores table to create first and last name columns that hold the first and last names for the store name.*/

SELECT store_name,
		LEFT(store_name, STRPOS(store_name, ' ') - 1) AS first_name,
		RIGHT(store_name, LENGTH(store_name) - STRPOS(store_name, ' ')) AS last_name
FROM stores;

-- o tambien

SELECT store_name, SPLIT_PART(store_name,' ',1) AS first_name, 
		SPLIT_PART(store_name,' ',2) AS last_name 
FROM stores;


/* CONCATE */

/*Each store in the stores table wants to create an email address for each store city. */
SELECT store_name, store_city,
		CONCAT(
			SPLIT_PART(LOWER(store_name), ' ', 2),'.',
			SPLIT_PART(LOWER(store_city), ' ', 1),'@', 
			REPLACE(LOWER(store_name), ' ', ''),'.com') AS company_email
FROM stores;




















