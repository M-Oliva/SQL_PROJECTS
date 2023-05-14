/***** DATA DEFINITION LANGUAGE *****/

/* 
First, the databases are created. */

CREATE SCHEMA blogs;

CREATE SCHEMA bills;

CREATE SCHEMA local;

CREATE SCHEMA staff;

/*
Then the tables are created and the data is inserted into it
*/

CREATE TABLE bills.payment_methods(
	pm_id smallint NOT NULL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);

INSERT INTO bills.payment_methods VALUES
	(1,'Cash'),
	(2,'Credit card'),
	(3,'Debit card'),
	(4,'Wire transfer');

SELECT * FROM bills.payment_methods;

--- Customers are the main shareholders

CREATE TABLE bills.clients(
	client_id serial NOT NULL PRIMARY KEY,
	name varchar(50) NOT NULL,
	address varchar(50) NOT NULL,
	city varchar(50) NOT NULL,
	state varchar(2) NOT NULL,
	phone varchar(50)  NULL
);

INSERT INTO bills.clients VALUES 
	(1,'Carmelia Comins','0094 Warrior Trail','Phoenix','AZ','204-346-5409'),
	(2,'Dulciana Causbey','0747 Russell Drive','Sacramento','CA','234-461-4569'),
	(3,'Justino Lantuffe','66 Mcguire Drive','Santa Fe','NM','325-391-3182'),
	(4,'Jedd Handslip','6 Wayridge Street','Denver','CO','993-865-9486'),
	(5,'Brit McInally','76 Scofield Alley','Carson City','NV','468-953-1271');

SELECT * FROM bills.clients;

---

CREATE TABLE bills.invoices (
	invoice_id serial NOT NULL PRIMARY KEY,
	number varchar(50) NOT NULL,
	client_id int NOT NULL,
	invoice_total decimal(9,2) NOT NULL,
	payment_total decimal(9,2) NOT NULL,
	invoice_date date NOT NULL,
	due_date date NOT NULL,
	payment_date date DEFAULT NULL
);

-- A foreign key must be created

ALTER TABLE bills.invoices ADD CONSTRAINT invoices_clients
FOREIGN KEY (client_id) REFERENCES bills.clients(client_id)
ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO bills.invoices VALUES
	(1,'96-082-4954',2,179.56,28.95,'2022-05-27','2022-06-19',NULL),
	(2,'03-328-8731',4,189.91,27.81,'2022-12-19','2022-04-23','2022-08-27'),
	(3,'42-226-7611',5,151.29,40.09,'2023-04-07','2022-06-28',NULL),
	(4,'00-469-8050',1,165.27,21.76,'2022-04-27','2022-11-14','2022-09-07'),
	(5,'37-845-3063',2,151.9,13.33,'2023-03-12','2022-07-20',NULL),
	(6,'10-928-7026',1,167.22,60.64,'2022-07-04','2022-11-26',NULL),
	(7,'97-634-6747',1,199.95,82.21,'2022-08-12','2023-01-02','2022-08-19'),
	(8,'82-197-3646',5,157.95,49.42,'2023-01-19','2023-02-20','2023-01-24'),
	(9,'19-323-8170',5,158.92,10.21,'2022-08-02','2022-10-16','2022-04-23'),
	(10,'12-055-8878',2,179.78,24.93,'2022-05-25','2023-03-02',NULL),
	(11,'13-657-1665',2,193.97,11.47,'2022-07-01','2022-06-20',NULL),
	(12,'77-126-0441',2,172.05,38.04,'2022-04-16','2022-08-02',NULL),
	(13,'45-917-6515',1,181.82,80.49,'2023-03-29','2023-03-13','2023-01-27'),
	(14,'88-500-8831',3,195.42,6.77,'2023-03-08','2022-05-26','2022-11-02'),
	(15,'41-011-0858',2,178.87,50.14,'2022-10-03','2022-04-25','2023-02-22'),
	(16,'64-742-3286',5,172.32,27.49,'2023-02-28','2023-03-04',NULL),
	(17,'67-264-4032',3,173.93,72.09,'2022-07-16','2023-04-04','2023-02-15'),
	(18,'48-874-5960',2,184.34,10.55,'2022-05-28','2022-11-30','2022-07-25'),
	(19,'99-611-4819',3,154.47,5.43,'2022-08-31','2022-10-21',NULL);

SELECT * FROM bills.invoices;

---

CREATE TABLE bills.payments (
	payment_id serial NOT NULL PRIMARY KEY,
	client_id int NOT NULL,
	invoice_id int NOT NULL,
	date date NOT NULL,
	amount decimal(9,2) NOT NULL,
	payment_method int NOT NULL
);

ALTER TABLE bills.payments ADD CONSTRAINT payments_client
FOREIGN KEY (client_id) REFERENCES bills.clients(client_id)
ON UPDATE CASCADE;

ALTER TABLE bills.payments ADD CONSTRAINT payments_invoices
FOREIGN KEY (invoice_id) REFERENCES bills.invoices(invoice_id)
ON UPDATE CASCADE;

ALTER TABLE bills.payments ADD CONSTRAINT payment_methods
FOREIGN KEY (payment_method) REFERENCES bills.payment_methods(pm_id)
ON UPDATE CASCADE;

INSERT INTO bills.payments VALUES
	(1,1,18,'2022-12-15',31.67,2),
	(2,1,12,'2022-10-12',4.02,1),
	(3,5,2,'2023-02-04',35.42,1),
	(4,2,17,'2022-04-16',43.16,2),
	(5,3,9,'2023-02-04',28.64,3),
	(6,4,6,'2022-12-15',83.35,3),
	(7,3,13,'2023-02-22',70.31,4),
	(8,2,5,'2022-05-13',72.52,2);

SELECT * FROM bills.payments;

---

CREATE TABLE local.products (
	product_id serial NOT NULL PRIMARY KEY,
	name varchar(50) NOT NULL,
	quantity_in_stock int NOT NULL,
	unit_price decimal(4,2) NOT NULL
);

INSERT INTO local.products VALUES
	(1,'tomato soup',19,2.90),
	(2,'soda - vodka',10,3.30),
	(3,'german sausage and chips',12,6.50),
	(4,'grilled fish and potatoes',17,6.25),
	(5,'italian cheese & tomato pizza',16,4.85),
	(6,'thai chicken and rice',11,5.95),
	(7,'vegetable pasta',13,4.85),
	(8,'roast chicken and potatoes',16,5.95),
	(9,'turkey and ham pie',18,10.00),
	(10,'chicken salad',12,7.55);

SELECT * FROM local.products;

---

CREATE TABLE local.shippers (
	shipper_id serial NOT NULL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);
	
INSERT INTO local.shippers VALUES
	(1,'Weimann, Heaney and Steuber'),
	(2,'Hermiston-Bahringer'),
	(3,'Stehr LLC'),
	(4,'Nolan-Price'),
	(5,'Emard, Goyette and Kuhlman');

SELECT * FROM local.shippers;

---

CREATE TABLE local.customers (
	customer_id serial NOT NULL PRIMARY KEY,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	birth_date date DEFAULT NULL,
	phone varchar(50) DEFAULT NULL,
	address varchar(50) NOT NULL,
	city varchar(50) NOT NULL,
	state char(2) NOT NULL,
	points int NOT NULL DEFAULT '0'
);

INSERT INTO local.customers VALUES
	(1, 'Andie', 'Smithers', '1983-12-24', '916-414-5568', '4 Maple Wood Court', 'Phoenix','AZ', 3542),
	(2, 'Deerdre', 'McAleese', '1981-09-07', '968-534-5241', '7681 Pankratz Place', 'Sacramento','CA', 3330),
	(3, 'Marlow', 'Jillitt', '1980-06-28', '866-480-3692', '3326 Nelson Court', 'Santa FE','NM', 2947),
	(4, 'Licha', 'Copeland', '1980-08-30', '786-428-6811', '26377 Loomis Alley', 'Carson City','NV', 614),
	(5, 'Trisha', 'Singers', '1984-10-30', '708-696-1589', '1 Bunker Hill Lane', 'Denver', 'CO', 3451),
	(6, 'Englebert', 'Simpkins', '1965-09-29', NULL, '83674 Arapahoe Road', 'Las Vegas', 'NV', 1430),
	(7, 'Stillmann', 'Mandel', '2000-10-01', '189-592-6038', '867 Starling Way', 'Roswell', 'NM', 1971),
	(8, 'Suzanne', 'Magwood', '1983-04-13', '131-554-5823', '229 Stang Center', 'Aspen','CO', 2994),
	(9, 'Sherwynd', 'Johannesson', '1965-04-03', '719-878-9662', '502 La Follette Crossing', 'Los Angeles', 'CA', 3208),
	(10, 'Amelita', 'Comettoi', '1965-11-08', '252-826-0323', '18651 Crest Line Plaza', 'Phoenix', 'AZ', 618);

SELECT * FROM local.customers;

---

CREATE TABLE local.order_status (
	order_status_id int NOT NULL PRIMARY KEY,
	name varchar(50) NOT NULL
);

INSERT INTO local.order_status VALUES
	(1,'Processed'),
	(2,'Shipped'),
	(3,'Delivered');

SELECT * FROM local.order_status;

---

CREATE TABLE local.orders (
	order_id serial NOT NULL PRIMARY KEY,
	customer_id int NOT NULL,
	order_date date NOT NULL,
	status smallint NOT NULL DEFAULT 1,
	comments varchar(2000) DEFAULT NULL,
	shipped_date date DEFAULT NULL,
	shipper_id smallint DEFAULT NULL
);

ALTER TABLE local.orders ADD CONSTRAINT orders_customers
FOREIGN KEY (customer_id) REFERENCES local.customers(customer_id)
ON UPDATE CASCADE;

ALTER TABLE local.orders ADD CONSTRAINT orders_order_status
FOREIGN KEY (status) REFERENCES local.order_status(order_status_id)
ON UPDATE CASCADE;

ALTER TABLE local.orders ADD CONSTRAINT orders_shippers
FOREIGN KEY (shipper_id) REFERENCES local.shippers(shipper_id)
ON UPDATE CASCADE;

INSERT INTO local.orders VALUES
	(1,8,'2022-08-26',2,NULL,NULL,NULL),
	(2,2,'2022-12-06',1,NULL,'2022-12-07',5),
	(3,6,'2023-01-14',2,NULL,NULL,NULL),
	(4,7,'2022-06-12',2,NULL,NULL,NULL),
	(5,10,'2022-11-02',3,'','2022-11-02',2),
	(6,9,'2022-09-08',2,'The live music gave a plus.',NULL,NULL),
	(7,5,'2022-08-25',1,NULL,'2022-08-25',3),
	(8,2,'2023-04-01',3,'The chicken was a bit dry, improve customer service.',NULL,NULL),
	(9,6,'2022-06-28',2,'Delicious dishes, but they took a while to arrive.','2022-06-28',2),
	(10,3,'2022-07-11',1,NULL,'2022-07-12',1);

SELECT * FROM local.orders;

---

CREATE TABLE local.order_items(
	order_id serial NOT NULL,
	product_id int NOT NULL,
	quantity int NOT NULL,
	unit_price decimal(4,2) NOT NULL
);

ALTER TABLE local.order_items ADD CONSTRAINT order_items_orders
FOREIGN KEY (order_id) REFERENCES local.orders(order_id)
ON UPDATE CASCADE;

ALTER TABLE local.order_items ADD CONSTRAINT order_items_products
FOREIGN KEY (product_id) REFERENCES local.products(product_id)
ON UPDATE CASCADE;

INSERT INTO local.order_items VALUES
	(1,2,7,9.51),
	(1,7,20,19.64),
	(2,10,7,10.89),
	(3,4,14,4.71),
	(3,8,12,17.51),
	(4,7,10,11.28),
	(5,1,20,7.4),
	(5,7,14,19.77),
	(5,3,11,15.32),
	(6,6,7,19.06),
	(6,4,19,16.27),
	(7,2,18,18.81),
	(7,4,11,4.02),
	(8,10,20,10.02),
	(9,3,9,9.65),
	(9,7,11,5.86),
	(10,1,18,6.77),
	(10,9,15,4.45);

SELECT * FROM local.order_items;

---

CREATE TABLE local.order_item_notes (
	note_id int NOT NULL PRIMARY KEY,
	order_id int NOT NULL,
	product_id int NOT NULL,
	note varchar(255) NOT NULL
);

INSERT INTO local.order_item_notes VALUES 
	('1', '1', '2', 'first note'),
	('2', '1', '2', 'second note');

SELECT * FROM local.order_item_notes;

---

CREATE TABLE IF NOT EXISTS staff.offices(
	office_id serial NOT NULL PRIMARY KEY,
	address varchar(50) NOT NULL,
	city varchar(50) NOT NULL,
	state varchar(50) NOT NULL
);

INSERT INTO staff.offices VALUES 
	(1,'4 Merrick Way','Phoenix','AZ'),
	(2,'029 Ramsey Alley','Sacramento','CA'),
	(3,'61797 Meadow Valley Alley','Denver','CO'),
	(4,'3 Arizona Plaza','Santa Fe','NM'),
	(5,'74980 Garrison Street','Sacramento','CA'),
	(6,'74 Cardinal Way','Carson City','NV'),
	(7,'97095 8th Alley','Denver','CO'),
	(8,'9781 Becker Drive','Phoenix','AZ'),
	(9,'8658 Dapin Street','Carson City','NV'),
	(10,'1 Hanover Plaza','Santa Fe','NM');

SELECT * FROM staff.offices;

---

CREATE TABLE staff.employees(
	employee_id serial NOT NULL PRIMARY KEY,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	job_title varchar(50) NOT NULL,
	salary int NOT NULL,
	reports_to int DEFAULT NULL,
	office_id int NOT NULL
);

ALTER TABLE staff.employees ADD CONSTRAINT employees_offices
FOREIGN KEY (office_id) REFERENCES staff.offices(office_id)
ON UPDATE CASCADE;


INSERT INTO staff.employees VALUES
	(72513,'Ansel','Francescoccio','Manager',120000,NULL,7),
	(70210,'Hanson','Sebborn','Administrator',100000,72513,10),
	(64369,'Skipton','Bowry','Executive chef',95000,70210,7),
	(68126,'Eustace','Ilson','Kitchen manager',90000,64369,9),
	(81381,'Roz','Bahl','Sous chef',85000,64369,5),
	(65974,'Mina','Greatorex','Cooks',80000,64369,4),
	(45796,'Fernande','Slym','Assistant cooks',65000,65974,3),
	(93474,'Karoly','Howat','Cleaning team',70000,70210,4),
	(42070,'Marget','Heighway','Head waiter',80000,70210,4),
	(95439,'Umberto','Penney','Recepcionist',72000,42070,10),
	(67681,'Orsola','Ghilks','Sommelier',72000,42070,4),
	(51908,'Jannel','Hriinchenko','Cleaning team',70000,70210,8),
	(61988,'Mozes','Gawthrope','Recepcionist',72000,42070,1),
	(81126,'Farlie','Willis','Waiters',70500,42070,8),
	(86014,'Spence','Flegg','Waiters',70500,42070,3),
	(52457,'Kamila','Hanmer','Waiters',70500,42070,8),
	(91432,'Kristina','Sergent','Waiters',70500,42070,1),
	(67899,'Kirby','Evason','Cleaning team',70000,70210,1),
	(59214,'Carolann','Bradman','Waiters',70500,42070,7),
	(74601,'Currey','Werendell','Cleaning team',70000,70210,2);

SELECT * FROM staff.employees;

---

CREATE TABLE blogs.posts (
	post_id serial NOT NULL PRIMARY KEY,
	title varchar(255) NOT NULL,
	body text NOT NULL,
	date_publlished timestamp DEFAULT NULL
);

-- Fixed a typing error below
ALTER TABLE blogs.posts RENAME date_publlished TO date_published;

INSERT INTO blogs.posts (title, body, date_published) VALUES 
	('Fish Friday Absolute Essentials', 'Lean protein? Check. Your choice of salmon or tuna? Check. Lots of delicious flavors? Yep, check and checkmate. StarKist Creations pouches have everything you need to win your day and achieve those', '2022-06-05'),
	('GreenWise Market Has Made-to-Order Meals','Explore made-to-order meals for all tastes.', '2023-03-29'),
	('Tango with a mango.','With the perfect blend of real fruit and creamy yoghurt, noosas new mango Fruit Smoothies are amazingly delicious.', '2022-09-23'),
	('A program to feast on', 'It will be hot hot! Its the Tacos Festival this summer at Benny&Co. Which one are you feeling?', '2022-11-11'),
	('Deliciously Simple','Absolut Vodka is the leading brand of premium vodka offering the true taste of vodka in original or your favorite flavor made from all natural ingredients.', '2023-01-09');






