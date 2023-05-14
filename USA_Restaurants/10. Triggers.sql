/***** TRIGGERS *****/


SELECT * FROM bills.invoices;

SELECT * FROM bills.payments;


/* update total of invoice table, if there is payment 
added to the payment table */

CREATE OR REPLACE FUNCTION bills.payments_ai()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE bills.invoices
		SET payment_total = payment_total + NEW.amount
		WHERE invoice_id = NEW.invoice_id;
	RETURN NEW;
END 
$$;

CREATE TRIGGER payments_after_insert
AFTER INSERT ON bills.payments
	FOR EACH ROW
EXECUTE PROCEDURE bills.payments_ai();

-- Testing

INSERT INTO bills.payments VALUES 
	(10, 5, 3, '2020-04-05', 120, 1);

-- Check

SELECT * FROM bills.payments;
SELECT * FROM bills.invoices;


/* trigger that gets fired when we delete the payment */

DROP TRIGGER IF EXISTS payments_ad ON bills.payments;


CREATE OR REPLACE FUNCTION bills.payments_ad()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE bills.invoices
		SET payment_total = payment_total - OLD.amount
		WHERE invoice_id = OLD.invoice_id;
	RETURN OLD;
END
$$;

CREATE TRIGGER payments_ad
	AFTER DELETE ON bills.payments
	FOR EACH ROW
EXECUTE PROCEDURE bills.payments_ad();
	
-- Testing

DELETE FROM bills.payments WHERE payment_id = 9;

-- Check

SELECT * FROM bills.invoices;
SELECT * FROM bills.payments;
	
	
/* Using Triggers for Auditing */

CREATE TABLE bills.payments_audit(
	client_id int NOT NULL, 
	date DATE NOT NULL,
	amount DECIMAL(9,2) NOT NULL,
	action_type VARCHAR(50) NOT NULL,
	action_date TIMESTAMP NOT NULL
);


/*trigger for auditing records for insert */

CREATE OR REPLACE FUNCTION bills.paymentsaai()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE bills.invoices
		SET payment_total = payment_total + NEW.amount
		WHERE invoice_id = NEW.invoice_id;


	INSERT INTO bills.payments_audit VALUES
		(NEW.client_id, NEW.date, NEW.amount, 'INSERT', NOW());

	RETURN NEW;
END
$$;

CREATE TRIGGER paymentsaai
	AFTER INSERT ON bills.payments
	FOR EACH ROW
EXECUTE PROCEDURE bills.paymentsaai();


/*trigger for auditing records for delete */

CREATE OR REPLACE FUNCTION bills.paymentsad()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE bills.invoices
		SET payment_total = payment_total - OLD.amount
		WHERE invoice_id = OLD.invoice_id;
		
	INSERT INTO bills.payments_audit VALUES
		(OLD.client_id, OLD.date, OLD.amount,'DELETE', NOW());
	
	RETURN OLD;
END
$$;

CREATE TRIGGER paymentsad
	AFTER DELETE ON bills.payments
	FOR EACH ROW
EXECUTE PROCEDURE bills.paymentsad();

-- Testing

SELECT * FROM bills.payments_audit;

INSERT INTO bills.payments VALUES 
	(11, 5, 3,'2020-04-05', 100, 1);

DELETE FROM bills.payments WHERE payment_id = 10;


/* Regular triggers are only tied to a single table and 
allow only DML, event triggers are global to the database
and are capable of handling DDL */
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	