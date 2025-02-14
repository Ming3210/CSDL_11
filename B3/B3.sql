-- 2
DELIMITER &&
create procedure GetCustomerByPhone(
	phoneNumber varchar(15)
    
)
begin
	select c.CustomerID, c.FullName, c.DateOfBirth,c.Address,c.Email
    from customers c where c.phoneNumber = phoneNumber;
end &&
DELIMITER &&;


call GetCustomerByPhone('0901234567');

drop procedure if exists  GetCustomerByPhone;


-- 3
DELIMITER &&
create procedure GetTotalBalance(
	id_in int,
    out total decimal
)
begin
	select sum(a.Balance) into total
    from customers c join accounts a on c.CustomerID = a.CustomerID
	where c.CustomerID = id_in
    group by a.customerId;
end &&
DELIMITER &&;
set @id = 1;
call GetTotalBalance(@id,@total);

select @id as customer_id,@total as total_balance;
drop  procedure if exists GetTotalBalance;

DELIMITER &&
drop procedure if exists IncreaseEmployeeSalary;
create procedure IncreaseEmployeeSalary( employee_id_in int, out new_salary decimal)
begin 
	update employees 
	set salary = salary * 1.1
	where employeeid = employee_id_in;
    select salary into new_salary
    from employees 
    where employeeid = employee_id_in;
end &&
DELIMITER &&;
call IncreaseEmployeeSalary(2,@new_salary);
select @new_salary;

call GetCustomerByPhone ('0901234567');
call GetTotalBalance (1,@TotalBalance);
select @TotalBalance;
call IncreaseEmployeeSalary (4,@new_salary);
select @new_salary;

drop procedure  GetCustomerByPhone;
drop procedure  GetTotalBalance;
drop procedure  IncreaseEmployeeSalary;