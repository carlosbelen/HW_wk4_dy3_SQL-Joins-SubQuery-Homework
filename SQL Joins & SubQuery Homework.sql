-- Inner Join on the Actor and Film_actor Table
     -- specifying where exactly to get the actor_id from (since it can be in at least 2 places)
SELECT actor.actor_id, first_name,last_name,film_id 
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id;

-- Left Join on the Actor and Film_Actor Table
SELECT actor.actor_id, first_name,last_name,film_id 
FROM film_actor
LEFT JOIN actor
ON actor.actor_id = film_actor.actor_id
 -- the following line checks to see if there are empty names:
WHERE first_name IS NULL AND last_name IS NULL;


-- Join that will produce info about a customer... JUMPING BETWEEN 4 TABLES
-- From the country of Angola
SELECT customer.first_name,customer.last_name,customer.email,country
FROM customer
INNER JOIN address
-- the following is how customer (table A) and address (table B) join or have in common:
ON customer.address_id = address.address_id  
INNER JOIN city
-- the 2nd join is from address to city:
ON address.city_id = city.city_id
INNER JOIN country
-- the 3rd join is from city to country:
ON city.country_id = country.country_id
WHERE country = 'Angola';
-- INNER JOIN can be substituted for FULL JOIN and it would yield the same information.



-- SubQuery Examples

--Two Queries split apart(which will become a subquery later)

-- Find a customer_id that has an amount greater than 175 in total payments
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 175
ORDER BY SUM(amount) DESC;
-- The above resulted in 6 customers


-- Find All customer info for everyone
SELECT *
FROM customer;

-- Lets get all the information for the 6 customers
-- Subquery to find 6 customers that have the total amount of payments greater than 175

SELECT *
FROM customer
-- the following sets the parameters for the customer table:
WHERE customer_id IN(
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
);
-- The innerquery runs first, than the outerquery takes that information and runs with it

-- Basic Subquery
-- Find all films with a language of 'English'
SELECT *
FROM film
WHERE language_id IN(
	SELECT language_id
	FROM language
	WHERE name = 'English'
);



-------------------------- HOMEWORK ---------------------------------
-- Question 1
-- List all customers who live in Texas (use JOINs)
-- Answer: 5 customers:
SELECT customer.first_name,customer.last_name
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id  
WHERE district = 'Texas';


-- Question 2
-- Get all payments above $6.99 with the Customer's Full Name
-- Answer: 1406 rows
SELECT last_name, first_name, amount
FROM customer  
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
WHERE amount > 6.99;

-- Question 3
-- Show all customers names who have made payments over $175 (use subqueries)
-- Answer: 6 customers.  This is the same as the example from class using customer_id.  Tried
--     to use last_name (for example) instead of customer_id, but it yielded the full list.
--     I don't know why.
SELECT *
FROM customer
WHERE customer_id IN(
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
);

-- Question 4
-- List all customers that live in Nepal (use the city table)
-- Joel's hint - use MULTI JOIN
-- Answer: 1 customer
SELECT customer.first_name,customer.last_name,customer.email,country
FROM customer
INNER JOIN address
-- the following is how customer (table A) and address (table B) join or have in common:
ON customer.address_id = address.address_id  
INNER JOIN city
-- the 2nd join is from address to city:
ON address.city_id = city.city_id
INNER JOIN country
-- the 3rd join is from city to country:
ON city.country_id = country.country_id
WHERE country = 'Nepal';


-- Question 5
-- Which staff member had the most transactions?
-- Answer: staff_id #2 w/ 7304 transactions
SELECT *
FROM payment
WHERE staff_id IN(
	SELECT staff_id 
-- 	COUNT(staff_id)
	FROM staff
	GROUP BY staff_id
	ORDER By count(staff_id) desc
);


-- Question 6
-- How many movies of each rating are there?
-- Answer:
SELECT rating, COUNT(rating)
FROM film
FULL JOIN film_category
ON film.film_id = film_category.film_id
GROUP BY rating;


-- Question 7 
-- Show all customers who have made a single payment above $6.99 (Use Subqueries)
-- Answer:
SELECT *
FROM customer
WHERE customer_id IN(
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING count(amount) > 6.99
	ORDER BY SUM(amount) DESC
);


-- Question 8
-- How many free rentals did our stores give away?
-- Answer: 24
SELECT amount, COUNT(amount)
FROM payment
FULL JOIN rental
ON payment.rental_id = rental.rental_id
GROUP BY amount;
