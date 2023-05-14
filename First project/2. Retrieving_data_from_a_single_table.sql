-- Trayendo data de una sola tabla
-- Para esto usaremos la bd de moshstore

SELECT * FROM moshstore.customers
WHERE customer_id>5
ORDER BY first_name;
/* Aqui estamos trayendo todos los datos de la tabla
customers cuyo id sea mayor a 5 y ordenado por nombre */

SELECT DISTINCT state
FROM moshstore.customers;
-- Aqui traemos los estados que no han sido repetidos

SELECT name, unit_price, (unit_price*1.1) AS new_price
FROM moshstore.products;
/*Trae el nombre de los productos con el precio y
el nuevo precio que es un aumento del 10% con
respecto al anterior*/

SELECT * FROM moshstore.orders
WHERE order_date >= '2018-01-01' AND order_date <= '2019-01-01';
-- Trae todas las ordenes realizadas en el año 2018

SELECT * FROM moshstore.customers
WHERE NOT (birth_date > '1990-01-01' AND points > 1000);
/* Va a traer todos los registros que no tenga año
de nacimiento superior a 1990-01-01 y que ademas su
puntaje sea mayor a 1000 */

SELECT * FROM moshstore.order_items
WHERE order_id = 6 AND quantity * unit_price > 30;
/* Trae items de la orden 6 cuyo precio total sea 
mayor a 30 */

SELECT *
FROM moshstore.customers
WHERE state IN ('VA', 'GA', 'FL');
--Trae todos los datos cuyo estados sean los mencionados

SELECT *
FROM moshstore.customers
WHERE state NOT IN ('VA', 'GA', 'FL');
--Trae todos los datos cuyo estados NO sean los mencionados

SELECT * FROM moshstore.products
WHERE quantity_in_stock IN (49, 38, 72);

SELECT * FROM moshstore.orders
WHERE shipped_date IS NULL;
-- Trae todos los datos que no tienen fecha de envio

SELECT * FROM moshstore.customers
ORDER BY last_name DESC, state ASC
LIMIT 10;
/* Trae todos los datos ordenados primero por apellidos 
de la Z-A y despues ordenados por estado de la A-Z
limitando su busqueda a los 10 primeros */

SELECT order_id, product_id, quantity, unit_price
FROM moshstore.order_items
LIMIT 5 OFFSET 2 ;
/* Trae los campos solicitados, limitandose a 5, 
pero saltandose los primeros 2 */

SELECT * FROM moshstore.customers
WHERE last_name LIKE '_____y';
/* Trae todos los datos para los apellidos que tengan ese
numero de caracteres y terminen con la letra y */

SELECT * FROM moshstore.customers
WHERE address LIKE '%TRAIL%' OR address LIKE '%AVENUE%'
	OR phone LIKE '%9'
/* Trae los clientes cuyas direcciones contengan TRAIL o
Avenue o si los numeros de telefono terminan en 9 */


--     Ahora estudiaremos las expresiones regulares
-- Usamos una expresion regular con ayuda de (~)

SELECT * FROM moshstore.customers
WHERE phone ~ '7$';
/* en este caso el simbolo $ nos ayuda a que lo que buscamos
termine en 7*/

SELECT * FROM moshstore.customers
WHERE phone ~ '^7';
/* en este caso el simbolo ^ nos ayuda a que lo que buscamos
empiece en 7*/

SELECT * FROM moshstore.customers
WHERE phone ~ '^[5-7]';
/* en este caso todos los registros que empiezan desde el 5 al 7 */

SELECT * FROM moshstore.customers
WHERE first_name ~ '[rl]a$';
/* Estamos solicitando aquellos nombres que terminen con
la letra a, pero que los preceda la letra r o la l */

SELECT * FROM moshstore.customers
WHERE first_name ~ 'bar|edd';
/* Estamos solicitando aquellos nombres que contengan bar o
edd */

SELECT * FROM moshstore.customers
WHERE last_name ~ '^[B-M].*(ey|ld)';
/* Estamos solicitando aquellos apellidos que empiecen desde
la letra B hasta la M, tengan cero o más caracteres(.*) y
terminen con ey o ld */

-- Ahora haremos una pequeña actividad
/*
Trae los clientes cuyos
- nombres sean ELKA o AMBUR
- apellidos que terminen con EY o ON
- que empiecen con MY o contengan SE
- apellidos que contenga una B seguidos por R o U
*/

SELECT * FROM moshstore.customers
WHERE first_name ~* 'ELKA|AMBUR';
/* En este caso el * despues del ~ nos ayuda que no importe
si son mayusculas o minisculas */ 

SELECT * FROM moshstore.customers
WHERE last_name ~ '[ey|on]$';

SELECT * FROM moshstore.customers
WHERE last_name ~* '^MY|SE';

SELECT * FROM moshstore.customers
WHERE last_name ~* 'B[R|U]';














