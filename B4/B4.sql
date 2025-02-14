-- 2
DELIMITER &&
create procedure UpdateSalaryByID(
	id_in int,
    out new_salary decimal
)
begin
	update employees e
    
    set e.salary = 
		case when e.salary < 20000000 then e.salary * 1.1
		else e.salary * 1.05
    end
    where e.EmployeeID = id_in
    ;
    
    select e.salary into new_salary from employees e
    where e.EmployeeID = id_in;
end &&
DELIMITER &&;

call UpdateSalaryByID(1,@salary);
select @salary;
drop procedure if exists UpdateSalaryByID;

-- 3
DELIMITER &&
create procedure GetLoanAmountByCustomerID(customerid_in int ,out totalloanamount decimal)
begin 
	select coalesce(sum(loanamount),0) into totalloanamount
    from loans
    where customerid = customerid_in
    group by customerid;
end &&
DELIMITER &&;
call GetLoanAmountByCustomerID(3,@totalloanamount);
select @totalloanamount;

-- 4

DELIMITER &&

create procedure deleteaccountiflowbalance(in p_accountid int)
begin
    declare v_balance decimal(15,2);

    -- lấy số dư tài khoản
    select balance into v_balance 
    from accounts 
    where accountid = p_accountId;

    if v_balance is null then
        select 'tài khoản không tồn tại.' as message;
    else
        if v_balance < 1000000 then
            delete from accounts where accountid = p_accountid;
            select 'tài khoản đã được xóa thành công.' as message;
        else
            select 'không thể xóa tài khoản do số dư lớn hơn hoặc bằng 1 triệu.' as message;
        end if;
    end if;
end &&

DELIMITER && ;


call DeleteAccountIfLowBalance(4);

-- 5

DELIMITER &&
create procedure  TransferMoney(from_account int ,to_account int , inout amount decimal)
begin
-- 1 kiểm tra tài khoản gửi , nhận có trong hệ thống không
	declare is_exists bit default 0;
    declare is_morethan bit default 0;
    if (select count(accountid) from accounts where accountid = from_account) > 0
		and (select count(accountid) from accounts where accountid = to_account) > 0 then
        set is_exists = 1;
	end if;
-- 2 nếu tồn tại tài khoản thì kiểm tra balance > amount?
	
	if is_exists = 1 then 
		if (select balance from accounts where accountid = from_account) > amount then 
			set is_morethan = 1;
		end if;
	end if;
-- 3 nếu balance >= amount : 
	if is_morethan = 1 then
	-- 3.1 trừ balance của from_account đi amount
		update accounts 
			set balance = balance - amount
            where accountid = from_account;
    -- 3.2 cộng balance của to_account lên amount
		update accounts 
			set balance = balance + amount
            where accountid = to_account;
    else
		set amount = 0;
	end if;
end &&
DELIMITER &&

drop procedure TransferMoney;
set @money = 3000000;
call TransferMoney(1,2,@money);
select @money;

DROP PROCEDURE UpdateSalaryByID;
DROP PROCEDURE GetLoanAmountByCustomerID;
DROP PROCEDURE DeleteAccountIfLowBalance;
DROP PROCEDURE TransferMoney;