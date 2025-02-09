/* What are the most in-demand skill for my role (regardless of pay - the most frequently
appearing skill in the job listings.) We are interested in Data Analyst roles and focus on all job postings.
Retrieve the top 5 valuable skills with the highest demand in job market for Data Analyst roles.  */

SELECT 
	skills,
	COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;