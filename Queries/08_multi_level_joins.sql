-- Multi-Level Joins & Conditional Analysis
-- Objective: Analyze complex customer-product relationships

--- Customers buying from >3 categories in last 6 months
select customer_id, count( distinct category) as category_count
from( select s.customer_id, si.sale_date, p.category
	from sales s join salesitems si on s.sale_id = si.sale_id
	join products p on si.product_id = p.product_id) as customer_purchase
where sale_date >= current_date - interval '6 months'
group by customer_id having count(distinct category) > 3;

--- Products sold to ≥5 customers with high revenue
with product_month_revenue as (
	select si.product_id, extract(month from si.sale_date) as sale_month, 
	count(distinct s.customer_id) as customer_count, sum(si.item_total) as revenue
	from salesitems si join sales s on si.sale_id = s.sale_id
	group by si.product_id,sale_month )

select * from product_month_revenue where customer_count >= 5 and 
revenue >= (select avg(revenue) from product_month_revenue);

--- Top-selling product per channel & campaign
select * from (select channel, channel_campaigns, product_id, 
	sum(quantity) as Total_quantity, sum(item_total) as revenue, 
 	rank() over( partition by channel, channel_campaigns 
	 order by sum(item_total) desc) as rn
	from salesitems group by channel,channel_campaigns, product_id) 
where rn = 1;

--- Customers buying multiple products per brand
select * from (select s.customer_id, p.brand,
	count(distinct p.product_id) as brand_qty,
	sum(si.item_total) as revenue, 
	sum(si.discount_applied) as discount
	from sales s join salesitems si on s.sale_id = si.sale_id
	join products p on si.product_id = p.product_id
	group by s.customer_id, p.brand)
where brand_qty > 1;