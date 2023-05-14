-- Views
/* Son usadas para guardar consultas que son repetitivas */

/* Supongamos la siguiente consulta */

SELECT c.client_id, c.name, SUM(i.invoice_total) AS total_sales
FROM mastery.clients AS c
	INNER JOIN mastery.invoices AS i USING (client_id)
GROUP BY 1, 2;

/* La guardamos en una vista de la siguiente forma */
CREATE VIEW v_sales_clients AS (
	SELECT c.client_id, c.name, SUM(i.invoice_total) AS total_sales
	FROM mastery.clients AS c
		INNER JOIN mastery.invoices AS i USING (client_id)
	GROUP BY 1, 2
);

/* Llamamos la vista ahora */
SELECT * 
FROM v_sales_clients;

/* Vista para ver el balance de cada cliente */
CREATE OR REPLACE VIEW clients_balance AS (
	SELECT c.client_id, c.name, SUM(i.invoice_total - i.payment_total) AS balance
	FROM mastery.clients AS c
		INNER JOIN mastery.invoices AS i USING(client_id)
	GROUP BY 1
);

-- Drop views

DROP VIEW v_sales_clients;

-- With check option clause

CREATE OR REPLACE VIEW v_invoices_rem_balance AS (
	SELECT invoice_id, number, client_id, invoice_total,
			payment_total, invoice_total - payment_total AS remaining_balance,
			invoice_date, due_date, payment_date
FROM mastery.invoices
WHERE (invoice_total - payment_total) > 0
) WITH CHECK OPTION;
/* Permite que no se inserten datos a menos que cumpla la 
condición dada */


SELECT * FROM v_invoices_rem_balance;

UPDATE v_invoices_rem_balance 
SET payment_total = invoice_total
WHERE invoice_id = 2;
/* Como esta actualización va a provocar un resultado '0',
el CHECK OPTION no nos permite realizarla */





