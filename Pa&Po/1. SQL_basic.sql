/* SQL basico */

/* Intenta escribir tu propia consulta para devolver solo
las columnas de id, ocurred_at y account_id para todas 
las ordenes en la tabla orders */

SELECT id, ocurred_at, account_id  
FROM orders;

/* Escriba una consulta que muestre todos los datos en las
columnas occurred_at, account_id y channel de la tabla
web_events y limite los registros a los primeros 15 */

SELECT ocurred_at, account_id, channel
FROM web_events
LIMIT 15;

/* Devuelva los 10 primeros pedidos en la tabla orders */

SELECT id, ocurred_at, total_amt_usd
FROM orders
ORDER BY ocurred_at
LIMIT 10;

/* Use la tabla web_events para encontrar toda la info sobre
las personas que fueron contactadas a traves de organic o
adwords */

SELECT w.id, w.account_id, w.ocurred_at, w.channel, a.name
FROM web_events AS w
	INNER JOIN accounts AS a ON w.account_id = a.id
WHERE channel IN ('organic', 'adwords');

/* Top 5 pedidos en terminos del total_amt_usd */

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;


/* Las menores 20 ordenes en terminos del menor total_amt_usd */

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd 
LIMIT 20;


/* Escriba una consulta que muestre el id, account_id y el
monto total en dolares de todos los pedidos, ordenados primero
por el account_id en forma ascendente y luego por el total en 
forma descendente */

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

/*Pulls the first 5 rows and all columns from the orders 
table that have a dollar amount of gloss_amt_usd greater 
than or equal to 1000.*/

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

/*Filter the accounts table to include the company name, 
website, and the primary point of contact (primary_poc) 
just for the Exxon Mobil company in the accounts table.*/

SELECT name, website, primary_poc
FROM accounts
WHERE name ~*'EXXON';

/*Create a column that divides the standard_amt_usd by 
the standard_qty to find the unit price for standard 
paper for each order. Limit the results to the first 
10 orders, and include the id and account_id fields.*/

SELECT id, account_id,
	ROUND(standard_amt_usd/standard_qty,2) AS unit_price
FROM orders
LIMIT 10;


/*finds the percentage of revenue that comes from poster 
paper for each order. You will need to use only the columns 
that end with _usd. (Try to do this without using the total 
column.) Display the id and account_id fields also.*/


SELECT id, account_id,
	poster_amt_usd/(standard_amt_usd + gloss_amt_usd +poster_amt_usd) AS post_per
FROM orders
LIMIT 10;


/* All the companies whose names start with 'C' */

SELECT * FROM accounts	
WHERE name ~* '^C';

/* All companies whose names contain the string 'one' 
somewhere in the name */

SELECT * FROM accounts	
WHERE name ~* 'one';

SELECT * FROM accounts	
WHERE name LIKE '%one%';

/*All companies whose names end with 's'.*/

SELECT * FROM accounts	
WHERE name ~* 's$';

SELECT * FROM accounts	
WHERE name LIKE '%s';

/*Use the accounts table to find the account name, 
primary_poc, and sales_rep_id for Walmart, Target, and 
Nordstrom.*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');


/*Use the accounts table to find the account name, 
primary poc, and sales rep id for all stores except Walmart, 
Target, and Nordstrom.*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

/*all the orders where the standard_qty is over 1000, the 
poster_qty is 0, and the gloss_qty is 0.*/

SELECT * FROM orders
WHERE standard_qty > 1000 
	AND poster_qty = 0 
	AND gloss_qty = 0;

/*Using the accounts table, find all the companies whose 
names do not start with 'C' and end with 's'.*/

SELECT * FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';


/*When you use the BETWEEN operator in SQL, do the results 
include the values of your endpoints, or not? Figure out 
the answer to this important question by writing a query 
that displays the order date and gloss_qty data for all 
orders where gloss_qty is between 24 and 29. Then look 
at your output to see if the BETWEEN operator included the 
begin and end values or not.*/

SELECT * FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

-- Si los tiene en cuenta, es decir es un intervalo cerrado

/*Use the web_events table to find all information regarding 
individuals who were contacted via the organic or adwords 
channels, and started their account at any point in 2016, 
sorted from newest to oldest.*/

SELECT * FROM web_events
WHERE channel IN ('organic', 'adwords')
	AND ocurred_at BETWEEN '2016-01-01' AND '2016-12-31'
ORDER BY ocurred_at DESC;


/*Find list of orders ids where either gloss_qty or 
poster_qty is greater than 4000. Only include the id field 
in the resulting table.*/

SELECT id FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;


/*Write a query that returns a list of orders where the 
standard_qty is over zero and either the gloss_qty or 
poster_qty is over 1000.*/

SELECT * FROM orders
WHERE standard_qty > 0
	AND (gloss_qty > 1000 OR poster_qty > 1000);


/*Find all the company names that start with a 'C' or 'W', 
and the primary contact contains 'ana' or 'Ana', but it 
doesn't contain 'eana'.*/

SELECT name FROM accounts
WHERE name ~* '^[C|W]'
	AND primary_poc ~* 'ana'
	AND primary_poc NOT LIKE '%eana%';

