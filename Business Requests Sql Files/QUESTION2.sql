-- 2 NO QUESTION
select city,count(store_id) as store_count
from retail_events_db.dim_stores  
group by city 
order by store_count desc;