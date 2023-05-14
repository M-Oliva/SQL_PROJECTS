-- Stored procedures and functions

CREATE OR REPLACE PROCEDURE mastery.get_clients()
LANGUAGE sql
AS $$
	SELECT * FROM mastery.clients;
$$;

/* Llamamos al procedimiento */
CALL mastery.get_clients();

/* get_invoices_with_balance para devolver todos las facturas
con balance mayores que cero */
DROP PROCEDURE IF EXISTS get_i_b();

CREATE OR REPLACE PROCEDURE mastery.get_i_b()
LANGUAGE sql
AS $$
	SELECT *
	FROM mastery.invoices
	WHERE (invoice_total - payment_total) > 0;
$$;

CALL mastery.get_i_b();

/* Parametros */
	
CREATE OR REPLACE PROCEDURE mastery.client_by_state(p_state CHAR(2))
LANGUAGE sql 
AS $$
	SELECT * FROM mastery.clients
	WHERE state = p_state;
$$;

CALL mastery.client_by_state('NY');


/* Ejercicio */
/* Devolver facturas por un cliente dado */
DROP PROCEDURE IF EXISTS invoices_by_client;

CREATE PROCEDURE mastery.invoices_by_client(p_client_name VARCHAR(50))
LANGUAGE SQL
AS $$
	SELECT * FROM mastery.invoices AS i
		INNER JOIN mastery.clients AS c ON c.client_id = i.invoice_id
		WHERE c.name = p_client_name;
$$;

CALL mastery.invoices_by_client('MyWorks');

/* SP con parametros por defecto */
/* Coloca el estado a CA si no te dan los parametros */

CREATE OR REPLACE PROCEDURE mastery.client_state(p_state CHAR(2))
LANGUAGE plpgsql
AS $$
DECLARE v_prueba varchar(50);
BEGIN
	IF p_state IS NULL 
		THEN SET p_state = 'CA';
	END IF;

	SELECT name FROM mastery.clients
		INTO v_prueba
	WHERE state = p_state;
END
$$;

CALL mastery.client_state('NULL');

/* Devuelve todos los clientes si no hay parametros dados */

CREATE OR REPLACE PROCEDURE mastery.g_t_s(p_state CHAR(2))
LANGUAGE SQL
AS $$
	SELECT * FROM mastery.clients
	WHERE state = NULLIF(p_state, state);
$$;
/* El NULLIF(argumento 1, argumento 2) devuelve un valor nulo 
si el argumento 1 = argumento 2 */

CALL mastery.g_t_s(NULL);

/* Ejercicio */
/* Procedimiento almacenado get_payments con 2 parametros
client_id INT, payment_method_id INT */

CREATE OR REPLACE PROCEDURE mastery.get_payments (p_client_id int, p_payment_method_id int)
LANGUAGE SQL
AS $$
	SELECT * FROM mastery.payments
	WHERE client_id = NULLIF (p_client_id, client_id)
	AND payment_method = NULLIF (p_payment_method_id, payment_method)
$$;

CALL mastery.get_payments(5, 2);
CALL mastery.get_payments(5, NULL);
CALL mastery.get_payments(NULL, 1);
CALL mastery.get_payments(NULL, NULL);

/* Parametros de validacion */
DROP PROCEDURE IF EXISTS make_payment;

CREATE OR REPLACE PROCEDURE mastery.make_payment(ppinvoice_id int, pppayment_amount decimal(9,2), pppayment_date DATE)
LANGUAGE plpgsql
AS $$
BEGIN
	IF pppayment_amount <= 0 THEN 
		RAISE NOTICE 'no es posible';
	ELSE
		UPDATE mastery.invoices AS i
		SET invoice_total = pppayment_amount,
			payment_date = pppayment_date
		WHERE invoice_id = ppinvoice_id;
	END IF;
END
$$;

-- Probando
CALL mastery.make_payment(1, -345, current_date);

CALL mastery.make_payment(1, 100, current_date);

-- Comprobamos que si se actualizó
SELECT * FROM mastery.invoices 
WHERE invoice_id = 1;

/* Parametros de salida */
DROP PROCEDURE IF EXISTS get_invoices_clients;

CREATE OR REPLACE PROCEDURE mastery.get_invoices_clients 
		(sclient_id INT, number_of_unpaid_invoices OUT INT, 
		 total_unpaid_amount OUT INT)
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
	FROM mastery.invoices
			INTO number_of_unpaid_invoices, total_unpaid_amount
	WHERE client_id = sclient_id AND payment_total = 0;
END
$$;

-- Probamos
CALL mastery.get_invoices_clients(1, 0, 0);
/* Colocamos cero en los parametros de salida porque hay que agregar un valor,
independiente obtendremos el resultado esperado */

/*Variables */

CREATE OR REPLACE PROCEDURE mastery.g_risk_factor()
LANGUAGE plpgsql
AS $$
DECLARE
	risk_factor decimal(9,2) DEFAULT 0;
	invoices_total decimal(9,2);
	invoice_count int;
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
	FROM mastery.invoices 
		INTO invoice_count, invoices_total;
		
	SELECT invoices_total /(invoice_count * 5)
		INTO risk_factor;
END
$$;

CALL mastery.g_risk_factor();

/* Funciones */

CREATE OR REPLACE FUNCTION mastery.get_risk_factor(fclient_id int)
RETURNS int
LANGUAGE plpgsql
AS $$
DECLARE
	risk_factor decimal(9,2) DEFAULT 0;
	invoices_total decimal(9,2);
	invoice_count int;
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
	FROM mastery.invoices 
		INTO invoice_count, invoices_total
	WHERE client_id = fclient_id;
		
	SELECT invoices_total /(invoice_count * 5)
		INTO risk_factor;
	
	RETURN NULLIF(risk_factor, 0);
END
$$;

-- Probando

SELECT client_id, name, mastery.get_risk_factor(2) AS risks
FROM mastery.clients;

/* Si sale este error: la consulta no tiene un destino para los 
datos de resultado 
HINT: Si quiere descartar los resultados de un SELECT, 
utilice PERFORM.

Lo que falta es un declarar una variable a traves de un INTO */











