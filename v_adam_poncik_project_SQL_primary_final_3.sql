CREATE VIEW v_adam_poncik_project_SQL_primary_final_3 AS 
WITH cte_grocery_timeframe AS (
	SELECT DISTINCT t.grocery_name,
		t.year,
		t.average_price
FROM t_adam_poncik_project_SQL_primary_final t
JOIN (
	SELECT grocery_name,
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
SELECT grocery_name,
	round(pct_price_change::numeric, 2) AS pct_price_change
FROM cte_price_change
WHERE pct_price_change IS NOT NULL
ORDER BY cte_price_change.pct_price_change ASC
;