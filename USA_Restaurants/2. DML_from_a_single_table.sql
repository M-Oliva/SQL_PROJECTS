/***** DATA MANIPULATION LANGUAGE FROM A SINGLE TABLE *****/

/* Local database will be used */


/* returns customers whose id is greater than 5 */

SELECT * FROM local.customers
WHERE customer_id > 5
ORDER BY first_name;


/* returns the state where the customers live */

SELECT DISTINCT state
FROM local.customers;


/*return all the products name, unit price, new price (unit price *1.1) */

SELECT name, unit_price, (unit_price*1.1) AS new_price
FROM local.products;


/*get the orders placed in 2022 */

SELECT * FROM local.orders
WHERE order_date >= '2022-01-01' AND order_date <= '2023-01-01';


/*returns all records whose birth year is greater than 
'1980' and with a score greater than 1000 */

SELECT * FROM local.customers
WHERE (birth_date > '1980-01-01' AND points > 1000);


/*get items of order #4 where total price is greater than 100 */

SELECT * FROM local.order_items
WHERE order_id = 4 AND (quantity * unit_price) > 100;


/*returns all data whose states are California and Arizona*/

SELECT *
FROM local.customers
WHERE state IN ('CA', 'AZ');

/*returns all data whose states are not California and Arizona*/

SELECT *
FROM local.customers
WHERE state NOT IN ('CA', 'AZ');


/*return products with quanity in stock equal to 49, 38, 72*/

SELECT * FROM local.products
WHERE quantity_in_stock IN (17, 10, 6);


/*get the orders that are not shipped*/

SELECT * FROM local.orders
WHERE shipped_date IS NULL;


/* Get all the data sorted by last name first
from Z-A and then sorted by state from A-Z
limiting your search to the first 10 */

SELECT * FROM local.customers
ORDER BY last_name DESC, state ASC
LIMIT 10;


/* offset start from 2nd record */

SELECT order_id, product_id, quantity, unit_price
FROM local.order_items
LIMIT 5 OFFSET 2;


/* % any number of characters 
	_ single character*/

SELECT * FROM local.customers
WHERE last_name LIKE '_____y';


/*get customers addresses contain COURT or AVENUE OR phone numbers end with 9*/

SELECT * FROM local.customers
WHERE address ILIKE '%court%' OR address LIKE '%AVENUE%'
	OR phone LIKE '%9'
-- ILIKE is not case sensitive



/* REGULAR EXPRESSIONS */

-- We use a regular expression with the help of (~)

SELECT * FROM local.customers
WHERE phone ~ '8$';
/* in this case the symbol $ helps us to find what we are looking for
end in 8*/


SELECT * FROM local.customers
WHERE phone ~ '^7';
/* in this case the symbol $ helps us to find what we are looking for
start at 7*/


SELECT * FROM local.customers
WHERE phone ~ '^[5-7]';
/* in this case all records starting from 5 to 7 */


/* We are requesting those names that end with
the letter e, but preceded by the letter r or n */

SELECT * FROM local.customers
WHERE first_name ~ '[rn]e$';


/* We are requesting those names that contain ich or
gle */

SELECT * FROM local.customers
WHERE first_name ~ 'ich|gle';


/* We are requesting those last name that start from the 
letter M to S, have zero or more characters (.*) and end 
with se, rs or ns */

SELECT * FROM local.customers
WHERE last_name ~ '^[M-S].*(se|rs|ns)';


/*
Get the customers whose
- first names are AMELITA or TRISHA
- last names end with EY or ON
- last name start with MY or contain SE
- last name contain L followed by A or E
*/


SELECT * FROM local.customers
WHERE first_name ~* 'AMELITA|TRISHA';
/* In this case the * helps that the search is not case sensitive */


SELECT * FROM local.customers
WHERE last_name ~ '[ey|on]$';


SELECT * FROM local.customers
WHERE last_name ~* '^MY|SE';


SELECT * FROM local.customers
WHERE last_name ~* 'L[E|A]';









