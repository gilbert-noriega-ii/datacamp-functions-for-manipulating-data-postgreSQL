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


/*In this exercise and the ones that follow, we are going to derive new fields from columns within the customer and film tables of the DVD rental database.
Concatenate the first_name and last_name columns separated by a single space followed by email surrounded by < and >.*/


SELECT first_name || ' ' || last_name || ' <' ||email || '>' AS full_email 
FROM customer;


/*Now use the CONCAT() function to do the same operation as the previous step.*/

SELECT CONCAT(first_name, ' ', last_name,  ' <', email, '>') AS full_email FROM customer

/*Now you are going to use the film and category tables to create a new field called film_category by concatenating the category name with the film's title.
Convert the film category name to uppercase.
Convert the first letter of each word in the film's title to upper case.
Concatenate the converted category name and film title separated by a colon.
Convert the description column to lowercase.*/

SELECT 
  UPPER(name)  || ': ' || INITCAP(title) AS film_category,
  LOWER(description) AS description
FROM film AS f 
INNER JOIN film_category AS fc 
  ON f.film_id = fc.film_id 
INNER JOIN category AS c 
  ON fc.category_id = c.category_id;


/*In this example, we are going to practice finding and replacing whitespace characters in the title column of the film table using the REPLACE() function.*/

SELECT REPLACE(title, ' ', '_') AS title
FROM film; 

/*In this example, we are going to determine the length of the description column in the film table of the DVD Rental database.
Select the title and description columns from the film table.
Find the number of characters in the description column with the alias desc_len.*/

SELECT 
  title,
  description,
  LENGTH(description) AS desc_len
FROM film;

/*In this exercise, we will practice getting the first 50 characters of the description column.*/

SELECT LEFT(description, 50) AS short_desc
FROM film AS f; 

/*Extract only the street address without the street number from the address column.
Use functions to determine the starting and ending position parameters.*/

SELECT SUBSTRING(address FROM POSITION(' ' IN address)+1 FOR CHAR_LENGTH(address))
FROM address;

/*In the next example, we are going to break apart the email column from the customer table into three new derived fields. 
Extract the characters to the left of the @ of the email column in the customer table and alias it as username.
Now use SUBSTRING to extract the characters after the @ of the email column and alias the new derived field as domain.*/

SELECT
  LEFT(email, POSITION('@' IN email)-1) AS username,
  SUBSTRING(email FROM POSITION('@' IN email)+1 FOR  CHAR_LENGTH(email)) AS domain
FROM customer;

/*Let's revisit the string concatenation exercise but use padding functions.
Add a single space to the end or right of the first_name column using a padding function.
Use the || operator to concatenate the padded first_name to the last_name column.*/

SELECT RPAD(first_name, LENGTH(first_name)+1) || last_name AS full_name
FROM customer;

/*Now add a single space to the left or beginning of the last_name column using a different padding function than the first step.
Use the || operator to concatenate the first_name column to the padded last_name.*/

SELECT first_name || LPAD(last_name, LENGTH(last_name)+1) AS full_name
FROM customer; 

/*Add a single space to the right or end of the first_name column.
Add the characters < to the right or end of last_name column.
Finally, add the characters > to the right or end of the email column.*/

SELECT 
	RPAD(first_name, LENGTH(first_name)+1) 
    || RPAD(last_name, LENGTH(last_name)+2, ' <') 
    || RPAD(email, LENGTH(email)+1, '>') AS full_email
FROM customer; 

/*In this exercise, we are going to revisit and combine a couple of exercises from earlier in this chapter. If you recall, you used the LEFT() function to truncate the description column to 50 characters but saw that some words were cut off and/or had trailing whitespace. We can use trimming functions to eliminate the whitespace at the end of the string after it's been truncated.
Convert the film category name to uppercase and use the CONCAT() concatenate it with the title.
Truncate the description to the first 50 characters and make sure there is no leading or trailing whitespace after truncating.*/

SELECT 
  CONCAT(UPPER(c.name), ': ', f.title) AS film_category, 
  TRIM(RPAD(description, 50)) AS film_desc
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;

/*In this exercise, we are going to use the film and category tables to create a new field called film_category by concatenating the category name with the film's title.
Get the first 50 characters of the description column
Determine the position of the last whitespace character of the truncated description column and subtract it from the number 50 as the second parameter in the first function above.*/*/


SELECT 
  UPPER(c.name) || ': ' || f.title AS film_category, 
  LEFT(description, 50 - POSITION(' ' IN REVERSE(LEFT(description, 50)))) 
FROM film AS f 
INNER JOIN film_category AS fc 
  ON f.film_id = fc.film_id 
INNER JOIN category AS c 
  ON fc.category_id = c.category_id;