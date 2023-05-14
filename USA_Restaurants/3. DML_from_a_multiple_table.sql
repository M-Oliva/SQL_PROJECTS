/***** DATA MANIPULATION LANGUAGE FROM A MULTIPLE TABLE *****/

-- Bring the data from different tables with the help of the JOIN


-- Initially the local database will be used

SELECT oi.order_id, p.name, oi.quantity, oi.unit_price
FROM local.order_items AS oi
	INNER JOIN local.products AS p
		ON oi.product_id = p.product_id;


-- Now a SELF JOIN will be used with the staff database

SELECT * FROM staff.employees
LIMIT 5;


/*employee and his/her manager */

SELECT e1.employee_id, e1.first_name, e1.last_name,
		CONCAT(e2.first_name, ' ',e2.last_name) AS manager
FROM staff.employees AS e1
	LEFT JOIN staff.employees AS e2
		ON e1.reports_to = e2.employee_id;
		
		
/* Joining multiple tables */	
		
SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
FROM local.orders AS o
	INNER JOIN local.customers AS c
		ON o.customer_id = c.customer_id
	INNER JOIN local.order_status AS os
		ON o.status = os.order_status_id;


/*payment and customer details*/

SELECT c.client_id, c.name, p.invoice_id, p.date, p.amount, pm.name AS method
FROM bills.payments AS p
	INNER JOIN bills.payment_methods AS pm
		ON p.payment_method = pm.pm_id
	INNER JOIN bills.clients AS c
		ON p.client_id = c.client_id;

/* Implicit Join   
I personally don't like to use it, because it makes 
the query unstructured */

SELECT c.client_id, c.name, p.invoice_id, p.date, p.amount, pm.name AS method
FROM bills.payments AS p, bills.payment_methods AS pm,
		bills.clients AS c
WHERE p.payment_method = pm.pm_id AND
	p.client_id = c.client_id;

/* Outer Joins */


/*products and how many time it has been ordered*/

SELECT p.product_id, p.name, oi.quantity
FROM local.products AS p
	LEFT JOIN local.order_items AS oi
		ON p.product_id = oi.product_id;
	
	
/* product which has never been ordered */

SELECT p.product_id, p.name, oi.quantity
FROM local.products AS p
	LEFT JOIN local.order_items AS oi
		ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


/* order, customer name, status where status is in processed or shipped */

SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS client_name, os.name
FROM local.orders AS o
	INNER JOIN local.customers AS c ON o.customer_id = c.customer_id
	INNER JOIN local.order_status AS os ON o.status = os.order_status_id
WHERE os.name IN ('Processed', 'Shipped');


/* Using */

/* What using does is replace the ON when both tables 
are related by the same name */

SELECT p.date, c.name, p.amount, pm.name
FROM bills.payments AS p
	INNER JOIN bills.clients AS c USING (client_id)
	INNER JOIN bills.payment_methods AS pm 
		ON pm.pm_id = p.payment_method;
		
		
/* Natural Joins */
/* it allows sql engine to pick up the keys by itself 
for joining */

SELECT o.order_id, c.first_name
FROM local.orders AS o
NATURAL JOIN local.customers AS c;


/* Union */ 

SELECT *, 'Active' AS status
	FROM local.orders
	WHERE order_date <= current_date - interval '1 year'
UNION
SELECT *, 'Archived' AS status
	FROM local.orders
	WHERE order_date > current_date - interval '1 year';


/* Case */
/* customer and point status */

SELECT customer_id, first_name, points,
	CASE
		WHEN points > 3000 THEN 'Gold'
		WHEN points BETWEEN 2000 AND 3000 THEN 'Silver'
		ELSE 'Bronze'
	END AS type
FROM local.customers
ORDER BY 2;

/* Order by 2 means that it will order them by the second
request made in the select, in this case by first_name */











