-- Profit & Margin Analysis
-- Objective: Identify profitable and loss-making products and categories

--- Total profit per product 
select p.product_name, 
sum(si.item_total - (si.quantity*p.cost_price)) as total_profit
from salesitems si join products p on si.product_id = p.product_id
group by product_name order by total_profit desc;

--- Products with negative profit and customers 
with product_profit as (
select s.customer_id, p.product_name, 
sum(si.item_total - (si.quantity*p.cost_price)) as profit
from sales s join salesitems si on s.sale_id = si.sale_id 
join products p on si.product_id = p.product_id 
group by s.customer_id, p.product_name )

select * from product_profit where profit < 0;

--- Average Profit Margin per category and brand
select p.category,p.brand, 
avg((si.item_total - (si.quantity*p.cost_price))/si.item_total) as Profit_margin
from salesitems si join products p on si.product_id = p.product_id
group by p.category,p.brand order by Profit_margin desc;
