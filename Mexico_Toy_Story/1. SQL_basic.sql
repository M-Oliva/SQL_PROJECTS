/***** SQL BASIC *****/


/*Try writing your own query to select only the id, store name, 
and store_open_date columns for all stores. */

SELECT store_id, store_name, store_open_date
FROM stores;


/*Try using LIMIT yourself below by writing a query that displays 
all the data of the most expensive products. */

SELECT product_id, product_name, product_price
FROM products
ORDER BY 3 DESC
LIMIT 5;


/*Use the stores table to find all information about the stores that 
are in Mexicali or Toluca.*/

SELECT * FROM stores
WHERE store_city IN ('Mexicali','Toluca');


/*the lowest 10 orders in terms of units */

SELECT store_id, product_id, units
FROM sales
ORDER BY 3
LIMIT 10;


/*Write a query that displays the store ID, product ID, and total 
units for all the sales, sorted first by the store ID (in ascending 
order), and then by the units (in descending order).*/

SELECT store_id, product_id, units
FROM sales
ORDER BY 1 ASC, 3 DESC;


/*displays store ID, product ID, and total units for all the sales, 
but this time sorted first by unit (in descending order), and then 
by store ID (in ascending order).*/

SELECT store_id, product_id, units
FROM sales
ORDER BY 3 DESC, 1 ASC;

/*Compare the results of these two queries above. How are the results 
different when you switch the column you sort on first*/

/*In query #1, all of the sales for each store ID are grouped together, 
and then within each of those groupings, the orders appear from the 
greatest units to the least.

In query #2, since you sorted by the units first, the orders appear from 
greatest to least regardless of which stores ID they were from. Then they
are sorted by store ID next. */


/*Pulls the first 5 rows and all columns from the products table that 
have a product_cost greater than or equal to 14.99.*/

SELECT *
FROM products
WHERE product_cost >= 14.99
ORDER BY 4 DESC
LIMIT 5;


/*Filter the stores table to include the store name, city, and 
location just for the hermosillo city.*/

SELECT store_name, store_city, store_location
FROM stores
WHERE store_name ~*'hermosillo';


/* Create a column that finds the profit for each product.*/

SELECT product_name, product_category,
	product_price - product_cost AS profit
FROM products;


/* All the products whose names start with 'D' */

SELECT * FROM products
WHERE product_name ~* '^D';


/* All city whose names contain the string 'ala' 
somewhere in the name */

SELECT * FROM stores	
WHERE store_city ~* 'ala';

SELECT * FROM stores	
WHERE store_city ILIKE '%ala%';


/*All products whose names end with 's'.*/

SELECT * FROM products	
WHERE product_name ~* 's$';

SELECT * FROM products	
WHERE product_name LIKE '%s';


/*Use the stores table to find the store name, 
city, and location for residential and commercial */

SELECT store_name, store_city, store_location
FROM stores
WHERE store_location IN ('Residential', 'Commercial');


/*Use the accounts table to find the account name, 
primary poc, and sales rep id for all stores except commercial.*/

SELECT store_name, store_city, store_location
FROM stores
WHERE store_location NOT IN ('Commercial');


/*all the products where the price is over $19.99,
and cost less than $25.99.*/

SELECT * FROM products
WHERE product_price > 19.99 
	AND product_cost < 25.99;


/*Using the stores table, find all the stores whose 
names do not start with 'C' and end with '2'.*/

SELECT * FROM stores
WHERE store_name NOT LIKE 'C%'
		AND store_name LIKE '%2';


/*When you use the BETWEEN operator in SQL, do the results 
include the values of your endpoints, or not? Figure out
the answer to this important question by writing a query 
that displays the store_id and product_id for all sales 
where units sold is between 15 and 20. Then look at your 
output to see if the BETWEEN operator included the begin 
and end values or not.*/

SELECT store_id, product_id, units FROM sales
WHERE units BETWEEN 15 AND 20
ORDER BY 3;

-- takes them into account, therefore it is a closed interval


/*Use the stores table to find all information regarding stores 
that are in Guanajuato city, and started their account at any point 
in 2016, sorted from newest to oldest.*/

SELECT * FROM stores
WHERE store_city IN ('Guanajuato')
	AND store_open_date BETWEEN '2016-01-01' AND '2016-12-31'
ORDER BY store_open_date DESC;


/*Find list of products where either product_cost or 
product_price is greater than 30.99. */

SELECT product_name FROM products
WHERE product_cost > 30.99 OR product_price > 30.99;


/*Write a query that returns a list of products where the 
product cateogry is toy and either product_cost or 
product_price is greater than 30.99.*/

SELECT * FROM products
WHERE product_category ~* 'toys'
	AND (product_cost > 30.99 OR product_price > 30.99);


/*Find all the company names that start with a 'C' or 'M', 
and contains 'mex' or 'Mex', but it 
doesn't contain 'chet'.*/

SELECT DISTINCT store_city FROM stores
WHERE store_city ~* '^[C|M]'
	AND store_city ~* 'mex'
	AND store_city NOT LIKE '%chet%';













