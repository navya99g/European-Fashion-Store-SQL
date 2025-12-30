-- Time-Series & Cohort Analysis
-- Objective: Analyze revenue trends and customer lifecycle behavior

--- Monthly revenue growth (LAG)
with monthly_revenue as (
	select extract(month from si.sale_date) as sale_month, 
	sum(si.item_total) as revenue 
	from salesitems si group by sale_month )

select sale_month, revenue, 
revenue - LAG(revenue) over(order by sale_month) as growth
from monthly_revenue;

--- New vs Returning cuatomers per month
select extract(month from s.sale_date) as sale_month, 
count(distinct case when s.sale_date = c.signup_date then c.customer_id end) as new_customers,
count(distinct case when s.sale_date > c.signup_date then c.customer_id end) as returning_customers
from sales s join customers c on s.customer_id = c.customer_id
group by sale_month order by sale_month;

--- Average purchase frequency per customer cohort
select extract(month from c.signup_date) as cohort,  
count(s.sale_id)/count(distinct c.customer_id)::float as avg_frequency
from customers c join sales s on c.customer_id = s.customer_id
group by cohort
