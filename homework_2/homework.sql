create database food_oms_db;
use food_oms_db;

-- DDL
create table items ( 
    id int not null auto_increment, 
    name varchar(50) not null, 
    price decimal(10,2) default 0, 
    primary key (id) 
);

create table categories (
    id int not null auto_increment , 
    name varchar(50) unique, 
    primary key(id) 
);

create table item_categories ( 
    item_id int not null, 
    category_id int not null, 
    foreign key (item_id) references items(id), 
    foreign key (category_id) references categories(id) 
);

-- Additional Table
create table customers ( 
    id int not null auto_increment, 
    name varchar(50), 
    phone_no varchar(15) unique, 
    primary key(id) 
);

create table orders ( 
    id int not null auto_increment, 
    customer_id int not null , 
    order_datetime datetime not null default current_timestamp, 
    primary key (id), 
    foreign key (customer_id) references customers(id) 
);
 
create table order_detail(
    order_id int not null,
    item_id int not null,
    quantity int default 1,
    foreign key (order_id) references orders(id),
    foreign key (item_id) references items(id)
);

-- DML 
-- Insert 
insert into customers (name, phone_no) values 
('Ani', '+6281310101010'),
('Budi', '+6281311111111'),
('Cica', '+6281312121212'),
('Doni', '+6281313131313'),
('Feni', '+6281314141414');

insert into items (name, price) values 
('Nasi Goreng Gila', 25000),
('Ice Water', 2000),
('Spaghetti', 40000),
('Green Tea Latte', 18000),
('Orange Juice', 15000),
('Vanilla Ice Cream', 13000),
('Cordon Bleu', 36000),
('French Fries', 20000),
('Mango Juice', 15000);

insert into categories (name) values ('Main Dish'), ('Beverage'), ('Dessert');

insert into item_categories (item_id, category_id) values 
(1, 1),
(2, 2),
(3, 1),
(4, 2),
(5, 2),
(6, 3),
(7, 1),
(8, 1),
(9, 2);

insert into orders (customer_id, order_datetime) values 
(1, subdate(now(), 3)),
(3, subdate(now(), 3)),
(4, subdate(now(), 2)),
(2, subdate(now(), 1)),
(5, now());

insert into order_detail (order_id, item_id, quantity) values 
(1, 3, 2),
(1, 4 ,1),
(1, 2, 1),
(2, 7, 3),
(2, 8, 5),
(2, 2, 8),
(3, 6, 2),
(4, 5, 6),
(4, 1, 6),
(5, 6, 1),
(5, 7, 1);

-- DETAIL ALL ORDER
SELECT  O.ID ORDER_ID
        ,DATE_FORMAT(ORDER_DATETIME, '%Y-%m-%d') ORDER_DATE
        ,C.NAME CUSTOMER_NAME
        ,C.PHONE_NO CUSTOMER_PHONE
        ,I.NAME ITEM_NAME
        ,PRICE_PER_ITEM
        ,QUANTITY
        ,(PRICE_PER_ITEM*QUANTITY) TOTAL_PER_ITEM
FROM CUSTOMERS C
JOIN ORDERS O
    ON C.ID = O.CUSTOMER_ID
JOIN ORDER_DETAIL OD
    ON O.ID = OD.ORDER_ID
JOIN ITEMS I
    ON OD.ITEM_ID = I.ID
ORDER BY O.ID

-- ORDER SUMMARY
WITH ALL_ORDER AS(
    SELECT  O.ID ORDER_ID
            ,DATE_FORMAT(ORDER_DATETIME, '%Y-%m-%d') ORDER_DATE
            ,C.NAME CUSTOMER_NAME
            ,C.PHONE_NO CUSTOMER_PHONE
            ,I.NAME ITEM_NAME
            ,PRICE_PER_ITEM
            ,QUANTITY
            ,(PRICE_PER_ITEM*QUANTITY) TOTAL_PER_ITEM
    FROM CUSTOMERS C
    JOIN ORDERS O
        ON C.ID = O.CUSTOMER_ID
    JOIN ORDER_DETAIL OD
        ON O.ID = OD.ORDER_ID
    JOIN ITEMS I
        ON OD.ITEM_ID = I.ID
)
SELECT  ORDER_ID, ORDER_DATE
        ,CUSTOMER_NAME, CUSTOMER_PHONE
        ,SUM(TOTAL_PER_ITEM) TOTAL
        ,GROUP_CONCAT(ITEM_NAME) ORDERED_ITEMS
FROM ALL_ORDER
GROUP BY    ORDER_ID, 
            ORDER_DATE, 
            CUSTOMER_NAME, 
            CUSTOMER_PHONE
ORDER BY ORDER_ID 

-- UPDATE QUERY
SELECT  O.ID ORDER_ID, 
        DATE_FORMAT(ORDER_DATETIME, '%Y-%m-%d') ORDER_DATE, 
        C.NAME CUSTOMER_NAME, 
        C.PHONE_NO CUSTOMER_PHONE,
        SUM(PRICE_PER_ITEM*QUANTITY) TOTAL, 
        GROUP_CONCAT(I.NAME) ITEM_ORDERED
FROM CUSTOMERS C
JOIN ORDERS O
ON C.ID = O.CUSTOMER_ID
JOIN ORDER_DETAIL OD
ON O.ID = OD.ORDER_ID
JOIN ITEMS I
ON OD.ITEM_ID = I.ID
GROUP BY ORDER_ID, ORDER_DATE, CUSTOMER_NAME, CUSTOMER_PHONE

-- UPDATE FOR ORDER_DETAIL : ADDED NEW COLUMN PRICE_PER_ITEM
mysql> update order_detail set price_per_item = 40000 where item_id = 3;

mysql> update order_detail set price_per_item = 18000 where item_id = 4;

mysql> update order_detail set price_per_item = 2000 where item_id = 2;

mysql> update order_detail set price_per_item = 36000 where item_id = 7;

mysql> update order_detail set price_per_item = 20000 where item_id = 8;

mysql> update order_detail set price_per_item = 13000 where item_id = 6;

mysql> update order_detail set price_per_item = 15000 where item_id = 5;

mysql> update order_detail set price_per_item = 25000 where item_id = 1;