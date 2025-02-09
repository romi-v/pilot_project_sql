SELECT job_posted_date 
FROM job_postings_fact
LIMIT 10;

-- Write a query to find job postings by year/month posted
SELECT 
	job_title_short AS title,
	job_location AS location,
	EXTRACT(YEAR FROM job_posted_date) AS year,
	EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
LIMIT 20;

-- We are only interested in Data Analyst jobs 
SELECT 
	COUNT(job_id) as number_of_listing,
	EXTRACT(YEAR FROM job_posted_date) AS year,
	EXTRACT(MONTH FROM job_posted_date) as month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY year, month
LIMIT 20;

--Write a query to find an average salary both yearly and hourly for job postings
-- that were posted after 1 June 2023, group by job schedule type.

SELECT job_schedule_type,
	   ROUND(AVG(salary_year_avg),2) as avg_salary_y,
	   ROUND(AVG(salary_hour_avg),2) as avg_salary_h   
FROM job_postings_fact
WHERE job_posted_date > '01/06/2023'
GROUP BY job_schedule_type;

--Write a query to count the number of job postings for each month in 2023 
--adjusting the date to be in New York timezone, currently UTC, order by month
SELECT job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' as date_time
FROM job_postings_fact;

SELECT	
	COUNT(job_id) as number_of_listing,
	EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') as month_posted
FROM job_postings_fact
GROUP BY month_posted
LIMIT 20;

--write a query to find companies that have posted job offering health insurance, 
--where these postings were made in Q2
SELECT
	j.company_id, 
	c.name, 
	j.job_health_insurance,
	j.job_posted_date
FROM job_postings_fact j
JOIN company_dim c ON j.company_id = c.company_id
WHERE j.job_health_insurance IS TRUE
AND EXTRACT(MONTH FROM j.job_posted_date) BETWEEN 4 AND 6
ORDER BY job_posted_date;


--create new tables from other tables:
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1
LIMIT 100;

--january
CREATE TABLE jan_2023_jobs AS 
	SELECT * FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

--february
CREATE TABLE feb_2023_jobs AS 
	SELECT * FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

--march
CREATE TABLE mar_2023_jobs AS 
	SELECT * FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT * FROM mar_2023_jobs;

--CASE statement:

SELECT job_title_short,
	   job_location
FROM job_postings_fact
LIMIT 10;

	--CREATE NEW COLUMN: FOR POSTINGS IN NY = LOCAL, ANYWHERE= REMOTE, OTHER = ON SITE
	
SELECT COUNT(job_id) AS number_of_jobs,
	   CASE
	   		WHEN job_location = 'Anywhere' THEN 'Remote'
			WHEN job_location LIKE '%Slovakia%' THEN 'Local'
			ELSE 'On-site'
			END as location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category
ORDER BY number_of_jobs DESC;

-- CREATE CATEGORIES FOR SALARY = bucketing
--check what the range is:
SELECT MAX(salary_year_avg) as max_sal,
	   MIN(salary_year_avg) as min_sal,
	   AVG(salary_year_avg) as avg_sal
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst';

--mode
SELECT salary_year_avg, COUNT(*) AS category_count
FROM job_postings_fact
GROUP BY salary_year_avg
ORDER BY category_count DESC;

--select value range per category:
SELECT COUNT(job_id) AS number_of_jobs,
	   CASE
	   		WHEN salary_year_avg < 50000 THEN 'low pay'
			WHEN salary_year_avg BETWEEN 50000 AND 100000 THEN 'standard pay'
			WHEN salary_year_avg > 100000 THEN 'high pay'
			ELSE 'no pay'
			END as salary_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY salary_category
ORDER BY number_of_jobs DESC;

--subqueries:
SELECT *
FROM (SELECT * 
	  FROM job_postings_fact
	  WHERE EXTRACT(MONTH FROM job_posted_date) = 3)
	  AS march_jobs;

-- CTE common table expressions:
WITH february_jobs AS(          --CTE starts here
					SELECT *
					FROM job_postings_fact
					WHERE EXTRACT(MONTH FROM job_posted_date) = 2
)     --CTE ends here
SELECT * FROM february_jobs;

-- list of companies without edu requirements using subquery:
SELECT company_id, 
	   name AS company_name
FROM company_dim
WHERE company_id IN 	
				(SELECT company_id FROM job_postings_fact
				WHERE job_no_degree_mention is true);

-- CTE = returns a temporary result set, only exists during the execution of the query, 
-- use WITH to define CTE at the beginning of a query

--find companies with most job openings, return company name, use CTE:
--1. define the temp. table with number of postings per company (CTE), 
--join the company_dim to get the comp. name and order desc to see the top emp.
-- use left join to make sure we involved all the companies, even if there are companies with no listings

WITH job_counts AS( 
				SELECT company_id,
				COUNT(*) as number_of_postings
				FROM job_postings_fact
				GROUP BY company_id
				)
				
SELECT c.company_id, c.name AS company_name, j.number_of_postings
FROM company_dim c
LEFT JOIN job_counts j ON j.company_id = c.company_id
ORDER BY number_of_postings DESC;

				
--Identify the top 5 skills that are most frequently mentioned in job_postings

SELECT top_skills.skill_id, top_skills.skills_count, s.skills, s.type 
FROM (
	SELECT skill_id, 
		   COUNT(*) AS skills_count
	FROM skills_job_dim
	GROUP BY skill_id 
	ORDER BY skills_count DESC
	LIMIT 5)
	AS top_skills
JOIN skills_dim s ON s.skill_id = top_skills.skill_id;


--Determine the size category of a company based on the number of postings. 
--The company is considered small when it has less than 10 job postings, 
--medium for 10-50 postings and large if more than 50 job postings. 

--1. determine the postings count for each company
WITH job_counts AS( 
				SELECT company_id,
				COUNT(*) as number_of_postings
				FROM job_postings_fact
				GROUP BY company_id
				)
--2. select statement with CASE to create a new column				
SELECT c.company_id, 
	   c.name AS company_name, 
	   j.number_of_postings,
	   CASE 
	   		WHEN number_of_postings < 10 THEN 'small'
			WHEN number_of_postings BETWEEN 10 AND 50 THEN 'medium'
			WHEN number_of_postings > 50 THEN 'large'
			ELSE 'size unknown'
			END as size_of_company
FROM company_dim c
JOIN job_counts j ON j.company_id = c.company_id;
	   
--Find the count of the remote Data analyst job postings per skill 
-- display top 5 skills by their demand in remote jobs
--include skill id, name and count of postings requiring the skill

WITH top_skills_remote AS (
		SELECT skill_id,
	 		   COUNT(*) as postings_count
		FROM skills_job_dim
		WHERE job_id IN (
				SELECT job_id
				FROM job_postings_fact
				WHERE job_work_from_home = true 
				AND job_title_short = 'Data Analyst')
		GROUP BY skill_id
		)
SELECT top_skills_remote.skill_id, 
	   s.skills, 
	   top_skills_remote.postings_count
FROM top_skills_remote
JOIN skills_dim s
ON s.skill_id = top_skills_remote.skill_id
ORDER BY postings_count DESC
LIMIT 5;

--UNION - for combining tables ("opposite" of joins)
--JOINS are used to combine tables that relate on a single value 
--(like skill_id in previous exercise), with join we add COLUMNS
-- whereas with UNION operator we combine tables by adding ROWS
-- the tables need to have the same amount of columnns and the data types must match!

--UNION REMOVES DUPLICATES, UNION ALL KEEPS DUPLICATES 

--combine 2 tables
SELECT * FROM jan_2023_jobs
UNION 
SELECT * FROM feb_2023_jobs;

--combine 3 tables
SELECT * FROM jan_2023_jobs
UNION 
SELECT * FROM feb_2023_jobs
UNION
SELECT * FROM mar_2023_jobs;

--union all
SELECT * FROM jan_2023_jobs
UNION ALL
SELECT * FROM feb_2023_jobs;

-- Get job posting from Q1 with salary > 70 000

SELECT q1_job_postings.company_id,
	   company_dim.name as company_name,
	   q1_job_postings.job_title_short,
	   q1_job_postings.job_location,
	   q1_job_postings.job_schedule_type,
	   q1_job_postings.salary_year_avg,
	   q1_job_postings.job_posted_date::DATE
FROM (
	SELECT * FROM jan_2023_jobs
	UNION ALL
	SELECT * FROM feb_2023_jobs
	UNION ALL
	SELECT * FROM mar_2023_jobs
	) as q1_job_postings
JOIN company_dim ON q1_job_postings.company_id = company_dim.company_id
WHERE q1_job_postings.salary_year_avg > 70000
AND q1_job_postings.job_title_short = 'Data Analyst'
ORDER BY q1_job_postings.salary_year_avg DESC;

 

