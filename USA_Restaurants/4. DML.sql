/***** DATA MANIPULATION LANGUAGE *****/


/* Inserting Row(s) */

INSERT INTO local.customers VALUES
	(11,'John', 'Smith', '1990-01-01', NULL, 'etca', 'etcc', 'CA', DEFAULT);


/* Creating copy of a table */

CREATE TABLE local.orders_achieved AS
	SELECT * FROM local.orders;
	
SELECT * FROM local.orders_achieved;

TRUNCATE local.orders_achieved;

INSERT INTO local.orders_achieved
	SELECT *
    FROM local.orders
    WHERE order_date < '2023-01-01';
    

/*copy of invoice table
with client name instead of client_id column
and with already made payment*/

CREATE TABLE bills.invoices_achieved AS
	SELECT i.invoice_id, i.number, c.name, i.invoice_total,
			i.payment_total, i.invoice_date, i.due_date, i.payment_date
	FROM bills.invoices AS i
		INNER JOIN bills.clients AS c USING (client_id)
	WHERE i.payment_date IS NOT NULL;


/* Updating Rows */

SELECT * FROM local.orders;

UPDATE local.orders
SET comments = 'blah blah', order_date = '2022-04-01'
WHERE order_id = 1;


/*give any customers born before 1985 give 50 extra points*/

UPDATE local.customers SET points = points + 50
	WHERE EXTRACT(YEAR FROM birth_date) < 1985; 


-- Use bills database

UPDATE bills.invoices SET 
	payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE client_id IN (
	SELECT client_id FROM bills.clients
	WHERE name ILIKE '%tino%'
);


/*set the commments to GOLD in orders of customer where points > 3000*/

UPDATE local.orders SET comments = 'Gold'
WHERE customer_id IN (
	SELECT customer_id FROM local.customers
	WHERE points > 3000
);

-- Check
SELECT * FROM local.orders;


/* Deleting rows */

DELETE FROM moshstore.orders
WHERE order_id = 14; 
/* It is important to put a condition on the DELETE so that it
does not delete the entire table */










