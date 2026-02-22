
-- Paper-1 : SportswearDB Solution

CREATE DATABASE Sportswear;

USE Sportswear;

CREATE TABLE color (
    id INT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    extra_fee DECIMAL(6,2)
);

CREATE TABLE customer (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    favorite_color_id INT,
    FOREIGN KEY (favorite_color_id) REFERENCES color(id)
);

CREATE TABLE category (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    parent_id INT NULL,
    FOREIGN KEY (parent_id) REFERENCES category(id)
);

CREATE TABLE clothing (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    size VARCHAR(10) CHECK (size IN ('S','M','L','XL','2XL','3XL')),
    price DECIMAL(8,2) CHECK (price > 0),
    color_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (color_id) REFERENCES color(id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE clothing_order (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    clothing_id INT NOT NULL,
    items INT CHECK (items > 0),
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (clothing_id) REFERENCES clothing(id)
);

SELECT * FROM color;
SELECT * FROM customer;
SELECT * FROM category;
SELECT * FROM clothing;
SELECT * FROM clothing_order;

INSERT INTO color VALUES
(1, 'Red', 50),
(2, 'Green', 30),
(3, 'Blue', 0),
(4, 'Black', 20),
(5, 'White', 0),
(6, 'Yellow', 0);

INSERT INTO customer VALUES
(101, 'Jay', 'Patel', 1),
(102, 'Dhruv', 'Shah', 2),
(103, 'Amit', 'Joshi', 3),
(104, 'Neha', 'Mehta', 4),
(105, 'Priya', 'Desai', 5),
(106, 'Rahul', 'Modi', 6),
(107, 'Riya', 'Kapoor', 3);

INSERT INTO category VALUES
(1, 'Top Wear', NULL),
(2, 'Bottom Wear', NULL),
(3, 'T-Shirt', 1),
(4, 'Jacket', 1),
(5, 'Joggers', 2),
(6, 'Shorts', 2);

INSERT INTO clothing VALUES
(201, 'Sports T-Shirt', 'M', 800, 1, 3),
(202, 'Sports T-Shirt', 'L', 850, 2, 3),
(203, 'Sports T-Shirt', 'XL', 900, 3, 3),
(204, 'Winter Jacket', 'XL', 2000, 4, 4),
(205, 'Training Joggers', 'M', 1200, 5, 5),
(206, 'Training Joggers', 'L', 1300, 3, 5),
(207, 'Training Joggers', 'XL', 1400, 2, 5),
(208, 'Running Shorts', 'M', 700, 6, 6),
(209, 'Running Shorts', 'XL', 750, 1, 6);

INSERT INTO clothing_order VALUES
(301, 101, 201, 2, '2024-04-10'),
(302, 101, 203, 1, '2024-05-12'),
(303, 102, 205, 3, '2024-03-22'),
(304, 103, 204, 1, '2024-06-18'),
(305, 104, 207, 2, '2024-04-25'),
(306, 105, 208, 4, '2024-07-02'),
(307, 101, 205, 1, '2025-01-10');

-- Queries

--1. List the customers whose favorite color is Red or Green and name is Jay or Dhruv.

SELECT C.first_name,C.last_name,CO.name
FROM customer C JOIN color CO
ON C.favorite_color_id = CO.id
WHERE CO.name IN ('RED','GREEN') AND C.first_name IN ('JAY','DHRUV');

--2. List the different types of Joggers with their sizes.

SELECT name,size
FROM clothing WHERE name LIKE '%JOGGERS%';

--3. List the orders of Jay of T-Shirt after 1st April 2024.

SELECT C.first_name,CL.name,CO.order_date,CA.name
FROM customer C JOIN clothing_order CO
ON C.ID = CO.customer_id
JOIN clothing CL
ON CO.clothing_id = CL.id
JOIN category CA
ON CL.category_id = CA.ID
WHERE C.first_name = 'JAY' AND CA.name = 'T-Shirt' AND CO.order_date > '2024-04-01';

--4. List the customer whose favorite color is charged extra.

SELECT C.first_name,CO.name,CO.extra_fee
FROM customer C JOIN color CO
ON C.favorite_color_id = CO.id
WHERE CO.extra_fee > 0;

--5. List category wise clothing’s maximum price, minimum price, average price and number of clothing items.

SELECT CA.name,MAX(CL.price) AS [MAX PRICE],MIN(CL.price) AS [MIN PRICE],
AVG(CL.price) AS [AVG PRICE],COUNT(CL.id) AS [NO.OF ITEMS]
FROM category CA JOIN clothing CL
ON CA.id = CL.category_id
GROUP BY CA.name;

--6. List the customers with no purchases at all.

SELECT DISTINCT C.first_name
FROM customer C LEFT JOIN clothing_order CO
ON C.id = CO.customer_id
WHERE CO.id IS NULL;

-- OR

SELECT first_name
FROM customer
WHERE id NOT IN (SELECT customer_id FROM clothing_order)

--7. List the orders of favorite color with all the details.

SELECT CO.id AS ORDER_ID,CO.customer_id,CO.clothing_id,CO.items,CO.order_date,
C.first_name,CL.name,COL.name
FROM clothing_order CO JOIN customer C
ON CO.customer_id = C.id
JOIN color COL
ON C.favorite_color_id = COL.ID
JOIN clothing CL
ON CO.clothing_id = CL.id;

--8. List the customers with total purchase value, number of orders and number of items purchased.

SELECT C.first_name,COUNT(CO.id) AS [NO. OF ORDERS],
SUM(CO.items) AS [NO. OF ITEMS],
SUM(CL.price * CO.items) AS [TOTAL PURCHASE VALUE]
FROM customer C JOIN clothing_order CO
ON C.id = CO.customer_id
JOIN clothing CL
ON CO.clothing_id = CL.id
GROUP BY C.first_name;

--9. List the Clothing item, Size, Order Value and Number of items sold during financial year 2024-25.

SELECT CL.name,CL.size,SUM(CO.items) AS TOTAL_ITEMS_SOLD,
SUM(CO.items * CL.price) AS ORDER_VALUE
FROM clothing CL JOIN clothing_order CO
ON CL.id = CO.clothing_id
WHERE CO.order_date BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY CL.name,CL.size;

--10. List the customers who wears XL size.

SELECT C.first_name
FROM customer C JOIN clothing_order CO
ON C.id = CO.customer_id
JOIN clothing CL
ON CO.clothing_id = CL.id
WHERE CL.size = 'XL';