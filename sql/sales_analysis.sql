create database sales_analysis;

USE sales_analysis;

SELECT
    COUNT(*) AS total_records,
    SUM(order_id IS NULL) AS missing_order_ids,
    SUM(order_date IS NULL) AS missing_order_dates,
    SUM(customer_id IS NULL) AS missing_customer_ids,
    SUM(product_id IS NULL) AS missing_product_ids,
    SUM(quantity IS NULL) AS missing_quantities,
    SUM(discount_rate IS NULL) AS missing_discounts,
    SUM(sales IS NULL) AS missing_sales
FROM orders;

SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    SUM(quantity <= 0) AS invalid_quantities,
    SUM(discount_rate < 0 OR discount_rate > 1) AS invalid_discounts,
    SUM(sales < 0) AS negative_sales,
    SUM(order_date > CURRENT_DATE()) AS future_order_dates
FROM orders;

SELECT
    SUM(c.customer_id IS NULL) AS unmatched_customers,
    SUM(p.product_id IS NULL) AS unmatched_products
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN products p
    ON o.product_id = p.product_id;

SELECT
    COUNT(*) AS total_order_records,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    SUM(sales) AS total_sales,
    ROUND(AVG(sales), 2) AS average_sales_per_record
FROM orders;

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS total_units_sold,
    SUM(o.sales) AS total_sales
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity) AS total_units_sold,
    SUM(o.sales) AS total_sales,
    ROUND(AVG(o.sales), 2) AS average_sales_per_record
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.sales) AS total_sales,
    SUM(o.quantity) AS total_units_purchased,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS sales_month,
    DATE_FORMAT(order_date, '%M') AS month_name,
    SUM(sales) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATE_FORMAT(order_date, '%M')
ORDER BY sales_year, sales_month;

SELECT
    YEAR(order_date) AS sales_year,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    SUM(sales) AS total_sales,
    ROUND(AVG(sales), 2) AS average_sales_per_record
FROM orders
GROUP BY YEAR(order_date)
ORDER BY sales_year;

SELECT
    YEAR(order_date) AS sales_year,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    SUM(sales) AS total_sales,
    ROUND(AVG(sales), 2) AS average_sales_per_record
FROM orders
WHERE MONTH(order_date) BETWEEN 1 AND 9
GROUP BY YEAR(order_date)
ORDER BY sales_year;

SELECT
    discount_rate,
    COUNT(*) AS total_records,
    SUM(sales) AS total_sales,
    ROUND(AVG(sales), 2) AS average_sales
FROM orders
GROUP BY discount_rate
ORDER BY discount_rate;

SELECT
    p.category,
    o.discount_rate,
    COUNT(*) AS total_records,
    SUM(o.quantity) AS total_units_sold,
    SUM(o.sales) AS total_sales,
    ROUND(AVG(o.sales), 2) AS average_sales
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    p.category,
    o.discount_rate
ORDER BY
    p.category,
    o.discount_rate;

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(o.quantity) AS total_units_sold,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category
),
ranked_products AS (
    SELECT
        product_id,
        product_name,
        category,
        total_units_sold,
        total_sales,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM product_sales
)
SELECT
    category,
    product_name,
    total_units_sold,
    total_sales,
    sales_rank
FROM ranked_products
WHERE sales_rank <= 3
ORDER BY category, sales_rank;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity) AS total_units_purchased,
    SUM(o.sales) AS total_sales,
    ROUND(AVG(o.sales), 2) AS average_sales_per_record
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id) >= 20
ORDER BY total_sales DESC;
