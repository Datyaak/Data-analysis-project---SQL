--Základní tabulky

-- Primární tabulka
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
	SELECT avg(cp.value) AS average_salary, cp.payroll_year, cpib."name" AS branch
	FROM czechia_payroll cp
	JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
	WHERE cp.value_type_code = 5958
	GROUP BY branch, cp.payroll_year
	ORDER BY cp.payroll_year, branch
) w
ON w.payroll_year = g."year"
;

-- Sekundární tabulka
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


-- VIEW pro otázku 1
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


--VIEW pro otázku 2
CREATE VIEW v_adam_poncik_project_SQL_primary_final_2 AS 
SELECT t.grocery_name,
	t."year",
	round(avg(t.average_salary), 0) AS average_salary,
	round(t.average_price::numeric, 2) AS average_price_rounded,
	round(round(avg(t.average_salary), 0) / round(t.average_price::numeric, 2), 2) AS purchase_power
FROM t_adam_poncik_project_sql_primary_final t
JOIN (
    SELECT 
      grocery_name, 
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


-- VIEW pro otázku 3
CREATE VIEW v_adam_poncik_project_SQL_primary_final_3 AS 
WITH cte_grocery_timeframe AS (
	SELECT DISTINCT
    t.grocery_name,
    t.year,
    t.average_price
  FROM t_adam_poncik_project_SQL_primary_final t
  JOIN (
    SELECT 
      grocery_name, 
      MIN(year) AS min_year, 
      MAX(year) AS max_year
    FROM t_adam_poncik_project_SQL_primary_final
    GROUP BY grocery_name
  ) j 
    ON j.grocery_name = t.grocery_name
   AND t.year IN (j.min_year, j.max_year)
),
cte_price_change AS (
	SELECT *,
		lag(average_price) OVER (PARTITION BY grocery_name ORDER BY "year") AS previous_line,
		((average_price / lag(average_price) OVER (PARTITION BY grocery_name ORDER BY "year")) - 1) * 100 AS pct_price_change
	FROM cte_grocery_timeframe
	ORDER BY cte_grocery_timeframe.grocery_name
)
SELECT grocery_name, round(pct_price_change::numeric, 2) AS pct_price_change
FROM cte_price_change
WHERE pct_price_change IS NOT NULL
ORDER BY cte_price_change.pct_price_change ASC
;



-- VIEW pro otázku 4
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
SELECT "year", pct_price_change, pct_salary_change,
	round(pct_salary_change::numeric - pct_price_change::numeric, 2) AS pct_growth_diff
FROM cte_pct_changes
WHERE pct_price_change IS NOT NULL AND pct_salary_change IS NOT NULL
;


-- VIEW pro otázku 5
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
	FROM cte_agregated_data 
	),
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