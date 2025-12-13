-- Customer Retention and Value Segmentation
SELECT 
    c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    c.Registration_Date,
    c.Last_Visit_Date,
    COUNT(o.Order_ID) AS Total_Orders,
    ROUND(COALESCE(SUM(o.Total_Amount), 0), 2) AS Total_Spent,
    ROUND(COALESCE(AVG(o.Total_Amount), 0), 2) AS Average_Order_Value,
    DATEDIFF('2024-09-18', c.Last_Visit_Date) AS Days_Since_Last_Visit,
    CASE 
        WHEN COUNT(o.Order_ID) >= 2 THEN 'Repeat Customer'
        WHEN COUNT(o.Order_ID) = 1 THEN 'One-Time Customer'
        ELSE 'Registered - No Orders'
    END AS Customer_Type,
    CASE 
        WHEN COALESCE(SUM(o.Total_Amount), 0) >= 50 THEN 'High Value'
        WHEN COALESCE(SUM(o.Total_Amount), 0) >= 25 THEN 'Medium Value'
        WHEN COALESCE(SUM(o.Total_Amount), 0) > 0 THEN 'Low Value'
        ELSE 'No Purchases'
    END AS Value_Segment,
    CASE 
        WHEN DATEDIFF('2024-09-18', c.Last_Visit_Date) <= 3 THEN 'Very Recent'
        WHEN DATEDIFF('2024-09-18', c.Last_Visit_Date) <= 7 THEN 'Recent'
        WHEN DATEDIFF('2024-09-18', c.Last_Visit_Date) <= 30 THEN 'Active'
        ELSE 'At Risk'
    END AS Recency_Status
FROM CUSTOMER c
LEFT JOIN ORDERS o ON c.Customer_ID = o.Customer_ID AND o.Status = 'Completed'
GROUP BY c.Customer_ID, c.First_Name, c.Last_Name, c.Registration_Date, c.Last_Visit_Date
ORDER BY Total_Spent DESC, Total_Orders DESC;