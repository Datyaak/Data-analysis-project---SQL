CREATE VIEW v_adam_poncik_project_sql_primary_final_5 AS
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
	FROM cte_agregated_data),
cte_gdp_change AS (
	SELECT country,
		"year",
		((gdp / previous_gdp) - 1) * 100 AS gdp_change
	FROM (
		SELECT *,
			lag(t2.gdp) OVER (PARTITION BY t2.country ORDER BY t2."year") AS previous_gdp
		FROM t_adam_poncik_project_sql_secondary_final t2
		WHERE t2.country = 'Czech Republic')
)
SELECT gc.country,
	pc."year",
	round(gc.gdp_change::numeric, 2) AS gdp_change_pct,
	round(pc.pct_price_change::numeric, 2) AS price_change_pct,
	round(lead(pc.pct_price_change::numeric) OVER (ORDER BY pc."year"), 2) AS price_change_next_year,
	round(pc.pct_salary_change, 2) AS salary_change_pct,
	round(lead(pc.pct_salary_change) OVER (ORDER BY pc."year"), 2) AS salary_change_next_year
FROM cte_pct_changes pc
JOIN cte_gdp_change gc ON pc."year" = gc."year"
;