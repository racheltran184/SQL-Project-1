# Urban Eats Café Analytics

[![Case Study](https://img.shields.io/badge/Case_Study-Read_the_page-111111?style=for-the-badge)](https://racheltran184.github.io/SQL-Project-1/)

![MySQL 8](https://img.shields.io/badge/MySQL-8-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

**The labour leak is in the roster, not the clock.** Urban Eats runs three cafés in Sydney, Melbourne and Brisbane. I designed its database and wrote the SQL behind five board questions, then took each answer down to the clock hour, the ticket and the plate. The result is four moves, each with an owner and a test: fit evening rosters to demand, sell the drink with takeaway, protect large bookings and win the second visit inside two weeks.

> Urban Eats is a case company and its records are dummy data built for the assignment: 30 orders over 25 days, 15 bookings and two days of clocked shifts. Patterns are directional, dollar effects are arithmetic rather than forecasts, and every action comes with a trial and a stop rule so live data decides before money moves.

---

## Overview

| Item | Detail |
|---|---|
| **Client** | Urban Eats Café Chain (case company): Sydney CBD, South Melbourne and Brisbane City |
| **Data** | 30 orders, 59 order lines, 27 payments, 15 bookings and 45 clocked staff shifts, August–September 2024 |
| **Scope** | 25 customers, 31 menu items, 15 categories and 20 staff across 3 outlets |
| **Tools** | MySQL 8: an 11-table schema, constraints, CTEs and window functions; a Chen-notation ERD |
| **Project** | Individual project for a postgraduate data and visualisation unit; taken deeper for the case study |

### Headline numbers

| Figure | What it means |
|---:|---|
| **13%** | Share of paid staff hours that fall after 8 pm, when none of the 30 orders came in |
| **0.7%** | Paid hours above the roster across 45 shifts; every late start was made up |
| **67%** | Takeaway food orders that left without a drink (6 of 9) |
| **45%** | Booked seats in parties of five or more, every one a special occasion |
| **15 days** | Every repeat customer came back within 15 days (median 11) |

---

## How the business runs

![Urban Eats operational flowchart](Urban%20Eat%20Cafe%20Operational%20Flowchart.png)

Urban Eats works as a loop. Customers book, order and pay; a central database records every transaction, booking, shift and menu item; operations set rosters and the menu from that data; the kitchen and floor serve; and the experience turns into a repeat visit, a bigger ticket or a lost customer.

## Data model

![Urban Eats ERD](Urban%20Eat%20Cafe%20ERD.png)

- **11 tables in one schema:** orders, payments, bookings, customers, menu, categories, outlets, staff and shifts.
- **`ORDER_ITEM`** carries the price and cost of each line as sold; **`STAFF_SHIFT`** carries each clock-in and clock-out.
- **Constraints stop bad records at the door:** price ≥ cost, check-out after check-in, valid statuses, and a last visit no earlier than registration.

| Board question | Tables | Grain | The measure that decides |
|---|---|---|---|
| Failed bookings | `RESERVATION` `ORDERS` | Booking | Seats by party size; share of bookings with an outcome |
| Customers worth keeping | `CUSTOMER` `ORDERS` `RESERVATION` | Customer | Days from a first to a second order |
| Selling together | `ORDER_ITEM` `PRODUCT_CATEGORY` | Ticket | Food orders without a drink, by channel; pair lift |
| Dishes that earn | `ORDER_ITEM` `PRODUCT` | Plate | Contribution per plate against food cost |
| Labour leakage | `STAFF_SHIFT` `SHIFT` `STAFF` `ORDERS` | Clock hour | Paid staff hours against orders and bookings, hour by hour |

---

## Five checks before any number

| Check | What it found | How the analysis handles it |
|---|---|---|
| Tickets against their lines | 21 of 27 completed tickets differ from the sum of their lines: a $33.70 gross gap on $554.90 (6.1%) | Revenue from payments; product mix and margin from the lines |
| Line price and cost against the menu | 3 lines carry another item's price and cost: pastries and a dessert keyed to the wrong product | Each line re-pointed to the item whose price and cost it carries |
| Stored last-visit date | Older than the last order for 19 of 20 buyers; a 30-day rule on it would call 5 active customers lapsed | Recency computed from orders |
| Booking outcomes | 5 of 10 bookings past their time still read "Confirmed" | Outcomes reported only where one was recorded |
| Clock coverage | 9 of 20 rostered shifts have no clock records; every clocked shift falls on 17 or 18 September | Labour compared hour by hour on clocked days only |

*Query: `audit_ticket_lines`, `audit_line_prices`, `audit_last_visit`, `audit_bookings_open`, `audit_clock_coverage`*

---

## Six findings

Data window: orders from 25 August to 18 September 2024, bookings dated 15 to 26 September, clocked shifts on 17 and 18 September. Contribution is price minus cost on each order line, as sold. Each finding names the block in [`analysis.sql`](analysis.sql) that produces it.

### 1. Evenings are rostered past the last order
Paid staff hours stay flat from mid-afternoon to close while orders fade. From 8 pm, the outlets carry **13% of paid hours and none of the 30 orders**; the only booking from 8 pm is a table for two in Sydney. Brisbane's last order and booking came by 6 pm against a 10:30 pm finish; Melbourne's by 7:30 pm against 11 pm. An evening hour costs **$70–105 in wages** for a crew of three or four, so at the menu's 66% gross margin it needs $106–160 in sales, five to seven dine-in tickets, to pay for itself.

*Query: `labour_by_hour`, `last_demand_by_outlet`, `evening_crew_cost`*

### 2. Doubles cover the evening, and the overlap is paid twice
On 18 September, **all three managers and all three kitchen hands worked both shifts**: 16.3 to 16.4 hours on the clock. A server did the same on 17 and 18 September. In 7 of those 8 doubles the second clock-in came before the first clock-out, so **80 minutes were paid twice** in two days ($36.67). Attendance is not the leak: across 45 shifts, paid hours were **0.7% above the roster**, the six 10-minute late starts all still worked a full shift, and no one left early.

*Query: `double_shifts`, `clock_vs_roster`*

### 3. Takeaway leaves the drink behind
Only 2 of 11 dine-in and 1 of 6 delivery food orders had no drink. **At the takeaway counter, 6 of 9 food orders left without one.** Takeaway is already the smallest ticket ($14.88, against $23.22 for dine-in and $25.12 for delivery), and a drink adds $4.67 on average, $3.33 of it margin. The one repeated pairing, cappuccino with bruschetta, appears in just 2 orders (lift 6.8): a test, not yet a menu section.

*Query: `drink_attach`, `channel_mix`, `pair_lift`*

### 4. Mains earn the dollars, at the highest food cost
A main earns **$7.70 to $13.70 a plate**; a coffee or pastry about $3. Fish and Chips has the lowest margin on the menu (59.8%) and the highest contribution per plate: $13.70. Fish and Chips, the Gourmet Burger and the Big Breakfast run at **40% food cost**, the highest on the menu. A $1 rise adds $1 a plate and pays for itself unless sales fall by more than 6.8% to 8.1%.

*Query: `menu_cm`*

### 5. Big tables hold the seats, and outcomes go unrecorded
Four of 15 bookings are parties of five to eight, and they hold **25 of 56 booked seats (45%)**: a business lunch, a birthday, a corporate event and an anniversary. Of 10 bookings whose time has passed, **5 still read "Confirmed"**, so the show rate can't be measured. Of the 5 with an outcome, 3 were seated, 1 was a no-show and 1 was cancelled.

*Query: `bookings_by_party`, `booking_outcomes`, `audit_bookings_open`*

### 6. Repeat guests return within two weeks
Seven of 20 buyers ordered twice, and **every one came back within 15 days** of their first order; the median gap was 11 days. Of the 13 one-order customers, 2 have gone more than 15 days without a second order. Three more have a first order in progress, including the host of a seated corporate party of six, and 2 registered without buying.

*Query: `repeat_gap`, `customer_status`*

---

## The next 90 days

Each action names the trigger, the scope and a stop rule. Sizes come from the sample; dollar effects are arithmetic, not forecasts.

| # | Owner | Action | Why | Measure |
|---|---|---|---|---|
| 01 | Operations | Close two hours after the last booking slot for four weeks: Brisbane at 8 pm, Melbourne at 9:30 pm; Sydney keeps 10 pm. Reopen any hour that averages $106–160 in sales | Frees four evening hours a night: $280–420 in wages | Sales per labour hour after 7 pm |
| 02 | Operations | Managers work one shift; a senior barista leads the evening and a 4 pm-to-close kitchen shift replaces the double | All three managers and all three kitchen hands worked 16.3–16.4 hours on 18 Sep | Days over 12 hours on the clock (target: none) |
| 03 | Operations | The time clock refuses a second clock-in until the first shift is closed, and holds any day over 12 hours for approval | 80 minutes paid twice in two days ($36.67) | Overlapping minutes per week |
| 04 | Front of house | Prompt "add a coffee?" on every takeaway food order. Keep it if the takeaway drink rate rises 10 points in four weeks | 6 of 9 takeaway food orders had no drink; every 10 drinks added is $47 of sales and $33 of margin | Takeaway food orders with a drink (33% now) |
| 05 | Front of house | Take a card guarantee for parties of five or more, and offer a set menu with the booking | 4 of 15 bookings hold 45% of booked seats, all occasions | No-shows and late cancellations, parties of 5+ |
| 06 | Front of house | Mark every booking seated, no-show or cancelled before close; flag any left open the next morning | 5 of 10 past bookings still read "Confirmed" | Past bookings with an outcome (50% now) |
| 07 | Marketing | Ten days after a first order with no return, send an offer that expires on day 15 | All 7 repeat customers came back within 15 days (median 11) | First-time buyers back within 15 days |
| 08 | Marketing | Within a week of any party of five or more, offer the host catering and a set menu for the next event | All four large bookings are occasions; a corporate host who seated six has yet to complete a first order | Repeat bookings from event hosts |
| 09 | Head chef | Add $1 to Fish and Chips, the Gourmet Burger and the Big Breakfast at one outlet for four weeks; keep it where units fall less than the break-even | +7% to 9% contribution per plate; break-even volume loss 6.8–8.1% | Units and contribution per main against the other outlets |
| 10 | Finance & data | Add discount and fee fields to `ORDERS`; flag any ticket whose total isn't its lines plus fees minus discounts | 21 of 27 completed tickets differ from their lines | Tickets that reconcile (22% now) |
| 11 | Finance & data | Flag lines whose price or cost differs from the menu; add `Reservation_ID` to `ORDERS` so a seated booking links to its bill | 3 lines keyed to the wrong product; seated bookings can't be valued | Lines off the menu price; bookings with a ticket |
| 12 | Finance & data | Replace the stored `Last_Visit_Date` with a view over orders and bookings, refreshed nightly | Stale for 19 of 20 buyers | Customers flagged lapsed who ordered in the last 30 days (target: none) |

---

## Strategy for the next year

| Track | Now (Quarter 1) | Next (Quarters 2–3) | Later (Quarter 4) |
|---|---|---|---|
| **Fit labour to demand**<br>Operations, outlet managers | Close two hours after the last booking slot, with a reopen rule; managers on one shift | Weekly rosters drawn from orders and bookings by clock hour | Covers per daypart forecast from a year of POS data |
| **Grow the ticket**<br>Front of house, head chef | Takeaway drink prompt, plus the $1 test on three mains | Takeaway main-and-drink combos priced from contribution, not cost-plus | A quarterly menu review on contribution per plate and food cost |
| **Keep the guest**<br>Marketing, outlet managers | A day-10 second-visit offer, timed to the 11-day habit | Set menus and catering for parties of five or more | Rewards timed to each guest's own return rhythm |
| **Trust the numbers**<br>Finance, BI | Nightly ticket reconciliation; every booking closed out by close | Price and cost flags on every line; a booking link on every ticket | One scorecard: sales per labour hour, drink rate, show rate and return rate |

**Leading measures, checked weekly:** sales per labour hour after 7 pm, by outlet · takeaway food orders with a drink (33% now) · past bookings with an outcome (50% now) · tickets that reconcile to their lines (22% now).

**Outcome measures, checked monthly:** wages as a share of sales, by outlet · average takeaway ticket ($14.88 now) · show rate for parties of five or more · first-time buyers back within 15 days.

---

## Repository

| File | What it is |
|---|---|
| `index.html` | The case study page, served at [racheltran184.github.io/SQL-Project-1](https://racheltran184.github.io/SQL-Project-1/) |
| `Database` | MySQL script: creates `urban_eats`, its 11 tables and constraints, and loads the sample records |
| `analysis.sql` | The queries behind the case study, one block per check or finding, each headed `-- @name` |
| `Business Concerns/` | First-pass queries for the five business concerns, with saved outputs |
| `Urban Eat Cafe ERD.png` | Entity-relationship diagram |
| `Urban Eat Cafe Operational Flowchart.png` | How the business runs |
| `Urban Eat Cafe REPORT.pdf` | Original assignment report |

## How to run it

1. In MySQL 8, run `Database` to create and load the `urban_eats` database.
2. Run `analysis.sql`. Each block answers one check or finding; the analysis date is 18 September 2024 for orders and 21 September 2024 for bookings.
3. The same queries run on live data if the schema is kept and the sample inserts are replaced with real transactions.

---

## What I'd add next

- **Hourly POS history for 8–12 weeks**, to set closing times on full demand rather than a sample.
- **Covers per ticket**, to price a no-show per seat instead of per table.
- **Delivery platform fees**, to compare channels on margin, not ticket size.
- **Waste and prep logs**, to weigh an earlier close against food thrown out.

## How I'd run the next analysis

- **Reconcile before you report:** a ticket that doesn't match its lines can't price a menu or a no-show.
- **Go to the grain:** paid minutes per clock hour showed what a daily wage total hides.
- **Count dollars, not percentages:** the lowest-margin dish earned the most per plate.
- **Time the trigger to the habit:** use the observed gap to a second visit, not a round 30 days.

---

**Rachel Tran** · [Portfolio](https://racheltran.vercel.app) · [LinkedIn](https://www.linkedin.com/in/racheltran184/) · [GitHub](https://github.com/racheltran184)
