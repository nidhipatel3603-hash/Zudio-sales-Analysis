create database Zudio;
use Zudio;
create table products(
product_id int primary key,
product_name varchar(50),
category varchar(30),
price decimal(10,2),
cost decimal(10,2)
);
select * from products;

create table customers(
customer_id int primary key,
gender varchar(10),
age_group varchar(10)
);
select * from customers;

CREATE TABLE stores (
store_id INT PRIMARY KEY,
city VARCHAR(50),
region VARCHAR(50)
);
select * from stores;


CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
store_id INT,
order_date DATE,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (store_id) REFERENCES stores(store_id)
);
select * from orders;

CREATE TABLE order_details (
order_id INT,
product_id INT,
quantity INT,
PRIMARY KEY (order_id, product_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);
select * from order_details;


-- TOTAL REVENUE--  
select sum(p.price * od.quantity) as total_revenue from order_details
od join products p on od.product_id = p.product_id;

-- TOTAL PROFIT-- 
select sum((p.price - p.cost)*od.quantity) as total_profit from order_details
od join products p on od.product_id = p.product_id;

-- TOP SELLING ITEMS--
SELECT p.product_name, SUM(od.quantity) AS total_sold FROM order_details 
od JOIN products p ON od.product_id = p.product_id GROUP BY p.product_name ORDER BY total_sold DESC; 

-- LEAST SELLING ITEM--
SELECT p.product_name, SUM(od.quantity) AS total_sold FROM order_details
od JOIN products p ON od.product_id = p.product_id GROUP BY p.product_name ORDER BY total_sold ASC LIMIT 5;  

-- CITY WISE SALE-- 
SELECT s.city, SUM(p.price * od.quantity) AS revenue FROM orders 
o JOIN stores s ON o.store_id = s.store_id JOIN order_details od ON o.order_id = od.order_id JOIN products p ON od.product_id = p.product_id GROUP BY s.city;

-- CATEGORY WISE SALE--  
SELECT p.category, SUM(p.price * od.quantity) AS revenue FROM order_details
od JOIN products p ON od.product_id = p.product_id GROUP BY p.category;

-- PRODUCT NEVER SOLD--  
SELECT p.product_name FROM products 
p LEFT JOIN order_details od ON p.product_id = od.product_id WHERE od.product_id IS NULL;

-- PROFIT MARGIN--  
SELECT p.product_name,(p.price - p.cost) / p.price * 100 AS profit_margin FROM products p;