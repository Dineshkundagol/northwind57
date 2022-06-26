use northwind_db;
/*32. High-value customers
We want to send all of our high-value customers a special VIP gift.
We're defining high-value customers as those who've made at least 1
order with a total value (not including the discount) equal to $10,000 or
more. We only want to consider orders made in the year 2016.*/

select 	orders.customer_id,
		customers.company_name,
        orders.order_id,
		sum(order_details.unit_price *order_details.quantity) as total
from orders join order_details on orders.order_id= order_details.order_id 
			join customers on customers.customer_id=orders.customer_id
where year(orders.order_date) = 1998
group by orders.customer_id, orders.order_id having total>= 10000
order by total desc; 

/*33. High-value customers - total orders
The manager has changed his mind. Instead of requiring that customers
have at least one individual orders totaling $10,000 or more, he wants to
define high-value customers as those who have orders totaling $15,000
or more in 2016. How would you change the answer to the problem
above?*/

select 	orders.customer_id,
		customers.company_name,
        orders.order_id,
		sum(order_details.unit_price *order_details.quantity) as total
from orders join order_details on orders.order_id= order_details.order_id 
			join customers on customers.customer_id=orders.customer_id
where year(orders.order_date) = 1998
group by orders.customer_id having total>= 15000
order by total desc; 

/*34. High-value customers - with discount
Change the above query to use the discount when calculating high-value
customers. Order by the total amount which includes the discount.*/

select 	orders.customer_id,
		customers.company_name,
        orders.order_id,
		sum(order_details.unit_price *order_details.quantity) as total_without_discount,
        sum(order_details.unit_price *order_details.quantity*(1-order_details.discount)) as total_with_discount
from orders join order_details on orders.order_id= order_details.order_id 
			join customers on customers.customer_id=orders.customer_id
where year(orders.order_date) = 1998
group by orders.customer_id having total_with_discount>= 10000
order by total_with_discount desc;


/*35. Month-end orders
At the end of the month, salespeople are likely to try much harder to get
orders, to meet their month-end quotas. Show all orders made on the last
day of the month. Order by EmployeeID and OrderID*/

select employee_id,order_id,order_date from orders
where order_date=last_day(order_date)
order by employee_id, order_id ;


/*36. Orders with many line items
The Northwind mobile app developers are testing an app that customers
will use to show orders. In order to make sure that even the largest
orders will show up correctly on the app, they'd like some samples of
orders that have lots of individual line items. Show the 10 orders with
the most line items, in order of total line items.*/
select orders.order_id, count(*) 
from orders join order_details on orders.order_id=order_details.order_id
group by orders.order_id
order by count(*) desc limit 10;

/*or we can use, SELECT order_id, count(*) FROM northwind_db.order_details
group by order_id
order by count(*) desc;*/

/*37. Orders - random assortment
The Northwind mobile app developers would now like to just get a
random assortment of orders for beta testing on their app. Show a
random set of 2% of all orders.*/

select order_id from orders
order by rand() limit 10;

/*38. Orders - accidental double-entry
Janet Leverling, one of the salespeople, has come to you with a request.
She thinks that she accidentally double-entered a line item on an order,
with a different ProductID, but the same quantity. She remembers that
the quantity was 60 or more. Show all the OrderIDs with line items that
match this, in order of OrderID.*/

select order_id 
from order_details
where quantity>=60
group by order_id, quantity having count(quantity)>1 
order by order_id;

/*39. Orders - accidental double-entry details
Based on the previous question, we now want to show details of the
order, for orders that match the above criteria.*/

select * from order_details
where order_id in (select order_id 
from order_details
where quantity>=60
group by order_id, quantity having count(quantity)>1 
order by order_id) and quantity>=60;


/*41. Late orders
Some customers are complaining about their orders arriving late. Which
orders are late?*/

select order_id, order_date,required_date,shipped_date from orders
where shipped_date>required_date;

/*42. Late orders - which employees?
Some salespeople have more orders arriving late than others. Maybe
they're not following up on the order process, and need more training.
Which salespeople have the most orders arriving late?*/

select orders.employee_id, concat(employees.first_name," ",employees.last_name), count(*) 
from orders join employees on orders.employee_id=employees.employee_id
where shipped_date>required_date
group by orders.employee_id
order by count(*) desc;


/*43. Late orders vs. total orders
Andrew, the VP of sales, has been doing some more thinking some more
about the problem of late orders. He realizes that just looking at the
number of orders arriving late for each salesperson isn't a good idea. It
needs to be compared against the total number of orders per
salesperson. Return results like the following:*/

#using cte
with cte1 as	(select orders.employee_id, concat(employees.first_name," ",employees.last_name) as employee_name, count(*) as number_of_delayed_orders 
				from orders join employees on orders.employee_id=employees.employee_id
				where shipped_date>required_date
				group by orders.employee_id
                ),
	cte2 as 	(select employee_id, count(*) as total_orders from orders group by employee_id)
select cte1.*,cte2.total_orders from cte1 right join cte2 on cte1.employee_id= cte2.employee_id
order by cte1.number_of_delayed_orders desc, cte2.total_orders desc;

/* checking from creating views
create view cte1 as(select orders.employee_id, concat(employees.first_name," ",employees.last_name) as employee_name, count(*) as number_of_delayed_orders 
				from orders join employees on orders.employee_id=employees.employee_id
				where shipped_date>required_date
				group by orders.employee_id
                );
create view cte2 as(select employee_id, count(*) as total_orders from orders group by employee_id);

select cte1.*,cte2.total_orders from cte1 join cte2 on cte1.employee_id= cte2.employee_id
order by cte1.number_of_delayed_orders desc, cte2.total_orders desc;;
*/

/*46. Late orders vs. total orders - percentage
Now we want to get the percentage of late orders over total orders.*/

with cte1 as	(select orders.employee_id, concat(employees.first_name," ",employees.last_name) as employee_name, count(*) as number_of_delayed_orders 
				from orders join employees on orders.employee_id=employees.employee_id
				where shipped_date>required_date
				group by orders.employee_id
                ),
	cte2 as 	(select employee_id, count(*) as total_orders from orders group by employee_id)
select cte1.*,cte2.total_orders, (cte1.number_of_delayed_orders* 100/cte2.total_orders) as percentage from cte1 right join cte2 on cte1.employee_id= cte2.employee_id
order by cte1.number_of_delayed_orders desc, cte2.total_orders desc;

/*47. Late orders vs. total orders - fix decimal
So now for the PercentageLateOrders, we get a decimal value like we
should. But to make the output easier to read, let's cut the
PercentLateOrders off at 2 digits to the right of the decimal point.*/

with cte1 as	(select orders.employee_id, concat(employees.first_name," ",employees.last_name) as employee_name, count(*) as number_of_delayed_orders 
				from orders join employees on orders.employee_id=employees.employee_id
				where shipped_date>required_date
				group by orders.employee_id
                ),
	cte2 as 	(select employee_id, count(*) as total_orders from orders group by employee_id)
select cte1.*,cte2.total_orders, convert((cte1.number_of_delayed_orders* 100/cte2.total_orders), decimal(10,2)) as percentage from cte1 right join cte2 on cte1.employee_id= cte2.employee_id
order by cte1.number_of_delayed_orders desc, cte2.total_orders desc;

/*48. Customer grouping
Andrew Fuller, the VP of sales at Northwind, would like to do a sales
campaign for existing customers. He'd like to categorize customers into
groups, based on how much they ordered in 2016. Then, depending on
which group the customer is in, he will target the customer with
different sales materials.
The customer grouping categories are 0 to 1,000, 1,000 to 5,000, 5,000
to 10,000, and over 10,000.
A good starting point for this query is the answer from the problem
“High-value customers - total orders. We don’t want to show customers
who don’t have any orders in 2016.
Order the results by CustomerID.*/
with cte as (select orders.customer_id,customers.company_name, sum(order_details.unit_price*order_details.quantity*(1-order_details.discount)) as total 
from order_details join orders on orders.order_id= order_details.order_id 
					left join customers on orders.customer_id=customers.customer_id
where year(orders.order_date) =1997
group by orders.customer_id)
select cte.customer_id, cte.company_name, cte.total,
case when total >=0 and total<1000 then "low"
	when total >=1000 and total<5000 then "medium"
    when total >=5000 and total<10000 then "high"
    when total >=10000  then "very high"
end as categories
from  cte
order by cte.customer_id;

/*50. Customer grouping with percentage
Based on the above query, show all the defined CustomerGroups, and
the percentage in each. Sort by the total in each group, in descending
order.*/


with cte as (select orders.customer_id,customers.company_name, 
					sum(order_details.unit_price*order_details.quantity*(1-order_details.discount)) as total,
                    count(*) as total_customers
from order_details join orders on orders.order_id= order_details.order_id 
					join customers on orders.customer_id=customers.customer_id
where year(orders.order_date) =1997
group by orders.customer_id),

cte1 as(select cte.customer_id, cte.company_name, cte.total,
	case when total >=0 and total<1000 then "low"
		when total >=1000 and total<5000 then "medium"
		when total >=5000 and total<10000 then "high"
		when total >=10000  then "very high"
	end as categories
	from  cte
	order by cte.customer_id),
cte2 as (select cte1.categories,count(*) as total  from cte1 
group by cte1.categories)
select categories, total, total/(select sum(total)from cte2) as percentage  from cte2;

/*51. Customer grouping - flexible
Andrew, the VP of Sales is still thinking about how best to group
customers, and define low, medium, high, and very high value
customers. He now wants complete flexibility in grouping the
customers, based on the dollar amount they've ordered. He doesn’t want
to have to edit SQL in order to change the boundaries of the customer
groups.
How would you write the SQL?
There's a table called CustomerGroupThreshold that you will need to
use. Use only orders from 2016.*/
delimiter %
create procedure bondaries(in lower_bound int,in high_bound int, in Vhigh_bound int) 
with cte as (select orders.customer_id,customers.company_name, sum(order_details.unit_price*order_details.quantity*(1-order_details.discount)) as total 
from order_details join orders on orders.order_id= order_details.order_id 
					left join customers on orders.customer_id=customers.customer_id
where year(orders.order_date) =1997
group by orders.customer_id)
select cte.customer_id, cte.company_name, cte.total,
case when total >=0 and total<1000 then "low"
	when total >=1000 and total<5000 then "medium"
    when total >=5000 and total<10000 then "high"
    when total >=10000  then "very high"
end as categories
from  cte order by cte.customer_id%

call bondaries(1000,5000,10000) %
delimiter ;


/*52. Countries with suppliers or customers
Some Northwind employees are planning a business trip, and would like
to visit as many suppliers and customers as possible. For their planning,
they’d like to see a list of all countries where suppliers and/or customers
are based.*/

(select country from customers) union (select country from suppliers);

/*53. Countries with suppliers or customers, version 2
The employees going on the business trip don’t want just a raw list of
countries, they want more details. We’d like to see output like the
below, in the Expected Results.*/

with cte as(select distinct country from customers),
	 cte1 as (select distinct country from suppliers)
     select distinct * from cte left join cte1 on cte.country =cte1.country union 
     select distinct * from cte1 left join cte on cte.country =cte1.country ; 
     
     /*54. Countries with suppliers or customers - version 3
The output of the above is improved, but it’s still not ideal
What we’d really like to see is the country name, the total suppliers, and
the total customers.*/

with cte as(select distinct country, count(customer_id) as customer from customers group by country),
	 cte1 as (select distinct country,count(supplier_id) as supplier from suppliers group by country)
     select distinct * from cte left join cte1 on cte.country =cte1.country union 
     select distinct * from cte1 left join cte on cte.country =cte1.country;
     
     
/*55. First order in each country
Looking at the Orders table—we’d like to show details for each order
that was the first in that particular country, ordered by OrderID.
So, we need one row per ShipCountry, and CustomerID, OrderID, and
OrderDate should be of the first order from that country.*/

select order_id,customer_id,ship_country,min(order_date) from orders
group by ship_country
order by order_id;

/*56. Customers with multiple orders in 5 day period
There are some customers for whom freight is a major expense when
ordering from Northwind.
However, by batching up their orders, and making one larger order
instead of multiple smaller orders in a short period of time, they could
reduce their freight costs significantly.
Show those customers who have made more than 1 order in a 5 day
period. The sales people will use this to help customers reduce their
costs.
Note: There are more than one way of solving this kind of problem. For
this problem, we will not be using Window functions.*/

select  initial_orders.customer_id, 
initial_orders.order_id,
 initial_orders.order_date, 
 next_orders.order_id,
 next_orders.order_date,
 datediff(next_orders.order_date,initial_orders.order_date) 
 from orders as initial_orders 
cross join orders as next_orders on initial_orders.customer_id= next_orders.customer_id 
where initial_orders.order_date<next_orders.order_date 
and datediff(next_orders.order_date,initial_orders.order_date)<6
order by initial_orders.customer_id;

/*57. Customers with multiple orders in 5 day period, version
2
There’s another way of solving the problem above, using Window
functions. We would like to see the following results.*/
