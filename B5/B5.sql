-- 3

create view view_album_artist as
select 
    album.albumid as album_id, 
    album.title as album_title, 
    artist.name as artist_name
from album
join artist on album.artistid = artist.artistid;

select * from View_Album_Artist;

-- 4
create view view_customer_spending as
select 
    customer.customerid, 
    customer.firstname, 
    customer.lastname, 
    customer.email, 
    coalesce(sum(invoice.total), 0) as total_spending
from customer
left join invoice on customer.customerid = invoice.customerid
group by customer.customerid, customer.firstname, customer.lastname, customer.email;

select * from View_Customer_Spending;


-- 5

create index idx_employee_lastname on employee(lastname);

explain select * from employee where lastname = 'king';


-- 6
DELIMITER &&

create procedure gettracksbygenre(
	id_in int
)
begin
    select 
        track.trackid, 
        track.name as track_name, 
        album.title as album_title, 
        artist.name as artist_name
    from track
    join album on track.albumid = album.albumid
    join artist on album.artistid = artist.artistid
    where track.genreid = id_in;
end &&

DELIMITER &&;


call GetTracksByGenre(1);

-- 7

DELIMITER &&;
create procedure GetTrackCountByAlbum (
	p_albumid_in int
)
begin
    select count(*) as total_tracks
    from track
    where albumid = p_albumid_in;
end &&;

DELIMITER &&;

call GetTrackCountByAlbum(5);

-- 8
drop view View_Album_Artist ;
drop view View_Customer_Spending ;
drop index idx_Employee_LastName  on customer(LastName );

drop procedure if exists GetTracksByGenre;
drop procedure if exists GetTrackCountByAlbum;