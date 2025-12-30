--- Importing Tables

-- Import SalesItems data
create table salesitems (item_id int, sale_id int, product_id int, quantity int, original_price float,unit_price float, discount_applied float,
discount_percent varchar(50), discounted int, item_total float, sale_date date, channel varchar, channel_campaigns varchar(244));
copy salesitems from 'C:\Program Files\PostgreSQL\18\data\Files\dataset_fashion_store_salesitems.csv' DELIMITER ',' CSV HEADER ;

Select * from salesitems ;

-- Import Sales data
create table sales (sale_id int, channel varchar(50), discounted int, total_amount float, sale_date date, customer_id int, country varchar);
copy sales from 'C:\Program Files\PostgreSQL\18\data\Files\dataset_fashion_store_sales.csv' DELIMITER ',' CSV HEADER ;

select * from sales;

-- Import Products sata
create table products (product_id int, product_name varchar, category varchar, brand varchar, color varchar, size varchar, catalog_price float, cost_price float,gender varchar);
copy products from 'C:\Program Files\PostgreSQL\18\data\Files\dataset_fashion_store_products.csv' DELIMITER ',' CSV HEADER ;

select * from products;

-- Import Customers data
create table customers (customer_id int, country varchar, age_range varchar, signup_date date);
copy customers from 'C:\Program Files\PostgreSQL\18\data\Files\dataset_fashion_store_customers.csv' DELIMITER ',' CSV HEADER ;

select * from customers;
