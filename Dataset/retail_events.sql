select * from retail_events_db.dim_campaigns;
select * from retail_events_db.dim_products;
select * from retail_events_db.dim_stores;
select * from retail_events_db.fact_events;


WITH MY_CTE AS(
SELECT
  *,
    CASE
        WHEN promo_type ="50% OFF" THEN base_price*.5
        WHEN promo_type ="25% OFF" THEN base_price*.75
        WHEN promo_type ="33% OFF" THEN base_price*.67
        WHEN promo_type ="BOGOF" THEN base_price*.5
        ELSE base_price-500
    END AS Promotional_price
FROM
    retail_events_db.fact_events)
    
 select campaign_name, 
round(sum(base_price*`quantity_sold(before_promo)`)/1000000,2) as 'Total revenue before promotion(M)',
round(sum(Promotional_price*`quantity_sold(after_promo)`)/1000000,2) as 'Total revenue after promotion(M)'   
from   MY_CTE MC join   retail_events_db.dim_campaigns  c
on  c.campaign_id=MC.campaign_id 
group by campaign_name 
order by 'Total revenue before promotion(M)','Total revenue after promotion(M)' desc ;   





