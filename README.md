# My pilot project using SQL
Diving into the data job market. This project focuses on data analyst roles and explores the top-paying jobs, in-demand skills and identifies the optimal skills to acquire or improve as a data analyst.

SQL queries can be found in the [project](/project/) folder.

All the data comes from Luke Barousse's SQL Course (https://lukebarousse.com/sql)

## The questions I wanted to answer through my queries were:

1. What are the top paying remote data analyst jobs?
2. What skills are required for these jobs?
3. What skills are most in demand for data analysts?
4. What skills are associated with higer salaries?
5. And finally, what are the optimal (high demand and high pay) skills to work on?

## Tools I used:

- **SQL** - most of my analysis was performed using sql, allowing me to query the database and gain critical insights
- **postgresql** - the chosen database management system, ideal for handling the job posting data
- **pgadmin4** for executing queries
- **ChatGPT** to speed up some of the steps
- **Git, GitHub** for version control and for sharing my scripts :)

## The Analysis

Each query for this project aimed at investgating specific aspects of the data job market.

1. Top paying remote data analyst jobs
   To identify the highest-paying job offers I filtered data analyst positions by average yearly salary and location, focusing on reemote jobs.
   This query highlights the highest-paying opportunities in the field.

   _Overview over the top 10 highest paying remote job opportunities for Data Analysts_

| **Job ID**  | **Company**                                      | **Job Title**                                    | **Job Type** | **Salary ($)** |
|------------|------------------------------------------------|-------------------------------------------------|-------------|---------------|
| 226942     | Mantys                                         | Data Analyst                                   | Full-time   | 650,000       |
| 547382     | Meta                                          | Director of Analytics                         | Full-time   | 336,500       |
| 552322     | AT&T                                          | Associate Director - Data Insights            | Full-time   | 255,829.50    |
| 99305      | Pinterest Job Advertisements                 | Data Analyst, Marketing                       | Full-time   | 232,423       |
| 1021647    | UCLA Healthcare Careers                      | Data Analyst (Hybrid/Remote)                  | Full-time   | 217,000       |
| 168310     | SmartAsset                                    | Principal Data Analyst (Remote)               | Full-time   | 205,000       |
| 731368     | Inclusively                                  | Director, Data Analyst - HYBRID               | Full-time   | 189,309       |
| 310660     | Motional                                      | Principal Data Analyst, AV Performance Analysis | Full-time   | 189,000       |
| 1749593    | SmartAsset                                    | Principal Data Analyst                        | Full-time   | 186,000       |
| 387860     | Get It Recruit - Information Technology      | ERM Data Analyst                              | Full-time   | 184,000       |


3. Top skills in the highest paying job postings
   To identify the skills associated with the highest paying positions I've filtered in the previous step, I added the required data from the dimension tables.
   I decided to create a new table as well as a simple bar chart displaying the top skills.

   ![top_skills](https://github.com/user-attachments/assets/a918e944-f08a-4ea9-a198-d85d4eabf97f)
   _Bar chart visualizing the necessary skills for the highest-paying Data Analyst jobs_


4. Most in-demand skills for data analysts
   The next task was to list the top 5 most valuable skills a data analyst should have - those that appeared in most of the listings, regardless of location or salary.
   I agained joined three tables to get all the neccessary data and finally filtered the skills by the amount of appearances of any given skill in job listings. I also created a      simple visualization in form of a pie chart.
   
 ![in_demand_skills](https://github.com/user-attachments/assets/49fe2479-86e1-460c-8f13-9f6d37988788)
 _Pie chart visualizing the most in-demand skills for Data Analyst jobs in general_
 
6. Skills associated with high salaries
   Here I focused on the specific skills that were associated with the highest salaries. I calculated the average salary associated with each skill, then filtered down to include     only Data Analyst roles and highest average salaries. Finally I analyzed the results with help of chatgpt to get meaningful insights.

```sql
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
```

6. Most optimal skills
   The last question I wanted to answer in this project was what are the most optimal skills (aka both in demand and associated with high salaries) to learn. I filtered the skills    first by average salary associated with the skill then by count of job postings for which this skill was required. This highlighted the spcific skills that are in demand and       well paid. 


# Results

I identified the top paying remote Data Analyst jobs by analyzing all the 2023 data job postings. I dug deeper into the data to provide some insights on what skills are necessary for a Data Analyst to have and which specific skills are associated with the highest-paying jobs.  

Analysing the job postings I found out that the most in-demand skills are not always the highest-paid. SQL, Python, and Tableau appear frequently in job postings, but they are not in the highest-paying jobs. On the other hand PySpark, Bitbucket, and Couchbase dominate high-paying job listings, but don’t appear in the most frequently listed skills.
→ This suggests high specialization = higher salary, while generalist skills (SQL, Python, Excel) are needed in many roles but may not be as lucrative.

_ChatGPT generated these suggees based on my SQL query results:_
**If You Want a High-Paying Job: Specialize in Big Data, AI, and DevOps**
Learn PySpark, Databricks, Kubernetes, and Airflow for big data engineering roles.
Gain experience with Couchbase, Elasticsearch, Watson, and DataRobot for AI & analytics.
Strengthen GitLab, Bitbucket, Jenkins, and CI/CD pipelines for DevOps roles.

**If You Want a Secure Job with High Demand: Master SQL, Python, and BI Tools**
SQL, Python, Excel, and Tableau appear in the most job postings.
Learn Power BI, Snowflake, and R if you’re in analytics.

**Cloud & DevOps Skills Boost Salary**
AWS, Azure, Kubernetes, and Jenkins bridge data & software engineering for high-paying roles.


## Closing thoughts

This challenging project really enhanced my SQL skills and provided some valuable insights into the data analyst job market. Aspiring data analysts can use these results as a guide to prioritizing skill development and can better position themselves in the competetive job market by focusing on high-demand, high-salary skills. This project also highlights the importance of continuous learning and adaptation to new trends in the field of data analytics.
