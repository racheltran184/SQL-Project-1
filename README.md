# Urban Eats Café Chain: Data-Driven Decision Playbook

![Urban Eats Operational Flowchart](https://github.com/racheltran184/SQL-Project-1/blob/main/Urban%20Eat%20Cafe%20Operational%20Flowchart.png)
> **Figure 1.** End-to-end value chain from customer demand to dining experience, operations, and analytics.

---

## 1. Executive Summary

Urban Eats is a growing multi-outlet café chain operating in Sydney, Melbourne, and Brisbane.  
This repository documents how a single, well-designed database and a small set of SQL analytics can answer **five board-level questions**:

1. **Are we losing money from reservation failures?**
2. **Which customers are worth investing in – and which are at risk of churning?**
3. **Which product combinations naturally belong together on the menu?**
4. **Which menu items actually drive profit – and which ones quietly destroy margin?**
5. **Where are we leaking labour cost through poor attendance and time theft?**

The aim of this project is not just to store data, but to **turn every reservation, order, and shift into a measurable business lever.**

---

## 2. How the Business Works 

The operational flowchart above shows Urban Eats as a closed loop:

1. **Customers & Demand (L1)**  
   Reservations, orders, and payments enter the system.

2. **Central Management System**  
   A single database captures transactions, staff shifts, reservations, and menu items.  
   This is where analytics (SQL) are run to create insight.

3. **Operations & Supply**  
   Staff rosters, product availability, and menu engineering decisions are driven from data.

4. **Kitchen & Service Execution**  
   Food is prepared, tables are served, and shifts are clocked in/out.

5. **Dining Experience & Retention (L2)**  
   The experience converts into **repeat visits, higher spend, or churn** – feeding back into the customer base.

The rest of this README explains how each analytics script in this repo turns that operational loop into **clear, actionable business insight.**

---

## 3. Five Critical Business Questions & Insights

Each Part-B SQL file in this repository is designed around a **single management question**, not just a technical query.  

### 3.1 Revenue Protection: What is reservation failure really costing us?

**File:** `Business concern 1.sql`  
**Business Question:**  
> “When customers no-show or cancel late, how much revenue do we actually lose – especially in peak hours?”

**What the analysis does**

- Calculates **average spend per cover** for dine-in customers by outlet.
- Identifies **no-shows and cancellations** and multiplies the seats lost by the **per-seat revenue**.
- Flags losses that happen in **peak windows** (12:00–14:00 lunch, 18:00–21:00 dinner).

**Key Insight (from the sample data)**

- Just **two failed reservations (five seats)** generated **$41.20 in lost revenue**,  
  **100%** during peak trading windows.
- Sydney’s CBD outlet shows higher **revenue per seat**, so a single no-show hurts more there than elsewhere.

**Decisions this enables**

- Introduce a **tiered deposit policy** (e.g., $10 per person peak / $5 off-peak).
- Send **24-hour confirmation SMS/email** with easy cancellation links.
- Maintain a **dynamic waitlist** to backfill late cancellations in real time.

**KPIs to monitor**

- Reservation **show rate** (% of bookings actually seated)  
- **Peak-hour lost revenue** from failed reservations  
- Average **revenue per seat** by outlet

---

### 3.2 Customer Lifecycle & Retention: Who should we fight hardest to keep?

**File:** `Business concern 2.sql`  
**Business Question:**  
> “Which customers are genuinely valuable, who is drifting away, and who never converted in the first place?”

**What the analysis does**

- Segments customers by:
  - **Value** (total spend),
  - **Frequency** (number of orders),
  - **Recency** (days since last visit).
- Labels each customer as:
  - `Repeat`, `One-Time`, or `Registered-No Orders`,
  - `High`, `Medium`, or `Low` value,
  - `Very Recent`, `Recent`, `Active`, or `At Risk`.

**Key Insight (from the sample data)**

- **Five high-value customers (≥ $50 spend)** have not visited in 30+ days –  
  putting roughly **$334 of repeat revenue at risk**.
- Another **five customers registered but never ordered**, indicating onboarding and conversion gaps.

**Decisions this enables**

- Launch **win-back campaigns** (email/SMS) specifically for **high-value, at-risk customers**.
- Design **VIP benefits** (early access offers, birthday rewards) for loyal repeaters.
- Create a **welcome journey** (voucher + guidance) to convert registered non-purchasers.

**KPIs to monitor**

- **Churn rate** among high-value customers  
- **Repeat purchase rate** by segment  
- Conversion from **“Registered” → “First Order”**  

---

### 3.3 Cross-Selling & Bundling: Which items naturally go together?

**File:** `Business concern 3.sql`  
**Business Question:**  
> “If average order value needs to increase tomorrow, which product pairings should be pushed first?”

**What the analysis does**

- Performs a **basket analysis** by looking at products purchased together in the **same order**.
- Counts how many times each **product pair** co-occurs.
- Highlights the pairs that appear **most frequently**.

**Key Insight (from the sample data)**

- Two clear pairs emerge:
  - **Cappuccino + Bruschetta** – light snack + coffee.
  - **Gourmet Burger + Chocolate Brownie** – indulgent main + dessert.

**Decisions this enables**

- Create a **“Perfect Pairs” menu section** featuring these combinations.  
- Train staff to say:  
  - “Would you like to try our bruschetta pairing with that cappuccino?”  
  - “Our most popular follow-up to the Gourmet Burger is the chocolate brownie.”
- Run **bundle pricing** experiments and track uplift in **AOV**.

**KPIs to monitor**

- Attach rate for each **focus pair** (e.g., % of cappuccino orders that include bruschetta).  
- **Average order value** by outlet and time of day.  

---

### 3.4 Menu Profitability: Which items are our Stars – and which should we retire?

**File:** `Business concern 4.sql`  
**Business Question:**  
> “If items had to be cut or re-engineered tomorrow, where should the process start, and which dishes must be protected at all costs?”

**What the analysis does**

- Aggregates per product:
  - **Units sold**
  - **Total revenue**
  - **Total profit** (price − cost)
  - **Profit margin %**
- Classifies items into the classic **Profit–Popularity Matrix**:
  - **Stars** (high profit, high volume),
  - **Workhorses** (low profit, high volume),
  - **Puzzles** (high profit, low volume),
  - **Underperformers** (low profit, low volume).

**Key Insight (from the sample data)**

- **Stars** such as **Gourmet Burger** and **Big Breakfast** deliver both **strong margins and healthy volume**.
- **Apple Pie** appears as an **underperformer** – modest margin and very low volume, making it a candidate for re-engineering or removal.

**Decisions this enables**

- Give Stars **priority menu real estate** and train staff to recommend them.
- For Puzzles, run **A/B tests** on pricing, naming, or bundling to uncover barriers.
- **Retire or redesign** underperformers to free capacity for better sellers.

**KPIs to monitor**

- **Menu mix** (% of total revenue from Star items)  
- Contribution margin per product and category  
- Impact of price/portion changes on volume and profit  

---

### 3.5 Labour Cost Control: Where is time – and money – slipping away?

**File:** `Business concern 5.sql`  
**Business Question:**  
> “Is labour being overpaid because of late arrivals, early departures, or ‘creative’ time logging?”

**What the analysis does**

- Compares **scheduled shifts** to **actual check-in / check-out times**.
- Quantifies:
  - **Minutes late**,
  - **Minutes early leave**,
  - **Hours variance** per shift.
- Translates variance into a **wage impact** based on staff hourly rate.
- Flags each shift as:
  - `CHRONIC LATENESS`,
  - `EARLY DEPARTURE`,
  - `OVERTIME CONCERN`,
  - or `NORMAL`.

**Key Insight (from the sample data)**

- **Six staff members** repeatedly arrive **≥10 minutes late**, each instance costing an extra **$1.84–$1.88**.
- Kitchen shifts show the **largest positive variance**, indicating overtime and potential scheduling issues.
- While each event is small, the **annualised labour leakage is meaningful**.

**Decisions this enables**

- Introduce a **5-minute grace window** and a transparent tardiness policy.
- Implement or justify **digital time-tracking** with geofencing and variance alerts.
- Use variance data to **re-design rosters** aligned with actual demand.

**KPIs to monitor**

- Late-arrival and early-departure **incident rate**  
- Total **labour variance cost** by outlet and role  
- Overtime hours as a % of scheduled hours  

---

## 4. Data Model 

![Urban Eats ERD](https://github.com/racheltran184/SQL-Project-1/blob/main/Urban%20Eat%20Cafe%20ERD.png)
> **Figure 2.** Underlying ERD: a single schema powering all operational reporting and advanced analytics.

At a glance:

- **Orders, payments, reservations, staff shifts, and products** all live in **one consistent schema**.
- Two associative tables – `ORDER_ITEM` and `STAFF_SHIFT` – turn many customer and staffing questions into simple joins.
- Time stamps (`Order_Date`, `Reservation_Date`, `Shift_Date`, `Check_In_Time`, `Check_Out_Time`) allow **trend, peak-window, and variance analysis** without changing the structure.

This design ensures the numbers are **traceable and auditable**.

---

## 5. How to Use This Repository 

1. **Create the database** with the Part A script  
   `"Database.sql"`

2. **Run the relevant SQL file** from the `part-b/` folder when insight is needed:  

   - Revenue leakage → `Business concern 1.sql`  
   - Customer retention → `Business concern 2.sql`  
   - Cross-selling → `Business concern 3.sql`  
   - Menu profitability → `Business concern 4.sql`  
   - Labour cost control → `Business concern 5.sql`  

3. **Export the result to Excel/Power BI/Tableau** to create reports or dashboards for management meetings.

The same structure can be applied to real café data by keeping the schema and replacing the sample inserts with live transactions.

---

## 6. Future Opportunities

This foundation makes several next steps straightforward:

- **Predictive models** for churn and visit frequency based on the current segmentation logic.
- **Demand forecasting** per daypart/outlet, to sharpen staffing and inventory levels.
- **Loyalty programme integration**, using the same customer keys and spend metrics.
- Real-time **dashboards** for outlet managers (RevPASH, labour variance, Star mix).

---

## 7. Learning Outcomes

From a business perspective, this project demonstrates how to:

- Translate vague concerns (“We’re losing money somewhere…”) into **precise analytical questions**.
- Design a data model that **reflects real operations**, not just abstract tables.
- Use SQL to produce **management-ready insight**, directly connected to **actions and KPIs**.
- Support both **strategic decisions** (portfolio, pricing, loyalty) and **operational improvements** (rostering, attendance control).

---

