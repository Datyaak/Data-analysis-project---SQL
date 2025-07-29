CREATE VIEW v_adam_poncik_project_SQL_primary_final_1 AS 
SELECT "year",
	branch,
	average_salary,
	lag(average_salary) OVER (PARTITION BY branch ORDER BY "year") AS previous_year,
	average_salary - lag(average_salary) OVER (PARTITION BY branch ORDER BY "year") AS yty_change
FROM (
	SELECT DISTINCT 
		year,
		branch,
		average_salary
	FROM t_adam_poncik_project_SQL_primary_final
	ORDER BY branch, year)
;