/*
Analysing the job postings we found out that the most in-demand skills are not always the highest-paid
SQL (8), Python (7), and Tableau (6) appear frequently in job postings, but they are not in the highest-paying jobs.
On the other hand PySpark (208K+), Bitbucket (189K+), and Couchbase (160K+) dominate high-paying job listings, but don’t appear in the most frequently listed skills.
→ This suggests high specialization = higher salary, while generalist skills (SQL, Python, Excel) are needed in many roles but may not be as lucrative.

Now let's try to identify what are the most optimal skills to learn (high demand and high pay)
- Identify skills in high demand and associated with high average salaries
*/

SELECT
	skills_dim.skill_id,
	skills_dim.skills,
	COUNT(job_postings_fact.job_id) AS demand_count,
	ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM 
	job_postings_fact
INNER JOIN 
	skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN 
	skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
	job_title_short = 'Data Analyst' AND 
	salary_year_avg IS NOT NULL
GROUP BY	
	skills_dim.skill_id
HAVING 
	COUNT(job_postings_fact.job_id) > 10
ORDER BY
	avg_salary DESC,
	demand_count DESC
LIMIT 25;

/*Cloud tools and specificaly cloud-based databases are on top of this list along with programming languages.