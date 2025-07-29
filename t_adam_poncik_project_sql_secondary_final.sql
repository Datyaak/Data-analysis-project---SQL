CREATE TABLE t_adam_poncik_project_sql_secondary_final AS
SELECT e.country,
	e."year",
	e.gdp,
	c.continent
FROM economies e
JOIN countries c ON e.country = c.country
WHERE c.continent = 'Europe' AND e.gdp IS NOT NULL
ORDER BY c.country ASC, e."year" ASC
;