-- Triggers

SELECT * FROM mastery.invoices;

SELECT * FROM mastery.payments;

/* Actualizar el total de la tabla de facturas, si hay un
pago añadido a la tabla de pagos */

CREATE OR REPLACE FUNCTION mastery.payments_ai()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE mastery.invoices
		SET payment_total = payment_total + NEW.amount
		WHERE invoice_id = NEW.invoice_id;
	RETURN NEW;
END 
$$;

CREATE TRIGGER payments_after_insert
AFTER INSERT ON mastery.payments
	FOR EACH ROW
EXECUTE PROCEDURE mastery.payments_ai();

-- Probando
INSERT INTO mastery.payments VALUES 
	(10, 5, 3, '2020-04-05', 120, 1);

-- Verificamos
SELECT * FROM mastery.payments;
SELECT * FROM mastery.invoices;

/* Trigger para cuando eliminamos el pago */

DROP TRIGGER IF EXISTS payments_ad ON mastery.payments;


CREATE OR REPLACE FUNCTION mastery.payments_ad()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE mastery.invoices
		SET payment_total = payment_total - OLD.amount
		WHERE invoice_id = OLD.invoice_id;
	RETURN OLD;
END
$$;

CREATE TRIGGER payments_ad
	AFTER DELETE ON mastery.payments
	FOR EACH ROW
EXECUTE PROCEDURE mastery.payments_ad();
	
-- Probamos
DELETE FROM mastery.payments WHERE payment_id = 9;

-- Verificamos
SELECT * FROM mastery.invoices;
SELECT * FROM mastery.payments;
	
	
/* Usando triggers para auditoria */
CREATE TABLE mastery.payments_audit(
	client_id int NOT NULL, 
	date DATE NOT NULL,
	amount DECIMAL(9,2) NOT NULL,
	action_type VARCHAR(50) NOT NULL,
	action_date TIMESTAMP NOT NULL
);

/* Trigger para auditar records para cada insert */
CREATE OR REPLACE FUNCTION mastery.paymentsaai()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE mastery.invoices
		SET payment_total = payment_total + NEW.amount
		WHERE invoice_id = NEW.invoice_id;


	INSERT INTO mastery.payments_audit VALUES
		(NEW.client_id, NEW.date, NEW.amount, 'INSERT', NOW());

	RETURN NEW;
END
$$;

CREATE TRIGGER paymentsaai
	AFTER INSERT ON mastery.payments
	FOR EACH ROW
EXECUTE PROCEDURE mastery.paymentsaai();


/* Triggers para auditar registros para eliminar */

CREATE OR REPLACE FUNCTION mastery.paymentsad()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE mastery.invoices
		SET payment_total = payment_total - OLD.amount
		WHERE invoice_id = OLD.invoice_id;
		
	INSERT INTO mastery.payments_audit VALUES
		(OLD.client_id, OLD.date, OLD.amount,'DELETE', NOW());
	
	RETURN OLD;
END
$$;

CREATE TRIGGER paymentsad
	AFTER DELETE ON mastery.payments
	FOR EACH ROW
EXECUTE PROCEDURE mastery.paymentsad();

-- Probando
SELECT * FROM mastery.payments_audit;

INSERT INTO mastery.payments VALUES 
	(11, 5, 3,'2020-04-05', 100, 1);


DELETE FROM mastery.payments WHERE payment_id = 10;

/* Continuamos con los EVENTOS */
	
/* Los triggers regulares solo estan atados a una sola tabla
y permite solo DML, los events triggers son globales a la 
database y son capaces de manejar DDL */
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	




