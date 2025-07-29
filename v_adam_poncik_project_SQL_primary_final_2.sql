CREATE VIEW v_adam_poncik_project_SQL_primary_final_2 AS 
SELECT t.grocery_name,
	t."year",
	round(avg(t.average_salary), 0) AS average_salary,
	round(t.average_price::numeric, 2) AS average_price_rounded,
	round(round(avg(t.average_salary), 0) / round(t.average_price::numeric, 2), 2) AS purchase_power
FROM t_adam_poncik_project_sql_primary_final t
JOIN (
	SELECT grocery_name,
		MIN(year) AS min_year,
		MAX(year) AS max_year
	FROM t_adam_poncik_project_SQL_primary_final
	GROUP BY grocery_name
) j 
ON j.grocery_name = t.grocery_name
AND t.year IN (j.min_year, j.max_year)
WHERE t.category_code IN (111301, 114201)
GROUP BY t."year", t.grocery_name, t.average_price
ORDER BY t.grocery_name, t."year";