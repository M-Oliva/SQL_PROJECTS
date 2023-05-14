/* Material */

/* Empezaremos creando las tablas necesarias para el proyecto */

CREATE TABLE public.accounts(
	id serial NOT NULL PRIMARY KEY,
	name varchar NOT NULL,
	website varchar,
	lat numeric,
	long numeric,
	primary_poc varchar,
	sales_rep_id int
);

CREATE TABLE public.orders(
	id serial NOT NULL PRIMARY KEY,
	account_id int NOT NULL,
	ocurred_at timestamp without time zone NOT NULL,
	standard_qty int,
	gloss_qty int,
	poster_qty int,
	total int,
	stadard_amt_usd numeric,
	gloss_amt_usd numeric,
	poster_amt_usd numeric,
	total_amt_usd numeric
);


CREATE TABLE public.region(
	id serial NOT NULL PRIMARY KEY,
	name varchar NOT NULL
);


CREATE TABLE public.sales_reps(
	id serial NOT NULL PRIMARY KEY,
	name varchar NOT NULL,
	region_id int NOT NULL
);


CREATE TABLE public.web_events(
	id serial NOT NULL PRIMARY KEY,
	account_id int NOT NULL,
	ocurred_at timestamp without time zone NOT NULL,
	channel varchar NOT NULL
);


-- Añadiremos las foreign keys

ALTER TABLE public.accounts ADD CONSTRAINT accounts_sales
FOREIGN KEY (sales_rep_id) REFERENCES public.sales_reps(id)
ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE public.orders ADD CONSTRAINT orders_accounts
FOREIGN KEY (account_id) REFERENCES public.accounts(id)
ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE public.web_events ADD CONSTRAINT web_accounts
FOREIGN KEY (account_id) REFERENCES public.accounts(id)
ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE public.sales_reps ADD CONSTRAINT sales_region
FOREIGN KEY (region_id) REFERENCES public.region(id)
ON UPDATE CASCADE ON DELETE CASCADE;

