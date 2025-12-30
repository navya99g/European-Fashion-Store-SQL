-- Campaign & Channel Performance
-- Objective: Evaluate marketing channel and campaign effectiveness

--- Total revenue per channel_campaign 
select s.channel, si.channel_campaigns, 
sum(item_total) as revenue, 
sum(si.quantity) as items_sold
from sales s join salesitems si  on s.sale_id = si.sale_id
group by s.channel, si.channel_campaigns order by revenue desc; 

--- Most effective campaign per channel
with campaign_perf as ( 
select s.channel, si.channel_campaigns, 
sum(si.item_total) / sum(si.quantity) as efficiency,
rank() over(partition by s.channel order by 
	sum(si.item_total) / sum(si.quantity) desc ) as rn
from sales s join salesitems si on s.sale_id = si.sale_id
group by s.channel,si.channel_campaigns)

select * from campaign_perf where rn = 1;

--- Channel ranking per month by revenue
select s.channel, extract(month from s.sale_date) as sale_month,
sum(si.item_total) as revenue, rank() over(partition by 
	extract(month from s.sale_date) order by sum(si.item_total) desc ) as rn
from sales s join salesitems si on s.sale_id = si.sale_id 
group by sale_month, s.channel;
