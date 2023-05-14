/************** DATA CLEANING ***************/

/*1) In the accounts table, there is a column holding the website for each company.
The last three digits specify what type of web address they are using. 
A list of extensions (and pricing) is provided at https://iwantmyname.com/domains. 
Pull these extensions and provide how many of each website type exist in the accounts table. */

SELECT RIGHT(website, 3) AS domain_name, COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/*2) There is much debate about how much the name (or even the first letter of a company name) matters. 
Use the accounts table to pull the first letter of each company name to see 
the distribution of company names that begin with each letter (or number).*/

SELECT LEFT(name, 1) AS first_letter, COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/*3) Use the accounts table and a CASE statement to create two groups: 
one group of company names that start with a number 
and a second group of those company names that start with a letter. 
What proportion of company names start with a letter?*/

SELECT SUM(numero) AS numero, SUM(letra) AS letra
FROM (	
	SELECT name, 
			CASE
				WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1
				ELSE 0
			END AS numero,
			CASE
				WHEN LEFT(UPPER(name), 1)  NOT IN ('0','1','2','3','4','5','6','7','8','9') THEN 1
				ELSE 0
			END AS letra
	FROM accounts) AS tb1;
	  

/*4) Consider vowels as a, e, i, o, and u. 
What proportion of company names start with a vowel, and what percent start with anything else?*/

SELECT ROUND(SUM(vocal)*100/SUM(conteo),1) AS vowel, 
		ROUND(SUM(consonante)*100/SUM(conteo),1) AS consonant
FROM (	
	SELECT name, COUNT(*) AS conteo,
			CASE
				WHEN LEFT(LOWER(name), 1) IN ('a','e','i','o','u') THEN 1
				ELSE 0
			END AS vocal,
			CASE
				WHEN LEFT(LOWER(name), 1) NOT IN ('a','e','i','o','u') THEN 1
				ELSE 0
			END AS consonante
	FROM accounts
	GROUP BY 1) AS tb1;

/****** POSITION & STRPOS *************/

/*1)Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.*/

SELECT primary_poc,
		LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) AS first_name,
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS last_name
FROM accounts;

-- o tambien

SELECT primary_poc, SPLIT_PART(primary_poc,' ',1) AS first_name, 
		SPLIT_PART(primary_poc,' ',2) AS last_name 
FROM accounts;

/*2) Now see if you can do the same thing for every rep name in the sales_reps table. 
Again provide first and last name columns.*/


SELECT name, SPLIT_PART(name, ' ', 1) AS first_name,
		SPLIT_PART(name, ' ', 2) AS last_name
FROM sales_reps;

SELECT name,
		LEFT(name, STRPOS(name,' ') - 1) AS first_name,
		RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS last_name
FROM sales_reps;


/****** CONCATE or || *************/

/*1/2)Each company in the accounts table wants to create an email address for each primary_poc. 
The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.*/

SELECT primary_poc, name,
		CONCAT(
			SPLIT_PART(LOWER(primary_poc), ' ', 1),'.',
			SPLIT_PART(LOWER(primary_poc), ' ', 2),'@', 
			REPLACE(LOWER(name), ' ', ''),'.com') AS company_email
FROM accounts;


/*We would also like to create an initial password, which they will change after their first log in. 
The first password will be the first letter of the primary_poc's first name (lowercase), 
then the last letter of their first name (lowercase), 
the first letter of their last name (lowercase), 
the last letter of their last name (lowercase), 
the number of letters in their first name, 
the number of letters in their last name, 
and then the name of the company they are working with, 
all capitalized with no spaces.
*/

SELECT primary_poc,
		CONCAT(LEFT(LOWER(primary_poc), 1),
				RIGHT(SPLIT_PART(primary_poc,' ', 1), 1),
				LEFT(SPLIT_PART(LOWER(primary_poc),' ', 2), 1),
				RIGHT(SPLIT_PART(LOWER(primary_poc),' ', 2), 1),
				LENGTH(SPLIT_PART(primary_poc,' ', 1)),
				LENGTH(SPLIT_PART(primary_poc,' ', 2)),
				REPLACE(UPPER(name),' ','')) AS password
FROM accounts;

/******* COALESCE ************/

SELECT COUNT(primary_poc) AS regular_count,
		COUNT(COALESCE(primary_poc,'no POC')) AS modified_count
FROM accounts;



