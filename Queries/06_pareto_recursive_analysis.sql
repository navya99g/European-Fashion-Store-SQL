-- Pareto & Recursive Analysis
-- Objective: Identify key contributors and high-growth customers

--- Products contributing to 80% revenue (Pareto)
with cte1 as (
	select p.category,p.product_id, sum(si.item_total) as product_revenue
	from products p join salesitems si on p.product_id = si.product_id  
	group by p.category,p.product_id ), 
	cte2 as (
	select *,sum(product_revenue) over(partition by category order by product_revenue desc) 
	as cumulative_revenue, 	sum(product_revenue) over(partition by category) as total_revenue
	from cte1) 

select cte2.category,cte2.product_id,p1.product_name 
from products p1 join cte2 on p1.product_id = cte2.product_id 
where cte2.cumulative_revenue <= 0.8*cte2.total_revenue;

--- Top 10% customers by country revenue
with cte1 as ( 
	select s.country,s.customer_id, sum(total_amount) as customer_spent 
	from sales s group by country,customer_id), 
	cte2 as (
	select *, 
	sum(customer_spent) over(partition by country order by customer_spent desc) as cum_revenue,
	sum(customer_spent) over(partition by country) as country_revenue from cte1)

select * from cte2 where cum_revenue <= 0.1*country_revenue;

--- Customers with ≥20% MoM quantity growth (Recursive CTE)
with recursive monthly_data as (
	select s.customer_id, extract(month from si.sale_date) as sale_month, 
	sum(si.quantity) as month_qty 
	from salesitems si join sales s on si.sale_id = s.sale_id 
	group by s.customer_id,sale_month), 
	ordered_data as (
	select *, 
	row_number() over(partition by customer_id order by sale_month) as rn 
	from monthly_data), 
	growth_cte as (
	select customer_id, sale_month, month_qty,rn, null::numeric as growth_pct 
	from ordered_data where rn=1
	union all
	select o.customer_id, o.sale_month, o.month_qty, o.rn,
	(o.month_qty - g.month_qty) / nullif(g.month_qty,0) as growth_pct
	from ordered_data o join growth_cte g on o.customer_id = g.customer_id and o.rn = g.rn + 1)

select * from growth_cte where growth_pct >= 0.2;
