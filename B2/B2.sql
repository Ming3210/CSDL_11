use session_11;

-- 2
create index idx_phone_number on customers(PhoneNumber);
EXPLAIN SELECT * FROM Customers WHERE PhoneNumber = '0901234567';

-- 3
create index idx_branch_salary on employees(branchid, salary);
EXPLAIN SELECT * FROM Employees WHERE BranchID = 1 AND Salary > 20000000;

-- 4
create unique index idx_unique_accountid_customerid on accounts(accountId, customerId);


-- 5
show index from customers;
show index from employees;
show index from accounts;

-- 6
drop index idx_phone_number on customers;
drop index idx_branch_salary on employees;
drop index idx_unique_accountid_customerid on accounts;
