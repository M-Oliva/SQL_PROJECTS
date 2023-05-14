/***** Essential functions *****/

-- Numerical functions

SELECT ROUND(7.58, 1);
/* Round the number up */

SELECT TRUNC(7.58374, 3);
/* Returns the number with the indicated decimal places
no rounding */

SELECT CEILING (7.58374);
/* Return the next integer up */

SELECT FLOOR(7.6);
/* Round the number down */

SELECT ABS(-5.4);
/* Returns the positive value of the indicated number */

SELECT RANDOM();
/* Returns a random number */


-- String functions

SELECT LENGTH('hello');
/* Return the length of the given text */

SELECT UPPER('hello');
/* Returns the indicated text in uppercase */

SELECT LOWER('hELLo');
/* Returns the indicated text in lowercase */

SELECT LTRIM(' I am so AWESONE');
/* Remove leading spaces */

SELECT RTRIM('I am so AWESONE ');
/* Remove trailing spaces */

SELECT TRIM(' I am so AWESONE ');
/* Remove leading, middle, and trailing spaces */

SELECT LEFT('Kindergarten',4);
/* Shorten the text to the left according to the indicated number */

SELECT RIGHT('Kindergarten',6);
/* Shorten the text to the right according to the indicated number */

SELECT SUBSTRING('Kindergarten', 3, 5)
/* Shorten the text according to the indicated number */

SELECT REPLACE('Kindergarten', 'garten', 'garden');
/* Replace the given text */






