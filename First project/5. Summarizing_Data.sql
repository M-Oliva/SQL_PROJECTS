-- Aggregate Data
/* MIN(), MAX(), AVG(), SUM(), COUNT() */

-- Usaremos la database mastery
SELECT MIN(invoice_total) AS lowest, MAX(invoice_total) AS highest,
	ROUND(AVG(invoice_total), 2) AS average, SUM(invoice_total) AS total,
	COUNT(invoice_total) AS number_of_invoices,
	COUNT (payment_date) AS number_of_payment
FROM mastery.invoices;
/* ROUND ayuda a redondear cuando se trata de numeros largos */

/*date-range, total-sales, total-payments, what-we-expect*/
SELECT 'First half of 2019' AS data_range, SUM(invoice_total) AS total_sales, SUM(payment_total) AS total_payment,
			SUM(invoice_total) - SUM(payment_total) AS what_we_expect
	FROM mastery.invoices
	WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT 'Second half of 2019' AS data_range, SUM(invoice_total) AS total_sales, SUM(payment_total) AS total_payment,
			SUM(invoice_total) - SUM(payment_total) AS what_we_expect
	FROM mastery.invoices
	WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT 'TOTAL' AS data_range, SUM(invoice_total) AS total_sales, SUM(payment_total) AS total_payment,
			SUM(invoice_total) - SUM(payment_total) AS what_we_expect
	FROM mastery.invoices
	WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31'
ORDER BY 1;
/* data_range es una manera de expresar una columna dentro de la tabla */


-- Clausula GROUP BY y HAVING

/* Total payment by date */
SELECT p.date, pm.name, SUM(p.amount) AS total_payments
FROM mastery.payments AS p
	INNER JOIN mastery.payment_methods AS pm 
		ON p.payment_method = pm.payment_method_id
GROUP BY 1, 2
ORDER BY 1;


/* Trae los clientes que viven en Virigina y han gastado más
de $100 */
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name,
		c.state, SUM(oi.unit_price * oi.quantity) AS total_spending
FROM moshstore.customers AS c
	INNER JOIN moshstore.orders AS o 
		ON c.customer_id = o.customer_id
	INNER JOIN moshstore.order_items AS oi
		ON o.order_id = oi.order_id
WHERE c.state LIKE 'VA' 
GROUP BY 1
HAVING SUM(oi.unit_price * oi.quantity) > 100;
/* En el HAVING tienes que poner toda la condición de lo 
que esgtas buscando */
/* La diferencia entre el WHERE y el HAVING es que el
WHERE es antes de agrupar las condiciones y no se usan las 
funciones agregadas, al contrario del HAVING que su correcto
uso es para las funciones agregagas */

-- ROLL UP
SELECT c.state, c.city, SUM(i.invoice_total) AS total_sales
FROM mastery.invoices AS i
	INNER JOIN mastery.clients AS c USING (client_id)
GROUP BY ROLLUP(1,2)
ORDER BY 1;
/* El ROLLUP permite incluir registros extras que representan
a los subtotales */


SELECT pm.name AS payment_method, SUM(amount) AS total
FROM mastery.payments AS p
	INNER JOIN mastery.payment_methods AS pm 
		ON p.payment_method = pm.payment_method_id
GROUP BY ROLLUP(1)
ORDER BY 1;








