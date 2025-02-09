/*
What skills are required for the top paying remote data analyst jobs?
Provide a detailed look at which skills are required in high-paying jobs, 
helping job seekers understand which skilLs to develop that align with top salaries
*/

WITH top_paying_jobs AS ( 
	SELECT 
		job_id,
		name as company_name,
		job_title,
		salary_year_avg
	FROM 
		job_postings_fact j
	LEFT JOIN company_dim c ON c.company_id = j.company_id
	WHERE 
		job_title_short = 'Data Analyst' AND 
		job_location = 'Anywhere' AND
 		salary_year_avg IS NOT NULL
	ORDER BY 
		salary_year_avg DESC
	LIMIT 10
	)
	
-- using 2x inner join as I am only interested in the skills that are actually listed and I need to join 2 dimension tables


SELECT 
	t.*,
	s.skills
FROM top_paying_jobs t
JOIN skills_job_dim j ON t.job_id = j.job_id
JOIN skills_dim s ON s.skill_id = j.skill_id
ORDER BY salary_year_avg DESC;
	
CREATE TABLE top_skills_remote AS(
	WITH top_paying_jobs AS ( 
		SELECT 
			job_id,
			name as company_name,
			job_title,
			salary_year_avg
		FROM 
			job_postings_fact j
		LEFT JOIN company_dim c ON c.company_id = j.company_id
		WHERE 
			job_title_short = 'Data Analyst' AND 
			job_location = 'Anywhere' AND
	 		salary_year_avg IS NOT NULL
		ORDER BY 
			salary_year_avg DESC
		LIMIT 10
		)	
	SELECT 
		t.*,
		s.skills
	FROM top_paying_jobs t
	JOIN skills_job_dim j ON t.job_id = j.job_id
	JOIN skills_dim s ON s.skill_id = j.skill_id
	ORDER BY salary_year_avg DESC
)

SELECT 
	skills,
	COUNT(*) as skill_count
FROM top_skills_remote
GROUP BY skills
ORDER BY skill_count DESC

/* The most demanded skill in the highest paying job postings is SQL, followed tightly by Python and Tableau.
Excel and Power BI remain in the top skills list too, emphasizing the need for strong foundation in Programming
and Visualization Tools like Python, Tableau and Power BI are.
*/
