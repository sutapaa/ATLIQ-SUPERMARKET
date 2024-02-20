-- 1 NO QUESTION
select distinct product_name,base_price,promo_type 
from retail_events_db.dim_products  p join retail_events_db.fact_events fe
on  fe.product_code=p.product_code where 
base_price>500 and promo_type="BOGOF";


