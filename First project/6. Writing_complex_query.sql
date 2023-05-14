-- WRITING COMPLEX QUERY
-- Empecemos con los subqueries

/* Productos más caros que la lechuga */
SELECT * 
FROM moshstore.products
WHERE unit_price > (SELECT unit_price 
				   	FROM moshstore.products
				   	WHERE name ILIKE '%lettuce%');


/* Encontrar empleados que ganan más que el promedio */
SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name,
		salary
FROM mshr.employees
WHERE salary > (SELECT AVG(salary) FROM mshr.employees);


-- Operador IN

/* Productos que nunca han sido ordenados */
SELECT p.product_id, p.name, p.quantity_in_stock, oi.order_id
FROM moshstore.order_items AS oi
	RIGHT JOIN moshstore.products AS p USING (product_id)
WHERE oi.product_id IS NULL;

/* Con el IN quedaria así: */
SELECT p.product_id, p.name,  p.quantity_in_stock
FROM moshstore.products AS p 
WHERE p.product_id NOT IN(
	SELECT DISTINCT product_id
    FROM moshstore.order_items
);

/* Traeme clientes sin facturas */
SELECT client_id, name, phone
FROM mastery.clients
WHERE client_id NOT IN (
	SELECT client_id FROM mastery.invoices
);


/* Clientes que ordenaron lechuga */
/* Con JOIN */
SELECT DISTINCT c.customer_id, 
		CONCAT (c.first_name, ' ', c.last_name) as full_name
FROM moshstore.customers AS c
	INNER JOIN moshstore.orders AS o USING (customer_id)
	INNER JOIN moshstore.order_items AS oi USING (order_id)
	INNER JOIN moshstore.products AS p USING (product_id)
WHERE p.name ~* 'lettuce';	


-- All keyword

/* Facturas más largas que las facturas del cliente 3 */
SELECT *
FROM mastery.invoices 
WHERE invoice_total > ALL (SELECT invoice_total
					 	FROM mastery.invoices
					 	WHERE client_id = 3);
/* El ALL se usa cuando una subconsulta trae más de 
un registro */


-- Any keyword

/* Clientes con al menos 2 facturas */
SELECT *
FROM mastery.clients
WHERE client_id = ANY (SELECT client_id FROM mastery.invoices
				  	GROUP BY client_id
				  	HAVING COUNT(client_id)>2);


/* Clientes cuyas facturas son más largas que las facturas
promedio */
SELECT * 
FROM mastery.clients AS c
	INNER JOIN mastery.invoices AS i USING (client_id)
WHERE i.invoice_total > (SELECT AVG(i.invoice_total) 
						 FROM mastery.invoices AS i);	
	
	
-- Operador EXISTS
/* Si el resultado de un subquerie es muy largo, es mejor usar 
EXISTS que IN */
SELECT * 
FROM mastery.clients AS c
WHERE EXISTS (SELECT client_id FROM mastery.invoices
			 	WHERE client_id = c.client_id);


-- Subqueries en el SELECT
SELECT client_id, name,
		(SELECT SUM(invoice_total) FROM mastery.invoices WHERE client_id = c.client_id) AS total_sales,
		(SELECT AVG(invoice_total) FROM mastery.invoices WHERE client_id = c.client_id) AS average,
FROM mastery.clients AS c
;

-- Subqueries en el FROM
SELECT *
FROM (SELECT c.client_id, c.name, SUM(i.invoice_total) AS total_sales, 
		AVG(i.invoice_total) AS average, 
	  	SUM(i.invoice_total) - AVG(i.invoice_total) AS difference
	  FROM mastery.invoices AS i
			RIGHT JOIN mastery.clients AS c ON c.client_id = i.client_id
	 GROUP BY 1) AS tbl1
WHERE total_sales IS NOT NULL;

