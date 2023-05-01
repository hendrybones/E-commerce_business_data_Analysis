/* Olist customers 
Which city has the most number of customers
sao paulo is the leading city with number of customer followed by no de janero
where as epitaciolandia,manoel urbano,part acre are the cities with the least number customers

*/
SELECT customer_city,customer_state,count(*) as Number_OF_Customers FROM Brazilian_Ecommerce_Olisit.dbo.olist_customers_dataset$
GROUP BY customer_city,customer_state
ORDER BY COUNT(*) DESC

/* .Which state grouped by city has the least and highest number of customers
*/
SELECT CUSTOMER_STATE,CUSTOMER_CITY,COUNT(customer_unique_id) AS Number_Of_Customer 
FROM Brazilian_Ecommerce_Olisit.dbo.olist_customers_dataset$
GROUP BY CUSTOMER_STATE,CUSTOMER_CITY
ORDER BY COUNT(*) DESC

/* HOW MANY CUSTOMER DO WE HAVE PER ZIP-CODE PREFIX
WE HAVE MANY CUSTOMERS COMMING FROM 4045 ZIP CODE FOLLOWED BY 
11065 & 38301
*/
SELECT CUSTOMER_UNIQUE_ID,CUSTOMER_ZIP_CODE_PREFIX,COUNT(*) AS NUMBER_OF_CUSTOMERS FROM Brazilian_Ecommerce_Olisit.dbo.olist_customers_dataset$
GROUP BY CUSTOMER_UNIQUE_ID,CUSTOMER_ZIP_CODE_PREFIX
ORDER BY COUNT(*) DESC

/*
HOW MANY CUSTOMER FEOM ZIP CODE 4045
*/
SELECT CUSTOMER_UNIQUE_ID,COUNT(CUSTOMER_UNIQUE_ID)AS NUMBER_OF_CUSTOMERS FROM Brazilian_Ecommerce_Olisit.dbo.olist_customers_dataset$
WHERE CUSTOMER_ZIP_CODE_PREFIX = 4045
GROUP BY CUSTOMER_UNIQUE_ID
/*
which city has the most sales
sao paulo has the most sales followed by curitiba where as abadia and afonso one of the cities
with the least sales
*/
SELECT seller_city,count(seller_id) AS number_of_sales FROM Brazilian_Ecommerce_Olisit.dbo.olist_sellers$
GROUP BY seller_city
ORDER BY count(*) DESC

/* 

how many sales wer made in each zip
ZIP CODE 14940 HA THE HIGHEST SALES FOLLOWED BY 13660
*/
SELECT SELLER_ZIP_CODE_PREFIX,COUNT(SELLER_ID) FROM Brazilian_Ecommerce_Olisit.dbo.olist_sellers$
GROUP BY SELLER_ZIP_CODE_PREFIX
ORDER BY COUNT(SELLER_ID) DESC

/* 
The product with the highest number of sales per product 
ferrsments jardim and relogios presentles has the highest sales 
*/
SELECT item.SELLER_ID,product_category_name,COUNT(item.SELLER_ID) AS NUMBER_OF_SALES_PER_PRODUCT  FROM Brazilian_Ecommerce_Olisit.dbo.olist_products_dataset$ product
INNER JOIN  Brazilian_Ecommerce_Olisit.dbo.olist_order_items_dataset$ As item ON item.product_id =product.product_id 
GROUP BY  item.SELLER_ID,product_category_name
ORDER BY  COUNT(*) DESC

/*
Which product had the most sales, which city had the most sales of the product
The product with highest sales comes from ibitinga followed by sao paulo which has quiet a number of sales coming 
from that area for different products
THIS SHOWS SELLERS FROM CITY ARE DOING THEIR JOB SO WELL
*/
SELECT PRODUCT_CATEGORY_NAME,sell.seller_city,COUNT(*) AS NUMBER_OF_SALES_PER_CITY FROM Brazilian_Ecommerce_Olisit.dbo.olist_products_dataset$ PRODUCT
INNER JOIN  Brazilian_Ecommerce_Olisit.dbo.olist_order_items_dataset$ As item ON item.product_id =product.product_id
INNER JOIN  Brazilian_Ecommerce_Olisit.dbo.olist_sellers$ As sell ON SELL.seller_id =ITEM.seller_id
GROUP BY PRODUCT_CATEGORY_NAME, SELL.seller_city
ORDER BY COUNT(*) DESC

/*
HOW MANY ORDERS DID WE HAVE 
WE HAVE A TOTAL OF 99441
*/
SELECT COUNT(*) AS TOTAL_NUMBER_OF_ORDERS FROM Brazilian_Ecommerce_Olisit.dbo.olist_orders_dataset$

/*
HOW MANY ORDERS WERE MADE IN EACH CITY
we have beleza as the highiest product order from sao paulo and automotivo which was ordered mostly in
goiania city on the other hand we have cool_stuff products which are the ones which had list orders from campos dos goytacazes
*/
SELECT ord.order_id,PRODUCT_CATEGORY_NAME,CUSTOMER_CITY,COUNT(ord.ORDER_ID) as Number_of_orders FROM Brazilian_Ecommerce_Olisit.dbo.olist_order_items_dataset$ item
INNER JOIN Brazilian_Ecommerce_Olisit.dbo.olist_orders_dataset$ AS ord ON ord.order_id=item.order_id
INNER JOIN Brazilian_Ecommerce_Olisit.dbo.olist_products_dataset$ AS product ON product.product_id=item.product_id
INNER JOIN Brazilian_Ecommerce_Olisit.dbo.olist_customers_dataset$ AS cust ON cust.customer_id=ord.customer_id
GROUP BY ord.ORDER_ID,PRODUCT_CATEGORY_NAME,customer_city
ORDER BY COUNT(*) desc

/*
How long does it take to approve an order from time it was ordered to the time approve
*/
SELECT ORDER_ID,Datediff(HOUR,order_purchase_timestamp,order_approved_at) as Time_Taken_In_Min 
FROM Brazilian_Ecommerce_Olisit.dbo.olist_orders_dataset$ 
Order by Time_Taken_In_Min DESC

/*What is the average approval time fromthe time of purchase

*/
SELECT ORDER_ID,AVG(Datediff(DAY,order_purchase_timestamp,order_approved_at)) as Time_Taken_In_Min 
FROM Brazilian_Ecommerce_Olisit.dbo.olist_orders_dataset$ 
GROUP BY order_id
Order by Time_Taken_In_Min DESC

/*
Time taken to deliver a product from the time approved to the time delivered to the carrier
*/
SELECT ORDER_ID,DATEDIFF(MINUTE,order_approved_at,order_delivered_carrier_date) as Time_Taken_Deliver_To_Carrier
FROM Brazilian_Ecommerce_Olisit.dbo.olist_orders_dataset$ 
order by Time_Taken_Deliver_To_Carrier DESC
/*

*/
SELECT *FROM Brazilian_Ecommerce_Olisit.dbo.olist_orders_dataset$

/*
How to create a CTE 
use CTE table to find the average orders made in the entire period
BY EACH PRODUCT
*/
WITH orders(PRODUCT_CATEGORY_NAME,CUSTOMER_CITY,Number_of_orders)
AS
(
SELECT PRODUCT_CATEGORY_NAME,CUSTOMER_CITY,COUNT(ord.ORDER_ID) as Number_of_orders FROM Brazilian_Ecommerce_Olisit.dbo.olist_order_items_dataset$ item
INNER JOIN Brazilian_Ecommerce_Olisit.dbo.olist_orders_dataset$ AS ord ON ord.order_id=item.order_id
INNER JOIN Brazilian_Ecommerce_Olisit.dbo.olist_products_dataset$ AS product ON product.product_id=item.product_id
INNER JOIN Brazilian_Ecommerce_Olisit.dbo.olist_customers_dataset$ AS cust ON cust.customer_id=ord.customer_id
GROUP BY ord.ORDER_ID,PRODUCT_CATEGORY_NAME,customer_city
)
select PRODUCT_CATEGORY_NAME,AVG(Number_of_orders) AS AVERAGE_ORDERS from orders
GROUP BY PRODUCT_CATEGORY_NAME
ORDER BY AVERAGE_ORDERS DESC

/*
CUSTOMER WITH THE MOST ORDERS AND THE CITY THAT ORDER CAME FROM
*/
WITH CUSTOMER (CUSTOMER_ID,ORDER_ID,CUSTOMER_CITY,Number_Of_Orders_Per_Customer)
AS
(
SELECT cust.customer_id,ORDER_ID,CUSTOMER_CITY,COUNT(order_id) as NUmber_Of_Orders_Per_Customer
FROM Brazilian_Ecommerce_Olisit.dbo.olist_orders_dataset$ AS ord
JOIN Brazilian_Ecommerce_Olisit.dbo.olist_customers_dataset$ AS cust on cust.customer_id=ord.customer_id
Group by cust.CUSTOMER_ID,ORDER_ID,CUSTOMER_CITY
)
select customer_id,Number_Of_Orders_Per_Customer from CUSTOMER

/*
CREATING VIEWS 
*/
CREATE VIEW CUSTOMER AS
SELECT cust.customer_id,ORDER_ID,CUSTOMER_CITY,COUNT(order_id) as NUmber_Of_Orders_Per_Customer
FROM Brazilian_Ecommerce_Olisit.dbo.olist_orders_dataset$ AS ord
JOIN Brazilian_Ecommerce_Olisit.dbo.olist_customers_dataset$ AS cust on cust.customer_id=ord.customer_id
Group by cust.CUSTOMER_ID,ORDER_ID,CUSTOMER_CITY

/*
REVENUE AND PAYMENT
*/
SELECT * FROM Brazilian_Ecommerce_Olisit.dbo.olist_order_payments_dataset$ 

/*
How much revenue does each product generate from each city
*/
SELECT PRODUCT_CATEGORY_NAME,CUSTOMER_ID,PAYMENT_VALUE
FROM Brazilian_Ecommerce_Olisit.dbo.olist_products_dataset$ AS PRO
INNER JOIN Brazilian_Ecommerce_Olisit.dbo.olist_order_items_dataset$ AS item on item.product_id=pro.product_id
INNER JOIN  Brazilian_Ecommerce_Olisit.dbo.olist_customers_dataset$ AS cust on item.product_id=PRO.product_id
INNER JOIN Brazilian_Ecommerce_Olisit.dbo.olist_order_payments_dataset$ AS PAY on pay.order_id=item.order_id
order by PAYMENT_VALUE desc