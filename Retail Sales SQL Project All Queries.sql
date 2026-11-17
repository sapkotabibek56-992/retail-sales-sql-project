/*
---------------------------------------------------------
Retail Sales SQL Project
Database: PostgreSQL
Author: Bibek Sapkota

Description:
A retail sales database project containing 90 SQL queries
covering basic SQL, aggregations, joins, business analysis,
subqueries, CTEs, CASE expressions, and window functions.

Tools:
- PostgreSQL
- pgAdmin 4
---------------------------------------------------------
*/

CREATE DATABASE retail_sales_db;

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2)
);


DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50)
);

CREATE TABLE Stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    employee_id INT,
    store_id INT,
    order_date DATE,
    quantity INT,

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id),

    FOREIGN KEY (employee_id)
        REFERENCES Employees(employee_id),

    FOREIGN KEY (store_id)
        REFERENCES Stores(store_id)
);

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Employees;
SELECT * FROM Stores;
SELECT * FROM Orders;

-- PART 1 – BASIC SQL

-- 1. Display all customers.
SELECT *
FROM Customers;

-- 2. Display customer names and cities.
SELECT customer_name, city
FROM Customers;

-- 3. Show all products.
SELECT *
FROM Products;

-- 4. Find customers from Kathmandu.
SELECT *
FROM Customers
WHERE city - 'Kathmandu';

-- 5. Find products costing more than 500.
SELECT *
FROM Products
WHERE price > 500;

-- 6. Find employees in the Sales department.
SELECT *
FROM Employees
WHERE department = 'Sales';

-- 7. Show orders placed after January 1, 2024.
SELECT *
FROM Orders
WHERE order_date > '2024-01-01';

-- 8. Show customers aged between 25 and 35.
SELECT *
FROM Customers
WHERE age BETWEEN 25 AND 35;

-- 9. Find products in the Electronics category.
SELECT *
FROM Products
WHERE category = 'Electronics';

-- 10. Display the first 10 customers.
SELECT *
FROM Customers
LIMIT 10;

-- 11. Sort customers by age.
SELECT *
FROM Customers
ORDER BY age;

-- 12. Sort products by highest price.
SELECT *
FROM Products
ORDER BY price DESC;

-- 13. Show unique cities.
SELECT DISTINCT city
FROM Customers;

-- 14. Count total customers.
SELECT COUNT(*)
FROM Customers;

-- 15. Count total orders.
SELECT COUNT(*)
FROM Orders;

-- 16. Find the cheapest product.
SELECT *
FROM Products
ORDER BY price
LIMIT 1;

-- 17. Find the most expensive product.
SELECT *
FROM Products
ORDER BY price DESC
LIMIT 1;

-- 18. Calculate the average product price.
SELECT AVG(price)
FROM Products;

-- 19. Find the total quantity ordered.
SELECT SUM(quantity)
FROM Orders;

-- 20. Show customers whose names start with A.

SELECT *
FROM Customers
WHERE customer_name LIKE 'A%';

-- 21. Count customers by city.
SELECT city,
       COUNT(*) AS total_customers
FROM Customers
GROUP BY city;

-- 22. Count customers by gender.
SELECT gender,
       COUNT(*) AS total_customers
FROM Customers
GROUP BY gender;

-- 23. Average age by city.
SELECT city,
       AVG(age) AS average_age
FROM Customers
GROUP BY city;

-- 24. Number of products in each category.
SELECT category,
       COUNT(*) AS total_products
FROM Products
GROUP BY category;

-- 25. Average product price by category.
SELECT category,
       AVG(price) AS average_price
FROM Products
GROUP BY category;

-- 26. Total quantity sold per product.


SELECT product_id,
       SUM(quantity) AS total_quantity
FROM Orders
GROUP BY product_id;

-- 27. Total orders per customer.
SELECT customer_id,
       COUNT(*) AS total_orders
FROM Orders
GROUP BY customer_id;

-- 28. Total orders per employee.
SELECT employee_id,
       COUNT(*) AS total_orders
FROM Orders
GROUP BY employee_id;

-- 29. Total orders per store.
SELECT store_id,
       COUNT(*) AS total_orders
FROM Orders
GROUP BY store_id;

-- 30. Cities with more than 100 customers.
select city , count(*)
from customers
group by city
having count (*) > 100
    
-- PART 2 – SQL JOIN Practice (Questions 31–60)
-- 31. Show customer name with each order.

SELECT
    o.order_id,
    c.customer_name
FROM Orders o
INNER JOIN Customers c
    ON o.customer_id = c.customer_id;

-- 32. Show product name with each order.
SELECT
    o.order_id,
    p.product_name
FROM Orders o
INNER JOIN Products p
    ON o.product_id = p.product_id;

-- 33. Show employee handling each order.
SELECT
    o.order_id,
    e.employee_name
FROM Orders o
INNER JOIN Employees e
    ON o.employee_id = e.employee_id;

-- 34. Show store for every order.
SELECT
    o.order_id,
    s.store_name
FROM Orders o
INNER JOIN Stores s
    ON o.store_id = s.store_id;

-- 35. Show customer and purchased product.
SELECT
    c.customer_name,
    p.product_name
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Products p
    ON o.product_id = p.product_id;

-- 36. Show customer, product and quantity.
SELECT
    c.customer_name,
    p.product_name,
    o.quantity
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Products p
    ON o.product_id = p.product_id;

-- 37. Show customer, employee and store.
SELECT
    c.customer_name,
    e.employee_name,
    s.store_name
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Employees e
    ON o.employee_id = e.employee_id
JOIN Stores s
    ON o.store_id = s.store_id;

-- 38. Show complete order details.
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    e.employee_name,
    s.store_name,
    o.order_date,
    o.quantity
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Products p
    ON o.product_id = p.product_id
JOIN Employees e
    ON o.employee_id = e.employee_id
JOIN Stores s
    ON o.store_id = s.store_id;

-- 39. Customers who never ordered.
SELECT
    c.customer_id,
    c.customer_name
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 40. Products never ordered.
SELECT
    p.product_id,
    p.product_name
FROM Products p
LEFT JOIN Orders o
    ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- 41. Employees with no orders.
SELECT
    e.employee_id,
    e.employee_name
FROM Employees e
LEFT JOIN Orders o
    ON e.employee_id = o.employee_id
WHERE o.order_id IS NULL;

-- 42. Stores with no orders.
SELECT
    s.store_id,
    s.store_name
FROM Stores s
LEFT JOIN Orders o
    ON s.store_id = o.store_id
WHERE o.order_id IS NULL;

-- 43. Count orders by customer.
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;

-- 44. Count orders by product.
SELECT
    p.product_name,
    COUNT(o.order_id) AS total_orders
FROM Products p
LEFT JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC;

-- 45. Count orders by employee.
SELECT
    e.employee_name,
    COUNT(o.order_id) AS total_orders
FROM Employees e
LEFT JOIN Orders o
    ON e.employee_id = o.employee_id
GROUP BY e.employee_name
ORDER BY total_orders DESC;

-- 46. Count orders by store.
SELECT
    s.store_name,
    COUNT(o.order_id) AS total_orders
FROM Stores s
LEFT JOIN Orders o
    ON s.store_id = o.store_id
GROUP BY s.store_name
ORDER BY total_orders DESC;

-- 47. Customer with the most orders.
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC
LIMIT 1;

-- 48. Most ordered product.
SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity
FROM Products p
JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 1;

-- 49. Employee who handled the most orders.
SELECT
    e.employee_name,
    COUNT(o.order_id) AS total_orders
FROM Employees e
JOIN Orders o
    ON e.employee_id = o.employee_id
GROUP BY e.employee_name
ORDER BY total_orders DESC
LIMIT 1;

-- 50. Store with the most orders.
SELECT
    s.store_name,
    COUNT(o.order_id) AS total_orders
FROM Stores s
JOIN Orders o
    ON s.store_id = o.store_id
GROUP BY s.store_name
ORDER BY total_orders DESC
LIMIT 1;

-- 51. Show all customers and their orders (LEFT JOIN).
SELECT
    c.customer_name,
    o.order_id
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id;

-- 52. Show all orders and customers (RIGHT JOIN).
SELECT
    c.customer_name,
    o.order_id
FROM Customers c
RIGHT JOIN Orders o
    ON c.customer_id = o.customer_id;

-- 53. Show all customers and orders (FULL OUTER JOIN).
SELECT
    c.customer_name,
    o.order_id
FROM Customers c
FULL OUTER JOIN Orders o
    ON c.customer_id = o.customer_id;

-- 54. Total quantity purchased by each customer.
SELECT
    c.customer_name,
    SUM(o.quantity) AS total_quantity
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_quantity DESC;

-- 55. Total quantity sold for each product.
SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity
FROM Products p
JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC;

-- 56. Average quantity per customer.
SELECT
    c.customer_name,
    AVG(o.quantity) AS average_quantity
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- 57. Average quantity handled by each employee.
SELECT
    e.employee_name,
    AVG(o.quantity) AS average_quantity
FROM Employees e
JOIN Orders o
    ON e.employee_id = o.employee_id
GROUP BY e.employee_name;

-- 58. Average quantity sold by each store.
SELECT
    s.store_name,
    AVG(o.quantity) AS average_quantity
FROM Stores s
JOIN Orders o
    ON s.store_id = o.store_id
GROUP BY s.store_name;

-- 59. Customers and the number of different products they purchased.
SELECT
    c.customer_name,
    COUNT(DISTINCT o.product_id) AS different_products
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY different_products DESC;

-- 60. Full sales report.
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    e.employee_name,
    s.store_name,
    o.order_date,
    o.quantity,
    (p.price * o.quantity) AS total_amount
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Products p
    ON o.product_id = p.product_id
JOIN Employees e
    ON o.employee_id = e.employee_id
JOIN Stores s
    ON o.store_id = s.store_id
ORDER BY o.order_date;






SELECT city,
       COUNT(*) AS total_customers
FROM Customers
GROUP BY city
HAVING COUNT(*) > 100;






-- -----------------------------------------------------
-- PART 3 – Business Analysis & Advanced SQL (61–90)
-- -----------------------------------------------------

-- 61. Top 10 customers by total quantity purchased
SELECT
    c.customer_name,
    SUM(o.quantity) AS total_quantity
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_quantity DESC
LIMIT 10;

-- 62. Top 10 best-selling products
SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity
FROM Products p
JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

-- 63. Most popular product category
SELECT
    p.category,
    SUM(o.quantity) AS total_quantity
FROM Products p
JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_quantity DESC
LIMIT 1;

-- 64. Total quantity sold by city
SELECT
    c.city,
    SUM(o.quantity) AS total_quantity
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_quantity DESC;

-- 65. Monthly order trend
SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY month
ORDER BY month;

--- 66. Daily order trend
SELECT
    order_date,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY order_date
ORDER BY order_date;

-- 67. Average quantity per order
SELECT
    AVG(quantity) AS average_quantity
FROM Orders;

-- 68. Highest quantity order
SELECT *
FROM Orders
ORDER BY quantity DESC
LIMIT 1;

-- 69. Lowest quantity order
SELECT *
FROM Orders
ORDER BY quantity
LIMIT 1;

-- 70. Total quantity sold by category
SELECT
    p.category,
    SUM(o.quantity) AS total_quantity
FROM Products p
JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_quantity DESC;

-- 71. Top employee by orders handled
SELECT
    e.employee_name,
    COUNT(*) AS total_orders
FROM Employees e
JOIN Orders o
    ON e.employee_id = o.employee_id
GROUP BY e.employee_name
ORDER BY total_orders DESC
LIMIT 1;

-- 72. Top store by orders
SELECT
    s.store_name,
    COUNT(*) AS total_orders
FROM Stores s
JOIN Orders o
    ON s.store_id = o.store_id
GROUP BY s.store_name
ORDER BY total_orders DESC
LIMIT 1;

-- 73. Customer purchase frequency
SELECT
    c.customer_name,
    COUNT(*) AS purchases
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY purchases DESC;

-- 74. Average customer age by gender
SELECT
    gender,
    AVG(age) AS average_age
FROM Customers
GROUP BY gender;

-- 75. Products never purchased
SELECT
    p.product_name
FROM Products p
LEFT JOIN Orders o
    ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- 76. Number of ordering customers by city
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_customers DESC;

-- 77. City with the most orders
SELECT
    c.city,
    COUNT(*) AS total_orders
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_orders DESC
LIMIT 1;

-- 78. Category with the most products
SELECT
    category,
    COUNT(*) AS total_products
FROM Products
GROUP BY category
ORDER BY total_products DESC
LIMIT 1;

-- 79. Find duplicate customer names
SELECT
    customer_name,
    COUNT(*)
FROM Customers
GROUP BY customer_name
HAVING COUNT(*) > 1;

-- 80. Top 5 busiest days
SELECT
    order_date,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY order_date
ORDER BY total_orders DESC
LIMIT 5;


-- -----------------------------------------------------
-- Advanced SQL
-- -----------------------------------------------------

-- 81. Price category using CASE
SELECT
    product_name,
    price,
    CASE
        WHEN price < 200 THEN 'Cheap'
        WHEN price BETWEEN 200 AND 500 THEN 'Medium'
        ELSE 'Expensive'
    END AS price_category
FROM Products;

-- 82. Customer age group using CASE
SELECT
    customer_name,
    age,
    CASE
        WHEN age < 25 THEN 'Young'
        WHEN age BETWEEN 25 AND 40 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group
FROM Customers;

-- 83. Customers with above-average orders
SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(*) >
(
    SELECT AVG(order_count)
    FROM
    (
        SELECT COUNT(*) AS order_count
        FROM Orders
        GROUP BY customer_id
    ) t
);

-- 84. Products priced above average
SELECT *
FROM Products
WHERE price >
(
    SELECT AVG(price)
    FROM Products
);

-- 85. Correlated subquery
SELECT *
FROM Products p
WHERE price >
(
    SELECT AVG(price)
    FROM Products
    WHERE category = p.category
);

-- 86. Customer Orders CTE
WITH CustomerOrders AS
(
    SELECT
        customer_id,
        COUNT(*) AS total_orders
    FROM Orders
    GROUP BY customer_id
)
SELECT *
FROM CustomerOrders;

-- 87. Product Sales CTE
WITH ProductSales AS
(
    SELECT
        product_id,
        SUM(quantity) AS total_quantity
    FROM Orders
    GROUP BY product_id
)
SELECT *
FROM ProductSales;

-- 88. ROW_NUMBER()
SELECT
    customer_name,
    ROW_NUMBER() OVER (ORDER BY age DESC) AS row_num
FROM Customers;

-- 89. RANK()
SELECT
    product_name,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank
FROM Products;

-- 90. DENSE_RANK()
SELECT
    employee_name,
    DENSE_RANK() OVER (ORDER BY employee_id) AS dense_rank
FROM Employees;


