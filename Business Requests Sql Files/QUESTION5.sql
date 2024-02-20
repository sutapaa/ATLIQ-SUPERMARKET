-- 5 NO QUESTION  
   WITH MY_CTE AS (
    SELECT
        *,
        CASE
            WHEN promo_type = "50% OFF" THEN base_price * 0.5
            WHEN promo_type = "25% OFF" THEN base_price * 0.75
            WHEN promo_type = "33% OFF" THEN base_price * 0.67
            WHEN promo_type = "BOGOF" THEN base_price * 0.5
            ELSE base_price - 500
        END AS Promotional_price,
        CASE
            WHEN promo_type = 'BOGOF' THEN `quantity_sold(after_promo)` * 2
            ELSE `quantity_sold(after_promo)`
        END AS AdjustedQuantity
    FROM
        retail_events_db.fact_events
)

SELECT
    product_name, category,
    ROUND(
    (SUM(Promotional_price * AdjustedQuantity) - SUM(base_price * `quantity_sold(before_promo)`))*100
    / SUM(base_price * `quantity_sold(before_promo)`),
    2
) AS revenue_change

     FROM
        MY_CTE MC
     JOIN retail_events_db.dim_products p ON p.product_code = MC.product_code
GROUP BY
    product_name,category
ORDER BY
    revenue_change DESC
    limit 5;

