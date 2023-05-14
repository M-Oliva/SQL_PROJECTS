/********** SQL advanced JOINS **********/

/*Say you're an analyst at Parch & Posey and you want to see:
each account who has a sales rep and each sales rep that has an account 
(all of the columns in these returned rows will be full)
but also each account that does not have a sales rep and each sales rep that does not have an account 
(some of the columns in these returned rows will be empty)*/

SELECT a.id, a.name AS accounts, s.id, s.name AS sales_reps
FROM accounts AS a
	FULL OUTER JOIN sales_reps AS s ON a.sales_rep_id = s.id;


/* To see rows where 1) Companies without sales rep OR 2)sales rep without accouts */

SELECT a.id, a.name AS accounts, s.id, s.name AS sales_reps
FROM accounts AS a
	FULL OUTER JOIN sales_reps AS s ON a.sales_rep_id = s.id
WHERE a.id IS NULL OR s.id IS NULL;


/*Inequality Join
 write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number 
 and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so:
accounts.primary_poc < sales_reps.name
The query results should be a table with three columns: 
the account name (e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski), 
and the sales representative's name (e.g. Samuel Racine)*/

SELECT a.name AS account, a.primary_poc AS primary_contact, s.name AS representatives_name
FROM accounts AS a
	LEFT JOIN sales_reps AS s ON a.sales_rep_id = s.id
		AND a.primary_poc < s.name;


/* UNION ALL vs UNION */
/*Nice! UNION only appends distinct values. 
More specifically, when you use UNION, the dataset is appended, and any rows in the appended table 
that are exactly identical to rows in the first table are dropped. 
If you’d like to append all the values from the second table, use UNION ALL. 
You’ll likely use UNION ALL far more often than UNION.*/

SELECT * FROM accounts
	WHERE name ILIKE 'WALMART'
UNION ALL
SELECT * FROM accounts
	WHERE name ILIKE 'DISNEY';

/*Perform the union in your first query (under the Appending Data via UNION header) in a common table expression and 
name it double_accounts. Then do a COUNT the number of times a name appears in the double_accounts table. 
If you do this correctly, your query results should have a count of 2 for each name.*/

WITH d_ac AS(
				SELECT * FROM accounts AS a1
				UNION ALL
				SELECT * FROM accounts AS a2
)

SELECT name, COUNT(*)
FROM d_ac
GROUP BY 1
ORDER BY 1;













