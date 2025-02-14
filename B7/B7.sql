use chinook;

-- 2

create view view_track_details as
select 
    track.trackid, 
    track.name as track_name, 
    album.title as album_title, 
    artist.name as artist_name, 
    track.unitprice
from track
join album on track.albumid = album.albumid
join artist on album.artistid = artist.artistid
where track.unitprice > 0.99;

select * from view_track_details;

-- 3
create view View_Customer_Invoice as 
select 
	c.CustomerId,
    concat(c.FirstName,'',c.lastname) as FullName,
    c.Email,
    sum(i.total) as Total_Spending ,
    concat(e.firstname,'',e.lastname) as Support_Rep
from customer c
join invoice i on c.CustomerId = i.CustomerId
join employee e on c.SupportRepId = e.EmployeeId
group by c.CustomerId;
select * from view_customer_invoice;


-- 4
create view view_top_selling_tracks as
select 
    t.trackid as track_id, 
    t.name as track_name, 
    g.name as genre_name, 
    sum(il.quantity) as total_sales
from track as t
join invoiceline as il on t.trackid = il.trackid
join genre as g on t.genreid = g.genreid
group by t.trackid, t.name, g.name
having total_sales > 10;


select * from view_top_selling_tracks;


-- 5
create index idx_track_name on track(name);
explain select * from track where name like '%love%';

-- 6
create index idx_invoice_total on invoice(total);
explain select * from invoice where total between 20 and 100;

-- 7

DELIMITER &&
CREATE procedure GetCustomerSpending (
	Customer_id_in int
)
begin 
	select coalesce((total_spending),0) as total_amount_spent
    from View_Customer_Invoice
    where customerid = customer_id_in;
end &&
DELIMITER &&
call GetCustomerSpending(1);


-- 8
create index idx_Track_Name on track(name)
DELIMITER &&
create procedure SearchTrackByKeyword (
	p_Keyword_in varchar(100)
)
begin 
	select *
    from track
    where `name` like concat('%',p_Keyword_in,'%');
end &&
DELIMITER &&
call SearchTrackByKeyword ('lo');


-- 9
DELIMITER &&
create procedure GetTopSellingTracks (
	p_MinSales_in int ,
    p_MaxSales_in int
)
begin
	select * from View_Top_Selling_Tracks where total_sales between p_MinSales_in and p_MaxSales_in;
end &&
DELIMITER &&
call GetTopSellingTracks(1,3);
drop procedure GetTopSellingTracks;
drop view view_top_selling_tracks;

-- 10
drop view if exists view_track_details;
drop view if exists view_customer_invoice;
drop view if exists view_top_selling_tracks;
drop index if exists idx_track_name;
drop index if exists idx_invoice_total;
drop procedure if exists get_customer_spending;
drop procedure if exists search_track_by_keyword;
drop procedure if exists get_top_selling_tracks;
