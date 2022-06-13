
-- MAVEN MOVIES PROJECT

/* SITUATION - You and your Uncle just purchased Maven Movies, a DVD rental business. You are in charge of the day-to-day operations*/

/* BRIEF - As a new owner you will need to learn everything you can about your business : your product, inventory, your staff, customer
           ,purchase behaviors, etc. You have access to the entire MavenMovies SQL database. 
		   You will need to analyze everything on you own. */

/* OBJECTIVE - Use MySQL to : Access and explore the database,
		       Develop a firm grasp of the 16 database tables and how they relate to each other,
               Analyze all aspects of company's data. */

-- There are 16 problem statements, answering them helps in analyzing the data.


/*Problem 1 - Needed list of all staff members, including first and last names,email address,
 and the store identification number where they work. 
 */
 
select 
	first_name,
    last_name,
    email,
    store_id
from staff; 


/*Problem 2 - Need seperate counts of inventory items held at each of your two stores.
*/
select 
	store_id,
	count(inventory_id) as inventory_items
from inventory	
group by store_id;


/*Problem 3 - Need a count of active customers for each of your stores separately.
*/
select	
	store_id,
    count(customer_id) as active_customers
from customer
where active = 1
group by store_id;



/*Problem 4 - In order to asses the liability of a data breach, provide a count of all customer 
email addresses stored in the database
*/
select 
	count(email) as emails
from customer;



/*Problem 5 - In interested in how diverse your film offering is as a means of understanding how likely you are
to keep customers engaged in the future. Please provide a count of unique film titless you have in inventory at each store
and then provide a count of the unique categories of films you provide.
*/

select
	store_id,
	count(distinct film_id) as unique_films
from inventory
group by store_id; 

select 
	count(distinct name) as unique_categories
from category;    



/*Problem 6 - Like to understand the replacement cost of your film. Provide replacement cost for film that is least expensive
to replace, the most expensive to replace, and the average of all films you carry.
*/

select
	min(replacement_cost) as least_expensive,
	max(replacement_cost) as most_expensive,
	avg(replacement_cost) as average_replacement_cost
    
from film;



/* Problem 7 - Provide average payment processed as well as the maximum payment you have processed.
*/
select
	avg(amount) as average_payment,
    max(amount) as max_payment
from payment;



/* Problem 8 - Provide list of all customer identification values, with count of rentals they have made all-time,
 with your highest volume customers at the top of the list.
*/
select 
	customer_id,
    count(rental_id) as nuumber_of_rentals
from rental
group by customer_id
order by count(rental_id) desc;


/* PROBLEM 9 - Send over the managers name at each store,with full address of each property (street address,district,city, and country 
) */

select
	staff.first_name as manager_first_name,
    staff.last_name as manager_last_name,
    address.address,
    address.district,
    city.city,
    country.country
from store
	left join staff on store.manager_staff_id = staff.staff_id
    left join address on store.address_id = address.address_id
    left join city on address.city_id = city.city_id
    left join country on city.country_id = country.country_id;
    
    
    
/* PROBLEM 10  - Pull a list of each inventory item you have stocked, including the store_id number, the inventory_id, name of the film,
the film's rating, its rental rate and replacement cost */

select
	inventory.store_id,
    inventory.inventory_id,
    film.title,
    film.rating,
    film.rental_rate,
    film.replacement_cost
from inventory
	left join film on inventory.film_id = film.film_id;
    
    
    
/* PROBLEM 11 - From the same list of films you just pulled, please roll that data up and provide a summary level overview of 
your inventory. We would like to know how many inventory items you have with each rating at each store */

select
	inventory.store_id,
    film.rating,
    count(inventory_id) as inventory_items
from inventory
	left join film on inventory.film_id = film.film_id
group by
		inventory.store_id,
        film.rating;
        
        
        
/* PROBLEM 12 - Like to see number of films, as well as the average replacement cost, and total replacement,cost, sliced by store 
and film category */

select
	store_id,
    category.name as category,
    count(inventory.inventory_id) as films,
    avg(film.replacement_cost) as avg_replacement_cost,
    sum(film.replacement_cost) as total_replacement_cost
from inventory
	left join film on inventory.film_id = film.film_id
    left join film_category on film.film_id = film_category.film_id
    left join category on category.category_id = film_category.category_id
group by
	store_id,
	category.name
order by
	sum(film.replacement_cost) desc;
        
        

/* PROBLEM 13 - Provide list of all customer names, which store they go to, whwether or not they are currently active, and their 
full address - street address, city and country */   
 
select
	customer.first_name,
    customer.last_name,
    customer.store_id,
    customer.active,
    address.address,
    city.city,
    country.country
    
from customer
	left join address on customer.address_id = address.address_id
    left join city on address.city_id = city.city_id
    left join country on city.country_id = country.country_id;
    
    
    
/* PROBLEM 14 - Pull together a list of customer names, their total lifetime rentals, and sum of all payments you have 
collected from them. It would be great to see this ordered on total lifetime value, with the most valuable
 customers at the top of the list */ 
 
select
	customer.first_name,
    customer.last_name,
    count(rental.rental_id) as total_rentals,
    sum(payment.amount) as total_payment_amount
from customer
	left join rental on customer.customer_id = rental.customer_id
    left join payment on rental.rental_id = payment.rental_id
group by
	customer.first_name,
	customer.last_name
order by
	sum(payment.amount) desc;
    
    

/* PROBLEM 15 - Provide list of advisor and investor names in one table. Could you please note whether they are an investor 
or an advisor, and for the investors, it would be good to include which company they work with */

select
	'investor' as type,
    first_name,
    last_name,
    company_name
from investor
union
select
		'advisor' as type,
        first_name,
        last_name,
        null
from advisor;



/* PROBLEM 16 - Interested in how well you have covered the most awarded actors. Of all the actors with three types of awards,
for what % of them do we carry a film? And hoe about for the actors with two types of awards? How about actors with just one 
award? */

select
	case
		when actor_award.awards = 'Emmy, Oscar, Tony ' then '3 awards'
        when actor_award.awards in ('Emmy, Oscar','Emmy, Tony','Oscar, Tony') then '2 awards'
        else '1 award'
	end as number_of_awards,
    avg(case when actor_award.actor_id is null then 0 else 1 end) as percentage_with_atleast_one_film
    
from actor_award

group by
	case 
		when actor_award.awards = 'Emmy, Oscar, Tony ' then '3 awards'
        when actor_award.awards in ('Emmy, Oscar','Emmy, Tony','Oscar, Tony') then '2 awards'
        else '1 award'
	end;
    
    
-- END OF THE PROJECT
    


    