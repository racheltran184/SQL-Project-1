-- Product Combination Analysis
SELECT 
    p1.Product_ID AS Product1_ID,
    p1.Product_Name AS Product1_Name,
    p2.Product_ID AS Product2_ID,
    p2.Product_Name AS Product2_Name,
    COUNT(*) AS Times_Ordered_Together
FROM ORDER_ITEM oi1
JOIN ORDER_ITEM oi2 
    ON oi1.Order_ID = oi2.Order_ID
JOIN PRODUCT p1 
    ON oi1.Product_ID = p1.Product_ID
JOIN PRODUCT p2 
    ON oi2.Product_ID = p2.Product_ID
WHERE oi1.Product_ID < oi2.Product_ID
GROUP BY oi1.Product_ID, oi2.Product_ID
HAVING Times_Ordered_Together >= 2
ORDER BY Times_Ordered_Together DESC;