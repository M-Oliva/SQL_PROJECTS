-- Designing databases

CREATE SCHEMA IF NOT EXISTS sql_store;

-- Usaremos la db de sql_store

CREATE TABLE IF NOT EXISTS sql_store.customers(
	customer_id SERIAL PRIMARY KEY,
	first_name varchar(50) NOT NULL, 
	email varchar(255) NOT NULL UNIQUE
);

/* Modificando la tabla */

ALTER TABLE sql_store.customers
	DROP COLUMN email,
	ADD last_name varchar(50) NOT NULL,
	ADD email varchar(255) NOT NULL UNIQUE;

ALTER TABLE sql_store.customers
	DROP COLUMN email,
	ADD points int NOT NULL,
	ADD email varchar(255) NOT NULL UNIQUE;

ALTER TABLE sql_store.customers
	ALTER COLUMN points SET DEFAULT 0;

/* Creando relaciones */

CREATE TABLE sql_store.orders(
	order_id SERIAL PRIMARY KEY, 
	customer_id int NOT NULL
);

ALTER TABLE sql_store.orders ADD CONSTRAINT order_customers
FOREIGN KEY (customer_id) REFERENCES sql_store.customers(customer_id)
ON UPDATE CASCADE
ON DELETE NO ACTION;


/* Modificando llaves primarias y foraneas */

ALTER TABLE sql_store.orders 
		DROP CONSTRAINT orders_pkey,
	ADD PRIMARY KEY (order_id),
		DROP CONSTRAINT order_customers,
	ADD CONSTRAINT orders_customers 
		FOREIGN KEY (customer_id) REFERENCES sql_store.customers(customer_id)
			ON UPDATE CASCADE ON DELETE NO ACTION;
















