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

<br> create database Union_Bank
<br> go

<br> USE Union_Bank
<br> go

<br> --2)Q2.Create all the tables mentioned in the database diagram.
<br> --create tables & add constraint Section 
<br> --3)Q3. Create all the constraints based on the database diagram.

<br> --Creating table named Customers

<br> create table Customers 
<br> (
<br> CustomerId int primary key identity(1,1),
<br> FirstName varchar(50) not null,
<br> LastName varchar(50) not null,
<br> Gender varchar(1) not null,
<br> Email varchar(50) not null,
<br> BirthDate date not null,
<br> Age as year(getdate())-year (BirthDate),
<br> City varchar(50) not null,
<br> State varchar(50) not null,
<br> --constraint ch1 check(Gender in ('m','f'))
<br> );
<br> go

<br> --Creating table named Customer_phones

<br> create table Customer_phones 
<br> (
<br> CustomerId int,
<br> phone varchar(50) not null,
<br> constraint  Customer_phones_IDS primary key (CustomerId, phone),
<br> constraint Customer_phones_Customers foreign key (CustomerId) 
<br> references Customers (CustomerId)
<br> );
<br> go

<br> --Creating table named Branch

<br> create table Branch 
<br> (
<br> BranchId int primary key,
<br> BranchName varchar(50) not null,
<br> Branch_Location varchar(50) not null,
<br> );
<br> go

<br> --Creating table named Account

<br> create table Account 
<br> (
<br> AccountNumber int primary key, 
<br> AccountType varchar(50) ,
<br> Balance float not null,
<br> OpenDate date default getdate(),
<br> Account_Status varchar(30) not null,
<br> Branchid INT,
<br> CustomerId int,
<br> constraint customer_Account foreign key (CustomerId)
<br> references Customers (CustomerId),
<br> constraint Branch_Account foreign key (Branchid)
<br> references Branch (BranchId),
<br> --constraint ch2 check(Account_status in ('active','not active')),
<br> );
<br> go
  
<br> ---we can check on account type through this constraint to check if 
<br> --- the account saving or current ---
<br> alter table account add constraint check_status check(accounttype in ('saving','current'))

<br> --Creating table named Transactions

<br> create table Transactions 
<br> (
<br> Transaction_Type_Id int primary key identity (1,1),
<br> TransactionType varchar(30) not null,
<br> );
<br> go

<br> --Creating table named Card 

<br> create table Card (
<br> CardNumber int primary key,
<br> CardType varchar(30) not null,
<br> card_Status varchar (30) not null,
<br> ExpiryDate date not null,
<br> AccountNumber int,
<br> constraint Card_Account  foreign key (AccountNumber)
<br> references Account (AccountNumber) 
<br> );
<br> go

<br> --Creating table named Employee

<br> create table Employee
<br> (
<br> EmployeeId int primary key,
<br> FirstName varchar(30) NOT NULL,
<br> LastName varchar(30) NOT null,
<br> Salary DECIMAL NOT NULL,
<br> Position varchar(50) NOT NULL,
<br> SupervisorID int,
<br> branchid INT,
<br> Dno INT,
<br> constraint super_Employee foreign key(SupervisorID)
<br> REFERENCES Employee (EmployeeId),
<br> CONSTRAINT branchid_Employee foreign key(branchid)
<br> references branch(branchid) ,
<br> );
<br> go

<br> --create table named Department

<br> CREATE TABLE Department 
<br> (
<br> Dnumber INT PRIMARY KEY,
<br> Dname VARCHAR(50) NOT NULL,
<br> MgriD INT,
<br> constraint manager_Employee foreign key(MgriD)
<br> REFERENCES Employee (EmployeeId) 
<br> )

<br> ALTER TABLE employee 
<br> ADD constraint Dno_Employee foreign key(Dno)references Department (DNumber) 

<br> --Creating table named Loan

<br> create table Loan 
<br> (
<br> LoanId int primary key,
<br> Amount decimal not null,
<br> loan_months_terms int not null,
<br> LoanType varchar(30) not null,
<br> StartDate date not null,
<br> EndDate date not null,
<br> InterestRate varchar(20) not null,
<br> customerid int,
<br> BranchId int,
<br> constraint Loan_customer foreign key (customerid)
<br> references Customers (customerid),
<br> constraint Loan_Branch foreign key (BranchId)
<br> references Branch (BranchId)
<br> );
<br> go

<br> --Creating table named ATM

<br> create table ATM 
<br> (
<br> AtmId int primary key,
<br> Atm_location varchar(50) NOT NULL,
<br> Atm_status varchar(30) NOT NULL ,
<br> BranchId int,
<br> constraint ATM_Branch foreign key (BranchId)
<br> references Branch(BranchId)
<br> );
<br> GO

<br> --create table Account_Atm_transcation

<br> CREATE TABLE Account_Atm_transcation
<br> (
<br> TransactionDate  DATE DEFAULT GETDATE() ,
<br> AccountNumber INT,
<br> transactionid INT identity(1,1) primary key,
<br> Transaction_Type_Id int,
<br> Atmid INT,
<br> Amount FLOAT NOT NULL, 
<br> CONSTRAINT Atm_account_transcation foreign key (AccountNumber) references Account(AccountNumber),
<br> CONSTRAINT transcation_Account_Atm foreign key (Transaction_Type_Id) references Transactions(Transaction_Type_Id)
<br> );
<br> go

# DATAWAREHOUSE
# Denormalized Data Base star Schema 
<br> Business Process "Transactions "
<br> Grain "Low Level"
<br> Dimensions -----> Account - Branch - Customer -ATM - Date - card 
<br> Fact Table: Transaction Table

# Satr OLTP schema

![OLAP_schema](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/3f65bc83-59bd-496a-876a-409758e80f27)

# Business Intelligence Using SSIS SSAS SSRS 
# First Integration using SSIS

![Atm_BranchDims](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/093af28a-95ce-4455-ab0f-56e5bc0a4b40)

# Secound Cube "The cube is Genarlized About Business and Specified for the CEO And CMO Should closely track financial performance, set clear goals, and analyse key metrics to measure profits. they must identify and manage risks by conducting assessments and creating strategies to mitigate potential threats."

![Cube](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/a5d9acd4-638b-406b-bdcb-d48097e89a08)

# Thrid Reporting using SSRS 

![120-121](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/e4985995-c7a7-4491-86b4-7b7551185c82)

![122-123](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/99f321b5-35aa-4c55-adbe-b25bc96bc2e4)

# Visualzation 
# Using Power BI
# The analysis of the Bank application history data of sales, customer, product and operations departments to figure out the company's performance to get an overview insight of both departments will empower the company to make data-driven decisions that can lead to increased revenue, cost savings, improved customer satisfaction, and enhanced overall business performance.

# It allows businesses to respond to market dynamics, customer preferences, and operational challenges more effectively and provides valuable insights to the operations, marketing, and sales teams for informed decision-making.

# Watch and Try IT
[[https://app.powerbi.com/view?r=eyJrIjoiYzBhOTBlZjktNWFmNC00YTk1LTlmMTYtN2UxMDJiNjAzZWE0IiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9](https://www.novypro.com/project/baking-system-|-analysis-dashboard)https://www.novypro.com/project/baking-system-|-analysis-dashboard](https://www.novypro.com/project/baking-system-|-analysis-dashboard)

![overview](https://github.com/Ahmedelbermawy/Bank_system_graduation_project/assets/133806022/33ac723b-86e4-442a-9024-c76916a70fc1)






