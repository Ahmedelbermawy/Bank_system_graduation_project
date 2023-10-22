create database TransactionsDM 

USE TransactionsDM
GO 

CREATE TABLE TranscationsDIM 
(
Transaction_Type_Id INT PRIMARY KEY,
TransactionType VARCHAR(100) NOT NULL
)

CREATE TABLE CustomerAcountDIM
(
[Account Number] INT PRIMARY KEY  ,
[Customer ID] INT ,
[Account Type] NVARCHAR(255) ,
[Balance] FLOAT,
[Status] NVARCHAR(255),
[CardNumber] varchar(50),
[Card_Type] varchar(50),
[Card_Status] varchar(50),
[Expiry_Date] date,
[First Name] VARCHAR(50),
[Last Name] VARCHAR(50),
[State] VARCHAR(50),
[Age] INT,
[Gender] VARCHAR(50),
[BD] DATE

)



CREATE TABLE ATMBranchDIM 
(
[Branch ID] INT  ,
[BranchName] NVARCHAR(255),
[Branch_Location] NVARCHAR(255),
[Location] NVARCHAR(255),
[ATM Status] NVARCHAR(255),
[ATM ID] int primary key
)


create table TransactionFact
(
[TransactionId] BIGINT PRIMARY KEY,
[TransactionTypeId] INT,
[Amount] MONEY ,
[TransactionDate] DATE,
[ATM ID] INT,
[Account Number] int
)

drop table DateDimension
-- Create the DateDimension table
CREATE TABLE DateDimension 
(
    DateKey INT ,
    FullDate DATE PRIMARY KEY,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT,
    DayOfWeek INT,
    DayOfYear INT,
    WeekOfYear INT,
    IsWeekend BIT,
    IsHoliday BIT
);

-- Populate the DateDimension table with dates
DECLARE @StartDate DATE = '2022-01-01';
DECLARE @EndDate DATE = '2030-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DateDimension (DateKey, FullDate, Year, Quarter, Month, Day, DayOfWeek, DayOfYear, WeekOfYear, IsWeekend, IsHoliday)
    VALUES (
        CAST(FORMAT(@StartDate, 'yyyyMMdd') AS INT), -- DateKey in YYYYMMDD format
        @StartDate, -- FullDate
        YEAR(@StartDate), -- Year
        DATEPART(QUARTER, @StartDate), -- Quarter
        MONTH(@StartDate), -- Month
        DAY(@StartDate), -- Day
        DATEPART(WEEKDAY, @StartDate), -- DayOfWeek (Sunday=1, Monday=2, ..., Saturday=7)
        DATEPART(DAYOFYEAR, @StartDate), -- DayOfYear
        DATEPART(WEEK, @StartDate), -- WeekOfYear
        CASE WHEN DATEPART(WEEKDAY, @StartDate) IN (1, 7) THEN 1 ELSE 0 END, -- IsWeekend (1 for Saturday or Sunday, 0 otherwise)
        -- You can add logic to determine holidays and set IsHoliday accordingly
        0
    );
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;


alter table atmbranchdim 
alter column atmid int not null

