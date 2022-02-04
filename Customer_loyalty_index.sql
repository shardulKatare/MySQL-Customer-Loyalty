USE mavenmovies;

SELECT * FROM Customer;

-- Calculating the Customer Loyalty Index

-- Step 1: Calculate the amount_purchase Index per Customer. This can be done by dividing highest purchase amount per customer by purchase amoutn per customer.alter

SELECT 
  first_name, 
  last_name, 
  ROUND((total_amount)/221.55,2) AS amount_purchase_index
FROM amount_prcustomer
ORDER BY 
	 Percantage_of_highest DESC;

-- Step 2: Calculate Duration of Customer History

CREATE TEMPORARY TABLE Customer_history
SELECT 
	first_name, 
    last_name,
    DATEDIFF(last_update, create_date) AS customer_days
FROM customer;

-- Step 2.1 Calculate the Customer history Index

SELECT 
  first_name, 
  last_name, 
  ROUND((customer_days)/835,2) AS customer_history_Index
FROM Customer_history
ORDER BY 
	prop DESC;

SELECT * FROM Customer;

# Step 3: Calculating the Customer Loyalty Index

CREATE TEMPORARY TABLE customer_loyalty
SELECT 
	customer.customer_id,
	first_name, 
	last_name,
    DATEDIFF(customer.last_update,customer.create_date) AS customer_history,
    SUM(amount) AS total_amount,
    ROUND(((DATEDIFF(customer.last_update,customer.create_date))/835)*10,0) AS customer_history_index,
    ROUND(((SUM(amount))/221.55)*10,0) AS amount_spent_index,
    customer.product_preference,
    customer.likely_torecommend,
    customer.desire_torepurchase,
	ROUND((ROUND(((DATEDIFF(customer.last_update,customer.create_date))/835)*10,2) + ((ROUND(((SUM(amount))/221.55)*10,2))) +customer.product_preference + customer.likely_torecommend + customer.desire_torepurchase)/5,2) AS Customer_loyalty_index
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY
	first_name, 
    last_name,
    customer.customer_id
ORDER BY customer_loyalty_index DESC;

#Step 4: Performing Customer Segmentation using the Customer Loyalty Index

SELECT
	first_name,
	last_name,
    customer_history,
    total_amount,
    customer_history_index, 
    amount_spent_index, 
	product_preference,
    likely_torecommend,
    desire_torepurchase,
    customer_loyalty_index,
	CASE 
		WHEN customer_loyalty_index > 7.00 THEN "Loyal Customer"
        WHEN customer_history_index < 2.00 THEN "New Customer"
		WHEN customer_history_index > 3.00 AND amount_spent_index < 4.00 THEN "Unprofitable Customer"
		WHEN customer_loyalty_index BETWEEN 5.00 AND 6.99 THEN "Repeat Customer"
        ELSE 'Captive Customer'
	END AS Customer_Segmentation
FROM customer_loyalty
	ORDER BY Customer_loyalty_index DESC;



