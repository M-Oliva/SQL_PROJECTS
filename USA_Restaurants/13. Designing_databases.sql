/***** Designing databases *****/


CREATE SCHEMA IF NOT EXISTS sql_store;


/* Creating tables */

CREATE TABLE IF NOT EXISTS sql_store.customers(
	customer_id SERIAL PRIMARY KEY,
	first_name varchar(50) NOT NULL, 
	email varchar(255) NOT NULL UNIQUE
);


/* Altering tables */

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


/* Creating relationship */

CREATE TABLE sql_store.orders(
	order_id SERIAL PRIMARY KEY, 
	customer_id int NOT NULL
);

ALTER TABLE sql_store.orders ADD CONSTRAINT order_customers
FOREIGN KEY (customer_id) REFERENCES sql_store.customers(customer_id)
ON UPDATE CASCADE
ON DELETE NO ACTION;


/* Altering Primary and Foreign Keys */

ALTER TABLE sql_store.orders 
		DROP CONSTRAINT orders_pkey,
	ADD PRIMARY KEY (order_id),
		DROP CONSTRAINT order_customers,
	ADD CONSTRAINT orders_customers 
		FOREIGN KEY (customer_id) REFERENCES sql_store.customers(customer_id)
			ON UPDATE CASCADE ON DELETE NO ACTION;















