/***** VIEWS *****/

/* They are used to save queries that are repetitive */


/* Assume the following query */

SELECT c.client_id, c.name, SUM(i.invoice_total) AS total_sales
FROM bills.clients AS c
	INNER JOIN bills.invoices AS i USING (client_id)
GROUP BY 1, 2;


/* We save it in a view as follows */

CREATE VIEW v_sales_clients AS (
	SELECT c.client_id, c.name, SUM(i.invoice_total) AS total_sales
	FROM bills.clients AS c
		INNER JOIN bills.invoices AS i USING (client_id)
	GROUP BY 1, 2
);

/* Call view */

SELECT * 
FROM v_sales_clients;


/*view to see the balance for each client.*/

CREATE OR REPLACE VIEW clients_balance AS (
	SELECT c.client_id, c.name, SUM(i.invoice_total - i.payment_total) AS balance
	FROM bills.clients AS c
		INNER JOIN bills.invoices AS i USING(client_id)
	GROUP BY 1
);

-- Drop views

DROP VIEW v_sales_clients;

-- With check option clause

CREATE OR REPLACE VIEW v_invoices_rem_balance AS (
	SELECT invoice_id, number, client_id, invoice_total,
			payment_total, invoice_total - payment_total AS remaining_balance,
			invoice_date, due_date, payment_date
FROM bills.invoices
WHERE (invoice_total - payment_total) > 0
) WITH CHECK OPTION;
/* Allows no data to be inserted unless the given condition is met */


SELECT * FROM v_invoices_rem_balance;

UPDATE v_invoices_rem_balance 
SET payment_total = invoice_total
WHERE invoice_id = 2;
/* Como esta actualización va a provocar un resultado '0',
el CHECK OPTION no nos permite realizarla */


























