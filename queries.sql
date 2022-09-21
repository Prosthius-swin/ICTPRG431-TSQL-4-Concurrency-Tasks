SELECT name, physical_name AS DB_FILE_LOCATION
FROM sys.master_files

SELECT *
FROM information_schema.tables;

CREATE DATABASE TSQL_4_Concurrency_Tasks;
GO
USE TSQL_4_Concurrency_Tasks;
GO

CREATE TABLE EmployeeInfo
(
    EmpID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);

INSERT INTO EmployeeInfo (EmpID, FirstName, LastName)
VALUES 
(1, 'John', 'Smith');
(2, 'Jane', 'Doe'),
(3, 'Joe', 'Doe'),
(4, 'John', 'Doe'),
(5, 'Jane', 'Smith');



-- session 1
BEGIN TRANSACTION; 
 
UPDATE EmployeeInfo
SET FirstName = 'Frank'
WHERE EmpID = 1;
 
WAITFOR DELAY '00:00:10'  
 
ROLLBACK TRANSACTION;

--session 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;

-- session 1
BEGIN TRANSACTION; 
 
UPDATE EmployeeInfo
SET FirstName = 'Frank'
WHERE EmpID = 1;
 
WAITFOR DELAY '00:00:10'  
 
ROLLBACK TRANSACTION;

--session 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;

--session 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
BEGIN TRANSACTION;
 
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;
 
WAITFOR DELAY '00:00:10'  
 
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;
 
ROLLBACK TRANSACTION;

--session 2
UPDATE EmployeeInfo
SET FirstName = 'Frank'
WHERE EmpID = 1;
