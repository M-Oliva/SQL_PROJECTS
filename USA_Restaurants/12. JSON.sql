/***** JSON *****/


-- Let's add a column in the products table

ALTER TABLE local.products ADD COLUMN properties json;

UPDATE local.products SET properties = '
	{
	"dimensions": [1, 2, 3],
	"weight": 10,
	"manufacture": {"name":"sony"}
	}'	
WHERE product_id = 1;

SELECT * FROM local.products;

UPDATE local.products SET properties = '
	{
	"dimensions": [1, 2, 3],
	"weight": 10,
	"manufacture": {"name":"sony"}
	}'	
WHERE product_id = 2;


/* Retrieving JSON data */

SELECT product_id, properties ->>'weight' AS weight
FROM local.products
WHERE product_id = 1;

SELECT product_id, properties ->>'dimensions' AS dimensiones
FROM local.products
WHERE product_id = 1;


/* To extract JSON data two levels deep, reference is made
to the following:
(object::json->>'level1')::json->>'level2' */
	
SELECT product_id, (properties::json ->>'manufacture'):: json ->>'name' AS manufacture
FROM local.products
WHERE product_id = 1;

















