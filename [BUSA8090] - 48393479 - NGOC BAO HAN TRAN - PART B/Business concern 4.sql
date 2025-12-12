
-- Product Portfolio Profitability Analysis
SELECT
    p.Product_ID,
    p.Product_Name,
    pc.Category_Name,
    COUNT(oi.Product_ID) AS Times_Ordered,
    SUM(oi.Quantity) AS Total_Units_Sold,
    ROUND(SUM(oi.Quantity * oi.Unit_Price), 2) AS Total_Revenue,
    ROUND(SUM(oi.Quantity * (oi.Unit_Price - p.Cost)), 2) AS Total_Profit,
    ROUND(
        (SUM(oi.Quantity * (oi.Unit_Price - p.Cost)) / SUM(oi.Quantity * oi.Unit_Price)) * 100,
        2
    ) AS Profit_Margin_Percent
FROM PRODUCT p
JOIN PRODUCT_CATEGORY pc ON p.Category_ID = pc.Category_ID
LEFT JOIN ORDER_ITEM oi ON p.Product_ID = oi.Product_ID
GROUP BY p.Product_ID, p.Product_Name, pc.Category_Name
ORDER BY Total_Profit DESC;