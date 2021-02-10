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


/*In this exercise, you will calculate the actual number of days rented as well as the true expected_return_date by using the rental_duration column from the film table along with the familiar rental_date from the rental table.
Subtract the rental_date from the return_date to calculate the number of days_rented.*/

SELECT f.title, 
       f.rental_duration,
       r.return_date - r.rental_date AS days_rented
FROM film AS f
     INNER JOIN inventory AS i ON f.film_id = i.film_id
     INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

/*Now use the AGE() function to calculate the days_rented.*/

SELECT f.title, 
		f.rental_duration,
		AGE(r.return_date, r.rental_date) AS days_rented
FROM film AS f
	INNER JOIN inventory AS i ON f.film_id = i.film_id
	INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

/* In this example, you will exclude films that have a NULL value for the return_date and also convert the rental_duration to an INTERVAL type.
Convert rental_duration by multiplying it with a 1 day INTERVAL
Subtract the rental_date from the return_date to calculate the number of days_rented.
Exclude rentals with a NULL value for return_date.*/

SELECT
	f.title,
 	INTERVAL '1' DAY * f.rental_duration,
 	r.return_date - r.rental_date AS days_rented
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
ORDER BY f.title;

/*Let's use those new skills to calculate the actual expected return date of a specific rental.
Convert rental_duration by multiplying it with a 1-day INTERVAL.
Add it to the rental date.*/

SELECT
    f.title,
	r.rental_date,
    f.rental_duration,
    INTERVAL '1' DAY * f.rental_duration + rental_date AS expected_return_date,
    r.return_date
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;


/*Use NOW() to select the current timestamp with timezone.*/

SELECT NOW();

/*Select the current date without any time value.*/

SELECT CURRENT_DATE;

/*Now, let's use the CAST() function to eliminate the timezone from the current timestamp.*/

SELECT CAST( NOW() AS TIMESTAMP )

/*Finally, let's select the current date
Use CAST() to retrieve the same result from the NOW() function.*/

SELECT 
	CURRENT_DATE,
    CAST( NOW() AS date )

/*Select the current timestamp without timezone and alias it as right_now.*/

SELECT CURRENT_TIMESTAMP::TIMESTAMP AS right_now;

/*Now select a timestamp five days from now and alias it as five_days_from_now.*/

SELECT
	CURRENT_TIMESTAMP::timestamp AS right_now,
    INTERVAL '5 DAYS' + CURRENT_TIMESTAMP AS five_days_from_now;

/*Finally, let's use a second-level precision with no fractional digits for both the right_now and five_days_from_now fields.*/

SELECT
	CURRENT_TIMESTAMP(2)::timestamp AS right_now,
    INTERVAL '5 days' + CURRENT_TIMESTAMP(2) AS five_days_from_now;

/*Get the day of the week from the rental_date column.*/

SELECT 
  EXTRACT(dow FROM rental_date) AS dayofweek 
FROM rental 
LIMIT 100;

/*Count the total number of rentals by day of the week.*/

SELECT 
  EXTRACT(dow FROM rental_date) AS dayofweek, 
  COUNT(rental_id) as rentals 
FROM rental 
GROUP BY 1;

/*Truncate the rental_date field by year.*/

SELECT DATE_TRUNC('year', rental_date) AS rental_year
FROM rental;

/*Now modify the previous query to truncate the rental_date by month.*/

SELECT DATE_TRUNC('month', rental_date) AS rental_month
FROM rental;

/*Let's see what happens when we truncate by day of the month.*/

SELECT DATE_TRUNC('day', rental_date) AS rental_day 
FROM rental;

/*Finally, count the total number of rentals by rental_day and alias it as rentals.*/

SELECT 
  DATE_TRUNC('day', rental_date) AS rental_day,
  COUNT(rental_id) AS rentals
FROM rental
GROUP BY 1;

/*In this exercise, you are going to extract a list of customers and their rental history over 90 days. 
Extract the day of the week from the rental_date column using the alias dayofweek.
Use an INTERVAL in the WHERE clause to select records for the 90 day period starting on 5/1/2005.*/

SELECT 
  EXTRACT(dow FROM rental_date) AS dayofweek,
  AGE(return_date, rental_date) AS rental_days
FROM rental AS r 
WHERE 
  rental_date BETWEEN CAST('2005-05-01' AS DATE)
  AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';

/*Finally, use a CASE statement and DATE_TRUNC() to create a new column called past_due which will be TRUE if the rental_days is greater than the rental_duration otherwise, it will be FALSE.*/

SELECT 
  c.first_name || ' ' || c.last_name AS customer_name,
  f.title,
  r.rental_date,
  EXTRACT(dow FROM r.rental_date) AS dayofweek,
  AGE(r.return_date, r.rental_date) AS rental_days,
  CASE WHEN DATE_TRUNC('day', AGE(r.return_date, r.rental_date)) > f.rental_duration * INTERVAL '1' day 
  THEN TRUE 
  ELSE FALSE END AS past_due 
FROM 
  film AS f 
  INNER JOIN inventory AS i 
  	ON f.film_id = i.film_id 
  INNER JOIN rental AS r 
  	ON i.inventory_id = r.inventory_id 
  INNER JOIN customer AS c 
  	ON c.customer_id = r.customer_id 
WHERE 
  r.rental_date BETWEEN CAST('2005-05-01' AS DATE) 
  AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';