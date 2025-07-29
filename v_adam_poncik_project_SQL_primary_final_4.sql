CREATE VIEW v_adam_poncik_project_sql_primary_final_4 AS
WITH cte_agregated_data AS (
	SELECT t."year",
		avg(t.average_price) AS average_price,
		lag(avg(t.average_price)) OVER (ORDER BY t."year") AS previous_year_price,
		avg(t.average_salary) AS average_salary,
		lag(avg(t.average_salary)) OVER (ORDER BY t."year") AS previous_year_salary
	FROM t_adam_poncik_project_sql_primary_final t
	GROUP BY t."year"
	ORDER BY t."year" ASC),
cte_pct_changes AS (
		SELECT *,
			100 * ((average_price / previous_year_price) - 1) AS pct_price_change,
			100 * ((average_salary / previous_year_salary) -1) AS pct_salary_change
		FROM cte_agregated_data
)
SELECT "year",
	pct_price_change,
	pct_salary_change,
	round(pct_salary_change::numeric - pct_price_change::numeric, 2) AS pct_growth_diff
FROM cte_pct_changes
WHERE pct_price_change IS NOT NULL AND pct_salary_change IS NOT NULL
;