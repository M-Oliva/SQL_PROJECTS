/***** TRANSACTIONS AND CONCURRENCY *****/


/* Transactions allow editing on the workspace and are not updated 
globally until the COMMIT OR ROLLBACK option is given */

SELECT * FROM local.orders;

BEGIN;
	INSERT INTO local.orders(order_id, customer_id, order_date, status)
	VALUES
		(11, 1, '2020-04-05', 1);
COMMIT;


-- Transaction 2

SELECT * FROM local.orders;

BEGIN;
	INSERT INTO local.orders(order_id, customer_id, order_date, status)
	VALUES
		(12, 3, '2023-04-05', 1);	
SAVEPOINT punto1;
	UPDATE local.orders SET customer_id = 5 WHERE order_id = 12;
ROLLBACK TO SAVEPOINT punto1;
COMMIT;

/* This option allows you to return to what you originally had */










