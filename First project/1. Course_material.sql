-- Inicialmente se crea las database, despues se pasan a
-- Crear las tablas y se insertan los datos en las mismas.

CREATE TABLE mastery.payment_methods (
	payment_method_id int NOT NULL PRIMARY KEY,
	name varchar(50) NOT NULL
);

INSERT INTO mastery.payment_methods(payment_method_id, name) VALUES
	(1, 'Credit Card'),
	(2, 'Cash'),
	(3, 'PayPal'),
	(4, 'Wire transfer');

SELECT * FROM mastery.payment_methods;


CREATE TABLE mastery.clients (
	client_id serial NOT NULL PRIMARY KEY,
	name varchar(50) NOT NULL,
	address varchar(50) NOT NULL,
	city varchar(50) NOT NULL,
	state char(2) NOT NULL,
	phone varchar(50) DEFAULT NULL
);

INSERT INTO mastery.clients VALUES 
	(1,'Vinte','3 Nevada Parkway','Syracuse','NY','315-252-7305'),
	(2,'Myworks','34267 Glendale Parkway','Huntington','WV','304-659-1170'),
	(3,'Yadel','096 Pawling Parkway','San Francisco','CA','415-144-6037'),
	(4,'Kwideo','81674 Westerfield Circle','Waco','TX','254-750-0784'),
	(5,'Topiclounge','0863 Farmco Road','Portland','OR','971-888-9129')
;

CREATE TABLE mastery.invoices (
	invoice_id serial NOT NULL PRIMARY KEY,
	number varchar(50) NOT NULL,
	client_id int NOT NULL,
	invoice_total decimal(9,2) NOT NULL,
	payment_total decimal(9,2) NOT NULL,
	invoice_date date NOT NULL,
	due_date date NOT NULL,
	payment_date date DEFAULT NULL
);

-- Como se observa, tiene referencia la tabla clients, por tanto
-- se crea una llave foranea para crear la relación
ALTER TABLE mastery.invoices ADD CONSTRAINT invoices_clients
FOREIGN KEY (client_id) REFERENCES mastery.clients(client_id)
ON DELETE RESTRICT ON UPDATE CASCADE;


-- Continuamos con la creación de las tablas

INSERT INTO mastery.invoices VALUES 
(1,'91-953-3396',2,101.79,0.00,'2019-03-09','2019-03-29',NULL),
(2,'03-898-6735',5,175.32,8.18,'2019-06-11','2019-07-01','2019-02-12'),
(3,'20-228-0335',5,147.99,0.00,'2019-07-31','2019-08-20',NULL),
(4,'56-934-0748',3,152.21,0.00,'2019-03-08','2019-03-28',NULL),
(5,'87-052-3121',5,169.36,0.00,'2019-07-18','2019-08-07',NULL),
(6,'75-587-6626',1,157.78,74.55,'2019-01-29','2019-02-18','2019-01-03'),
(7,'68-093-9863',3,133.87,0.00,'2019-09-04','2019-09-24',NULL),
(8,'78-145-1093',1,189.12,0.00,'2019-05-20','2019-06-09',NULL),
(9,'77-593-0081',5,172.17,0.00,'2019-07-09','2019-07-29',NULL),
(10,'48-266-1517',1,159.50,0.00,'2019-06-30','2019-07-20',NULL),
(11,'20-848-0181',3,126.15,0.03,'2019-01-07','2019-01-27','2019-01-11'),
(13,'41-666-1035',5,135.01,87.44,'2019-06-25','2019-07-15','2019-01-26'),
(15,'55-105-9605',3,167.29,80.31,'2019-11-25','2019-12-15','2019-01-15'),
(16,'10-451-8824',1,162.02,0.00,'2019-03-30','2019-04-19',NULL),
(17,'33-615-4694',3,126.38,68.10,'2019-07-30','2019-08-19','2019-01-15'),
(18,'52-269-9803',5,180.17,42.77,'2019-05-23','2019-06-12','2019-01-08'),
(19,'83-559-4105',1,134.47,0.00,'2019-11-23','2019-12-13',NULL);

SELECT * FROM mastery.invoices;


CREATE TABLE mastery.payments (
	payment_id serial NOT NULL PRIMARY KEY,
	client_id int NOT NULL,
	invoice_id int NOT NULL,
	date date NOT NULL,
	amount decimal(9,2) NOT NULL,
	payment_method int NOT NULL
);

ALTER TABLE mastery.payments ADD CONSTRAINT payments_client
FOREIGN KEY (client_id) REFERENCES mastery.clients(client_id)
ON UPDATE CASCADE;

ALTER TABLE mastery.payments ADD CONSTRAINT payments_invoices
FOREIGN KEY (invoice_id) REFERENCES mastery.invoices(invoice_id)
ON UPDATE CASCADE;

ALTER TABLE mastery.payments ADD CONSTRAINT payment_methods
FOREIGN KEY (payment_method) REFERENCES mastery.payment_methods(payment_method_id)
ON UPDATE CASCADE;

INSERT INTO mastery.payments VALUES 
	(1,5,2,'2019-02-12',8.18,1),
	(2,1,6,'2019-01-03',74.55,1),
	(3,3,11,'2019-01-11',0.03,1),
	(4,5,13,'2019-01-26',87.44,1),
	(5,3,15,'2019-01-15',80.31,1),
	(6,3,17,'2019-01-15',68.10,1),
	(7,5,18,'2019-01-08',32.77,1),
	(8,5,18,'2019-01-08',10.00,2);

-- Crearemos una nueva database
--DROP DATABASE IF EXISTS mosh_sql_store;
CREATE SCHEMA moshstore;

-- A partir de aqui usaremos la otra database
-- Se crean las tablas

CREATE TABLE moshstore.products (
	product_id serial NOT NULL PRIMARY KEY,
	name varchar(50) NOT NULL,
	quantity_in_stock int NOT NULL,
	unit_price decimal(4,2) NOT NULL
);

INSERT INTO moshstore.products VALUES
	(1,'Foam Dinner Plate',70,1.21),
	(2,'Pork - Bacon,back Peameal',49,4.65),
	(3,'Lettuce - Romaine, Heart',38,3.35),
	(4,'Brocolinni - Gaylan, Chinese',90,4.53),
	(5,'Sauce - Ranch Dressing',94,1.63),
	(6,'Petit Baguette',14,2.39),
	(7,'Sweet Pea Sprouts',98,3.29),
	(8,'Island Oasis - Raspberry',26,0.74),
	(9,'Longan',67,2.26),
	(10,'Broom - Push',6,1.09);		


CREATE TABLE moshstore.shippers (
	shipper_id serial NOT NULL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);
	
INSERT INTO moshstore.shippers VALUES
	(1,'Hettinger LLC'),
	(2,'Schinner-Predovic'),
	(3,'Satterfield LLC'),
	(4,'Mraz, Renner and Nolan'),
	(5,'Waters, Mayert and Prohaska');


CREATE TABLE moshstore.customers (
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

INSERT INTO moshstore.customers VALUES
	(1,'Babara','MacCaffrey','1986-03-28','781-932-9754','0 Sage Terrace','Waltham','MA',2273),
	(2,'Ines','Brushfield','1986-04-13','804-427-9456','14187 Commercial Trail','Hampton','VA',947),
	(3,'Freddi','Boagey','1985-02-07','719-724-7869','251 Springs Junction','Colorado Springs','CO',2967),
	(4,'Ambur','Roseburgh','1974-04-14','407-231-8017','30 Arapahoe Terrace','Orlando','FL',457),
	(5,'Clemmie','Betchley','1973-11-07',NULL,'5 Spohn Circle','Arlington','TX',3675),
	(6,'Elka','Twiddell','1991-09-04','312-480-8498','7 Manley Drive','Chicago','IL',3073),
	(7,'Ilene','Dowson','1964-08-30','615-641-4759','50 Lillian Crossing','Nashville','TN',1672),
	(8,'Thacher','Naseby','1993-07-17','941-527-3977','538 Mosinee Center','Sarasota','FL',205),
	(9,'Romola','Rumgay','1992-05-23','559-181-3744','3520 Ohio Trail','Visalia','CA',1486),
	(10,'Levy','Mynett','1969-10-13','404-246-3370','68 Lawn Avenue','Atlanta','GA',796);


CREATE TABLE moshstore.order_status (
	order_status_id int NOT NULL PRIMARY KEY,
	name varchar(50) NOT NULL
);

INSERT INTO moshstore.order_status VALUES
	(1,'Processed'),
	(2,'Shipped'),
	(3,'Delivered');

CREATE TABLE moshstore.orders (
	order_id serial NOT NULL PRIMARY KEY,
	customer_id int NOT NULL,
	order_date date NOT NULL,
	status smallint NOT NULL DEFAULT 1,
	comments varchar(2000) DEFAULT NULL,
	shipped_date date DEFAULT NULL,
	shipper_id smallint DEFAULT NULL
);

ALTER TABLE moshstore.orders ADD CONSTRAINT orders_customers
FOREIGN KEY (customer_id) REFERENCES moshstore.customers(customer_id)
ON UPDATE CASCADE;

ALTER TABLE moshstore.orders ADD CONSTRAINT orders_order_status
FOREIGN KEY (status) REFERENCES moshstore.order_status(order_status_id)
ON UPDATE CASCADE;

ALTER TABLE moshstore.orders ADD CONSTRAINT orders_shippers
FOREIGN KEY (shipper_id) REFERENCES moshstore.shippers(shipper_id)
ON UPDATE CASCADE;

INSERT INTO moshstore.orders VALUES
	(1,6,'2019-01-30',1,NULL,NULL,NULL),
	(2,7,'2018-08-02',2,NULL,'2018-08-03',4),
	(3,8,'2017-12-01',1,NULL,NULL,NULL),
	(4,2,'2017-01-22',1,NULL,NULL,NULL),
	(5,5,'2017-08-25',2,'','2017-08-26',3),
	(6,10,'2018-11-18',1,'Aliquam erat volutpat. In congue.',NULL,NULL),
	(7,2,'2018-09-22',2,NULL,'2018-09-23',4),
	(8,5,'2018-06-08',1,'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.',NULL,NULL),
	(9,10,'2017-07-05',2,'Nulla mollis molestie lorem. Quisque ut erat.','2017-07-06',1),
	(10,6,'2018-04-22',2,NULL,'2018-04-23',2);


CREATE TABLE moshstore.order_items(
	order_id serial NOT NULL,
	product_id int NOT NULL,
	quantity int NOT NULL,
	unit_price decimal(4,2) NOT NULL
);

ALTER TABLE moshstore.order_items ADD CONSTRAINT order_items_orders
FOREIGN KEY (order_id) REFERENCES moshstore.orders(order_id)
ON UPDATE CASCADE;

ALTER TABLE moshstore.order_items ADD CONSTRAINT order_items_products
FOREIGN KEY (product_id) REFERENCES moshstore.products(product_id)
ON UPDATE CASCADE;

INSERT INTO moshstore.order_items VALUES
	(1,4,4,3.74),
	(2,1,2,9.10),
	(2,4,4,1.66),
	(2,6,2,2.94),
	(3,3,10,9.12),
	(4,3,7,6.99),
	(4,10,7,6.40),
	(5,2,3,9.89),
	(6,1,4,8.65),
	(6,2,4,3.28),
	(6,3,4,7.46),
	(6,5,1,3.45),
	(7,3,7,9.17),
	(8,5,2,6.94),
	(8,8,2,8.59),
	(9,6,5,7.28),
	(10,1,10,6.01),
	(10,9,9,4.28);	


CREATE TABLE moshstore.order_item_notes (
	note_id int NOT NULL PRIMARY KEY,
	order_id int NOT NULL,
	product_id int NOT NULL,
	note varchar(255) NOT NULL
);

INSERT INTO moshstore.order_item_notes VALUES 
	('1', '1', '2', 'first note'),
	('2', '1', '2', 'second note');


-- Creamos otra database para agregar más datos
--DROP SCHEMA IF EXISTS mshr;
CREATE SCHEMA mshr;

CREATE TABLE IF NOT EXISTS mshr.offices(
	office_id serial NOT NULL PRIMARY KEY,
	address varchar(50) NOT NULL,
	city varchar(50) NOT NULL,
	state varchar(50) NOT NULL
);

INSERT INTO mshr.offices VALUES 
	(1,'03 Reinke Trail','Cincinnati','OH'),
	(2,'5507 Becker Terrace','New York City','NY'),
	(3,'54 Northland Court','Richmond','VA'),
	(4,'08 South Crossing','Cincinnati','OH'),
	(5,'553 Maple Drive','Minneapolis','MN'),
	(6,'23 North Plaza','Aurora','CO'),
	(7,'9658 Wayridge Court','Boise','ID'),
	(8,'9 Grayhawk Trail','New York City','NY'),
	(9,'16862 Westend Hill','Knoxville','TN'),
	(10,'4 Bluestem Parkway','Savannah','GA');		


CREATE TABLE mshr.employees(
	employee_id serial NOT NULL PRIMARY KEY,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	job_title varchar(50) NOT NULL,
	salary int NOT NULL,
	reports_to int DEFAULT NULL,
	office_id int NOT NULL
);

ALTER TABLE mshr.employees ADD CONSTRAINT employees_offices
FOREIGN KEY (office_id) REFERENCES mshr.offices(office_id)
ON UPDATE CASCADE;

INSERT INTO mshr.employees VALUES
	(37270,'Yovonnda','Magrannell','Executive Secretary',63996,NULL,10),
	(33391,'Darcy','Nortunen','Account Executive',62871,37270,1),
	(37851,'Sayer','Matterson','Statistician III',98926,37270,1),
	(40448,'Mindy','Crissil','Staff Scientist',94860,37270,1),
	(56274,'Keriann','Alloisi','VP Marketing',110150,37270,1),
	(63196,'Alaster','Scutchin','Assistant Professor',32179,37270,2),
	(67009,'North','de Clerc','VP Product Management',114257,37270,2),
	(67370,'Elladine','Rising','Social Worker',96767,37270,2),
	(68249,'Nisse','Voysey','Financial Advisor',52832,37270,2),
	(72540,'Guthrey','Iacopetti','Office Assistant I',117690,37270,3),
	(72913,'Kass','Hefferan','Computer Systems Analyst IV',96401,37270,3),
	(75900,'Virge','Goodrum','Information Systems Manager',54578,37270,3),
	(76196,'Mirilla','Janowski','Cost Accountant',119241,37270,3),
	(80529,'Lynde','Aronson','Junior Executive',77182,37270,4),
	(80679,'Mildrid','Sokale','Geologist II',67987,37270,4),
	(84791,'Hazel','Tarbert','General Manager',93760,37270,4),
	(95213,'Cole','Kesterton','Pharmacist',86119,37270,4),
	(96513,'Theresa','Binney','Food Chemist',47354,37270,5),
	(98374,'Estrellita','Daleman','Staff Accountant IV',70187,37270,5),
	(115357,'Ivy','Fearey','Structural Engineer',92710,37270,5);

-- Procedemos con otra database
DROP SCHEMA IF EXISTS msiv;
CREATE SCHEMA msiv;

CREATE TABLE msiv.products (
	product_id serial NOT NULL PRIMARY KEY,
	name varchar(50) NOT NULL,
	quantity_in_stock smallint NOT NULL,
	unit_price decimal(4,2) NOT NULL
);

INSERT INTO msiv.products VALUES 
	(1,'Foam Dinner Plate',70,1.21),
	(2,'Pork - Bacon,back Peameal',49,4.65),
	(3,'Lettuce - Romaine, Heart',38,3.35),
	(4,'Brocolinni - Gaylan, Chinese',90,4.53),
	(5,'Sauce - Ranch Dressing',94,1.63),
	(6,'Petit Baguette',14,2.39),
	(7,'Sweet Pea Sprouts',98,3.29),
	(8,'Island Oasis - Raspberry',26,0.74),
	(9,'Longan',67,2.26),
	(10,'Broom - Push',6,1.09);

-- Creamos la database del blog
--DROP SCHEMA IF EXISTS blog;
CREATE SCHEMA blog;

CREATE TABLE blog.posts (
	post_id serial NOT NULL PRIMARY KEY,
	title varchar(255) NOT NULL,
	body text NOT NULL,
	date_publlished timestamp DEFAULT NULL
);

-- Corrijo un error de escritura a continuación
ALTER TABLE blog.posts RENAME date_publlished TO date_published;

INSERT INTO blog.posts (title, body, date_published) VALUES 
	('Handling a Form in React', 'Web applications often need to send data from browser to the backend server. Certainly, the most used way of doing so is through a HTML form, by using text inputs, radio buttons, checkboxes, selects and so on. This remains true in React. Are you looking how to handle forms in React? If so, this article is a great fit for you. Have a good read.', '2019-01-01'),
	('What JavaScript Framework You Should Learn to Get a Job in 2019?', 'Are you wondering what JavaScript framework or library you should use to land a job in 2019? In this post, I am going to go over a comparison of the most popular JavaScript frameworks that are available today. By the end of this post, you will be ready to pick the right framework to help you land a front-end developer job in 2019.', '2019-03-02'),
	('Building an Accessible React Modal Component', 'Modal is an overlay on the web-page, but has some standards to follow. WAI-ARIA Authoring Practices are the standards set by W3C. This lets bots and screen-readers know that it is a modal. It is not within the regular flow of the page. We’ll create an awesome react modal using React components.', '2019-01-15'),
	('Redux Vs. Mobx – What Should I Pick For My Web App?', 'State management is a hard problem to solve in large applications. Redux and Mobx are both external libraries that are popularly used to solve state management problems.', '2019-02-20'),
	('Stateful and Stateless Components in React', 'Today, we’re going to review what stateful and stateless components are in React, how you can tell the difference, and the complex process of deciding whether to make components stateful or not.', '2019-03-29');











