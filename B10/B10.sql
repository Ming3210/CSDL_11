-- 1
use sakila;

-- 2
create unique index idx_unique_email on customer (email);

insert into customer (store_id, first_name, last_name, email, address_id, active, create_date)
values (1, 'Jane', 'Doe', 'johndoe@example.com', 6, 1, now());

-- 3
DELIMITER &&
create procedure CheckCustomerEmail(in email_input varchar(50), out exists_flag int)
begin
    select count(*) into exists_flag 
    from customer 
    where email = email_input;
end &&
DELIMITER ;

call CheckCustomerEmail('ldt2005@gmail.com', @exists_flag);
select @exists_flag;

-- 4
create index idx_rental_customer_id on rental (customer_id);

-- 5
CREATE VIEW view_active_customer_rentals AS
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    r.rental_date,
    CASE 
        WHEN r.return_date IS NOT NULL THEN 'Returned'
        ELSE 'Not Returned'
    END AS status
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE c.active = 1
AND r.rental_date >= '2023-01-01'
AND (r.return_date IS NULL OR r.return_date >= NOW() - INTERVAL 30 DAY);


SELECT * FROM view_active_customer_rentals;


-- 6
create index idx_payment_customer_id on payment (customer_id);

-- 7
CREATE VIEW view_customer_payments AS
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(p.amount) AS total_payment,
    MAX(p.payment_date) AS last_payment_date
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_date >= '2005-01-01'
GROUP BY c.customer_id, full_name
HAVING total_payment > 100;

-- 8
DELIMITER $$
CREATE PROCEDURE GetCustomerPaymentsByAmount(IN min_amount DECIMAL(10,2), IN date_from DATE)
BEGIN
    SELECT * FROM view_customer_payments 
    WHERE total_payment >= min_amount;
END $$
DELIMITER ;
CALL GetCustomerPaymentsByAmount(200, '2023-01-01');


-- 9
drop view view_active_customer_rentals;
drop view view_customer_payments;
drop index idx_unique_email on customer;
drop index idx_rental_customer_id on rental;
drop index idx_payment_customer_id on payment;
drop procedure CheckCustomerEmail;
drop procedure GetCustomerPaymentsByAmount;