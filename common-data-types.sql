/* actor table fields are 

actor_id
first_name
last_name
last_update

*/

/* customer table fields are 

customer_id
store_id
first_name
last_name
email
address_id
activebool
create_date
last_update
active

*/

/* rental table fields are 

rental_id
rental_date
inventory_id
customer_id
return_date
staff_id
last_update

*/


/* film table fields are 

film_id
title
description
release_year
language_id
original_language_id
rental_duration
rental_length
replacement_cost
rating
last_update
special_features

*/

/*In this exercise we will look at how to query the tables table of the INFORMATION_SCHEMA database to discover information about tables in the DVD Rentals database including the name, type, schema, and catalog of all tables and views and then how to use the results to get additional information about columns in our tables.
Select all columns from the INFORMATION_SCHEMA.TABLES system database. Limit results that have a public table_schema.*/

SELECT * 
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'public';

/*Select all columns from the INFORMATION_SCHEMA.COLUMNS system database. Limit by table_name to actor*/

SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE table_name = 'actor';

/*Select the column name and data type from the INFORMATION_SCHEMA.COLUMNS system database.
Limit results to only include the customer table.*/

SELECT
 	column_name, 
    data_type
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE table_name = 'customer';

/*Select the rental date and return date from the rental table.
Add an INTERVAL of 3 days to the rental_date to calculate the expected return date`.*/

SELECT
 	rental_date,
	return_date,
 	rental_date + INTERVAL '3 days' AS expected_return_date
FROM rental;

/*Select the title and special features from the film table and compare the results between the two columns.*/

SELECT 
  title, 
  special_features 
FROM film;

/*Select all films that have a special feature Trailers by filtering on the first index of the special_features ARRAY.*/

SELECT 
  title, 
  special_features 
FROM film
WHERE special_features[1] = 'Trailers';

/*Now let's select all films that have Deleted Scenes in the second index of the special_features ARRAY.*/

SELECT 
  title, 
  special_features 
FROM film
WHERE special_features[2] = 'Deleted Scenes';

/*Match 'Trailers' in any index of the special_features ARRAY regardless of position.*/

SELECT
  title, 
  special_features 
FROM film 
WHERE 'Trailers' = ANY(special_features);

/*Use the contains operator to match the text Deleted Scenes in the special_features column.*/

SELECT 
  title,
  special_features
FROM film 
WHERE special_features @> ARRAY['Deleted Scenes'];