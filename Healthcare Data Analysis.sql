--Create Database and Use
create database healthinsightdb;
use healthinsightdb;

--select top 10 records from healthcare_dataset
select top 10 * from dbo.healthcare_dataset;

--1.Explore Dataset
--1.1 Total Records
select count(*) as Total_Records from dbo.healthcare_dataset;

--1.2 View Unique Diseases
select distinct Medical_Condition from dbo.healthcare_dataset;

--1.3 View Unique Addmission Types
select distinct Admission_Type from dbo.healthcare_dataset;

--2. Perform SQL Analysis Queries
--2.1 Gender Distribution
select Gender,
count(*) as total_patients
from dbo.healthcare_dataset
group by Gender;

--2.2 Most common disease
select Medical_Condition,
count(*) as Total_Cases
from dbo.healthcare_dataset
group by Medical_Condition
order by total_cases desc;

--2.3 Average Billing Amount
select avg(Billing_Amount) as Average_Billing_Amount from dbo.healthcare_dataset;

--2.4 Highest Billing Patient
select top 10
Name,
Medical_Condition,
Billing_Amount
from healthcare_dataset
order by Billing_Amount desc;

--2.5 Insurance Provider Analysis
select Insurance_Provider,
count(*) as Total_Patients,
avg(Billing_Amount) as Average_Billing
from dbo.healthcare_dataset
group by Insurance_Provider
order by Total_Patients desc;

--2.6 Emergency vs Urgennt vs Elective Admissions
select Admission_Type,
count(*) as Total_Admissions
from dbo.healthcare_dataset
group by Admission_Type;

--2.7 Test Result Analysis
select Test_Results,
count(*) as Total_Patients
from dbo.healthcare_dataset
group by Test_Results;

--3 Advanced SQL
--3.1 Window Function to Rank Patients by Billing Amount
select Name,
Billing_Amount,
Rank() over (order by Billing_Amount desc) as Billing_Rank
from dbo.healthcare_dataset;

--3.2 Case Statement
select Name,
Age,
CASE 
	WHEN Age < 18 THEN 'Child'
	WHEN Age BETWEEN 18 AND 60 THEN 'Adult'
	ELSE 'Senior'
END as Age_Group
from dbo.healthcare_dataset;

--3.3 Monthly Admissions Trend
select
MONTH(Date_of_Admission) as Admission_Month,
count(*) as Total_Admissions
from dbo.healthcare_dataset
group by MONTH(Date_of_Admission)
order by Admission_Month;

--To perform a join with another table, we need to create another tables first.
--Create Patients Table
create table Patients (
Patient_ID int primary key,
Name varchar(100),
Age int,
Gender Varchar(10),
Blood_Type Varchar(5)
);
insert into Patients
select ROW_NUMBER() over (order by Name) as Patient_ID,
Name,
Age,
Gender,
Blood_Type
from dbo.healthcare_dataset;

create table Admissions (
Patient_ID int,
Hospital varchar(100),
Doctor varchar(100),
Addmission_Type varchar(50),
Date_of_Admission date,
Date_of_Discharge date,
Room_Number int,
);
insert into Admissions
select ROW_NUMBER() over (order by Name) as Patient_ID,
Hospital,
Doctor,
Admission_Type,
Date_of_Admission,
Discharge_Date,
Room_Number
from dbo.healthcare_dataset;

create table Billing (
Patient_ID int,
Insurance_Provider varchar(100),
Billing_Amount float
);	
insert into Billing
select ROW_NUMBER() over (order by Name) as Patient_ID,
Insurance_Provider,
Billing_Amount
from dbo.healthcare_dataset;

create table Medical_Records (
Patient_ID int,
Medical_Condition varchar(100),
Medication varchar(100),
Test_Results varchar(100)
);
insert into Medical_Records
select ROW_NUMBER() over (order by Name) as Patient_ID,
Medical_Condition,
Medication,
Test_Results
from dbo.healthcare_dataset;

--Inner Join
select
p.Name,
p.Gender,
a.Hospital,
a.Doctor
from Patients p
inner join Admissions a on p.Patient_ID = a.Patient_ID;

--Join with Billing
select
p.Name,
b.Insurance_Provider,
b.Billing_Amount
from Patients p
inner join Billing b on p.Patient_ID = b.Patient_ID;

--Muti Table Join
select
p.Name,
m.Medical_Condition,
a.Hospital,
b.Billing_Amount
from Patients p
inner join Medical_Records m on p.Patient_ID = m.Patient_ID
inner join Admissions a on p.Patient_ID = a.Patient_ID
inner join Billing b on p.Patient_ID = b.Patient_ID;

--Verify Table
select top 10 * from Patients;
select top 10 * from Admissions;
select top 10 * from Billing;
select top 10 * from Medical_Records;

--Summary of the dataset
--Developed a healthcare analytics project using Microsoft SQL Server Management Studio by performing data cleaning, normalization, joins, aggregate functions, and analytical queries to analyze patient demographics, billing trens, hostipal performance, and medical conditions.
