-- Q1

WITH OrderCounts AS (
    SELECT 
        Cuisine, 
        Restaurant_id, 
        COUNT(Order_id) AS number_of_orders
    FROM orders
    GROUP BY Cuisine, Restaurant_id
)
select * from (
    SELECT 
        Cuisine, 
        Restaurant_id, 
        number_of_orders,
        ROW_NUMBER() OVER (PARTITION BY Cuisine ORDER BY number_of_orders DESC) AS RN
    FROM OrderCounts
)a where rn<=3


-- Q2

WITH FirstOrders AS (
    SELECT 
        Customer_code,
        CAST(MIN(Placed_at) AS DATE) AS first_order_date
    FROM orders
    GROUP BY Customer_code
)
SELECT 
    first_order_date, 
    COUNT(*) AS number_of_new_customers
FROM FirstOrders
GROUP BY first_order_date
ORDER BY first_order_date;


-- Q3

SELECT 
    Customer_code, 
    COUNT(*) AS number_of_orders
FROM orders
WHERE MONTH(Placed_at) = 1 AND YEAR(Placed_at) = 2025
  AND Customer_code NOT IN (
      SELECT DISTINCT Customer_code 
      FROM orders 
      WHERE NOT (MONTH(Placed_at) = 1 AND YEAR(Placed_at) = 2025)
  )
GROUP BY Customer_code
HAVING COUNT(*) = 1;


-- Q4

WITH CustomerMilestones AS (
    SELECT 
        Customer_code,
        MIN(Placed_at) AS first_order_date,
        MAX(Placed_at) AS latest_order_date
    FROM orders
    GROUP BY Customer_code
)
SELECT 
    cm.Customer_code,
    cm.first_order_date,
    cm.latest_order_date,
    o.Promo_code_Name AS first_order_promo
FROM CustomerMilestones cm
JOIN orders o 
    ON cm.Customer_code = o.Customer_code 
    AND cm.first_order_date = o.Placed_at
WHERE cm.latest_order_date < DATEADD(day, -7, GETDATE())  
  AND cm.first_order_date < DATEADD(month, -1, GETDATE())   
  AND o.Promo_code_Name IS NOT NULL;                     


-- Q5

WITH NumberedOrders AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY Customer_code ORDER BY Placed_at) AS order_number
    FROM orders
)
SELECT 
    Customer_code,
    order_number,
    Placed_at
FROM NumberedOrders
WHERE order_number % 3 = 0                             -- Milestone identifier
  AND CAST(Placed_at AS DATE) = CAST(GETDATE() AS DATE); -- Reached milestone today


-- Q6

SELECT 
    Customer_code,
    COUNT(*) AS total_orders,
    COUNT(Promo_code_Name) AS promo_orders -- COUNT(column) ignores NULLs
FROM orders
GROUP BY Customer_code
HAVING COUNT(*) > 1                     -- Returning customer
   AND COUNT(*) = COUNT(Promo_code_Name); -- Every single order used a promo


-- Q7

WITH FirstOrders AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY Customer_code ORDER BY Placed_at) AS RN
    FROM orders
    WHERE MONTH(Placed_at) = 1 AND YEAR(Placed_at) = 2025
)
SELECT 
    100.0 * COUNT(CASE WHEN RN = 1 AND Promo_code_Name IS NULL THEN Customer_code END) 
    / COUNT(DISTINCT Customer_code) AS organic_acquisition_percentage
FROM FirstOrders;