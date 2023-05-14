/***** STORED PROCEDURES *****/


CREATE OR REPLACE PROCEDURE bills.get_clients()
LANGUAGE sql
AS $$
	SELECT * FROM bills.clients;
$$;


/* Call Stored Procedure */
CALL bills.get_clients();

/* get_invoices_with_balance to return all the invoices with balance > 0 */
DROP PROCEDURE IF EXISTS bills.get_i_b();

CREATE OR REPLACE PROCEDURE bills.get_i_b()
LANGUAGE sql
AS $$
	SELECT *
	FROM bills.invoices
	WHERE (invoice_total - payment_total) > 0;
$$;

CALL bills.get_i_b();

/* Parameters */
	
CREATE OR REPLACE PROCEDURE bills.client_by_state(p_state CHAR(2))
LANGUAGE sql 
AS $$
	SELECT * FROM bills.clients
	WHERE state = p_state;
$$;

CALL bills.client_by_state('NY');


/* exercise */
/* return invoices for a given client */

DROP PROCEDURE IF EXISTS bills.invoices_by_client;

CREATE PROCEDURE bills.invoices_by_client(p_client_name VARCHAR(50))
LANGUAGE SQL
AS $$
	SELECT * FROM bills.invoices AS i
		INNER JOIN bills.clients AS c ON c.client_id = i.invoice_id
		WHERE c.name = p_client_name;
$$;

CALL bills.invoices_by_client('MyWorks');


/* Parameters with DEFAULT values */

/* set the state to CA if there is no parameters given */

CREATE OR REPLACE PROCEDURE bills.client_state(p_state CHAR(2))
LANGUAGE plpgsql
AS $$
DECLARE v_prueba varchar(50);
BEGIN
	IF p_state IS NULL 
		THEN SET p_state = 'CA';
	END IF;

	SELECT name FROM bills.clients
		INTO v_prueba
	WHERE state = p_state;
END
$$;

CALL bills.client_state('NULL');

/* get all clients,  if there is no parameters given */

CREATE OR REPLACE PROCEDURE bills.g_t_s(p_state CHAR(2))
LANGUAGE SQL
AS $$
	SELECT * FROM bills.clients
	WHERE state = NULLIF(p_state, state);
$$;
/* NULLIF(argument 1, argument 2) returns null if 
argument 1 = argument 2 */

CALL bills.g_t_s(NULL);

/* Exercise */
/*stored procedure get_payments with two parameters
	client_id INT(4),
    payment_method_id int */
	
CREATE OR REPLACE PROCEDURE bills.get_payments (p_client_id int, p_payment_method_id int)
LANGUAGE SQL
AS $$
	SELECT * FROM bills.payments
	WHERE client_id = NULLIF (p_client_id, client_id)
	AND payment_method = NULLIF (p_payment_method_id, payment_method)
$$;

CALL bills.get_payments(5, 2);
CALL bills.get_payments(5, NULL);
CALL bills.get_payments(NULL, 1);
CALL bills.get_payments(NULL, NULL);


/* Parameters validation */

DROP PROCEDURE IF EXISTS bills.make_payment;

CREATE OR REPLACE PROCEDURE bills.make_payment(ppinvoice_id int, pppayment_amount decimal(9,2), pppayment_date DATE)
LANGUAGE plpgsql
AS $$
BEGIN
	IF pppayment_amount <= 0 THEN 
		RAISE NOTICE 'no es posible';
	ELSE
		UPDATE bills.invoices AS i
		SET invoice_total = pppayment_amount,
			payment_date = pppayment_date
		WHERE invoice_id = ppinvoice_id;
	END IF;
END
$$;

-- Testing
CALL bills.make_payment(1, -345, current_date);

CALL bills.make_payment(1, 100, current_date);

-- Check 
SELECT * FROM bills.invoices 
WHERE invoice_id = 1;

/* Output parameters */


/*get unpaid invoices for a client */

DROP PROCEDURE IF EXISTS bills.get_invoices_clients;

CREATE OR REPLACE PROCEDURE bills.get_invoices_clients 
		(sclient_id INT, number_of_unpaid_invoices OUT INT, 
		 total_unpaid_amount OUT INT)
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
	FROM bills.invoices
			INTO number_of_unpaid_invoices, total_unpaid_amount
	WHERE client_id = sclient_id AND payment_total > 70;
END
$$;

-- Testing

CALL bills.get_invoices_clients(3, 0, 0);

/* Put zero in the output parameters because you have to add a value, 
independently we will obtain the expected result */

-------------------------------------------------------------------------
/*Variables */

CREATE OR REPLACE PROCEDURE bills.g_risk_factor()
LANGUAGE plpgsql
AS $$
DECLARE
	risk_factor decimal(9,2) DEFAULT 0;
	invoices_total decimal(9,2);
	invoice_count int;
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
	FROM bills.invoices 
		INTO invoice_count, invoices_total;
		
	SELECT invoices_total /(invoice_count * 5)
		INTO risk_factor;
END
$$;

CALL bills.g_risk_factor();

/* Functions */

CREATE OR REPLACE FUNCTION bills.get_risk_factor(fclient_id int)
RETURNS int
LANGUAGE plpgsql
AS $$
DECLARE
	risk_factor decimal(9,2) DEFAULT 0;
	invoices_total decimal(9,2);
	invoice_count int;
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
	FROM bills.invoices 
		INTO invoice_count, invoices_total
	WHERE client_id = fclient_id;
		
	SELECT invoices_total /(invoice_count * 5)
		INTO risk_factor;
	
	RETURN NULLIF(risk_factor, 0);
END
$$;

-- Testing

SELECT client_id, name, bills.get_risk_factor(2) AS risks
FROM bills.clients;

/* If you get this error: the query does not have a destination for the
result data
HINT: If you want to discard the results of a SELECT,
use PERFORM.

What is missing is a declaration of a variable through an INTO */
















