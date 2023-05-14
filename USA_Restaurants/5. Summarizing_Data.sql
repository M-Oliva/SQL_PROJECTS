/***** Aggregate data *****/

/* MIN(), MAX(), AVG(), SUM(), COUNT() */


-- Use bills database

SELECT MIN(invoice_total) AS lowest, MAX(invoice_total) AS highest,
	ROUND(AVG(invoice_total), 2) AS average, SUM(invoice_total) AS total,
	COUNT(invoice_total) AS number_of_invoices,
	COUNT (payment_date) AS number_of_payment
FROM bills.invoices;

/* ROUND helps to round when dealing with long numbers */


/*date-range, total-sales, total-payments, what-we-expect*/

SELECT 'First half of 2022' AS data_range, SUM(invoice_total) AS total_sales, SUM(payment_total) AS total_payment,
			SUM(invoice_total) - SUM(payment_total) AS what_we_expect
	FROM bills.invoices
	WHERE invoice_date BETWEEN '2022-01-01' AND '2022-06-30'
UNION
SELECT 'Second half of 2022' AS data_range, SUM(invoice_total) AS total_sales, SUM(payment_total) AS total_payment,
			SUM(invoice_total) - SUM(payment_total) AS what_we_expect
	FROM bills.invoices
	WHERE invoice_date BETWEEN '2022-07-01' AND '2022-12-31'
UNION
SELECT 'TOTAL' AS data_range, SUM(invoice_total) AS total_sales, SUM(payment_total) AS total_payment,
			SUM(invoice_total) - SUM(payment_total) AS what_we_expect
	FROM bills.invoices
	WHERE invoice_date BETWEEN '2022-01-01' AND '2022-12-31'
ORDER BY 1;

/* data_range is a way to express a column within the table */


-- GROUP BY & HAVING

/* Total payment by date */

SELECT p.date, pm.name, SUM(p.amount) AS total_payments
FROM bills.payments AS p
	INNER JOIN bills.payment_methods AS pm 
		ON p.payment_method = pm.pm_id
GROUP BY 1, 2
ORDER BY 1;


/*get customers located in New Mexico who have spent more than $100 */

SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name,
		c.state, SUM(oi.unit_price * oi.quantity) AS total_spending
FROM local.customers AS c
	INNER JOIN local.orders AS o 
		ON c.customer_id = o.customer_id
	INNER JOIN local.order_items AS oi
		ON o.order_id = oi.order_id
WHERE c.state LIKE 'NM' 
GROUP BY 1
HAVING SUM(oi.unit_price * oi.quantity) > 100;

/* In the HAVING you have to put all the condition of what you 
are looking for */

/* The difference between the WHERE and the HAVING is that the 
WHERE is before grouping the conditions and the aggregate functions
are not used, contrary to the HAVING that its correct use is for the 
aggregate functions */


-- ROLL UP

SELECT c.state, c.city, SUM(i.invoice_total) AS total_sales
FROM bills.invoices AS i
	INNER JOIN bills.clients AS c USING (client_id)
GROUP BY ROLLUP(1,2)
ORDER BY 1;

/* The ROLLUP allows you to include extra records that 
represent the subtotals */


/*roll up with payment method*/

SELECT pm.name AS payment_method, SUM(amount) AS total
FROM bills.payments AS p
	INNER JOIN bills.payment_methods AS pm 
		ON p.payment_method = pm.pm_id
GROUP BY ROLLUP(1)
ORDER BY 1;








