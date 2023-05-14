/***** Material *****/


/* the tables are created */

CREATE TABLE products (
	product_id serial NOT NULL PRIMARY KEY,
	product_name varchar(50) NOT NULL,
	product_category varchar(50) NOT NULL,
	product_cost decimal(5,2) NOT NULL,
	product_price decimal(5,2) NOT NULL
);


CREATE TABLE stores (
	store_id serial NOT NULL PRIMARY KEY,
	store_name varchar(50) NOT NULL,
	store_city varchar(50) NOT NULL,
	store_location varchar(50) NOT NULL,
	store_open_date date
);


CREATE TABLE sales (
	sales_id serial NOT NULL PRIMARY KEY,
	date date,
	store_id int NOT NULL,
	product_id int NOT NULL,
	units int
);


CREATE TABLE inventory (
	store_id int NOT NULL,
	product_id int NOT NULL,
	stock_on_hand int DEFAULT NULL
);


-- Add foreign keys

ALTER TABLE sales ADD CONSTRAINT product_sales
FOREIGN KEY (product_id) REFERENCES products(product_id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE sales ADD CONSTRAINT stores_sales
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE inventory ADD CONSTRAINT product_inventory
FOREIGN KEY (product_id) REFERENCES products(product_id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE inventory ADD CONSTRAINT inventory_sales
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE CASCADE ON UPDATE CASCADE;

















