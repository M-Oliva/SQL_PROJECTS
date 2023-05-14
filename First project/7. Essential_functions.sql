-- Essential_functions

-- Numerical functions

SELECT ROUND(7.58, 1);
/* Redondea el numero hacia arriba */

SELECT TRUNC(7.58374, 3);
/* Devuelve el numero con las posiciones decimales indicadas
sin redondear */

SELECT CEILING (7.58374);
/* Devuelve el siguiente entero hacia arriba */

SELECT FLOOR(7.6);
/* Redondea el numero hacia abajo */

SELECT ABS(-5.4);
/* Regresa el valor positivo del numero indicado */

SELECT RANDOM();
/* Regresa un numero aleatorio */


-- String functions

SELECT LENGTH('hello');
/* Da la longitud del texto indicado */

SELECT UPPER('hello');
/* Regresa en mayusculas el texto indicado */

SELECT LOWER('hELlo');
/* Regresa en minusculas el texto indicado */

SELECT LTRIM('    I am so AWESONE');
/* Quita los espacios iniciales */

SELECT RTRIM('I am so AWESONE           ');
/* Quita los espacios finales */

SELECT TRIM('            I am       so AWESONE           ');
/* Quita los espacios iniciales, intermedios y finales */

SELECT LEFT('Kindergarten',4);
/* Acorta el texto a la izq de acuerdo al numero indicado */

SELECT RIGHT('Kindergarten',6);
/* Acorta el texto a la der de acuerdo al numero indicado */

SELECT SUBSTRING ('Kindergarten', 3, 5)
/* Acorta el texto de acuerdo a los numero indicado */

SELECT REPLACE('Kindergarten', 'garten', 'garden');
/* Reemplaza el texto indicado */


































