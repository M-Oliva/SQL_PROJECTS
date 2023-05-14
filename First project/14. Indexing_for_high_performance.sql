-- Indexing for high performance

/* 
Costo de la busqueda:
- Mejorar la base de datos
- Desacelarar las escrituras
- Solo deberia reservarse para consultas criticas de rendimiento

Importante: indice de diseño basado en consultas, no en tablas
*/

/* Crear el index */

-- Usaremos la database de moshstore

/* Verificar el tipo y las filas del resultado de la explicación.
Esto representa cuantas filas tiene que verificar para obtener
el resultado. TODO es exploración completa de la tabla */

EXPLAIN SELECT customer_id FROM moshstore.customers
WHERE state = 'CA';

CREATE INDEX i_state
ON moshstore.customers(state);

/* Encuentra clientes con mas de 1000 puntos */
EXPLAIN SELECT customer_id FROM moshstore.customers
WHERE points>1000;

CREATE INDEX i_points
ON moshstore.customers(points);

/* Revisando el index */

/* Se usa para calcular y obtener el analisis correcto en la
tabla */
ANALYZE VERBOSE moshstore.customers;

/* Para mostrar todas las tablas */
SELECT * FROM pg_catalog.pg_tables;

/* Listar indices de una tabla */
SELECT * FROM pg_indexes
WHERE tablename = 'customers' 
	AND schemaname = 'moshstore';

SELECT * FROM pg_indexes
WHERE tablename = 'orders' 
	AND schemaname = 'moshstore';

/* Indexing en cadenas de texto */

/* String columns: CHAR, VARCHA, TEXT, BLOB */

/* Que tan rapido se verifica el valor optimo para establecer 
para la cadena */

SELECT
	COUNT (DISTINCT LEFT(last_name, 1)),
	COUNT (DISTINCT LEFT(last_name, 5)),
	COUNT (DISTINCT LEFT(last_name, 10))
FROM moshstore.customers;


CREATE INDEX i_last_name
ON moshstore.customers(last_name);
















