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
