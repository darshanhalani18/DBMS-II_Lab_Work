
# Sportswear Database – SQL Practice Schema


## Database Creation

```sql
CREATE DATABASE Sportswear;
USE Sportswear;
```

## Table-1 : color

```sql
CREATE TABLE color (
    id INT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    extra_fee DECIMAL(6,2) CHECK (extra_fee >= 0)
);
```

## Insert Data

```sql
INSERT INTO color VALUES
(1,'Red',50),
(2,'Green',30),
(3,'Blue',0),
(4,'Black',20),
(5,'White',0),
(6,'Yellow',0);
```

## Table-2 : customer

```sql
CREATE TABLE customer (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    favorite_color_id INT,
    FOREIGN KEY (favorite_color_id) REFERENCES color(id)
);
```

## Insert Data

```sql
INSERT INTO customer VALUES
(101,'Jay','Patel',1),
(102,'Dhruv','Shah',2),
(103,'Amit','Joshi',3),
(104,'Neha','Mehta',4),
(105,'Priya','Desai',5),
(106,'Rahul','Modi',6),
(107,'Riya','Kapoor',3);
```

## Table-3 : category

```sql
CREATE TABLE category (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    parent_id INT NULL,
    FOREIGN KEY (parent_id) REFERENCES category(id)
);
```
## Insert Data

```sql
INSERT INTO category VALUES
(1,'Top Wear',NULL),
(2,'Bottom Wear',NULL),
(3,'T-Shirt',1),
(4,'Jacket',1),
(5,'Joggers',2),
(6,'Shorts',2);
```

## Table-4 : clothing

```sql
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
```

## Insert Data

```sql
INSERT INTO clothing VALUES
(201,'Sports T-Shirt','M',800,1,3),
(202,'Sports T-Shirt','L',850,2,3),
(203,'Sports T-Shirt','XL',900,3,3),
(204,'Winter Jacket','XL',2000,4,4),
(205,'Training Joggers','M',1200,5,5),
(206,'Training Joggers','L',1300,3,5),
(207,'Training Joggers','XL',1400,2,5),
(208,'Running Shorts','M',700,6,6),
(209,'Running Shorts','XL',750,1,6);
```

## Table-5 : clothing_order

```sql
CREATE TABLE clothing_order (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    clothing_id INT NOT NULL,
    items INT CHECK (items > 0),
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (clothing_id) REFERENCES clothing(id)
);
```

## Insert Data

```sql
INSERT INTO clothing_order VALUES
(301,101,201,2,'2024-04-10'),
(302,101,203,1,'2024-05-12'),
(303,102,205,3,'2024-03-22'),
(304,103,204,1,'2024-06-18'),
(305,104,207,2,'2024-04-25'),
(306,105,208,4,'2024-07-02'),
(307,101,205,1,'2025-01-10');
```