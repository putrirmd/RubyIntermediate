# Homework : Week 2
This folder contains erd and all the SQL used for the homework in week-2 that you can find inside homework.sql. 

## Entity Relationship Diagram
Additional entity : 
Entity Name | Description
------------ | -------------
Customers | Record customer data such as name, phone number
Orders | Record about the order such as the customer who ordered, date and time when the order was made
Order_Detail | Record all the detail of the order such as items in an order and quantity of the item
<br>
<img src="all_screenshots/homework2_erd.png" width=500>

## All Tables
<img src="all_screenshots/describe_table_1.png" width=450>
<br>
<img src="all_screenshots/describe_table_2.png" width=450>

## Data inside each table
<img src="all_screenshots/data_1.png" width=450>
<br>
<img src="all_screenshots/data_2.png" width=450>

## Detail for every order
<img src="all_screenshots/detail_all_order.png" width=700>

## Order summary
<img src="all_screenshots/order_summary.png" width=700>

# UPDATE
Added new column for ORDER_DETAIL : PRICE_PER_ITEM.
Based on the above ERD, we couldn't capture the old price of an item if it's updated in the future.
So, in order to solve that issue, I added new column in ORDER_DETAIL which is PRICE_PER_ITEM to capture the current price of an ITEM_ID for current ORDER_ID.
#### Below is the updated ERD and updated data inside ORDER_DETAIL
<br>
<img src="all_screenshots/update_erd.png" width=500>
<br>
<img src="all_screenshots/update_order_deatils.png" width=450>

#### Updated Query for Order Summary
<img src="all_screenshots/update_query.png" width=700>