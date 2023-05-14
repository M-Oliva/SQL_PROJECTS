-- Traeremos la data proveniente de diferentes tablas con
-- ayuda del JOIN

-- Inicialmente usaremos la base de datos MOSHSTORE

SELECT oi.order_id, p.name, oi.quantity, oi.unit_price
FROM moshstore.order_items AS oi
	INNER JOIN moshstore.products AS p
		ON oi.product_id = p.product_id;
		
-- Ahora haremos uso de un SELF JOIN con la base de datos MSHR

SELECT * FROM mshr.employees
LIMIT 5;

/* Traeremos los empleados con su manager */

SELECT e1.employee_id, e1.first_name, e1.last_name,
		CONCAT(e2.first_name, ' ',e2.last_name) AS manager
FROM mshr.employees AS e1
	LEFT JOIN mshr.employees AS e2
		ON e1.reports_to = e2.employee_id;
		
-- Uniremos multiples tablas	
		
SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
FROM moshstore.orders AS o
	INNER JOIN moshstore.customers AS c
		ON o.customer_id = c.customer_id
	INNER JOIN moshstore.order_status AS os
		ON o.status = os.order_status_id;
		
-- Detalles del cliente y pagos en la base de datos MASTERY

SELECT c.client_id, c.name, p.invoice_id, p.date, p.amount, pm.name AS method
FROM mastery.payments AS p
	INNER JOIN mastery.payment_methods AS pm
		ON p.payment_method = pm.payment_method_id
	INNER JOIN mastery.clients AS c
		ON p.client_id = c.client_id;

-- Ahora usaremos un join implicito, en lo personal no me gusta
-- usarlo, porque hace que la consulta carezca de estructura

SELECT c.client_id, c.name, p.invoice_id, p.date, p.amount, pm.name AS method
FROM mastery.payments AS p, mastery.payment_methods AS pm,
		mastery.clients AS c
WHERE p.payment_method = pm.payment_method_id AND
	p.client_id = c.client_id;

-- Cuantas veces han sido ordenados los productos y cuales no
SELECT p.product_id, p.name, oi.quantity
FROM moshstore.products AS p
	LEFT JOIN moshstore.order_items AS oi
		ON p.product_id = oi.product_id;
	
-- productos que nunca han sido ordenados
SELECT p.product_id, p.name, oi.quantity
FROM moshstore.products AS p
	LEFT JOIN moshstore.order_items AS oi
		ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Dame la orden, nombre de cliente y estado siempre y cuando el
-- estado sea procesado o enviado
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS client_name, os.name
FROM moshstore.orders AS o
	INNER JOIN moshstore.customers AS c ON o.customer_id = c.customer_id
	INNER JOIN moshstore.order_status AS os ON o.status = os.order_status_id
WHERE os.name IN ('Processed', 'Shipped');


-- Vamos a trabajar la abreviatura using, como se muestra:
SELECT p.date, c.name, p.amount, pm.name
FROM mastery.payments AS p
	INNER JOIN mastery.clients AS c USING (client_id)
	JOIN mastery.payment_methods AS pm 
		ON pm.payment_method_id = p.payment_method;
/* Lo que hace el using es reemplazar el ON cuando ambas
tablas se relacionan por el mismo nombre */

-- Natural join
-- Permite que sql escoja las llaves por el mismo al momento de la unión
SELECT o.order_id, c.first_name
FROM moshstore.orders AS o
NATURAL JOIN moshstore.customers AS c;

-- Union (concatena los select de forma vertical)
SELECT *, 'Active' AS status
	FROM moshstore.orders
	WHERE order_date <= current_date - interval '1 year'
UNION
SELECT *, 'Archived' AS status
	FROM moshstore.orders
	WHERE order_date > current_date - interval '1 year';

-- Usaremos el case
SELECT customer_id, first_name, points,
	CASE
		WHEN points > 3000 THEN 'Gold'
		WHEN points BETWEEN 2000 AND 3000 THEN 'Silver'
		ELSE 'Bronze'
	END AS type
FROM moshstore.customers
ORDER BY 2;
/* Order by 2 significa que los va a ordenar por la segunda 
solicitud hecha en el select, en este caso por first_name */







