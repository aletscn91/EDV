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




*/

