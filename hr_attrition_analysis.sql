use Employees;

select count(*) as TotalRows from dbo.[HR-Employee-Attrition];

--See what's inside
Select top 10 * from dbo.[HR-Employee-Attrition];

-- check the column and data types
EXEC sp_help'dbo.[HR-Employee-Attrition]';

-- Handle missing values
Delete from [HR-Employee-Attrition] 
where Department is Null
OR Age is Null
OR MonthlyIncome is Null;

Update [HR-Employee-Attrition]
Set Age = (Select(AVG(Age)) From [HR-Employee-Attrition])
where Age is null

-- convert to proper types
Alter Table [HR-Employee-Attrition]
Alter Column Age INT;

Alter Table [HR-Employee-Attrition]
Alter Column [MonthlyIncome] Decimal (18,2);

Alter Table [HR-Employee-Attrition]
Alter Column [YearsAtCompany] int;

--Remove Duplicates
with CTE AS (
	Select *,
		Row_Number() over (PARTITION by EmployeeNumber ORDER by EmployeeNumber) AS rn
	from [HR-Employee-Attrition])
Delete From CTE where rn >1;

-- Check for outliers 
Select * from [HR-Employee-Attrition]
where Age <18 OR Age >70;

SElect * From [HR-Employee-Attrition]
Where [MonthlyIncome] = 0;

-- Look for missing values in important columns
SELECT
    SUM(CASE WHEN EmployeeNumber IS NULL THEN 1 ELSE 0 END) AS Missing_EmployeeNumber,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Missing_Age,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Missing_Gender,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS Missing_Department,
    SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS Missing_JobRole,
    SUM(CASE WHEN [MonthlyIncome] IS NULL THEN 1 ELSE 0 END) AS Missing_MonthlyIncome,
    SUM(CASE WHEN [YearsAtCompany] IS NULL THEN 1 ELSE 0 END) AS Missing_YearsAtCompany,
    SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS Missing_Attrition,
    SUM(CASE WHEN PerformanceRating IS NULL THEN 1 ELSE 0 END) AS Missing_PerformanceRating
FROM [HR-Employee-Attrition];

--See the actual rows with missing data
SELECT *
FROM [HR-Employee-Attrition]
WHERE EmployeeNumber IS NULL
   OR Age IS NULL
   OR Gender IS NULL
   OR Department IS NULL
   OR [MonthlyIncome] IS NULL
   OR Attrition IS NULL;

SELECT
    COUNT(*) AS TotalRows,
    100.0 * SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS PctMissing_Age,
    100.0 * SUM(CASE WHEN [MonthlyIncome] IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS PctMissing_Salary,
    100.0 * SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS PctMissing_Department
FROM [HR-Employee-Attrition];

--Quick analysis - Attrition rate
SELECT
	Attrition,
	count(*) AS count,
	Round(100.0 * count(*)/ SUM(Count(*)) over(),2) AS Perc
from dbo.[HR-Employee-Attrition]
Group by Attrition;

-- find Stuff
select * from dbo.[HR-Employee-Attrition]
where Attrition ='Yes';

--select top 5
select top 5 Age,MonthlyIncome from dbo.[HR-Employee-Attrition];

select top 5 *from dbo.[HR-Employee-Attrition];

--Show only employees who left the compony
select count( * ) as EmployeesWhoLeft
from [HR-Employee-Attrition] 
where Attrition ='Yes';

--count employees by department
select Department, count(*) as TotalEmployees
From [HR-Employee-Attrition]
Group by Department;

--Average monthly income by job role
select jobRole,
	AVG(MonthlyIncome) as AverageSalary
From [HR-Employee-Attrition]
Group by JobRole;

--Attrition by gender
select Gender,
	Attrition,
	count(*) AS Total
From [HR-Employee-Attrition]
Group By Gender, Attrition;

--Attrition by jobrole and department
Select 
Department,
JobRole,
Count(*) As Total,
Sum(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) as LeftCount,
Round(100.0 * Sum(CASE WhEN Attrition = 'YES' Then 1 ELSE 0 END)/ count(*), 2) as AttritionRate
from [HR-Employee-Attrition]
group by Department , JobRole
Order by AttritionRate Desc;

--WHAT MAKES PEOPLE LEAVE? AVG STATS
SELECT
Attrition,
AVG(CAST(AGE AS INT)) AS AVGAge,
AVG(CAST([MonthlyIncome] AS decimal(18,2))) AS AVGIncome,
AVG(CAST([YearsAtCompany] AS int)) AS AVGTenure,
AVG(CAST([JobSatisfaction] AS int)) AS AVGJobSatisfaction,
AVG(CAST([WorkLifeBalance] AS int)) AS AVGWorkingLifeBalance
from [HR-Employee-Attrition]
Group by Attrition

select Age,MonthlyIncome,JobRole
from [HR-Employee-Attrition]

select Department, BusinessTravel
From [HR-Employee-Attrition]

select count (*)  as EmployeesOlderThan30 from [HR-Employee-Attrition]
where Age > 30;

select * 
from [HR-Employee-Attrition]
where Department = 'Sales'
And Age>35;

select count(*) as EmployeesInSales
from [HR-Employee-Attrition]
where Department = 'Sales'
And Age>35;

--find all employees who are older than 40,work overtime and have monthly income greater than 8000
Select *
From [HR-Employee-Attrition]
where Age >40
AND OverTime ='Yes'
And MonthlyIncome> 8000;


Select count(*) as HighEanersWithOverTime
From [HR-Employee-Attrition]
where Age >40
AND OverTime ='Yes'
And MonthlyIncome> 8000;

--Add Attrition to see if they left
Select Age,Gender,Department,JobRole,MonthlyIncome,OverTime, Attrition
From [HR-Employee-Attrition]
where Age >30
AND OverTime ='Yes'
And MonthlyIncome> 8000
order by MonthlyIncome DESC;

--Employees who work overtime
select count (*) as EmployeeWorkOvertime
from [HR-Employee-Attrition]
where OverTime ='yes'

select *
from [HR-Employee-Attrition]
where OverTime ='yes'

--Monthly Income greater than 10 000
SELECT *
fROM [HR-Employee-Attrition]
WHERE  MonthlyIncome >10000

SELECT COUNT(*) AS MonthlyIncomeabove10000
fROM [HR-Employee-Attrition]
WHERE  MonthlyIncome >10000

--Employees who did not leave 
select * 
from [HR-Employee-Attrition]
Where Attrition ='No';

select count(*) as EmployeesStillWorking
from [HR-Employee-Attrition]
Where Attrition ='No';

Select Age,Department,Jobrole,Gender,MonthlyIncome
from [HR-Employee-Attrition]
where Age> 50
And OverTime ='Yes'
And Department ='Human Resources'
And MonthlyIncome >10000
And Attrition ='No';

--How Many Department are there
select count(distinct department) As TotalDepartment
from [HR-Employee-Attrition];

--How many male and female employees
select
	Gender,
	count(*) as EmployeeCount
from [HR-Employee-Attrition]
group by Gender
order by EmployeeCount;

--what is the average age?
select AVG(Age) as AverageAge
from [HR-Employee-Attrition];

--What is the average salary?
Select AVG(CAST([MonthlyIncome] as Decimal(18,2))) As AverageMonthlyIncome
from [HR-Employee-Attrition];

--All 5 in 1 query
SELECT 
	COUNT(*) AS TotalEmployees,
	Count(Distinct Department) as TotalDepartment,
	AVG(Age) as AverageAge,
	Avg([MonthlyIncome]) as AverageMonthlyIncome
From [HR-Employee-Attrition];

--Average Salary by department
select 
	Department,
	AVG(CAST([MonthlyIncome] AS DECIMAL(18,2))) AS AvgMonthlyIncome,
	count(*) as EmployeeCount
from [HR-Employee-Attrition]
Group by Department
Order by AvgMonthlyIncome Desc;

--Department with the highest salary
Select top 1 
	Department,
	AVG(CAST([MonthlyIncome] as decimal(18,2)))  as AVGMonthlyIncome
from [HR-Employee-Attrition]
Group by Department
Order by AVGMonthlyIncome DESC;

--Employees with the longest tenure
select top 10
	EmployeeNumber,
	Age,
	Department,
	Jobrole,
	YearsAtCompany as TenureYears,
	MonthlyIncome,
	Attrition
from [HR-Employee-Attrition]
Order by YearsAtCompany DESC;

--Highest paid employees
select top 10
	EmployeeNumber,
	Age,
	Gender,
	Department,
	JobRole,
	MonthlyIncome,
	Attrition
from [HR-Employee-Attrition]
Order by MonthlyIncome DESC;

--Rank Employees by salary
select 
	EmployeeNumber,
	Department,
	JobRole,
	CAST([MonthlyIncome] as decimal(18,2)) as MonthlyIncome,
	Rank() over(Order by CAST([MonthlyIncome] as decimal(18,2)) DESC) as SalaryRank
From [HR-Employee-Attrition];

--Salary Distribution
Select 
	case 
		When MonthlyIncome <5000 then 'Low: <5k'
		When MonthlyIncome between 5000 and 10000 Then 'Mid: 5k-10k'
		When MonthlyIncome between 10001 and 15000 then 'High: 10k-15k'
		else 'Very High:>15k'
	End as SalaryRange,
	Count(*) as EmployeeCount
from [HR-Employee-Attrition]
Group by 
	case
		When MonthlyIncome <5000 then 'Low: <5k'
		When MonthlyIncome between 5000 and 10000 Then 'Mid: 5k-10k'
		When MonthlyIncome between 10001 and 15000 then 'High: 10k-15k'
		else 'Very High:>15k'
	end
order by EmployeeCount DESC;

--Employee turnover/Attrition count
select
	Attrition,
	Count(*) as EmployeeCount
from [HR-Employee-Attrition]
group by Attrition;

--Attrition rate by department
select 
	Department,
	count(*) as TotalEmployees,
	Sum(Case when Attrition = 'Yes' Then 1 else 0 End ) as LeftCount,
	Round(100.0 * sum(case when attrition = 'Yes' Then 1 Else 0 End)/Count(*),2) as AttritionRate
From [HR-Employee-Attrition]
group by Department
Order by AttritionRate DESC;

--Average Performance Rating
select AVG(cast(performanceRating as Decimal (10,2))) as AvgPerformanceRating
from [HR-Employee-Attrition]

--Top Performaing departments
select 
	Department,
	AVG(cast(PerformanceRating as Decimal (10,2))) as AVGPerformanceRating,
	count(*) as TotalEmployees,
	Round(100.0*sum(case when Attrition ='yes' Then 1 Else 0 End)/Count(*),2) as AttritionRate
From [HR-Employee-Attrition]
Group by Department
Order by AVGPerformanceRating DESC;

--Work life Balance Distribution
select Worklifebalance,
count(*) as EmployeeCount,
round(100.0 * Count(*)/(Select count(*) from [HR-Employee-Attrition]),2) as percentage 
from [HR-Employee-Attrition]
group by Worklifebalance
Order by Worklifebalance;

--Satisfaction vs Attrition Risk
Select 
	JobSatisfaction,
	EnvironmentSatisfaction,
	Count(*) as TotalEmplyees,
	Sum(Case when Attrition = 'yes' then 1 else 0 end) as LeftEmployees,
	Round(100.0 * Sum(CASE WHEN Attrition = 'yes' THEN 1 ELSE 0 END )/Count(*),2) AS AttritionRate
from [HR-Employee-Attrition]
Group by JobSatisfaction, EnvironmentSatisfaction
Order by AttritionRate DESC;

--Factors that Drive attrition
Select 
	BusinessTravel,
	MaritalStatus,
	YearsAtCompany,
	JobLevel,
	count(*) as Total,
	SUM(Case When Attrition = 'Yes' THEN 1 ELSE 0 END) as Employees_Left
From [HR-Employee-Attrition]
Group by BusinessTravel,MaritalStatus,YearsAtCompany,JobLevel
Having Sum(Case When Attrition = 'Yes' THEN 1 ELSE 0 END)>0
Order by Employees_Left DESC;

--Salary by joblevel and Department
select
department,
jobLevel,
Count(*) as Employees,
Round(AVG(MonthlyIncome),2) AS AvgSalary,
Round(Min(MonthlyIncome),2) as MinSalary,
Round(Max(MonthlyIncome),2) as MaxSalary
from [HR-Employee-Attrition]
group by Department,JobLevel
Order by Department,JobLevel;

--Impact of PercentSalaryHike on attrition
Select
PercentSalaryHike,
Count(*) AS Employees,
Sum(CASE WHEN Attrition = 'Yes' THEN 1 Else 0 END ) AS Employees_left,
ROUND(100.0 * Sum(case when Attrition = 'Yes' Then 1 ELSE 0 END)/ Count(*),2) As AttritionRate
From [HR-Employee-Attrition]
Group by PercentSalaryHike
Order by PercentSalaryHike;

-- STOCK OPTIONS VS RETENTION
select 
	stockOptionLevel,
	count(*) as employees,
	Sum(Case WHen Attrition ='Yes' Then 1 ELSE 0 END) as EmployeesLeft,
	Round(100.0 * Sum(Case WHEN Attrition = 'Yes' Then 1 Else 0 End) /Count(*),2) as AttritionRate
From [HR-Employee-Attrition]
group by stockOptionLevel
Order by StockOptionLevel;

--OverTime and BusinessTravel Attrition Hotsport
select
overtime,businessTravel,
Count(*) as Employees,
	Sum(Case WHen Attrition ='Yes' Then 1 ELSE 0 END) as EmployeesLeft,
	Round(100.0 * Sum(Case WHEN Attrition = 'Yes' Then 1 Else 0 End) /Count(*),2) as AttritionRate
From [HR-Employee-Attrition]
Group by OverTime, BusinessTravel
Order by AttritionRate Desc;

--Distance from Home Impact
SELECT 
    CASE 
        WHEN DistanceFromHome <= 5 THEN '0-5 km'
        WHEN DistanceFromHome <= 15 THEN '6-15 km'
        WHEN DistanceFromHome <= 25 THEN '16-25 km'
        ELSE '25+ km'
    END AS DistanceBand,
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employee_Left,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AttritionRate
FROM [HR-Employee-Attrition]
GROUP BY 
    CASE 
        WHEN DistanceFromHome <= 5 THEN '0-5 km'
        WHEN DistanceFromHome <= 15 THEN '6-15 km'
        WHEN DistanceFromHome <= 25 THEN '16-25 km'
        ELSE '25+ km'
    END
ORDER BY AttritionRate DESC;

--All 4 Satisfaction Scores vs Attrition
SELECT 
    JobSatisfaction,
    EnvironmentSatisfaction,
    RelationshipSatisfaction,
    WorkLifeBalance,
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employee_Left,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AttritionRate
FROM [HR-Employee-Attrition]
GROUP BY JobSatisfaction, EnvironmentSatisfaction, RelationshipSatisfaction, WorkLifeBalance
ORDER BY AttritionRate DESC;

--TENURE + EXPERIENCE
SELECT 
    YearsAtCompany,
    YearsInCurrentRole,
    YearsSinceLastPromotion,
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employee_Left,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AttritionRate
FROM [HR-Employee-Attrition]
GROUP BY YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion
HAVING COUNT(*) > 5
ORDER BY AttritionRate DESC;

-- Education Impact
SELECT 
    Education,
    EducationField,
    COUNT(*) AS Employees,
    ROUND(AVG(MonthlyIncome), 2) AS AvgSalary,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employee_Left
FROM [HR-Employee-Attrition]
GROUP BY Education, EducationField
ORDER BY AvgSalary DESC;

--Training Times Last Year
SELECT 
    TrainingTimesLastYear,
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employee_Left,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AttritionRate
FROM [HR-Employee-Attrition]
GROUP BY TrainingTimesLastYear
ORDER BY TrainingTimesLastYear;

-- 
select 
count(*) as Total_Employees
From [HR-Employee-Attrition]
where YearsAtCompany >=5;

SELECT 
    CASE Education
        WHEN 1 THEN '1-Below College'
        WHEN 2 THEN '2-College' 
        WHEN 3 THEN '3-Bachelor'
        WHEN 4 THEN '4-Master'
        WHEN 5 THEN '5-Doctor'
    END + ' - ' + EducationField AS EducationLabel,
    COUNT(*) AS Employees,
    ROUND(AVG(MonthlyIncome), 2) AS AvgSalary,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employee_Left
FROM [HR-Employee-Attrition]
GROUP BY Education, EducationField
ORDER BY AvgSalary DESC;

SELECT 
    ROUND(100.0 * SUM(CASE WHEN YearsSinceLastPromotion >= 5 THEN 1 ELSE 0 END) / COUNT(*), 2) AS StuckRate
FROM [HR-Employee-Attrition];

SELECT 
    OverTime,
    ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AttritionRate
FROM [HR-Employee-Attrition]
GROUP BY OverTime;