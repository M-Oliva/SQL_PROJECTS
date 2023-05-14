-- JSON

-- Vamos agregar una columna en en la tabla products
ALTER TABLE msiv.products ADD COLUMN properties json;

UPDATE msiv.products SET properties = '
	{
	"dimensions": [1, 2, 3],
	"weight": 10,
	"manufacture": {"name":"sony"}
	}'	
WHERE product_id = 1;

SELECT * FROM msiv.products;

UPDATE msiv.products SET properties = '
	{
	"dimensions": [1, 2, 3],
	"weight": 10,
	"manufacture": {"name":"sony"}
	}'	
WHERE product_id = 2;

/* Recuperando datos tipo JSON */

SELECT product_id, properties ->>'weight' AS weight
FROM msiv.products
WHERE product_id = 1;

SELECT product_id, properties ->>'dimensions' AS dimensiones
FROM msiv.products
WHERE product_id = 1;

/* Para extraer datos JSON con dos niveles de profundidad
se hace alusión a lo siguiente:
	(objeto::json->>'nivel1')::json->>'nivel2' */
	
SELECT product_id, (properties::json ->>'manufacture'):: json ->>'name' AS manufacture
FROM msiv.products
WHERE product_id = 1;
