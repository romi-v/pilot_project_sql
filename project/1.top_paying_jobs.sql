/*
What are the top-paying jobs for a Data Analyst role?
- Identify the top 10 highest paying Data Analyst jobs that are available remotely. Focus on
job postings with specified salaries (remove nulls). 
*/

SELECT 
	job_id,
	name as company_name,
	job_title,
	job_location, 
	job_schedule_type,
	salary_year_avg,
	job_posted_date
FROM 
	job_postings_fact j
LEFT JOIN company_dim c ON c.company_id = j.company_id
WHERE 
	job_title_short = 'Data Analyst' AND 
	job_location = 'Anywhere' AND
 	salary_year_avg IS NOT NULL
ORDER BY 
	salary_year_avg DESC
LIMIT 10;
	   