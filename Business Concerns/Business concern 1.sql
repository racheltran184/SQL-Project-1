-- Financial impact of reservation failures (use outlet’s real averages)
WITH
dinein AS (
  SELECT Outlet_ID, AVG(Total_Amount) AS avg_ticket
  FROM ORDERS
  WHERE Order_Type = 'Dine-in' AND Status = 'Completed'
  GROUP BY Outlet_ID
),
-- Avg party size for completed reservations per outlet (to get per-cover value)
party AS (
  SELECT Outlet_ID, AVG(Party_Size) AS avg_party_completed
  FROM RESERVATION
  WHERE Status = 'Completed'
  GROUP BY Outlet_ID
),
baseline AS (
  SELECT
    d.Outlet_ID,
    CASE
      WHEN COALESCE(p.avg_party_completed,0) > 0
        THEN d.avg_ticket / p.avg_party_completed
      ELSE 0
    END AS per_cover_value
  FROM dinein d
  LEFT JOIN party p ON p.Outlet_ID = d.Outlet_ID
)
SELECT
  r.Status AS Reservation_Status,
  o.Outlet_Name,
  COUNT(*)                         AS Count,
  AVG(r.Party_Size)                AS Avg_Party_Size,
  SUM(r.Party_Size)                AS Total_Seats_Lost,
  ROUND(SUM(r.Party_Size * COALESCE(b.per_cover_value,0)), 2) AS Estimated_Lost_Revenue,
  SUM(
    CASE
      WHEN (TIME(r.Reservation_Time) BETWEEN '12:00:00' AND '14:00:00')
        OR (TIME(r.Reservation_Time) BETWEEN '18:00:00' AND '21:00:00')
      THEN 1 ELSE 0
    END
  )                                AS Peak_Time_Losses
FROM RESERVATION r
JOIN OUTLET o       ON o.Outlet_ID = r.Outlet_ID
LEFT JOIN baseline b ON b.Outlet_ID = r.Outlet_ID
WHERE r.Status IN ('No-show', 'Cancelled')
GROUP BY r.Status, o.Outlet_Name
ORDER BY Estimated_Lost_Revenue DESC;