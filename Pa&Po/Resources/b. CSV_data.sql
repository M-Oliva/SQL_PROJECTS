/* CSV data */

/*
Se va a importar data en formato CSV para cada una de las tablas
creadas en el recurso anterior, de la siguiente manera:

	1. Vamos a las tablas que se encuentran en el schema elegido
	2. Clic derecho sobre la tabla a la cual se le van a agregar
		datos, escoger la opcion Import/Export Data
	3. Escogemos import, buscamos el archivo, escogemos tipo de 
		archivo CSV y encoding UTF8.
	4. Luego vamos a opciones, activamos Header y el delimitador
		que tiene nuestro archivo.
*/


-- Comprobamos:

SELECT * FROM public.region;

SELECT * FROM public.accounts;

SELECT * FROM public.sales_reps;

SELECT * FROM public.web_events;

SELECT * FROM public.orders;












