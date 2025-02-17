-- 1
use chinook; 

-- 2
create view View_High_Value_Customers as
select c.customerid,concat(c.firstname,' ',c.lastname) as fullname,c.email as Email,sum(i.total) as totalspending
from customer c
join invoice i on c.customerid = i.customerid
where i.invoicedate > '2021-01-01' and c.country <> 'Brazil' 
group by c.customerid,fullname,Email
HAVING SUM(i.total) >200;

select * from View_High_Value_Customers;

-- 3

CREATE VIEW View_Popular_Tracks AS
SELECT 
    t.TrackId, 
    t.Name AS Track_Name, 
    SUM(il.Quantity) AS Total_Sales
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
WHERE il.UnitPrice > 1.00
GROUP BY t.TrackId, Track_Name
HAVING Total_Sales > 15;

select * from View_Popular_Tracks;


-- 4
CREATE INDEX idx_Customer_Country ON Customer (Country) USING HASH;

EXPLAIN SELECT * FROM Customer WHERE Country = 'Canada';


-- 5
CREATE FULLTEXT INDEX idx_Track_Name_FT ON Track (Name);

EXPLAIN SELECT * FROM Track 
WHERE MATCH(Name) AGAINST('Love' IN NATURAL LANGUAGE MODE);


-- 6
EXPLAIN
SELECT hvc.*
FROM View_High_Value_Customers hvc
JOIN Customer c ON hvc.CustomerId = c.CustomerId
WHERE c.Country = 'Canada';


-- 7
EXPLAIN
SELECT vpt.*, t.UnitPrice
FROM View_Popular_Tracks vpt
JOIN Track t ON vpt.TrackId = t.TrackId
WHERE MATCH(t.Name) AGAINST('Love' IN NATURAL LANGUAGE MODE);



-- 8
DELIMITER &&
CREATE PROCEDURE GetHighValueCustomersByCountry(IN p_Country VARCHAR(50))
BEGIN
    SELECT vc.* FROM View_High_Value_Customers vc
    JOIN customer c ON vc.CustomerId = c.CustomerId
    WHERE c.country = p_Country;
END &&
DELIMITER &&;

CALL GetHighValueCustomersByCountry('Germany');

-- 9
DELIMITER &&

CREATE PROCEDURE UpdateCustomerSpending(IN p_CustomerId INT, IN p_Amount DECIMAL(10,2))
BEGIN
    UPDATE Invoice
    SET Total = Total + p_Amount
    WHERE CustomerId = p_CustomerId
    ORDER BY InvoiceDate DESC;
END &&

DELIMITER &&;


CALL UpdateCustomerSpending(5, 50.00);
SELECT * FROM View_High_Value_Customers WHERE CustomerId = 5;


-- 10
-- Xóa VIEW
DROP VIEW IF EXISTS View_High_Value_Customers;
DROP VIEW IF EXISTS View_Popular_Tracks;

-- Xóa INDEX
DROP INDEX idx_Customer_Country ON Customer;
DROP INDEX idx_Track_Name_FT ON Track;

-- Xóa PROCEDURE
DROP PROCEDURE IF EXISTS GetHighValueCustomersByCountry;
DROP PROCEDURE IF EXISTS UpdateCustomerSpending;

