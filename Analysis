-- =====================================================================
-- Urban Eats Café Chain: the queries behind the case study
-- https://racheltran184.github.io/SQL-Project-1/
--
-- MySQL 8. Run the `Database` script first, then this file.
-- Each block starts with "-- @name <block>"; the README names the block
-- behind every check and finding.
--
-- Analysis dates: orders and customers as of 18 September 2024 (the last
-- order date); bookings as of 21 September 2024, 4:20 pm (the latest
-- timestamp in the records).
--
-- Blocks
--   Checks    audit_ticket_lines, audit_line_prices, audit_last_visit,
--             audit_bookings_open, audit_clock_coverage
--   Finding 1 labour_by_hour, last_demand_by_outlet, evening_crew_cost
--   Finding 2 double_shifts, clock_vs_roster
--   Finding 3 drink_attach, channel_mix, pair_lift
--   Finding 4 menu_cm
--   Finding 5 bookings_by_party, booking_outcomes (+ audit_bookings_open)
--   Finding 6 repeat_gap, customer_status
-- =====================================================================

USE urban_eats;

-- ---------------------------------------------------------------------
-- Five checks before any number
-- ---------------------------------------------------------------------

-- @name audit_ticket_lines
-- Expect: 27 completed tickets, 21 not reconciled; $33.70 gross gap on $554.90.
-- Do ticket totals (what was charged) match the line items (what was sold)?
WITH items AS (
  SELECT Order_ID, SUM(Quantity * Unit_Price) AS Item_Total
  FROM ORDER_ITEM
  GROUP BY Order_ID
)
SELECT
  COUNT(*)                                                  AS Completed_Orders,
  SUM(ROUND(o.Total_Amount - i.Item_Total, 2) <> 0)         AS Orders_Not_Reconciled,
  ROUND(SUM(o.Total_Amount), 2)                             AS Ticket_Revenue,
  ROUND(SUM(i.Item_Total), 2)                               AS Item_Revenue,
  ROUND(SUM(ABS(o.Total_Amount - i.Item_Total)), 2)         AS Gross_Gap,
  ROUND(SUM(o.Total_Amount - i.Item_Total), 2)              AS Net_Gap
FROM ORDERS o
JOIN items i ON i.Order_ID = o.Order_ID
WHERE o.Status = 'Completed';

-- @name audit_line_prices
-- Expect: 3 lines keyed to the wrong pastry or dessert.
-- Line prices and costs that disagree with the product master, and the product they actually match
SELECT oi.Order_ID, oi.Product_ID, p.Product_Name AS Keyed_As,
       oi.Unit_Price, p.Price AS List_Price, oi.Item_Cost, p.Cost AS List_Cost,
       m.Product_ID AS Matches_ID, m.Product_Name AS Matches_Product
FROM ORDER_ITEM oi
JOIN PRODUCT p ON p.Product_ID = oi.Product_ID
LEFT JOIN PRODUCT m ON m.Price = oi.Unit_Price AND m.Cost = oi.Item_Cost
WHERE oi.Unit_Price <> p.Price OR oi.Item_Cost <> p.Cost
ORDER BY oi.Order_ID;

-- @name audit_last_visit
-- Stored Last_Visit_Date against each buyer's last completed order, and who a
-- 30-day rule would call lapsed on each date (as of 18 September 2024).
-- Expect: 20 buyers; stored date older for 19; 5 lapsed on the stored date, 0 on orders.
WITH last_order AS (
  SELECT Customer_ID, MAX(Order_Date) AS Last_Order_Date
  FROM ORDERS
  WHERE Status = 'Completed'
  GROUP BY Customer_ID
)
SELECT
  COUNT(*)                                                     AS Buyers,
  SUM(c.Last_Visit_Date < l.Last_Order_Date)                   AS Stored_Date_Older,
  SUM(DATEDIFF('2024-09-18', c.Last_Visit_Date) > 30)          AS Lapsed_On_Stored_Date,
  SUM(DATEDIFF('2024-09-18', l.Last_Order_Date) > 30)          AS Lapsed_On_Orders
FROM CUSTOMER c
JOIN last_order l ON l.Customer_ID = c.Customer_ID;

-- @name audit_bookings_open
-- Bookings whose time has passed but still read 'Confirmed'.
-- Expect: 5 bookings.
SELECT r.Reservation_ID, o.Outlet_Name, r.Reservation_Date, r.Reservation_Time,
       r.Party_Size, r.Special_Requests
FROM RESERVATION r
JOIN OUTLET o ON o.Outlet_ID = r.Outlet_ID
WHERE r.Status = 'Confirmed'
  AND TIMESTAMP(r.Reservation_Date, r.Reservation_Time) < TIMESTAMP('2024-09-21 16:20:00')
ORDER BY r.Reservation_Date, r.Reservation_Time;

-- @name audit_clock_coverage
-- Rostered shifts with and without clock records, by date.
-- Expect: 9 of 20 shifts without clock records (all of 15 and 16 September, plus
-- Brisbane's evening on 17 September); every clocked shift falls on 17 or 18 September.
SELECT sh.Shift_Date,
       COUNT(*)                         AS Rostered_Shifts,
       SUM(c.Shift_ID IS NULL)          AS Shifts_Without_Clock,
       COALESCE(SUM(c.Staff_Clocked), 0) AS Staff_Clocked
FROM SHIFT sh
LEFT JOIN (
  SELECT Shift_ID, COUNT(*) AS Staff_Clocked
  FROM STAFF_SHIFT
  GROUP BY Shift_ID
) c ON c.Shift_ID = sh.Shift_ID
GROUP BY sh.Shift_Date
ORDER BY sh.Shift_Date;

-- ---------------------------------------------------------------------
-- Finding 1: evenings are rostered past the last order
-- ---------------------------------------------------------------------

-- @name labour_by_hour
-- Expect: 362.49 paid hours; 46.66 of them (13%) from 8 pm, against 0 orders and 1 booking.
-- Paid staff minutes in each clock hour against orders and bookings starting in that hour
WITH RECURSIVE hrs AS (
  SELECT 5 AS h UNION ALL SELECT h + 1 FROM hrs WHERE h < 23
),
clocked AS (
  SELECT ss.Staff_ID, sh.Outlet_ID, sh.Shift_Date, s.Hourly_Rate,
         HOUR(ss.Check_In_Time) * 60 + MINUTE(ss.Check_In_Time)   AS in_min,
         HOUR(ss.Check_Out_Time) * 60 + MINUTE(ss.Check_Out_Time) AS out_min
  FROM STAFF_SHIFT ss
  JOIN SHIFT sh ON sh.Shift_ID = ss.Shift_ID
  JOIN STAFF s  ON s.Staff_ID = ss.Staff_ID
),
paid AS (
  SELECT h.h,
         SUM(GREATEST(0, LEAST(c.out_min, h.h * 60 + 60) - GREATEST(c.in_min, h.h * 60))) AS staff_min,
         SUM(GREATEST(0, LEAST(c.out_min, h.h * 60 + 60) - GREATEST(c.in_min, h.h * 60)) * c.Hourly_Rate / 60.0) AS wages
  FROM hrs h CROSS JOIN clocked c
  GROUP BY h.h
),
orders_h AS (
  SELECT HOUR(Order_Time) AS h, COUNT(*) AS orders FROM ORDERS GROUP BY HOUR(Order_Time)
),
bookings_h AS (
  SELECT HOUR(Reservation_Time) AS h, COUNT(*) AS bookings FROM RESERVATION GROUP BY HOUR(Reservation_Time)
)
SELECT p.h AS Hour, ROUND(p.staff_min / 60.0, 2) AS Paid_Staff_Hours, ROUND(p.wages, 2) AS Wages,
       COALESCE(o.orders, 0) AS Orders, COALESCE(b.bookings, 0) AS Bookings
FROM paid p
LEFT JOIN orders_h o   ON o.h = p.h
LEFT JOIN bookings_h b ON b.h = p.h
ORDER BY p.h;

-- @name last_demand_by_outlet
-- Each outlet's last order and last booking slot against its rostered close.
-- Expect: Brisbane 5:45 pm / 6 pm against 10:30 pm; Melbourne 7 pm / 7:30 pm against 11 pm;
-- Sydney's only booking from 8 pm is a table for two.
SELECT o.Outlet_Name,
       (SELECT MAX(x.Order_Time) FROM ORDERS x WHERE x.Outlet_ID = o.Outlet_ID)             AS Last_Order_Time,
       (SELECT MAX(r.Reservation_Time) FROM RESERVATION r WHERE r.Outlet_ID = o.Outlet_ID)  AS Last_Booking_Slot,
       (SELECT COUNT(*) FROM RESERVATION r
         WHERE r.Outlet_ID = o.Outlet_ID AND r.Reservation_Time >= '20:00:00')             AS Bookings_From_8pm,
       (SELECT SUM(r.Party_Size) FROM RESERVATION r
         WHERE r.Outlet_ID = o.Outlet_ID AND r.Reservation_Time >= '20:00:00')             AS Seats_From_8pm,
       (SELECT MAX(s.End_Time) FROM SHIFT s WHERE s.Outlet_ID = o.Outlet_ID)                AS Rostered_Close
FROM OUTLET o
ORDER BY o.Outlet_ID;

-- @name evening_crew_cost
-- Wages per hour for each clocked evening crew, and the sales an hour needs to
-- cover them at the menu's gross margin (contribution / revenue on completed lines).
-- Expect: crews of three or four cost $69.50-105.50 an hour; gross margin 65.8%;
-- sales to cover $106-160 an hour.
WITH margin AS (
  SELECT SUM(oi.Quantity * (oi.Unit_Price - oi.Item_Cost)) / SUM(oi.Quantity * oi.Unit_Price) AS gm
  FROM ORDER_ITEM oi
  JOIN ORDERS o ON o.Order_ID = oi.Order_ID AND o.Status = 'Completed'
),
crew AS (
  SELECT sh.Outlet_ID, sh.Shift_Date, COUNT(*) AS Crew, SUM(s.Hourly_Rate) AS Wages_Per_Hour
  FROM STAFF_SHIFT ss
  JOIN SHIFT sh ON sh.Shift_ID = ss.Shift_ID
  JOIN STAFF s  ON s.Staff_ID = ss.Staff_ID
  WHERE sh.Shift_Type = 'Evening'
  GROUP BY sh.Outlet_ID, sh.Shift_Date
)
SELECT o.Outlet_Name, c.Shift_Date, c.Crew, c.Wages_Per_Hour,
       ROUND(100 * m.gm, 1)              AS Gross_Margin_Pct,
       ROUND(c.Wages_Per_Hour / m.gm, 2) AS Sales_To_Cover_Hour
FROM crew c
JOIN OUTLET o ON o.Outlet_ID = c.Outlet_ID
CROSS JOIN margin m
ORDER BY c.Shift_Date, c.Outlet_ID;

-- ---------------------------------------------------------------------
-- Finding 2: doubles cover the evening, and the overlap is paid twice
-- ---------------------------------------------------------------------

-- @name double_shifts
-- Expect: 8 doubles; 80 minutes paid twice ($36.67).
-- Staff on two shifts the same day: total paid hours and minutes paid twice
WITH day_shifts AS (
  SELECT ss.Staff_ID, sh.Shift_Date, ss.Check_In_Time, ss.Check_Out_Time, ss.Hours_Worked,
         LAG(ss.Check_Out_Time) OVER (PARTITION BY ss.Staff_ID, sh.Shift_Date ORDER BY ss.Check_In_Time) AS prev_out
  FROM STAFF_SHIFT ss
  JOIN SHIFT sh ON sh.Shift_ID = ss.Shift_ID
)
SELECT CONCAT(s.First_Name, ' ', s.Last_Name) AS Staff, s.Role, d.Shift_Date,
       SUM(d.Hours_Worked) AS Paid_Hours, COUNT(*) AS Shifts,
       SUM(GREATEST(0, TIMESTAMPDIFF(MINUTE, d.Check_In_Time, d.prev_out))) AS Minutes_Paid_Twice,
       ROUND(SUM(GREATEST(0, TIMESTAMPDIFF(MINUTE, d.Check_In_Time, d.prev_out))) * s.Hourly_Rate / 60.0, 2) AS Cost_Paid_Twice
FROM day_shifts d
JOIN STAFF s ON s.Staff_ID = d.Staff_ID
GROUP BY s.Staff_ID, s.First_Name, s.Last_Name, s.Role, s.Hourly_Rate, d.Shift_Date
HAVING COUNT(*) > 1
ORDER BY d.Shift_Date, Paid_Hours DESC;

-- @name clock_vs_roster
-- Expect: 362.49 paid hours against 360.00 rostered (+0.7%); 6 late starts, all of
-- them 10 minutes and all followed by a full shift; no early finishes.
-- Paid hours against rostered hours, and how often people start late
SELECT COUNT(*)                                                                     AS Staff_Shifts,
       ROUND(SUM(ss.Hours_Worked), 2)                                               AS Paid_Hours,
       ROUND(SUM(TIME_TO_SEC(TIMEDIFF(sh.End_Time, sh.Start_Time))) / 3600.0, 2)      AS Rostered_Hours,
       SUM(TIMESTAMPDIFF(MINUTE, TIMESTAMP(sh.Shift_Date, sh.Start_Time), ss.Check_In_Time) > 5)   AS Starts_Over_5_Min_Late,
       SUM(TIMESTAMPDIFF(MINUTE, ss.Check_Out_Time, TIMESTAMP(sh.Shift_Date, sh.End_Time)) > 5)    AS Leaves_Over_5_Min_Early
FROM STAFF_SHIFT ss
JOIN SHIFT sh ON sh.Shift_ID = ss.Shift_ID;

-- The late starts, one row each
SELECT CONCAT(s.First_Name, ' ', s.Last_Name) AS Staff, sh.Shift_Date, sh.Start_Time,
       TIMESTAMPDIFF(MINUTE, TIMESTAMP(sh.Shift_Date, sh.Start_Time), ss.Check_In_Time) AS Minutes_Late,
       ss.Hours_Worked,
       ROUND(TIME_TO_SEC(TIMEDIFF(sh.End_Time, sh.Start_Time)) / 3600.0, 2)        AS Rostered_Hours
FROM STAFF_SHIFT ss
JOIN SHIFT sh ON sh.Shift_ID = ss.Shift_ID
JOIN STAFF s  ON s.Staff_ID = ss.Staff_ID
WHERE TIMESTAMPDIFF(MINUTE, TIMESTAMP(sh.Shift_Date, sh.Start_Time), ss.Check_In_Time) > 5
ORDER BY sh.Shift_Date, sh.Start_Time;

-- ---------------------------------------------------------------------
-- Finding 3: takeaway leaves the drink behind
-- ---------------------------------------------------------------------

-- @name drink_attach
-- Expect: food orders without a drink: dine-in 2 of 11, delivery 1 of 6, takeaway 6 of 9.
-- Food orders that leave without a drink, by channel
WITH tagged AS (
  SELECT o.Order_ID, o.Order_Type, o.Total_Amount,
         MAX(pc.Category_Name IN ('Hot Beverages', 'Cold Beverages')) AS has_drink,
         MAX(pc.Category_Name NOT IN ('Hot Beverages', 'Cold Beverages')) AS has_food
  FROM ORDERS o
  JOIN ORDER_ITEM oi      ON oi.Order_ID = o.Order_ID
  JOIN PRODUCT p          ON p.Product_ID = oi.Product_ID
  JOIN PRODUCT_CATEGORY pc ON pc.Category_ID = p.Category_ID
  WHERE o.Status = 'Completed'
  GROUP BY o.Order_ID, o.Order_Type, o.Total_Amount
)
SELECT Order_Type,
       SUM(has_food)                                AS Food_Orders,
       SUM(has_food AND NOT has_drink)              AS Food_No_Drink,
       ROUND(100.0 * SUM(has_food AND NOT has_drink) / SUM(has_food), 1) AS Pct_No_Drink,
       ROUND(AVG(CASE WHEN has_food AND has_drink THEN Total_Amount END), 2)     AS AOV_With_Drink,
       ROUND(AVG(CASE WHEN has_food AND NOT has_drink THEN Total_Amount END), 2) AS AOV_No_Drink
FROM tagged
GROUP BY Order_Type
ORDER BY Order_Type;

-- @name channel_mix
-- Average ticket by channel, and what a drink adds.
-- Expect: takeaway $14.88, dine-in $23.22, delivery $25.12; a drink averages $4.67, $3.33 of it margin.
SELECT Order_Type,
       COUNT(*)                     AS Completed_Orders,
       ROUND(SUM(Total_Amount), 2)  AS Sales,
       ROUND(AVG(Total_Amount), 2)  AS Avg_Ticket
FROM ORDERS
WHERE Status = 'Completed'
GROUP BY Order_Type
ORDER BY Avg_Ticket;

-- Average price and contribution of a drink sold on a completed order
SELECT SUM(oi.Quantity)                                                        AS Drinks_Sold,
       ROUND(SUM(oi.Quantity * oi.Unit_Price) / SUM(oi.Quantity), 2)             AS Avg_Drink_Price,
       ROUND(SUM(oi.Quantity * (oi.Unit_Price - oi.Item_Cost)) / SUM(oi.Quantity), 2) AS Avg_Drink_Contribution
FROM ORDER_ITEM oi
JOIN ORDERS o            ON o.Order_ID = oi.Order_ID AND o.Status = 'Completed'
JOIN PRODUCT p           ON p.Product_ID = oi.Product_ID
JOIN PRODUCT_CATEGORY pc ON pc.Category_ID = p.Category_ID
WHERE pc.Category_Name IN ('Hot Beverages', 'Cold Beverages');

-- @name pair_lift
-- Items bought together on two or more completed tickets, with lift
-- (lift = tickets with both x all tickets / (tickets with A x tickets with B)).
-- Expect: one pair, cappuccino with bruschetta, on 2 tickets (lift 6.8).
WITH t AS (
  SELECT DISTINCT oi.Order_ID, oi.Product_ID
  FROM ORDER_ITEM oi
  JOIN ORDERS o ON o.Order_ID = oi.Order_ID AND o.Status = 'Completed'
),
n AS (SELECT COUNT(DISTINCT Order_ID) AS tickets FROM t),
singles AS (SELECT Product_ID, COUNT(*) AS tickets FROM t GROUP BY Product_ID),
pairs AS (
  SELECT a.Product_ID AS A_ID, b.Product_ID AS B_ID, COUNT(*) AS Together
  FROM t a
  JOIN t b ON b.Order_ID = a.Order_ID AND b.Product_ID > a.Product_ID
  GROUP BY a.Product_ID, b.Product_ID
)
SELECT pa.Product_Name AS Item_A, pb.Product_Name AS Item_B, p.Together,
       ROUND(1.0 * p.Together * n.tickets / (ia.tickets * ib.tickets), 1) AS Lift
FROM pairs p
CROSS JOIN n
JOIN singles ia ON ia.Product_ID = p.A_ID
JOIN singles ib ON ib.Product_ID = p.B_ID
JOIN PRODUCT pa ON pa.Product_ID = p.A_ID
JOIN PRODUCT pb ON pb.Product_ID = p.B_ID
WHERE p.Together >= 2
ORDER BY p.Together DESC, Lift DESC;

-- ---------------------------------------------------------------------
-- Finding 4: mains earn the dollars, at the highest food cost
-- ---------------------------------------------------------------------

-- @name menu_cm
-- Expect: mains earn $7.70-13.70 a plate; Fish and Chips $13.70 at 40.2% food cost.
-- Contribution margin per item from the line itself (price and cost at the time of sale),
-- with mis-keyed lines re-pointed to the product whose price and cost they carry
WITH lines AS (
  SELECT oi.Order_ID,
         COALESCE(m.Product_ID, oi.Product_ID) AS Product_ID,
         oi.Quantity, oi.Unit_Price, oi.Item_Cost
  FROM ORDER_ITEM oi
  JOIN ORDERS o   ON o.Order_ID = oi.Order_ID AND o.Status = 'Completed'
  JOIN PRODUCT p  ON p.Product_ID = oi.Product_ID
  LEFT JOIN PRODUCT m
         ON (oi.Unit_Price <> p.Price OR oi.Item_Cost <> p.Cost)
        AND m.Price = oi.Unit_Price AND m.Cost = oi.Item_Cost
)
SELECT p.Product_Name, pc.Category_Name,
       SUM(l.Quantity)                                         AS Units,
       ROUND(SUM(l.Quantity * l.Unit_Price), 2)                AS Revenue,
       ROUND(SUM(l.Quantity * (l.Unit_Price - l.Item_Cost)), 2) AS Contribution,
       ROUND(AVG(l.Unit_Price - l.Item_Cost), 2)               AS CM_Per_Unit,
       ROUND(100.0 * SUM(l.Quantity * l.Item_Cost) / SUM(l.Quantity * l.Unit_Price), 1) AS Food_Cost_Pct
FROM lines l
JOIN PRODUCT p           ON p.Product_ID = l.Product_ID
JOIN PRODUCT_CATEGORY pc ON pc.Category_ID = p.Category_ID
GROUP BY p.Product_ID, p.Product_Name, pc.Category_Name
ORDER BY Contribution DESC;

-- The $1 test on the three 40% food-cost mains: contribution gain and break-even volume loss
SELECT Product_Name, Price, Cost,
       ROUND(Price - Cost, 2)              AS CM_Per_Plate,
       ROUND(100.0 * Cost / Price, 1)      AS Food_Cost_Pct,
       ROUND(100.0 / (Price - Cost), 1)    AS CM_Gain_Pct_From_1_Dollar,
       ROUND(100.0 / (Price - Cost + 1), 1) AS Break_Even_Unit_Loss_Pct
FROM PRODUCT
WHERE Product_Name IN ('Fish and Chips', 'Gourmet Burger', 'Big Breakfast')
ORDER BY CM_Per_Plate DESC;

-- ---------------------------------------------------------------------
-- Finding 5: big tables hold the seats, and outcomes go unrecorded
-- ---------------------------------------------------------------------

-- @name bookings_by_party
-- Expect: parties of 5 or more: 4 of 15 bookings, 25 of 56 seats (45%), all with an occasion.
-- Seats by party size and occasion
SELECT CASE WHEN Party_Size >= 5 THEN '5 or more' WHEN Party_Size >= 3 THEN '3 to 4' ELSE '2' END AS Party,
       COUNT(*) AS Bookings, SUM(Party_Size) AS Seats,
       SUM(Special_Requests IS NOT NULL) AS With_Request
FROM RESERVATION
GROUP BY CASE WHEN Party_Size >= 5 THEN '5 or more' WHEN Party_Size >= 3 THEN '3 to 4' ELSE '2' END
ORDER BY MIN(Party_Size) DESC;

-- @name booking_outcomes
-- Expect: 10 past bookings; 5 still 'Confirmed'; of the 5 with an outcome, 3 seated
-- ('Completed'), 1 no-show, 1 cancelled.
SELECT Status,
       SUM(TIMESTAMP(Reservation_Date, Reservation_Time) <  TIMESTAMP('2024-09-21 16:20:00')) AS Past,
       SUM(TIMESTAMP(Reservation_Date, Reservation_Time) >= TIMESTAMP('2024-09-21 16:20:00')) AS Upcoming,
       SUM(Party_Size) AS Seats,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, Booked_Datetime, TIMESTAMP(Reservation_Date, Reservation_Time))) / 1440, 1) AS Avg_Lead_Days
FROM RESERVATION
GROUP BY Status;

-- ---------------------------------------------------------------------
-- Finding 6: repeat guests return within two weeks
-- ---------------------------------------------------------------------

-- @name repeat_gap
-- Expect: 7 repeat buyers, all back within 15 days; median gap 11 days.
-- Days between a customer's first and second completed order
WITH seq AS (
  SELECT Customer_ID, Order_Date,
         LAG(Order_Date) OVER (PARTITION BY Customer_ID ORDER BY Order_Date, Order_Time) AS prev_date
  FROM ORDERS
  WHERE Status = 'Completed'
)
SELECT Customer_ID, prev_date AS First_Order, Order_Date AS Second_Order, DATEDIFF(Order_Date, prev_date) AS Gap_Days
FROM seq
WHERE prev_date IS NOT NULL
ORDER BY Gap_Days;

-- @name customer_status
-- Every customer by stage, as of 18 September 2024.
-- Expect: 7 repeat buyers; 13 one-order buyers (2 past day 15); 3 first orders in
-- progress; 2 registered without an order.
WITH done AS (
  SELECT Customer_ID, COUNT(*) AS Completed_Orders, MIN(Order_Date) AS First_Order
  FROM ORDERS
  WHERE Status = 'Completed'
  GROUP BY Customer_ID
),
open_orders AS (
  SELECT Customer_ID, COUNT(*) AS Open_Orders
  FROM ORDERS
  WHERE Status <> 'Completed'
  GROUP BY Customer_ID
)
SELECT CASE
         WHEN d.Completed_Orders >= 2 THEN 'Repeat buyer'
         WHEN d.Completed_Orders = 1
              AND DATEDIFF('2024-09-18', d.First_Order) > 15 THEN 'One order, past day 15'
         WHEN d.Completed_Orders = 1 THEN 'One order, within 15 days'
         WHEN oo.Open_Orders > 0 THEN 'First order in progress'
         ELSE 'Registered, no order'
       END      AS Stage,
       COUNT(*) AS Customers
FROM CUSTOMER c
LEFT JOIN done d         ON d.Customer_ID = c.Customer_ID
LEFT JOIN open_orders oo ON oo.Customer_ID = c.Customer_ID
GROUP BY Stage
ORDER BY Customers DESC;

-- Customers whose first order is still in progress, with any booking they hold
SELECT c.Customer_ID, o.Order_Date, o.Status AS Order_Status,
       r.Party_Size, r.Status AS Booking_Status, r.Special_Requests
FROM CUSTOMER c
JOIN ORDERS o           ON o.Customer_ID = c.Customer_ID AND o.Status <> 'Completed'
LEFT JOIN RESERVATION r ON r.Customer_ID = c.Customer_ID
WHERE c.Customer_ID NOT IN (SELECT Customer_ID FROM ORDERS WHERE Status = 'Completed')
ORDER BY c.Customer_ID;
