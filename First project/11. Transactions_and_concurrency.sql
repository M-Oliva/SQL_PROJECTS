-- Transactions and concurrency
/* Las transacciones permiten que se edite sobre el espacio de trabajo
y no se actualiza globalmente hasta que no se de la opción de COMMIT O ROLLBACK */
SELECT * FROM moshstore.orders;

BEGIN;
	INSERT INTO moshstore.orders(order_id, customer_id, order_date, status)
	VALUES
		(11, 1, '2020-04-05', 1);
COMMIT;

-- Transaccion 2
SELECT * FROM moshstore.orders;

BEGIN;
	INSERT INTO moshstore.orders(order_id, customer_id, order_date, status)
	VALUES
		(12, 3, '2023-04-05', 1);	
SAVEPOINT punto1;
	UPDATE moshstore.orders SET customer_id = 5 WHERE order_id = 12;
ROLLBACK TO SAVEPOINT punto1;
COMMIT;
/* Esta opcion permite devolver a lo que originalmente se tenia */











