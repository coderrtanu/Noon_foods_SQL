
# Advanced SQL Portfolio Project: Food Delivery Data Analytics (Noon Food Case Study)

## 📌 Project Overview
This project focuses on extracting key business metrics and performance insights for a newly launched food delivery vertical (**Noon Food** in Dubai). Using an advanced-level dataset spanning from January 1, 2025, to March 31, 2025, the analysis solves realistic business scenarios regarding customer acquisition, purchasing behavior, campaign tracking, and operations.

The queries are written in standard SQL and can be executed across platforms like SQL Server, PostgreSQL, MySQL, or Snowflake.

---

## 📊 Database Schema & Dataset
The core analysis revolves around the `orders` table, which tracks the following attributes:
* `Order_id`: Unique identifier for each order.
* `Customer_code`: Unique identifier for each customer.
* `Placed_at`: Timestamp of when the order was submitted.
* `Restaurant_id`: Unique identifier for the outlet.
* `Cuisine`: The style of food (e.g., American, Italian, Japanese, Lebanese, Mexican).
* `Order_status`: Current delivery state (e.g., Delivered, Cancelled).
* `Promo_code_Name`: The promo campaign applied (can be `NULL` if ordered organically).

---

## 🔍 Key Analytical Problems Solved

### 1. Top Outlets by Cuisine (Without LIMIT/TOP)
* **Business Goal:** Identify the top-performing restaurant within each cuisine vertical based on total order volume without relying on hardcoded constraints like `TOP` or `LIMIT`.
* **Technique Used:** Window Functions (`ROW_NUMBER()` / `DENSE_RANK()`) combined with a CTE.

### 2. Daily Customer Acquisition Count
* **Business Goal:** Track growth velocity by calculating exactly how many **new** users placed their very first order each day from the launch date.
* **Technique Used:** Dynamic Date aggregation (`MIN(placed_at)`) and `GROUP BY` counts.

### 3. January Cohort Churn Analysis
* **Business Goal:** Count users who were acquired during the launch month (January 2025), placed exactly *one* order in January, and never returned to order again in February or March.
* **Technique Used:** Subqueries utilizing `NOT IN` exclusions alongside a `HAVING count(*) = 1` condition.

### 4. High-Intent Dormant Customers
* **Business Goal:** Extract a list of customers who haven't ordered in the last 7 days, but were originally acquired over a month ago using a promotional discount.
* **Technique Used:** Date Arithmetic (`DATEADD` / `getdate()`), self-joins to match first-order flags, and non-null evaluation.

### 5. Automated Retention Marketing Triggers
* **Business Goal:** Provide a clean data stream to help the Growth/Marketing team trigger a personalized message to a customer *every single time* they achieve a milestone multiple of 3 orders (3rd, 6th, 9th, etc.) strictly on the day the milestone is cleared.
* **Technique Used:** Modulus operator (`% 3 = 0`) filtered on dynamic system dates.

### 6. Promo-Driven Super-Consumers
* **Business Goal:** List all returning customers (more than 1 order) who strictly buy food only when a promo discount code is active.
* **Technique Used:** Comparative aggregation comparing total orders to non-null conditional promo counts inside a `HAVING` clause.

### 7. Organic vs. Paid Acquisition Share
* **Business Goal:** Determine the percentage of users acquired in January 2025 who ordered organically (without a promo code) on their first order.
* **Technique Used:** Conditional aggregation (`COUNT(CASE WHEN...)`) to evaluate first-row actions.

---

## 🛠️ Tech Stack & Skills Showcased
* **SQL Dialect:** Optimized for SQL Server / T-SQL (easily portable to PostgreSQL or MySQL).
* **Advanced Concepts:** Common Table Expressions (CTEs), Analytical Window Functions, Multi-conditional Joins, Conditional Aggregations, Date/Time Manipulation, Modulus Math.
