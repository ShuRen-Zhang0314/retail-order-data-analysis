-- Q1: 销售额 Top 10 产品
SELECT product_id, SUM(sale_price) AS total_sales
FROM df_orders
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;

-- Q2: 每个地区销量前 5 的产品（窗口函数）
WITH cte AS (
    SELECT region, product_id, SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY region, product_id
)
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY region ORDER BY sales DESC) AS rn
    FROM cte
) t
WHERE rn <= 5;

--Q3：月度销售额环比增长率（LAG 函数
WITH monthly AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month,
           SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY order_month
)
SELECT order_month, sales,
       ROUND((sales - LAG(sales) OVER (ORDER BY order_month))
             / LAG(sales) OVER (ORDER BY order_month) * 100, 2) AS mom_growth_pct
FROM monthly;

--Q4：验证"折扣侵蚀利润"假设
SELECT CASE
           WHEN discount_percent = 0 THEN '无折扣'
           WHEN discount_percent <= 20 THEN '低折扣(≤20%)'
           WHEN discount_percent <= 40 THEN '中折扣(20-40%)'
           ELSE '高折扣(>40%)'
       END AS discount_band,
       COUNT(*) AS order_cnt,
       ROUND(SUM(profit) / SUM(sale_price) * 100, 2) AS profit_margin_pct,
       SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS loss_orders
FROM df_orders
GROUP BY discount_band
ORDER BY profit_margin_pct DESC;

--Q5：各地区经营全景
SELECT region,
       COUNT(DISTINCT order_id) AS total_orders,
       SUM(sale_price) AS total_revenue,
       SUM(profit) AS total_profit,
       ROUND(SUM(profit) / SUM(sale_price) * 100, 2) AS profit_margin_pct
FROM df_orders
GROUP BY region
ORDER BY total_revenue DESC;


