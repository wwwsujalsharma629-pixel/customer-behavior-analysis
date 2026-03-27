create database customer_data;
use customer_data;
select *from customer_behaviour_data;

select sum(purchase_amount) as total
from customer_behaviour_data
group by gender;

-- Q2 which customers used a discount but still spend than the average purchase amount
select customer_id,discount_applied
from customer_behaviour_data
where discount_applied="yes" and purchase_amount >= (select avg(purchase_amount) from customer_behaviour_data);


-- Q3 compare the average purchase amount between standard and express shipping
select  item_purchased, avg(review_rating) as "average review rating"
from customer_behaviour_data
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- Q4 compare the average purchase amount but still spent more than the average purchase amount?
select shipping_type,
avg((purchase_amount))from
customer_behaviour_data 
where shipping_type in( "Standard","Express")
group by shipping_type ;      

-- Q5 Do subcscribed customers spend more? compare average spend and total revenue
-- between subscribers and non subscribers 
select subscription_status,
count(customer_id),
avg((purchase_amount)) as avg_rev,
 sum(purchase_amount) as total_rev
from customer_behaviour_data
group by subscription_status 
order by total_rev desc
limit 20;
        
# Q6. which 5 products  have the highest  percentage  of purchases  with  discount applied 
select (item_purchased),
sum(case when discount_applied = 'Yes' then 1 else 0 end )*100 /count(*) as discount_rate
from  customer_behaviour_data
group by item_purchased
order by discount_rate desc
limit 5;

#Q7 segment customer  into new,returning,and loyal based  on their total no of previous
-- previos purchases , and show the count of each segment 
select 
case
	 when previous_purchases =1 then "new"
	 when previous_purchases between 2 and 10 then "returning"
	 else "loyal"
     end as customer_segment ,
     count(*) as total_customer
     from customer_behaviour_data
     group by customer_segment ;
	
-- Q8 what are the 3 most purchased products within each category ?
with item_count as(
select category,item_purchased,count(customer_id) as
total_orders, row_number()
over(partition by category order by count(customer_id)desc) as item_rank
from customer_behaviour_data
group by category,item_purchased
)
select
 total_orders,
item_rank,category,item_purchased
from item_count
where item_rank<=3;

-- Q9 Are customers who repeat buyers(more than previuos purchases) also likely to sucsribe
select subscription_status,
count(customer_id) as total_buyers 
from customer_behaviour_data
where previous_purchases >5 
group by subscription_status;

-- Q10 what is the revenue contribution of each age group
select age_group,sum(purchase_amount) as total_revenue
from customer_behaviour_data
group by age_group
order by total_revenue desc

     
     