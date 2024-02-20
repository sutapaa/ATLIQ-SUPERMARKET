-- 3 NO QUESTION
WITH MY_CTE AS (
    SELECT
        *,
        CASE
            WHEN promo_type = '50% OFF' THEN base_price * 0.5
            WHEN promo_type = '25% OFF' THEN base_price * 0.75
            WHEN promo_type = '33% OFF' THEN base_price * 0.67
            WHEN promo_type = 'BOGOF' THEN base_price * 0.5
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
    campaign_name, 
round(sum(base_price*`quantity_sold(before_promo)`)/1000000,2) as 'Total revenue before promotion(M)',
round(sum(Promotional_price*AdjustedQuantity)/1000000,2) as 'Total revenue after promotion(M)' 
FROM
    MY_CTE MC
JOIN
    retail_events_db.dim_campaigns c ON c.campaign_id = MC.campaign_id
GROUP BY
    campaign_name
ORDER BY
    'Total revenue before promotion(M)',
    'Total revenue after promotion(M)' DESC;