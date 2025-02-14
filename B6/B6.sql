-- 3
create view view_film_category as
select 
    film.film_id, 
    film.title, 
    category.name as category_name
from film
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id;

select * from view_film_category;

-- 4
create view view_high_value_customers as
select 
    customer.customer_id, 
    customer.first_name, 
    customer.last_name, 
    sum(payment.amount) as total_payment
from customer
join payment on customer.customer_id = payment.customer_id
group by customer.customer_id, customer.first_name, customer.last_name
having total_payment > 100;

select * from view_high_value_customers;

-- 5
create index idx_rental_rental_date on rental(rental_date);
explain select * from rental where rental_date = '2005-06-14';


-- 6

DELIMITER &&

create procedure CountCustomerRentals ( 
	p_customer_id int, 
    out rental_count int
)
begin
    select count(*) into rental_count
    from rental
    where customer_id = p_customer_id;
end &&

DELIMITER &&;

call CountCustomerRentals(5, @rental_count);
select @rental_count;


-- 7
DELIMITER &&

create procedure GetCustomerEmail (
	p_customer_id int,
    out customer_email varchar(255)
)
begin
    select email into customer_email
    from customer
    where customer_id = p_customer_id;
end &&
DELIMITER &&;

call GetCustomerEmail(3, @customer_email);
select @customer_email;

-- 8

drop view view_film_category;
drop view view_high_value_customers;
drop index idx_rental_rental_date on rental(rental_date);
drop procedure if exists CountCustomerRentals;
drop procedure if exists GetCustomerEmail;

