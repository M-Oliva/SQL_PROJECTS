/***** Indexing for high performance *****/

/*
Cost of Indexes
- increase the database
- slow down the writes
- thus, should only reserves for perfromance critical queries
IMPORTANT: design index based on quries, not based on tables
*/

/* Creating the index */

/* check out TYPE and ROWS from explain result. This represents 
how many rows mysql has to check to get the result. ALL is full 
table scan. */

EXPLAIN SELECT customer_id FROM local.customers
WHERE state = 'CA';

CREATE INDEX i_state
ON local.customers(state);


/* find customers with more than 1000 points */

EXPLAIN SELECT customer_id FROM local.customers
WHERE points>1000;

CREATE INDEX i_points
ON local.customers(points);


/* Viewing the index */

/*  ususally use this to calculate and get the 
correct analysis on table */

ANALYZE VERBOSE local.customers;


/* To show all tables */

SELECT * FROM pg_catalog.pg_tables;


/* list indexes of a table */

SELECT * FROM pg_indexes
WHERE tablename = 'customers' 
	AND schemaname = 'local';

SELECT * FROM pg_indexes
WHERE tablename = 'orders' 
	AND schemaname = 'local';


/* Indexing on strings */

/* String columns: CHAR, VARCHA, TEXT, BLOB */

/* how to quickly check optimal value to set for prefix string */

SELECT
	COUNT (DISTINCT LEFT(last_name, 1)),
	COUNT (DISTINCT LEFT(last_name, 5)),
	COUNT (DISTINCT LEFT(last_name, 10))
FROM local.customers;


CREATE INDEX i_last_name
ON local.customers(last_name);














