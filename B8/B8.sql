-- 1
use sakila;
-- 2
create view view_long_action_movies as
select f.film_id,f.title,f.length,c.name as category_name
from film f
join film_category fa on f.film_id = fa.film_id
join category c on fa.category_id = c.category_id
where c.name = 'Action' and f.length > 100;

select * from view_long_action_movies;


-- 3
CREATE VIEW view_texas_customers AS
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    a.district
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN rental r ON c.customer_id = r.customer_id
WHERE a.district = 'Texas'
GROUP BY c.customer_id, c.first_name, c.last_name, a.district;

drop view view_texas_customers;

select * from view_texas_customers;
-- 4
create view view_high_value_staff  as
select s.staff_id,s.first_name,s.last_name,sum(p.amount)  as total_payment 
from staff s
join payment p on s.staff_id = p.staff_id
group by s.staff_id, s.first_name, s.last_name
having sum(p.amount) > 100;

select * from view_high_value_staff;

-- 5
CREATE FULLTEXT INDEX idx_film_title_description
ON film(title, description);

-- 6
CREATE INDEX idx_rental_inventory_id
ON rental(inventory_id) USING HASH;

-- 7
SELECT *
FROM view_long_action_movies
WHERE MATCH(title, description) AGAINST ('War');


-- 8
DELIMITER &&
CREATE PROCEDURE GetRentalByInventory(IN inventory_id INT)
BEGIN
    SELECT * 
    FROM rental 
    WHERE inventory_id = inventory_id;
END &&
DELIMITER &&;


-- cau 9
DROP VIEW IF EXISTS view_long_action_movies;
DROP VIEW IF EXISTS view_texas_customers;
DROP VIEW IF EXISTS view_high_value_staff;
DROP INDEX idx_film_title_description ON film;
DROP INDEX idx_rental_inventory_id ON rental;
DROP PROCEDURE IF EXISTS GetRentalByInventory;