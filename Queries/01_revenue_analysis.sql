-- Revenue Analysis
-- Objective: Analyze revenue contribution across customers, countries, brands, and time

--- Total revenue, discount, items per customer
select s.customer_id, 
sum(si.item_total) as total_revenue, 
sum(si.discount_applied) as total_discount, 
sum(si.quantity) as total_items
from sales s join salesitems si on s.sale_id = si.sale_id
group by customer_id order by total_revenue desc;

--- Top 5 customers per country by revenue
with Revenue_Country as (
	select c.country, c.customer_id, sum(si.item_total) as revenue, 
	rank() over ( partition by c.country order by sum(si.item_total) desc) as rn
	from customers c join sales s on c.customer_id = s.customer_id
	join salesitems si on s.sale_id = si.sale_id 
	group by c.country,c.customer_id order by c.country)

select * from Revenue_Country where rn <= 5;

--- Top 3 products per brand per month by revenue
with monthly_revenue as (
	select p.brand, extract(month from si.sale_date) as sales_month , p.product_name, sum(si.item_total), 
	rank() over(partition by p.brand,extract(month from si.sale_date) order by sum(si.item_total) desc) as rn
	from products p join salesitems si on p.product_id = si.product_id
	group by p.brand, sales_month, p.product_name)

select * from monthly_revenue where rn <= 3;  