/*
How does different skills impact salary?
Look at the average salary associated with eeach skill for Data Analyst positions. Focus on
roles with specified salaries(no null values),regardless of location. 
Identify the most financially rewarding skills to aquire or improve. 
*/

SELECT 
	skills,
	ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM 
	job_postings_fact
INNER JOIN 
	skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN 
	skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
	job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY 
	skills
ORDER BY 
	avg_salary DESC
LIMIT 25;

-- How does this compare with remote jobs?
SELECT 
	skills,
	ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM 
	job_postings_fact
INNER JOIN 
	skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN 
	skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
	job_title_short = 'Data Analyst' AND 
	salary_year_avg IS NOT NULL AND
	job_location = 'Anywhere'
GROUP BY 	
	skills
ORDER BY 
	avg_salary DESC
LIMIT 25;


/* 
Analysis using chatgpt:
--Key Takeaways:

--Data Science & Big Data Roles Are in High Demand
PySpark, Pandas, NumPy, Databricks, and Airflow are highly sought after.

--Cloud & DevOps Are Essential
Kubernetes, Linux, Jenkins, and GCP skills are widely mentioned, showing that cloud infrastructure is a major hiring focus.

--Version Control & Collaboration Tools Matter
Bitbucket and GitLab are widely listed, reinforcing the importance of version control skills.

--Niche Skills Like Watson & MicroStrategy Still Hold Value
While less mainstream, IBM Watson and MicroStrategy suggest specialized roles in AI and BI.

*/