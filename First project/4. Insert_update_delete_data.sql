-- En este item trabajaremos las inserciones, actualizaciones y eliminación
-- Insertar registros

INSERT INTO moshstore.customers VALUES
	(11,'John', 'Smith', '1990-01-01', NULL, 'etca', 'etcc', 'CA', DEFAULT);

-- Crear copia a una tabla ya creada
CREATE TABLE moshstore.orders_achieved AS
	SELECT * FROM moshstore.orders;
	
SELECT * FROM moshstore.orders_achieved;

TRUNCATE moshstore.orders_achieved;

INSERT INTO moshstore.orders_achieved
	SELECT *
    FROM moshstore.orders
    WHERE order_date < '2019-01-01';
    
/* Copia a la tabla invoice con el nombre del cliente en lugar
del id y con el pago ya realizado */

CREATE TABLE mastery.invoices_achieved AS
	SELECT i.invoice_id, i.number, c.name, i.invoice_total,
			i.payment_total, i.invoice_date, i.due_date, i.payment_date
	FROM mastery.invoices AS i
		INNER JOIN mastery.clients AS c USING (client_id)
	WHERE i.payment_date IS NOT NULL;

-- Actualizamos registros
SELECT * FROM moshstore.orders;

UPDATE moshstore.orders
SET comments = 'blah blah', order_date = '2020-04-01'
WHERE order_id = 1;

-- A todos los clientes nacidos antes de 1990, dar 50 puntos extras
UPDATE moshstore.customers SET points = points + 50
	WHERE EXTRACT(YEAR FROM birth_date) < 1990; 

-- Ahora usaremos la database mastery
UPDATE mastery.invoices SET 
	payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE client_id IN (
	SELECT client_id FROM mastery.clients
	WHERE name ILIKE '%works%'
);

-- Comentarios en gold de clientes que tengan puntos > 3000
UPDATE moshstore.orders SET comments = 'Gold'
WHERE customer_id IN (
	SELECT customer_id FROM moshstore.customers
	WHERE points > 3000
);

-- Comprobamos que se hizo la actualización
SELECT * FROM moshstore.orders;


-- Por ultimo, eliminaremos registros
DELETE FROM moshstore.orders
WHERE order_id = 14; 
/* Es importante colocar una condición en el DELETE
para que no borre la tabla entera */

