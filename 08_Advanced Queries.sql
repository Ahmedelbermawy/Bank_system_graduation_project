---------------------------------------View------------------------------------------

----------------- to get employee details along with department name---------

CREATE OR ALTER VIEW EmployeeDetails 
AS
SELECT e.[Employee ID] , concat (e.[First Name],' ',e.[Last Name]) AS employee_name, e.salary, d.dname AS department_name
FROM Employee e JOIN Department d 
ON e.Dno = d.Dnumber
WHERE Dnumber=10

--test view query 

select * from EmployeeDetails 

------------------name of manager employee-----------------------------

create or alter view managerofemployee 
as
SELECT [First Name],[Last Name],dname
FROM employee e JOIN department d
ON e.dno=D.dnumber
AND e.[Employee ID]=D.mgrid

--test view query 

select * from managerofemployee  

----------------Create View to view the Loan Summary -----------------

create or alter view LoanSummary 
As 
Select L.loanId,c.[First Name],l.Amount,L.[Interest Rate]
from loan l,Customer c
where l.[Customer ID]=c.Customer_ID

--test view query 

select * from LoanSummary 

--------view to count each transaction and display the sum of transactions-------

create or alter view most_transactions
as
  select t.TransactionType , count(a.TransactionTypeId) as count_transactions 
  from transactions_ATM_Account a, Transcations t
  where a.TransactionTypeId= t.Transaction_Type_Id
  group by transactionType
  union all
  SELECT 'Sum_of_Transactions' Transaction_type_Id, count(a.TransactionTypeId)
  FROM transactions_ATM_Account a
 
--test view query 

SELECT * from most_transactions

-----------create a view to get customer and their account details with the availability loans amount---------

create or alter  view v_customer_acc_details 
As 
select c.Customer_ID, cp.[Mobile Number] , concat(c.[First Name],c.[Last Name]) as "Full Name" 
,a.[Account Number] , a.Balance , l.Amount as "Loan Amount" 
from Customer_phones cp inner join Customer c 
on cp.Customer_ID = c.Customer_ID
inner join account a 
on c.Customer_ID = a.[Customer ID]
inner join loan l 
on c.Customer_ID = l.[Customer ID]
group by c.Customer_ID, cp.[Mobile Number],concat(c.[First Name],c.[Last Name]), a.[Account Number] , a.Balance , l.Amount 

--test view query 

select * from v_customer_acc_details



--------------------------------Funcation-----------------------------

----------------Function to calculate total salary for each department --------

CREATE  OR ALTER FUNCTION cal_salary(@dnum INT)
RETURNS DECIMAL(10,2)
BEGIN
DECLARE @total DECIMAL(10,2)
SELECT  @total=SUM(salary)
FROM  employee 
WHERE Dno=@dnum
RETURN @total
END 

--test function query 

--select * from Employee
select dbo.cal_Salary(10) AS Total_Salary


---------Create Scalar function name GetEmployeeSupervisor------------------------ 
--Returns the name of an employee's supervisor based on their employeeid.---------

create or alter function getemployeesupervisor (@employeeid int) 
returns varchar(50)
 begin 
    declare @name varchar(50),@name2 VARCHAR(50)
  select @name=s.[First Name] ,@name2=s.[Last Name]
  from employee e join employee s
  on s.[Employee ID]=e.SuperVisor_ID
  where e.[Employee ID]=@employeeid
  return @name + ' '+ @name2
 end 

--test function query 

--select * from Employee
select dbo.getemployeesupervisor (2) as fullname


--------------create function Calculate Monthly payment ----------------

create or alter function dbo.CalculateMonthlypayment(
@interest_rate float,
@loan_amount float,
@loan_termmonths int,
@monthly_interestrate float )
returns float
as 
begin 
	set @monthly_interestrate = @interest_rate/(12*100) ;
	return ( @loan_amount*@monthly_interestrate) / (1 - power(1+ @monthly_interestrate,-@loan_termmonths)) ;
End;

--test function query 

select dbo.CalculateMonthlypayment(4.56,116500,42,0.0038) as [Monthly Loan Payment] 

-----------------create function calculate Interest Amount -------------------------

create function dbo.calculateInterestAmount(
@loan_amount float,
@interest_rate float,
@loan_termmonths int)
returns float
as
begin
	return @loan_amount*(@interest_rate/(12*100))*@loan_termmonths
end;

--test function query 

select dbo.calculateInterestAmount(1000,10,12) as [Interest Amount]

-------------------------------Procedure-----------------------------

---------------------Procedure to count employees in each department------------------------------

create or alter proc total_of_num 
as
select count(e.[Employee ID]) as count_num,d.DName
from employee e join Department d
on e.Dno= d.dnumber
group by d.dname

--test proc query 

execute total_of_num 

-------------proc that return the transactions that specific customer had done------------------

CREATE OR ALTER proc get_customer_transaction @account_nu INT, @trans_date DATE
AS
    begin
    if EXISTS (SELECT * FROM transactions_ATM_Account a WHERE a.[Account Number] = @account_nu)
    begin
        SELECT a.TransactionDate, a.[Account Number],a.transactionid,a.[ATM ID]
		,Amount,a.TransactionTypeId, t.TransactionType
        FROM transactions_ATM_Account  a join Transcations t
		on a.TransactionTypeId = t.Transaction_Type_Id
        WHERE a.[Account Number] = @account_nu
        AND a.transactiondate = @trans_date	
    END
    ELSE
    BEGIN
        PRINT 'This id is invalid'
end
        RETURN 
    END 
--test proc query

--SELECT * FROM Account 
EXECUTE get_customer_transaction 1002, '2023-02-6'

----------proc that return the amount of money of specific transaction type-------------

create or alter proc total_amount_of_specific_transaction @transaction_type varchar(20)
as 
select t.transactionType,a.TransactionTypeId ,sum(amount) as sum_amount_transaction
from transcations t, transactions_ATM_Account a
where a.TransactionTypeId = t.Transaction_Type_Id 
and transactionType =  @transaction_type
group by transactionType, a.TransactionTypeId

--test proc query 

--SELECT * FROM Account_Atm_transcation aat 
EXECUTE total_amount_of_specific_transaction 'Withdrawal'

------------Create a stored procedure to add "Dear" as a prefix to customer's name.-------------------- 

CREATE OR ALTER PROCEDURE sp_Update_customer 
@customerId int
AS
UPDATE Customer 
SET [First Name] = Concat('Dear' , ' ' , [First Name])
where Customer_ID = @customerId 

--test proc query 

--SELECT * FROM customers

EXEC sp_Update_customer 1;
  
---------Create a stored procedure that accepts AccountId as a parameter and returns customer's full name and account's details.--------- 

create PROCEDURE sp_Customer_Details @AccountNumber INT
AS
SELECT c.[First Name] +' ' +c.[Last Name] AS Customer_full_name , a.[Account Number] ,a.balance 
FROM Customer c
JOIN Account a
ON c.Customer_ID = a.[Customer ID]
WHERE a.[Account Number] = @AccountNumber;

--test proc query

EXEC sp_Customer_Details 1001;

-------------Write a query to remove cstate column from Customer table. -----------------------

CREATE PROCEDURE sp_Remove_Column
AS
ALTER TABLE Customers
DROP COLUMN state

--test proc query      $danguer$   $danguer$   $danguer$   $danguer$   $danguer$ 

EXEC sp_Remove_Column;

---------------------------------------Trigger-----------------------------------------------------

----------------------Trigger to update last_updated column when an employee is updated---------------

ALTER TABLE employee 
ADD last_updated DATETIME
    
CREATE OR ALTER TRIGGER UpdateEmployeeLastUpdated
ON Employee
AFTER UPDATE
as
BEGIN
    UPDATE Employee
    SET last_updated = GETDATE()
	FROM employee e,INSERTED i
    WHERE e.[Employee ID] = i.[Employee ID];
END

--test trigger query 

UPDATE employee 
SET salary+=200000
WHERE [Employee ID]=1

SELECT * FROM employee 

---------------------Trigger that update balance depend on the transaction type----------------------

create or alter trigger update_balance
on transactions_ATM_Account
after insert 
AS

 if exists (select TransactionTypeId from inserted where TransactionTypeId=1)

 begin 
 declare @amount float, @account_no int
 select @amount = amount, @account_no = [Account Number] from inserted
 update Account
 set balance -= @amount where [Account Number] = @account_no
 END

 else if exists(select TransactionTypeId from inserted where TransactionTypeId =2)

 begin 
 select @amount = amount, @account_no = [Account Number] from inserted
 update Account
 set balance += @amount where [Account Number] = @account_no
 end

--test trigger query 

 insert into transactions_ATM_Account
 values (37599,1,1000,'2023-8-19',1001,Null)

 select* from Account

--------------------------------cte--------------------------------------------------

------------------------CREATE cte employee salary greather  than 45000 and his department name--------------
 WITH CTE_Employee 
 AS 
 ( SELECT [First Name], [Last Name],  Salary,d.dname
 FROM Employee e JOIN department d 
 ON d.Dnumber= e.Dno
WHERE Salary > '15000' )
--run cte 
SELECT [First Name], [Last Name],Dname, Salary
FROM CTE_Employee

--SELECT * FROM employee 

--------------------------------case-----------------------------------------------
--create case on age to return baby,young,old
SELECT [First Name], [Last Name], Age,  
CASE 
WHEN Age > 40 THEN 'Old' 
WHEN Age BETWEEN 27 AND 40 THEN 'Young man' 
ELSE 'Child'
END AS description_Age
FROM Customer 
WHERE Age IS NOT NULL 
ORDER BY age
-------------------------rank----------------------------------
SELECT *, dense_RANK() OVER(PARTITION BY Dno ORDER BY Salary ) AS employe_rank
FROM Employee 
ORDER BY Dno, Salary

--test
SELECT * FROM employee

----------------------------------- top -------------------------           
select top 2 * from employee  
----------------------------------like -------------------------
select * from employee e 
where [First Name] like '_k%'
-------------------------------end--------------------------------
