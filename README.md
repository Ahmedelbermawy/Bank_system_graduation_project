# BankSystemGraduationProject_ITI
# BankSystemDesign
# First we Received a Required Document from the client 
![Screenshot 2023-10-22 210826](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/921f5c42-373c-4302-9adc-ba5e8257950f)

# Second We Start to Draw The ERD 
![02_ERD](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/e3ab73b9-c414-4a48-85c4-5cf8f19abc46)

# Thrid We Start to Execute The Mapping 
![03_Mapping](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/88b6f7bc-90c2-40d7-9587-70820f763a35)

# Fourth implementation  of OLTP schema  
![05_OLTP_schema](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/6c5ab93b-c3dd-4948-a8ab-836515ca0758)

# Let's go for structure

create database Union_Bank
go
USE Union_Bank
go

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

--Creating a table named Customer_phones

create table Customer_phones 
(
CustomerId int,
phone varchar(50) not null,
constraint  Customer_phones_IDS primary key (CustomerId, phone),
constraint Customer_phones_Customers foreign key (CustomerId) 
references Customers (CustomerId)
);
go

--Creating a table named Branch

create table Branch 
(
BranchId int primary key,
BranchName varchar(50) not null,
Branch_Location varchar(50) not null,
);
go

--Creating a table named Account

create table Account 
(
AccountNumber int primary key, 
AccountType varchar(50) ,
Balance float not null,
Account_Status varchar(30) not null,
Branchid INT,
CustomerId int,
constraint customer_Account foreign key (CustomerId)
references Customers (CustomerId),
constraint Branch_Account foreign key (Branchid)
references Branch (BranchId),
--constraint ch2 check(Account_status in ('active','not active')),
);
go

alter table account add constraint check_status check(account type in ('saving','current'))

--Creating a table named Transactions

create table Transactions 
(
Transaction_Type_Id int primary key identity (1,1),
TransactionType varchar(30) not null,
);
go

--Creating a table named Card 

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
ADD add column csv INT null
ALTER TABLE card
ALTER COLUMN cardnumber BIGINT 

--Creating a table named Employee

create table Employee
(
EmployeeId int primary key,
FirstName varchar(30) NOT NULL,
LastName varchar(30) NOT null,
Salary DECIMAL NOT NULL,
Position varchar(50) NOT NULL,
SupervisorID int,
branchid INT,
Dno INT,
constraint super_Employee foreign key(SupervisorID)
REFERENCES Employee (EmployeeId),
CONSTRAINT branchid_Employee foreign key(branchid)
references branch(branchid) ,
);
go
ALTER TABLE Employee
ALTER COLUMN SuperVisor_ID 

--create a table named Department

CREATE TABLE Department 
(
Dnumber INT PRIMARY KEY,
Dname VARCHAR(50) NOT NULL,
MgriD INT,
constraint manager_Employee foreign key(MgriD)
REFERENCES Employee (EmployeeId) 
)

ALTER TABLE employee 
ADD constraint Dno_Employee foreign key(Dno)references Department (DNumber) 

--Creating a table named Loan

create table Loan 
(
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

--Creating a table named ATM

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
transaction-id INT identity(1,1) primary key,
Transaction_Type_Id int,
Atmid INT,
Amount FLOAT NOT NULL, 
CONSTRAINT Atm_account_transcation foreign key (AccountNumber) references Account(AccountNumber),
CONSTRAINT transcation_Account_Atm foreign key (Transaction_Type_Id) references Transactions(Transaction_Type_Id)
);
GO

ALTER TABLE Account_Atm_transcation
ALTER COLUMN TransactionId 



