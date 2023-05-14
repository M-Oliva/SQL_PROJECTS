/***** SQL JOIN *****/


/*Try pulling all the data from the products table, and all 
the data from the inventory table.*/

SELECT p.*, i.*
FROM products AS p
	INNER JOIN inventory AS i ON p.product_id = i.product_id;
	
	
/*Try pulling product_cost and product_price from the
products table, and the stock_on_hand from the 
inventory table.*/

SELECT product_cost, product_price, stock_on_hand
FROM products AS p
	INNER JOIN inventory AS i ON p.product_id = i.product_id;
	

/*Provide a table for all sales associated with product 
name of Deck Of Cards. */

SELECT p.product_name, s.sales_id, s.date, s.units
FROM sales AS s
	INNER JOIN products AS p USING (product_id)
WHERE product_name ~* 'deck';


/*Provide a table for all sales associated with product 
name and store city. */

SELECT p.product_name, st.store_city, s.sales_id, s.date, s.units 
FROM sales AS s
	INNER JOIN products AS p USING (product_id)
	INNER JOIN stores AS st USING (store_id)
ORDER BY s.units DESC;


/*Provide a table for all sales associated with product 
name and store city in morelia. */

SELECT p.product_name, st.store_city, s.sales_id, s.date, s.units 
FROM sales AS s
	INNER JOIN products AS p USING (product_id)
	INNER JOIN stores AS st USING (store_id)
WHERE st.store_city ~* 'morelia'
ORDER BY s.units DESC;


/*Provide a table for all sales associated with product 
name and store city in morelia, with units over 20. */

SELECT p.product_name, st.store_city, s.sales_id, s.date, s.units 
FROM sales AS s
	INNER JOIN products AS p USING (product_id)
	INNER JOIN stores AS st USING (store_id)
WHERE st.store_city ~* 'morelia' AND s.units > 20
ORDER BY s.units DESC;


/*What is the stock on hold by product id 15? */

SELECT DISTINCT p.product_name, st.store_name, i.stock_on_hand
FROM inventory AS i
	INNER JOIN products AS p ON i.product_id = p.product_id
	INNER JOIN stores AS st USING (store_id)
WHERE p.product_id = 15 AND i.stock_on_hand NOT IN (0)
ORDER BY i.stock_on_hand;


/*Find all sales that were made in 2017. */

SELECT p.product_name, st.store_city, s.sales_id, s.date, s.units 
FROM sales AS s
	INNER JOIN products AS p USING (product_id)
	INNER JOIN stores AS st USING (store_id)
WHERE date BETWEEN '2017-01-01' AND '2017-12-31';
















