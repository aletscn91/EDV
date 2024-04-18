/****** AVG *******

1. 

select 
	c.category_name,
	p.product_name ,
	p.unit_price,
	avg(p.unit_price) over (partition by p.category_id) as avgpricebycategory
from products p 
left join categories c on c.category_id = p.category_id 

2. Da distinto al print del pdf porque yo acá también tomo en cuenta el descuento aplicado a la venta

select 
	avg(od.unit_price*od.quantity*(1-od.discount)) over (partition by o.customer_id),*
from orders o 
left join order_details od on od.order_id = o.order_id 


3. 


select 
	p.product_name ,
	c.category_name,
	p.quantity_per_unit ,
	p.unit_price,
	od.quantity ,
	avg(od.quantity) over (partition by c.category_name) as avgquantity
from products p 
left join categories c on c.category_id = p.category_id 
left join order_details od on od.product_id = p.product_id 
order by c.category_name , p.product_name 



****** MIN *******

4. 

select 
customer_id,
order_date , 
min(order_date) over (partition by customer_id)
from orders

****** MAX *******

5.

select 
product_id,
product_name ,
unit_price ,
category_id ,
max(unit_price) over (partition by category_id) as maxunitprice
from products p 

****** ROW NUMBER *******

6.

with quantity_by_product as(
select distinct 
p.product_name, 
sum(od.quantity) over (partition by od.product_id) as total_quantity from order_details od
left join products p on p.product_id =od.product_id 
)
select 
row_number() over (order by total_quantity desc) as ranking, product_name, total_quantity
from quantity_by_product q

7. 

select 
row_number() over (order by customer_id),
* from customers 

8. 
select 
	row_number() over (order by birth_date desc), 
	concat(first_name,' ', last_name) employeename , 
	birth_date 
from employees e 

9.

select 
	sum(od.unit_price*od.quantity*(1-od.discount)) over (partition by o.customer_id),c.*
from orders o 
left join order_details od on od.order_id = o.order_id 
left join customers c on c.customer_id = o.customer_id 



select 
	c.category_name,
	p.product_name ,
	p.unit_price,
	od.quantity,
	sum(od.unit_price*od.quantity*(1-od.discount)) over (partition by p.category_id) as totalsales
from products p 
left join categories c on c.category_id = p.category_id 
left join order_details od on od.product_id = p.product_id 
order by 1,2


11.

select 
	ship_country,
	order_id,
	shipped_date ,
	freight,
	sum(freight) over (partition by ship_country)
	as totalshippingcosts
from orders 
where shipped_date is not NULL
order by 1,2 asc

****RANK****
12. 
with sales_by_customer as (
select  
	c.customer_id , 
	c.company_name,
	sum(od.unit_price*od.quantity*(1)) totalsales
	from orders o 
left join order_details od on od.order_id = o.order_id 
left join customers c on c.customer_id = o.customer_id 
group by c.customer_id 
)
select 
	customer_id,
	company_name,
	totalsales,
	rank() over (order by totalsales desc)
from sales_by_customer




13.

select
	employee_id,
	first_name, 
	last_name, 
	hire_date, 
	rank() over (order by hire_date asc) as Rank  
from employees e 
order by Rank



14.

select
	product_id,
	product_name,
	unit_price,
	rank() over (order by unit_price desc) as Rank
from products p 
order by rank

***lag***
15.

select 
	order_id,
	product_id,
	quantity,
	lag(quantity,1) over (order by order_id, product_id)
from order_details od 
order by 1,2


16.
select 
	order_id,
	order_date,
	customer_id,
	lag(order_date,1) over (order by customer_id,order_date) as lastorderdate
from orders o 
order by 3,1

17.

select
	product_id,
	product_name ,
	unit_price ,
	lag(unit_price,1) over (order by product_id,unit_price) as lastunitprice,
	unit_price - lag(unit_price,1) over (order by product_id,unit_price) as pricedifference
from products p 	

18.

select
	product_name ,
	unit_price ,
	lead(unit_price,1) over (order by product_id ,unit_price) as nextprice
from products p
order by product_id 


19.

with sales as (
select distinct
	c.category_name,
	sum(od.unit_price * od.quantity) over (partition by c.category_name) totalsales
	from order_details od 
inner join products p on p.product_id = od.product_id 
inner join categories c on c.category_id  = p.category_id 
order by 1
)
select
	*,
	lead(totalsales,1) over (order by category_name)
from sales

*/