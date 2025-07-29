CREATE TABLE t_adam_poncik_project_SQL_primary_final AS
SELECT g.grocery_name,
	g.category_code,
	g."year",
	g.average_price,
	w.average_salary,
	w.branch
FROM (
	SELECT cpc."name" AS grocery_name,
		c.category_code,
		date_part('year', c.date_from) AS year,
		avg(c.value) AS average_price
	FROM  czechia_price c
	JOIN czechia_price_category cpc ON cpc.code = c.category_code
	GROUP BY grocery_name, "year", c.category_code) g
JOIN (
	SELECT avg(cp.value) AS average_salary,
		cp.payroll_year,
		cpib."name" AS branch
	FROM czechia_payroll cp
	JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
	WHERE cp.value_type_code = 5958
	GROUP BY branch, cp.payroll_year
	ORDER BY cp.payroll_year, branch
) w
ON w.payroll_year = g."year"
;