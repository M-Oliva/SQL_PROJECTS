/***** WRITING COMPLEX QUERY *****/

/* Subqueries */


/* products that are more expensive than grilled fish */

SELECT * 
FROM local.products
WHERE unit_price > (SELECT unit_price 
				   	FROM local.products
				   	WHERE name ILIKE '%grilled%');


/* find employees who earn more than average */

SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name,
		salary
FROM staff.employees
WHERE salary > (SELECT AVG(salary) FROM staff.employees);


--  IN Operator


/* products that have never been ordered*/

SELECT p.product_id, p.name, p.quantity_in_stock, oi.order_id
FROM local.order_items AS oi
	RIGHT JOIN local.products AS p USING (product_id)
WHERE oi.product_id IS NULL;

SELECT p.product_id, p.name,  p.quantity_in_stock
FROM local.products AS p 
WHERE p.product_id NOT IN(
	SELECT DISTINCT product_id
    FROM local.order_items
);


/* find clients without invoices */

SELECT client_id, name, phone
FROM bills.clients
WHERE client_id NOT IN (
	SELECT client_id FROM bills.invoices
);



/* Subqueries vs JOIN */


/*customers who have ordered Soda - vodka*/

SELECT DISTINCT c.customer_id, 
		CONCAT (c.first_name, ' ', c.last_name) as full_name
FROM local.customers AS c
	INNER JOIN local.orders AS o USING (customer_id)
	INNER JOIN local.order_items AS oi USING (order_id)
	INNER JOIN local.products AS p USING (product_id)
WHERE p.name ~* 'soda';	


-- All keyword


/*invoices larger than invoices of client 2*/

SELECT *
FROM bills.invoices 
WHERE invoice_total > ALL (SELECT invoice_total
					 	FROM bills.invoices
					 	WHERE client_id = 2);

/*ALL is used when a subquery returns more than one record */


-- Any keyword


/*clients with at least 2 invoices*/

SELECT *
FROM bills.clients
WHERE client_id = ANY (SELECT client_id FROM bills.invoices
				  	GROUP BY client_id
				  	HAVING COUNT(client_id)>2);


/*client's own invoices that are larger than client's average invoice amount*/

SELECT * 
FROM bills.clients AS c
	INNER JOIN bills.invoices AS i USING (client_id)
WHERE i.invoice_total > (SELECT AVG(i.invoice_total) 
						 FROM bills.invoices AS i);	
	
	
-- EXISTS Operator

/* if result set of sub queries is too large, we better use EXISTS
rather than IN   */

/*clients that have an inovice*/

SELECT * 
FROM bills.clients AS c
WHERE EXISTS (SELECT client_id FROM bills.invoices
			 	WHERE client_id = c.client_id);


-- Subqueries in SELECT

SELECT client_id, name,
		(SELECT SUM(invoice_total) FROM bills.invoices WHERE client_id = c.client_id) AS total_sales,
		(SELECT AVG(invoice_total) FROM bills.invoices WHERE client_id = c.client_id) AS average
FROM bills.clients AS c;


-- Subqueries in FROM

SELECT *
FROM (SELECT c.client_id, c.name, SUM(i.invoice_total) AS total_sales, 
		AVG(i.invoice_total) AS average, 
	  	SUM(i.invoice_total) - AVG(i.invoice_total) AS difference
	  FROM bills.invoices AS i
			RIGHT JOIN bills.clients AS c ON c.client_id = i.client_id
	 GROUP BY 1) AS tbl1
WHERE total_sales IS NOT NULL;














