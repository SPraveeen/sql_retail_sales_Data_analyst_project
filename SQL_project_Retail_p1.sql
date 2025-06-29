--sql retail sales analysis -p1
create database Sql_Project_P1;

--create table
--transactions_id	sale_date	sale_time	customer_id	gender	age	category	quantiy	price_per_unit	cogs	total_sale
drop table if exists retail_sales;
create table retail_sales
		(
			transactions_id	int primary key,
			sale_date date,
			sale_time time,
			customer_id	int,
			gender varchar(15),
			age	INT,
			category varchar(15),	
			quantiy int,	
			price_per_unit float,
			cogs float,
			total_sale float
		);

--check table
select * from retail_sales
limit 10;

--total records
select count(*) from retail_sales;

--Data cleaning
--check if there are any nulls
select * from retail_sales
where transactions_id is null 
or sale_date is null
or sale_time is null
or gender is null
or category is null
or quantiy is null
or cogs is null
or total_sale is null

--delete null value rows
delete from retail_sales
where transactions_id is null 
or sale_date is null
or sale_time is null
or gender is null
or category is null
or quantiy is null
or cogs is null
or total_sale is null;

--Data Exploration
--How many sales we have?
select count(*) as total_sales from retail_sales;

--How many unique customers we have?
select count(distinct(customer_id)) as total_customer from retail_sales;

--Unique categories
select distinct(category) from retail_sales;

--Data Analysis & Business Key Problems and answers;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 
--'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales
where category='Clothing' 
and
to_char(sale_date,'YYYY MM')='2022 11'
and
quantiy >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale),count(*) as total_orders from retail_sales
group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age from retail_sales
where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(*) as total_transaction from retail_sales
group by gender,category
order  by 2;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select t1.year,t1.month,t1.avg_sale from (
	select 
	extract( year from sale_date)as year, 
	extract( month from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract( year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by 1,2
) as t1
where t1.rank=1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale)as total_sales from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
category,
count(distinct(customer_id)) as cnt_unique_customers
from retail_sales
group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale as(
	select *, 
	case when extract (hour from sale_time) <12 then 'Morning'
	when  extract (hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as shift
	from retail_sales
)
select shift,count(*)as total_orders from hourly_sale
group by shift


--end of project
