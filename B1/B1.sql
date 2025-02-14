use session_11;
-- 2
create view EmployeeBranch as
select e.EmployeeID,e.FullName,e.Position,e.Salary,b.BranchName,b.Location
from employees e
join branch b on e.BranchID = b.BranchID;


-- 3
create view HighSalaryEmployees as
select EmployeeID,FullName,Position,Salary
from employees 
where salary >= 15000000
with check option;

-- 4
select * from EmployeeBranch;

select * from HighSalaryEmployees;

-- 5
alter table Employees add PhoneNumber varchar(15);

create or replace view EmployeeBranch as
select 
    e.EmployeeID, 
    e.FullName, 
    e.Position, 
    e.Salary, 
    e.PhoneNumber,
    b.BranchName, 
    b.Location
from Employees e
join Branch b on e.BranchID = b.BranchID;

-- 6
delete from Employees where Branchid = (select Branchid from branch where branchname = 'Chi nhánh Hà Nội');

select * from Employees;