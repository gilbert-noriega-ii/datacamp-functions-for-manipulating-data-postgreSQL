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


/* inventory table fields are 

inventory_id
film_id
store_id
last_update

*/



/*Select all columns for all records that begin with the word GOLD.*/

SELECT *
FROM film
WHERE title LIKE 'GOLD%';

/*Now select all records that end with the word GOLD.*/

SELECT *
FROM film
WHERE title LIKE '%GOLD';

/*Finally, select all records that contain the word 'GOLD'.*/

SELECT *
FROM film
WHERE title LIKE '%GOLD%';

/*In this example, you will convert a text column from the film table to a tsvector and inspect the results. 
Select the film description and convert it to a tsvector data type.*/

SELECT to_tsvector(description)
FROM film;

/*In this exercise, you will practice searching a text column and match it against a string.
Select the title and description columns from the film table.
Perform a full-text search on the title column for the word elf.*/

SELECT title, description
FROM film
WHERE to_tsvector(title) @@ to_tsquery('elf');


/* In this exercise, you are going to create a new ENUM data type called compass_position.
Create a new enumerated data type called compass_position.
Use the four positions of a compass as the values.*/

CREATE TYPE compass_position AS ENUM (
  	'North', 
  	'South',
  	'East', 
  	'West'
);

/*Verify that the new data type has been created by looking in the pg_type system table.*/

CREATE TYPE compass_position AS ENUM (
  	'North', 
  	'South',
  	'East', 
  	'West'
);

SELECT *
FROM pg_type
WHERE typname='compass_position';

/*Select the column_name, data_type, udt_name.
Filter for the rating column in the film table.*/

SELECT column_name, data_type, udt_name
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE table_name ='film' AND column_name ='rating';

/*Select all columns from the pg_type table where the type name is equal to mpaa_rating.*/

SELECT *
FROM pg_type 
WHERE typname ='mpaa_rating'

/*In this exercise, you will build a query step-by-step that can be used to produce a report to determine which film title is currently held by which customer using the inventory_held_by_customer() function.
Select the title and inventory_id columns from the film and inventory tables in the database.*/

SELECT 
	f.title, 
    i.inventory_id
FROM film AS f 
	INNER JOIN inventory AS i ON f.film_id=i.film_id

/*In this exercise, you will build a query step-by-step that can be used to produce a report to determine which film title is currently held by which customer using the inventory_held_by_customer() function.
inventory_id is currently held by a customer and alias the column as held_by_cust*/

