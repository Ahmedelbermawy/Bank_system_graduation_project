--Documentation For DB Banking System SQL Code Implementation
--MS-SQL PROJECT on Banking System name union_Bank

--PHASE I of project begins

--1)Q1.Create a database for a banking application called ‘Union_Bank’ 
-----Using Our Database ‘Union_Bank'

create database Union_Bank
go

USE Union_Bank
go

--2)Q2.Create all the tables mentioned in the database diagram.
--create tables & add constraint Section 
--3)Q3. Create all the constraints based on the database diagram.

--Creating table named Customers
create table Customers 
(
CustomerId int primary key identity(1,1),
FirstName varchar(50) not null,
LastName varchar(50) not null,
Gender varchar(1) not null,
Email varchar(50) not null,
BirthDate date not null,
Age as year(getdate())-year (BirthDate),

State varchar(50) not null,
--constraint ch1 check(Gender in ('m','f'))
);
go

--Creating table named Customer_phones
create table Customer_phones 
(
CustomerId int,
phone varchar(50) not null,
constraint  Customer_phones_IDS primary key (CustomerId, phone),
constraint Customer_phones_Customers foreign key (CustomerId) 
references Customers (CustomerId)
);
go

--Creating table named Branch
create table Branch 
(
BranchId int primary key,
BranchName varchar(50) not null,
Branch_Location varchar(50) not null,
);
go

--Creating table named Account
create table Account 
(
AccountNumber int primary key, 
AccountType varchar(50) ,
Balance float not null,
Account_Status varchar(30) not null,
Branchid INT,
CustomerId int,
constraint customer_Account foreign key (CustomerId)
references Customers (CustomerId) ,
constraint Branch_Account foreign key (Branchid)
references Branch (BranchId) ,
--constraint ch2 check(Account_status in ('active','not active')),
);
go
  
---we can check on account type through this constraint to check if 
--- the account saving or current ---
alter table account add constraint check_status check(accounttype in ('saving','current'))

--Creating table named Transactions
create table Transactions 
(
Transaction_Type_Id int primary key identity (1,1),
TransactionType varchar(30) not null,
);
go

--Creating table named Card */
create table Card (
CardNumber int primary key,
CardType varchar(30) not null,
card_Status varchar (30) not null,
ExpiryDate date not null,
AccountNumber int,
constraint Card_Account  foreign key (AccountNumber)
references Account (AccountNumber) 
);
go
ALTER TABLE card 
ADD addcolumn csv INT null
ALTER TABLE card
ALTER COLUMN cardnumber BIGINT 

--Creating table named Employee
create table Employee (
EmployeeId int primary key,
FirstName varchar(30) NOT NULL,
LastName varchar(30) NOT null,
Salary DECIMAL NOT NULL,
Position varchar(50) NOT NULL,
SupervisorID int ,
branchid INT,
Dno INT ,
constraint super_Employee foreign key(SupervisorID)
REFERENCES Employee (EmployeeId) ,
CONSTRAINT branchid_Employee foreign key(branchid)
references branch(branchid) ,
);
go
ALTER TABLE Employee
ALTER COLUMN SuperVisor_ID 

--create table named Department
CREATE TABLE Department 
(
Dnumber INT PRIMARY KEY ,
Dname VARCHAR(50) NOT NULL,
MgriD INT ,
constraint manager_Employee foreign key(MgriD)
REFERENCES Employee (EmployeeId) 
)

ALTER TABLE employee 
ADD constraint Dno_Employee foreign key(Dno)references Department (DNumber) 

--Creating table named Loan
create table Loan (
LoanId int primary key,
Amount decimal not null,
loan_months_terms int not null,
LoanType varchar(30) not null,
StartDate date not null,
EndDate date not null,
InterestRate varchar(20) not null,
customerid int,
BranchId int,
constraint Loan_customer foreign key (customerid)
references Customers (customerid),
constraint Loan_Branch foreign key (BranchId)
references Branch (BranchId)
);
go


--Creating table named ATM
create table ATM (
AtmId int primary key,
Atm_location varchar(50) NOT NULL,
Atm_status varchar(30) NOT NULL ,
BranchId int,
constraint ATM_Branch foreign key (BranchId)
references Branch(BranchId)
);
GO

--create table Account_Atm_transcation
CREATE TABLE Account_Atm_transcation
(
TransactionDate  DATE DEFAULT GETDATE() ,
AccountNumber INT,
transactionid INT identity(1,1) primary key,
Transaction_Type_Id int,
Atmid INT ,
Amount FLOAT NOT NULL, 
CONSTRAINT Atm_account_transcation foreign key (AccountNumber) references Account(AccountNumber),
CONSTRAINT transcation_Account_Atm foreign key (Transaction_Type_Id) references Transactions(Transaction_Type_Id)
);
GO
ALTER TABLE Account_Atm_transcation
ALTER COLUMN TransactionId 