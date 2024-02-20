-- 4 NO QUESTION 
WITH MYT_CTE AS (
   SELECT
        *,
       CASE
	WHEN promo_type = 'BOGOF' THEN `quantity_sold(after_promo)` * 2
            ELSE `quantity_sold(after_promo)`
        END AS AdjustedQuantity
        FROM
        retail_events_db.fact_events
),
Ranked_CTE AS (
    SELECT
        category,
        ROUND((SUM(AdjustedQuantity) - SUM(`quantity_sold(before_promo)`)) * 100 / SUM(`quantity_sold(before_promo)`), 1) AS incremental_sold_quantity
        FROM
        MYT_CTE
        JOIN retail_events_db.dim_products AS p ON p.product_code = MYT_CTE.product_code
    WHERE
        campaign_id = 'CAMP_DIW_01'
    GROUP BY
      category
)

 SELECT
    *,
    RANK() OVER(ORDER BY  incremental_sold_quantity DESC) AS rank_order

FROM
    Ranked_CTE;