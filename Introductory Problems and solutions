use northwind_db;
/*1. Which shippers do we have?
We have a table called Shippers. Return all the fields from all the
shippers
*/

select * 
from shippers;


/*2. Certain fields from Categories
In the Categories table, selecting all the fields using this SQL:
Select * from Categories
…will return 4 columns. We only want to see two columns,
CategoryName and Description
*/

select 
	category_name, 
    description
from categories;


/*3.  Sales Representatives
We’d like to see just the FirstName, LastName, and HireDate of all the
employees with the Title of Sales Representative. Write a SQL
statement that returns only those employees.
*/

select 
	first_name,
    last_name,
    hire_date,
    title
from employees 
where title= "Sales Representative";


/*4. Sales Representatives in the United States
Now we’d like to see the same columns as above, but only for those
employees that both have the title of Sales Representative, and also are
in the United States.
*/

select 
		first_name,
        last_name,
        hire_date
from employees
where 	title= "Sales Representative" and 
		country = "USA";
        

/*5. Orders placed by specific EmployeeID
Show all the orders placed by a specific employee. The EmployeeID for
this Employee (Steven Buchanan) is 5.
*/

select *
from orders
where employee_id= 5;


/*6. Suppliers and ContactTitles
In the Suppliers table, show the SupplierID, ContactName, and
ContactTitle for those Suppliers whose ContactTitle is not Marketing
Manager.
*/

select 
		supplier_id,
        contact_name,
        contact_title
from suppliers
where contact_title != "Marketing Manager";


/*7. Products with “queso” in ProductName
In the products table, we’d like to see the ProductID and ProductName
for those products where the ProductName includes the string “queso”.
*/

select 
		product_id,
        product_name
from products
where product_name like "queso%";


/*8. Orders shipping to France or Belgium
Looking at the Orders table, there’s a field called ShipCountry. Write a
query that shows the OrderID, CustomerID, and ShipCountry for the
orders where the ShipCountry is either France or Belgium.
*/

select 	order_id,
		customer_id, 
        ship_country 
from orders 
where ship_country in ("france","belgium"); 


/*9. Orders shipping to any country in Latin America
Now, instead of just wanting to return all the orders from France of
Belgium, we want to show all the orders from any Latin American
country. But we don’t have a list of Latin American countries in a table
in the Northwind database. So, we’re going to just use this list of Latin
American countries that happen to be in the Orders table:
Brazil
Mexico
Argentina
Venezuela
*/

select 	order_id,
		customer_id, 
        ship_country 
from orders 
where ship_country 
	in (
		"Brazil",
        "Mexico",
        "Argentina",
        "Venezuela"
        ); 
        

/*10. Employees, in order of age
For all the employees in the Employees table, show the FirstName,
LastName, Title, and BirthDate. Order the results by BirthDate, so we
have the oldest employees first.
*/

select 	first_name,
		last_name,
        title,
        birth_date 
from employees
order by birth_date;


/* 11. Showing only the Date with a DateTime field
In the output of the query above, showing the Employees in order of
BirthDate, we see the time of the BirthDate field, which we don’t want.
Show only the date portion of the BirthDate field.
*/

select 	first_name,
		last_name,
        title,
        date(birth_date)
from employees
order by birth_date;


/*12. Employees full name
Show the FirstName and LastName columns from the Employees table,
and then create a new column called FullName, showing FirstName and
LastName joined together in one column, with a space in-between.
*/

select 	first_name, 
		last_name, 
        concat(first_name, " ", last_name) 
from employees;


/*13. OrderDetails amount per line item
In the OrderDetails table, we have the fields UnitPrice and Quantity.
Create a new field, TotalPrice, that multiplies these two together. We’ll
ignore the Discount field for now.
In addition, show the OrderID, ProductID, UnitPrice, and Quantity.
Order by OrderID and ProductID.
*/

select 	order_id, 
		product_id,
        unit_price,
        quantity,
        unit_price*quantity as total_price 
from order_details
order by order_id, product_id;


/*14. How many customers?
How many customers do we have in the Customers table? Show one
value only, and don’t rely on getting the recordcount at the end of a
resultset.
*/

select count(*) from customers;


/*15. When was the first order?
Show the date of the first order ever made in the Orders table.
*/

select min(order_date) from orders;


/*16. Countries where there are customers
Show a list of countries where the Northwind company has customers.
*/

select distinct country from customers;


/*17. Contact titles for customers
Show a list of all the different values in the Customers table for
ContactTitles. Also include a count for each ContactTitle.
This is similar in concept to the previous question “Countries where
there are customers”
, except we now want a count for each ContactTitle.
*/

select 	contact_title,
		count(*)
 from customers
 group by contact_title;

 
 /*18. Products with associated supplier names
We’d like to show, for each product, the associated Supplier. Show the
ProductID, ProductName, and the CompanyName of the Supplier. Sort
by ProductID.
This question will introduce what may be a new concept, the Join clause
in SQL. The Join clause is used to join two or more relational database
tables together in a logical way.
Here’s a data model of the relationship between Products and Suppliers.
*/

select Product_ID, Product_Name, Company_Name 
from products  join suppliers on products.supplier_id= suppliers.supplier_id
order by product_id ;


/*19. Orders and the Shipper that was used
We’d like to show a list of the Orders that were made, including the
Shipper that was used. Show the OrderID, OrderDate (date only), and
CompanyName of the Shipper, and sort by OrderID.
In order to not show all the orders (there’s more than 800), show only
those rows with an OrderID of less than 10300.*/

select 	order_id,
		date(order_date),
        shippers.company_name
from orders join shippers on orders.ship_via = shippers.shipper_id
where order_id<10300
order by order_id;
