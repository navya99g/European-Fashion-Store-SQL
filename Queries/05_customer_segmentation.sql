-- Customer Segmentation & Value Analysis
-- Objective: Segment customers based on revenue, profitability, and discount behavior

--- Customer revenue segmentation (High / Medium / Low)
with cus_rev as (
	select c.customer_id, sum(s.total_amount) as revenue
	from customers c join sales s on c.customer_id = s.customer_id
	group by c.customer_id), pct as (
		select percentile_cont(0.66) within group(order by revenue ) as p66,
		percentile_cont(0.33) within group(order by revenue) as p33
		from cus_rev)

select customer_id, revenue, case 
when revenue >= p66 then 'High'
when revenue >= p33 then 'Medium' else 'Low' end as segment
from pct cross join cus_rev;

--- VIP customers based on high-margin categories
with category_margin as (
	select p.category, 
	sum(si.item_total-(si.quantity*p.cost_price))/sum(si.item_total) as profit_margin
	from products p join salesitems si on p.product_id = si.product_id 
	group by p.category),
	high_category as (
	select category from category_margin where profit_margin > 
	(select avg(profit_margin) from category_margin))

select s1.customer_id as VIP_Customers from sales s1 
join salesitems si1 on s1.sale_id = si1.sale_id
join products p1 on si1.product_id = p1.product_id
join high_category hc on p1.category = hc.category
group by customer_id 
having count(distinct p1.product_id) = (
	select count(distinct p2.product_id) from products p2 
	join high_category hc2 on p2.category = hc2.category);

--- Discounted revenue contribution per category
with category_discount as (
	select p.category, sum(si.discount_applied*si.quantity) as Total_discount
	from products p join salesitems si on p.product_id = si.product_id group by p.category)

select *,
Total_discount*100/sum(Total_discount)over() as percentage_contribution
from category_discount;