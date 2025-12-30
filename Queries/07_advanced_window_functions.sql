-- Advanced Window Functions
-- Objective: Perform ranking, cumulative, and rolling analytics

--- Product revenue ranking per category per month
select *,rank() over(partition by category,sale_month 
order by revenue desc) as rn
from ( select p.category,p.product_id,extract(month from si.sale_date) as sale_month,
	sum(si.item_total) as revenue from products p 
	join salesitems si on p.product_id = si.product_id
	group by p.category,sale_month,p.product_id) as product_revenue;

	--- Cumulative spend and MoM growth per customer
with cte1 as (select customer_id, extract(month from si.sale_date) as sale_month, 
	sum(si.item_total) as monthly_spent
	from sales s join salesitems si on s.sale_id = si.sale_id
	group by customer_id,sale_month)

select *, 
sum(monthly_spent) over(partition by customer_id order by sale_month) as Customer_spent, 
monthly_spent - lag(monthly_spent) over(partition by customer_id order by sale_month) as month_growth
from cte1;

--- 3-month moving average revenue per product
select *,avg(revenue) over( partition by product_id order by sale_month 
rows between 2 preceding and current row) as revenue_average
from (select product_id, extract(month from sale_date) as sale_month, 
	sum(item_total) as revenue from salesitems 
	group by product_id, sale_month) product_sales ;


