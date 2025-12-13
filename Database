CREATE DATABASE urban_eats;
USE urban_eats;
-- 1. PRODUCT_CATEGORY Table
CREATE TABLE PRODUCT_CATEGORY (
    Category_ID INT PRIMARY KEY AUTO_INCREMENT,
    Category_Name VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT
);
-- 1. PRODUCT_CATEGORY Table (15 rows)
INSERT INTO PRODUCT_CATEGORY (Category_Name, Description) VALUES
('Hot Beverages', 'Coffee, tea, hot chocolate and other warm drinks'),
('Cold Beverages', 'Iced drinks, smoothies, juices and cold refreshments'),
('Breakfast Items', 'Morning meals including eggs, toast, pastries and cereals'),
('Lunch Mains', 'Hearty lunch dishes including burgers, salads, and sandwiches'),
('Light Meals', 'Smaller portions and snacks for quick dining'),
('Desserts', 'Sweet treats including cakes, cookies, and ice cream'),
('Pastries', 'Fresh baked goods including croissants, muffins, and danishes'),
('Soups', 'Hot and cold soup varieties'),
('Salads', 'Fresh garden salads and healthy options'),
('Sides', 'Complementary items like fries, bread, and appetizers'),
('Healthy Options', 'Low-calorie and nutritious menu items'),
('Kids Menu', 'Child-friendly meals and portions'),
('Seasonal Specials', 'Limited-time seasonal menu items'),
('Vegan Options', 'Plant-based menu items'),
('Gluten-Free', 'Items suitable for gluten-free diets');

-- 2. PRODUCT Table
CREATE TABLE PRODUCT (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Category_ID INT NOT NULL,
    Product_Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(8 , 2 ) NOT NULL CHECK (Price >= 0),
    Cost DECIMAL(8 , 2 ) NOT NULL CHECK (Cost >= 0),
    Is_Available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (Category_ID)
        REFERENCES PRODUCT_CATEGORY (Category_ID),
    CONSTRAINT chk_profit CHECK (Price >= Cost)
);

-- 2. PRODUCT Table ( key entity)
INSERT INTO PRODUCT (Category_ID, Product_Name, Description, Price, Cost, Is_Available) VALUES
-- Hot Beverages
(1, 'Cappuccino', 'Rich espresso with steamed milk foam', 4.50, 1.20, TRUE),
(1, 'Latte', 'Smooth espresso with steamed milk', 4.80, 1.30, TRUE),
(1, 'Flat White', 'Double shot espresso with microfoam milk', 4.20, 1.15, TRUE),
(1, 'Hot Chocolate', 'Premium chocolate with whipped cream', 5.20, 1.80, TRUE),
(1, 'Earl Grey Tea', 'Traditional bergamot-infused black tea', 3.80, 0.90, TRUE),
-- Cold Beverages
(2, 'Iced Coffee', 'Cold brew coffee served over ice', 4.20, 1.25, TRUE),
(2, 'Green Smoothie', 'Spinach, apple, banana and honey blend', 6.50, 2.10, TRUE),
(2, 'Fresh Orange Juice', 'Freshly squeezed orange juice', 4.80, 1.60, TRUE),
(2, 'Iced Tea', 'Refreshing iced tea with lemon', 3.50, 0.95, TRUE),
-- Breakfast Items
(3, 'Big Breakfast', 'Eggs, bacon, sausage, beans, toast, hashbrown', 18.90, 7.50, TRUE),
(3, 'Avocado Toast', 'Smashed avocado on sourdough with feta', 12.50, 4.20, TRUE),
(3, 'Pancakes Stack', 'Three fluffy pancakes with maple syrup', 14.20, 4.80, TRUE),
(3, 'Breakfast Burrito', 'Scrambled eggs, cheese, bacon in tortilla', 11.80, 4.10, TRUE),
-- Lunch Mains
(4, 'Gourmet Burger', 'Beef patty with premium toppings and fries', 19.50, 7.80, TRUE),
(4, 'Caesar Salad', 'Cos lettuce, parmesan, croutons, caesar dressing', 15.90, 5.30, TRUE),
(4, 'Fish and Chips', 'Beer battered fish with chunky chips', 22.90, 9.20, TRUE),
(4, 'Chicken Wrap', 'Grilled chicken with salad in tortilla wrap', 13.80, 4.90, TRUE),
-- Light Meals
(5, 'Soup of the Day', 'Daily rotating soup with bread roll', 8.90, 2.80, TRUE),
(5, 'Bruschetta', 'Toasted bread with tomato, basil, balsamic', 9.50, 2.90, TRUE),
(5, 'Cheese Toastie', 'Grilled cheese sandwich with tomato', 7.80, 2.20, TRUE),
-- Desserts
(6, 'Chocolate Brownie', 'Rich chocolate brownie with vanilla ice cream', 8.90, 2.60, TRUE),
(6, 'Cheesecake Slice', 'New York style cheesecake with berry coulis', 9.50, 3.10, TRUE),
(6, 'Apple Pie', 'Traditional apple pie with custard', 8.20, 2.40, TRUE),
-- Pastries
(7, 'Croissant', 'Buttery French croissant', 4.20, 1.30, TRUE),
(7, 'Blueberry Muffin', 'Fresh blueberry muffin', 4.80, 1.50, TRUE),
(7, 'Danish Pastry', 'Flaky pastry with fruit filling', 5.20, 1.70, TRUE),
-- Healthy Options
(11, 'Acai Bowl', 'Acai berries with granola and fresh fruit', 12.90, 4.50, TRUE),
(11, 'Quinoa Salad', 'Quinoa with roasted vegetables and dressing', 14.50, 5.20, TRUE),
-- Vegan Options
(14, 'Vegan Burger', 'Plant-based patty with vegan cheese and fries', 17.90, 6.80, TRUE),
(14, 'Coconut Curry', 'Vegetables in coconut curry sauce with rice', 16.50, 5.90, TRUE),
-- Seasonal (currently unavailable)
(13, 'Pumpkin Spice Latte', 'Autumn spiced latte with pumpkin flavor', 5.50, 1.90, FALSE);

-- 3. CUSTOMER Table
CREATE TABLE CUSTOMER (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address TEXT,
    Registration_Date DATE NOT NULL DEFAULT (CURRENT_DATE),
    Last_Visit_Date DATE,
    CONSTRAINT chk_visit_after_reg 
    CHECK (Last_Visit_Date >= Registration_Date OR Last_Visit_Date IS NULL)
);
-- 3. CUSTOMER Table (25 rows)
INSERT INTO CUSTOMER (First_Name, Last_Name, Phone, Email, Address, Registration_Date, Last_Visit_Date) VALUES
('Sarah', 'Johnson', '0412345678', 'sarah.johnson@email.com', '123 Main St, Sydney NSW 2000', '2024-01-15', '2024-09-15'),
('Michael', 'Chen', '0423456789', 'michael.chen@email.com', '456 George St, Sydney NSW 2000', '2024-02-20', '2024-09-10'),
('Emma', 'Williams', '0434567890', 'emma.williams@email.com', '789 Pitt St, Sydney NSW 2000', '2024-01-10', '2024-09-12'),
('James', 'Brown', '0445678901', 'james.brown@email.com', '321 Collins St, Melbourne VIC 3000', '2024-03-05', '2024-09-08'),
('Lisa', 'Davis', '0456789012', 'lisa.davis@email.com', '654 Flinders St, Melbourne VIC 3000', '2024-02-28', '2024-09-14'),
('David', 'Wilson', '0467890123', 'david.wilson@email.com', '987 Queen St, Brisbane QLD 4000', '2024-01-25', '2024-09-11'),
('Sophie', 'Taylor', '0478901234', 'sophie.taylor@email.com', '147 King St, Sydney NSW 2000', '2024-04-12', '2024-09-13'),
('Ryan', 'Anderson', '0489012345', 'ryan.anderson@email.com', '258 Bourke St, Melbourne VIC 3000', '2024-03-18', '2024-08-20'),
('Jessica', 'Thomas', '0490123456', 'jessica.thomas@email.com', '369 Ann St, Brisbane QLD 4000', '2024-02-14', '2024-09-09'),
('Matthew', 'Jackson', '0401234567', 'matthew.jackson@email.com', '741 Elizabeth St, Sydney NSW 2000', '2024-05-03', '2024-09-16'),
('Amy', 'White', '0412345679', 'amy.white@email.com', '852 Little Collins St, Melbourne VIC 3000', '2024-01-30', '2024-07-15'),
('Daniel', 'Harris', '0423456780', 'daniel.harris@email.com', '963 Edward St, Brisbane QLD 4000', '2024-04-08', '2024-09-07'),
('Rachel', 'Martin', '0434567891', 'rachel.martin@email.com', '159 York St, Sydney NSW 2000', '2024-03-22', '2024-09-05'),
('Andrew', 'Thompson', '0445678902', 'andrew.thompson@email.com', '357 Swanston St, Melbourne VIC 3000', '2024-02-10', '2024-06-30'),
('Chloe', 'Garcia', '0456789013', 'chloe.garcia@email.com', '468 Adelaide St, Brisbane QLD 4000', '2024-05-15', '2024-09-03'),
('Benjamin', 'Martinez', '0467890124', 'ben.martinez@email.com', '579 Kent St, Sydney NSW 2000', '2024-01-08', '2024-09-01'),
('Olivia', 'Robinson', '0478901235', 'olivia.robinson@email.com', '680 La Trobe St, Melbourne VIC 3000', '2024-04-25', '2024-08-28'),
('Nathan', 'Clark', '0489012346', 'nathan.clark@email.com', '791 Queen St, Brisbane QLD 4000', '2024-03-12', '2024-08-15'),
('Isabella', 'Rodriguez', '0490123457', 'isabella.rodriguez@email.com', '802 Castlereagh St, Sydney NSW 2000', '2024-05-20', '2024-08-10'),
('Joshua', 'Lewis', '0401234568', 'joshua.lewis@email.com', '913 Russell St, Melbourne VIC 3000', '2024-02-05', '2024-07-25'),
('Grace', 'Lee', '0412345680', 'grace.lee@email.com', '124 Creek St, Brisbane QLD 4000', '2024-06-01', '2024-09-17'),
('Ethan', 'Walker', '0423456781', 'ethan.walker@email.com', '235 Park St, Sydney NSW 2000', '2024-04-30', '2024-09-18'),
('Mia', 'Hall', '0434567892', 'mia.hall@email.com', '346 Spencer St, Melbourne VIC 3000', '2024-05-10', '2024-09-16'),
('Lucas', 'Allen', '0445678903', 'lucas.allen@email.com', '457 Charlotte St, Brisbane QLD 4000', '2024-03-28', '2024-08-05'),
('Zoe', 'Young', '0456789014', 'zoe.young@email.com', '568 Macquarie St, Sydney NSW 2000', '2024-06-15', '2024-09-14');

-- 4. OUTLET Table (Created before STAFF to handle circular reference)
CREATE TABLE OUTLET (
    Outlet_ID INT PRIMARY KEY AUTO_INCREMENT,
    Outlet_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Address TEXT NOT NULL,
    State VARCHAR(50) NOT NULL,
    Suburb VARCHAR(50) NOT NULL,
    Opening_Date DATE NOT NULL,
    Manager_ID INT NULL
);

-- 4. OUTLET Table (3 outlets as per business requirement)
INSERT INTO OUTLET (Outlet_Name, Phone, Address, State, Suburb, Opening_Date, Manager_ID) VALUES
('Urban Eats CBD Sydney', '0287654321', '100 George Street, Sydney NSW 2000', 'NSW', 'Sydney CBD', '2023-03-15', NULL),
('Urban Eats South Melbourne', '0398765432', '200 Collins Street, Melbourne VIC 3000', 'VIC', 'South Melbourne', '2023-06-10', NULL),
('Urban Eats Brisbane City', '0732109876', '300 Queen Street, Brisbane QLD 4000', 'QLD', 'Brisbane City', '2023-09-20', NULL);

-- 5. STAFF Table
CREATE TABLE STAFF (
    Staff_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Role ENUM('Manager', 'Chef', 'Barista', 'Server', 'Kitchen Staff') 
    NOT NULL,
    Hire_Date DATE NOT NULL DEFAULT (CURRENT_DATE),
    Hourly_Rate DECIMAL(5,2) NOT NULL CHECK (Hourly_Rate >= 0),
    Home_Outlet_ID INT NOT NULL,
    FOREIGN KEY (Home_Outlet_ID) REFERENCES OUTLET(Outlet_ID)
);

-- Add Manager_ID foreign key to OUTLET after STAFF creation
ALTER TABLE OUTLET
ADD CONSTRAINT fk_outlet_manager
FOREIGN KEY (Manager_ID) REFERENCES STAFF(Staff_ID);

-- 5. STAFF Table 
INSERT INTO STAFF (First_Name, Last_Name, Role, Hire_Date, Hourly_Rate, Home_Outlet_ID) VALUES
-- Sydney Staff
('Tom', 'Mitchell', 'Manager', '2023-03-10', 35.00, 1),
('Maria', 'Santos', 'Chef', '2023-03-20', 28.50, 1),
('Jake', 'Thompson', 'Barista', '2023-04-01', 24.00, 1),
('Emma', 'Kelly', 'Server', '2023-04-15', 22.50, 1),
('Alex', 'Nguyen', 'Kitchen Staff', '2023-05-01', 23.00, 1),
('Sophie', 'Green', 'Barista', '2023-05-15', 24.00, 1),
('Ryan', 'O\'Connor', 'Server', '2023-06-01', 22.50, 1),
-- Melbourne Staff
('Lisa', 'Parker', 'Manager', '2023-06-05', 35.00, 2),
('Marco', 'Rossi', 'Chef', '2023-06-15', 29.00, 2),
('Chloe', 'Wong', 'Barista', '2023-07-01', 24.50, 2),
('James', 'Stewart', 'Server', '2023-07-15', 22.50, 2),
('Priya', 'Patel', 'Kitchen Staff', '2023-08-01', 23.50, 2),
('Daniel', 'Kim', 'Barista', '2023-08-15', 24.50, 2),
-- Brisbane Staff
('Sarah', 'Clarke', 'Manager', '2023-09-15', 34.50, 3),
('Tony', 'Moretti', 'Chef', '2023-09-25', 28.00, 3),
('Jessica', 'Liu', 'Barista', '2023-10-01', 24.00, 3),
('Michael', 'Fraser', 'Server', '2023-10-15', 22.50, 3),
('Amy', 'Davis', 'Kitchen Staff', '2023-11-01', 23.00, 3),
('Chris', 'Taylor', 'Server', '2023-11-15', 22.50, 3),
('Zoe', 'Campbell', 'Barista', '2024-01-10', 24.00, 3);
-- Update Manager_ID in OUTLET table
UPDATE OUTLET SET Manager_ID = 1 WHERE Outlet_ID = 1;
UPDATE OUTLET SET Manager_ID = 8 WHERE Outlet_ID = 2;
UPDATE OUTLET SET Manager_ID = 14 WHERE Outlet_ID = 3;

-- 6. ORDERS Table
CREATE TABLE ORDERS (
    Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Outlet_ID INT NOT NULL,
    Order_Date DATE NOT NULL DEFAULT (CURRENT_DATE),
    Order_Time TIME NOT NULL DEFAULT (CURRENT_TIME),
    Order_Type ENUM('Dine-in', 'Takeaway', 'Delivery') NOT NULL,
    Status ENUM('Pending', 'Preparing', 'Ready', 'Completed', 'Cancelled') 
    DEFAULT 'Pending',
    Total_Amount DECIMAL(10,2) NOT NULL CHECK (Total_Amount >= 0),
    FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
    FOREIGN KEY (Outlet_ID) REFERENCES OUTLET(Outlet_ID)
);

-- 6. ORDERS Table (key entity)
INSERT INTO ORDERS (Customer_ID, Outlet_ID, Order_Date, Order_Time, Order_Type, Status, Total_Amount) VALUES
-- Recent orders (varied times and types)
(1, 1, '2024-09-18', '08:30:00', 'Dine-in', 'Completed', 23.40),
(2, 1, '2024-09-18', '09:15:00', 'Takeaway', 'Completed', 9.30),
(3, 1, '2024-09-18', '12:45:00', 'Delivery', 'Completed', 31.80),
(4, 2, '2024-09-18', '07:45:00', 'Dine-in', 'Completed', 18.90),
(5, 2, '2024-09-18', '13:20:00', 'Takeaway', 'Completed', 15.60),
(6, 3, '2024-09-17', '08:15:00', 'Dine-in', 'Completed', 26.70),
(7, 1, '2024-09-17', '14:30:00', 'Delivery', 'Completed', 19.50),
(8, 2, '2024-09-17', '11:00:00', 'Takeaway', 'Completed', 12.80),
(9, 3, '2024-09-16', '16:45:00', 'Dine-in', 'Completed', 17.40),
(10, 1, '2024-09-16', '10:30:00', 'Takeaway', 'Completed', 14.20),
(11, 2, '2024-09-15', '09:00:00', 'Dine-in', 'Completed', 22.90),
(12, 3, '2024-09-15', '13:15:00', 'Delivery', 'Completed', 28.40),
(13, 1, '2024-09-14', '15:30:00', 'Takeaway', 'Completed', 8.90),
(14, 2, '2024-09-14', '12:00:00', 'Dine-in', 'Completed', 33.50),
(15, 3, '2024-09-13', '08:45:00', 'Takeaway', 'Completed', 16.70),
-- Older orders for analytics
(16, 1, '2024-09-10', '11:30:00', 'Dine-in', 'Completed', 25.30),
(17, 2, '2024-09-08', '14:15:00', 'Delivery', 'Completed', 21.60),
(18, 3, '2024-09-05', '09:30:00', 'Takeaway', 'Completed', 13.40),
(19, 1, '2024-08-28', '16:00:00', 'Dine-in', 'Completed', 29.80),
(20, 2, '2024-08-25', '10:45:00', 'Takeaway', 'Completed', 18.20),
-- Some recent orders in different statuses
(21, 1, '2024-09-18', '18:30:00', 'Dine-in', 'Preparing', 24.70),
(22, 2, '2024-09-18', '19:00:00', 'Delivery', 'Ready', 32.40),
(23, 3, '2024-09-18', '17:45:00', 'Takeaway', 'Pending', 11.80),
(1, 2, '2024-09-12', '08:00:00', 'Dine-in', 'Completed', 21.40),
(3, 3, '2024-09-10', '12:30:00', 'Takeaway', 'Completed', 15.90),
(5, 1, '2024-09-08', '14:45:00', 'Delivery', 'Completed', 27.30),
(7, 2, '2024-09-06', '11:15:00', 'Dine-in', 'Completed', 19.60),
(9, 3, '2024-09-04', '15:00:00', 'Takeaway', 'Completed', 23.80),
(11, 1, '2024-09-02', '09:45:00', 'Dine-in', 'Completed', 16.50),
(13, 2, '2024-08-30', '13:30:00', 'Delivery', 'Completed', 22.10);


-- 7. ORDER_ITEM Table (Associative Entity)
CREATE TABLE ORDER_ITEM (
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Unit_Price DECIMAL(8 , 2 ) NOT NULL CHECK (Unit_Price >= 0),
    Item_Cost DECIMAL(8 , 2 ) NOT NULL CHECK (Item_Cost >= 0),
    PRIMARY KEY (Order_ID , Product_ID),
    FOREIGN KEY (Order_ID)
        REFERENCES ORDERS (Order_ID),
    FOREIGN KEY (Product_ID)
        REFERENCES PRODUCT (Product_ID)
);

-- 7. ORDER_ITEM Table ( associative entity with multiple items per order)
INSERT INTO ORDER_ITEM (Order_ID, Product_ID, Quantity, Unit_Price, Item_Cost) VALUES
-- Order 1 items (Customer 1, Total: 23.40)
(1, 2, 1, 4.80, 1.30),  -- Latte
(1, 10, 1, 18.90, 7.50), -- Big Breakfast
-- Order 2 items (Customer 2, Total: 9.30)
(2, 1, 2, 4.50, 1.20),   -- 2 Cappuccinos
-- Order 3 items (Customer 3, Total: 31.80)
(3, 14, 1, 19.50, 7.80), -- Gourmet Burger
(3, 21, 1, 8.90, 2.60),  -- Chocolate Brownie
(3, 6, 1, 4.20, 1.25),   -- Iced Coffee
-- Order 4 items (Customer 4, Total: 18.90)
(4, 10, 1, 18.90, 7.50), -- Big Breakfast
-- Order 5 items (Customer 5, Total: 15.60)
(5, 15, 1, 15.90, 5.30), -- Caesar Salad
-- Order 6 items (Customer 6, Total: 26.70)
(6, 12, 1, 14.20, 4.80), -- Pancakes
(6, 1, 1, 4.50, 1.20),   -- Cappuccino
(6, 7, 1, 6.50, 2.10),   -- Green Smoothie
(6, 23, 1, 4.20, 1.30),  -- Croissant
-- Order 7 items (Customer 7, Total: 19.50)
(7, 14, 1, 19.50, 7.80), -- Gourmet Burger
-- Order 8 items (Customer 8, Total: 12.80)
(8, 11, 1, 12.50, 4.20), -- Avocado Toast
-- Order 9 items (Customer 9, Total: 17.40)
(9, 17, 1, 13.80, 4.90), -- Chicken Wrap
(9, 9, 1, 3.50, 0.95),   -- Iced Tea
-- Order 10 items (Customer 10, Total: 14.20)
(10, 12, 1, 14.20, 4.80), -- Pancakes
-- Continue with more order items...
(11, 16, 1, 22.90, 9.20), -- Fish and Chips
(12, 27, 1, 12.90, 4.50), -- Acai Bowl
(12, 2, 1, 4.80, 1.30),   -- Latte
(12, 24, 1, 4.80, 1.50),  -- Blueberry Muffin
(13, 18, 1, 8.90, 2.80),  -- Soup of the Day
(14, 28, 1, 14.50, 5.20), -- Quinoa Salad
(14, 29, 1, 17.90, 6.80), -- Vegan Burger
(14, 6, 1, 4.20, 1.25),   -- Iced Coffee
(15, 13, 1, 11.80, 4.10), -- Breakfast Burrito
(15, 3, 1, 4.20, 1.15),   -- Flat White
(16, 30, 1, 16.50, 5.90), -- Coconut Curry
(16, 8, 1, 4.80, 1.60),   -- Orange Juice
(17, 19, 1, 9.50, 2.90),  -- Bruschetta
(17, 22, 1, 9.50, 3.10),  -- Cheesecake
(17, 1, 1, 4.50, 1.20),   -- Cappuccino
(18, 20, 1, 7.80, 2.20),  -- Cheese Toastie
(18, 4, 1, 5.20, 1.80),   -- Hot Chocolate
(19, 21, 2, 8.90, 2.60),  -- 2 Chocolate Brownies
(19, 26, 1, 5.20, 1.70),  -- Danish Pastry
(19, 2, 1, 4.80, 1.30),   -- Latte
(20, 11, 1, 12.50, 4.20), -- Avocado Toast
(20, 5, 1, 3.80, 0.90),   -- Earl Grey Tea
-- Current orders (non-completed)
(21, 15, 1, 15.90, 5.30), -- Caesar Salad
(21, 1, 2, 4.50, 1.20),   -- 2 Cappuccinos
(22, 14, 1, 19.50, 7.80), -- Gourmet Burger
(22, 21, 1, 8.90, 2.60),  -- Chocolate Brownie
(22, 6, 1, 4.20, 1.25),   -- Iced Coffee
(23, 13, 1, 11.80, 4.10), -- Breakfast Burrito
-- Additional completed orders
(24, 17, 1, 13.80, 4.90), -- Chicken Wrap
(24, 2, 1, 4.80, 1.30),   -- Latte
(24, 25, 1, 4.20, 1.30),  -- Apple Pie (price adjusted)
(25, 15, 1, 15.90, 5.30), -- Caesar Salad
(26, 10, 1, 18.90, 7.50), -- Big Breakfast
(26, 7, 1, 6.50, 2.10),   -- Green Smoothie
(27, 19, 1, 9.50, 2.90),  -- Bruschetta
(27, 1, 2, 4.50, 1.20),   -- 2 Cappuccinos
(28, 16, 1, 22.90, 9.20), -- Fish and Chips
(29, 12, 1, 14.20, 4.80), -- Pancakes
(29, 8, 1, 4.80, 1.60),   -- Orange Juice
(30, 18, 1, 8.90, 2.80),  -- Soup
(30, 20, 1, 7.80, 2.20),  -- Cheese Toastie
(30, 3, 1, 4.20, 1.15);   -- Flat White

-- 8. PAYMENT Table
CREATE TABLE PAYMENT (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Amount DECIMAL(10,2) NOT NULL CHECK (Payment_Amount >= 0),
    Payment_Method ENUM('Cash', 'Credit Card', 'Debit Card', 'Digital Wallet', 'EFTPOS') 
    NOT NULL,
    Payment_Date DATE NOT NULL DEFAULT (CURRENT_DATE),
    Payment_Status ENUM('Pending', 'Completed', 'Failed', 'Refunded') 
    NOT NULL DEFAULT 'Pending',
    Is_Refund BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (Order_ID) REFERENCES ORDERS (Order_ID)
);

-- 8. PAYMENT Table 
INSERT INTO PAYMENT (Order_ID, Payment_Amount, Payment_Method, Payment_Date, Payment_Status, Is_Refund) VALUES
(1, 23.40, 'Credit Card', '2024-09-18', 'Completed', FALSE),
(2, 9.30, 'Cash', '2024-09-18', 'Completed', FALSE),
(3, 31.80, 'Digital Wallet', '2024-09-18', 'Completed', FALSE),
(4, 18.90, 'EFTPOS', '2024-09-18', 'Completed', FALSE),
(5, 15.60, 'Credit Card', '2024-09-18', 'Completed', FALSE),
(6, 26.70, 'Cash', '2024-09-17', 'Completed', FALSE),
(7, 19.50, 'Digital Wallet', '2024-09-17', 'Completed', FALSE),
(8, 12.80, 'Debit Card', '2024-09-17', 'Completed', FALSE),
(9, 17.40, 'Credit Card', '2024-09-16', 'Completed', FALSE),
(10, 14.20, 'Cash', '2024-09-16', 'Completed', FALSE),
(11, 22.90, 'EFTPOS', '2024-09-15', 'Completed', FALSE),
(12, 28.40, 'Digital Wallet', '2024-09-15', 'Completed', FALSE),
(13, 8.90, 'Cash', '2024-09-14', 'Completed', FALSE),
(14, 33.50, 'Credit Card', '2024-09-14', 'Completed', FALSE),
(15, 16.70, 'Debit Card', '2024-09-13', 'Completed', FALSE),
(16, 25.30, 'Digital Wallet', '2024-09-10', 'Completed', FALSE),
(17, 21.60, 'Credit Card', '2024-09-08', 'Completed', FALSE),
(18, 13.40, 'Cash', '2024-09-05', 'Completed', FALSE),
(19, 29.80, 'EFTPOS', '2024-08-28', 'Completed', FALSE),
(20, 18.20, 'Debit Card', '2024-08-25', 'Completed', FALSE),
(24, 21.40, 'Credit Card', '2024-09-12', 'Completed', FALSE),
(25, 15.90, 'Cash', '2024-09-10', 'Completed', FALSE),
(26, 27.30, 'Digital Wallet', '2024-09-08', 'Completed', FALSE),
(27, 19.60, 'EFTPOS', '2024-09-06', 'Completed', FALSE),
(28, 23.80, 'Credit Card', '2024-09-04', 'Completed', FALSE),
(29, 16.50, 'Cash', '2024-09-02', 'Completed', FALSE),
(30, 22.10, 'Digital Wallet', '2024-08-30', 'Completed', FALSE);

-- 9. RESERVATION Table
CREATE TABLE RESERVATION (
    Reservation_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Outlet_ID INT NOT NULL,
    Reservation_Date DATE NOT NULL,
    Reservation_Time TIME NOT NULL,
    Booked_Datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Party_Size INT NOT NULL CHECK (Party_Size > 0),
    Status ENUM('Confirmed', 'Cancelled', 'Completed', 'No-show') 
    DEFAULT 'Confirmed',
    Special_Requests TEXT,
    FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
    FOREIGN KEY (Outlet_ID) REFERENCES OUTLET(Outlet_ID)
);
-- 9. RESERVATION Table 
INSERT INTO RESERVATION (Customer_ID, Outlet_ID, Reservation_Date, Reservation_Time, Booked_Datetime, Party_Size, Status, Special_Requests) VALUES
(1, 1, '2024-09-20', '19:00:00', '2024-09-18 10:30:00', 2, 'Confirmed', 'Window table preferred'),
(3, 1, '2024-09-21', '12:30:00', '2024-09-18 14:15:00', 4, 'Confirmed', 'High chair needed'),
(5, 2, '2024-09-19', '18:30:00', '2024-09-17 16:45:00', 6, 'Confirmed', 'Birthday celebration'),
(7, 2, '2024-09-22', '11:00:00', '2024-09-18 09:20:00', 3, 'Confirmed', NULL),
(9, 3, '2024-09-20', '13:00:00', '2024-09-18 11:45:00', 2, 'Confirmed', 'Gluten-free options needed'),
(11, 1, '2024-09-23', '18:00:00', '2024-09-19 15:30:00', 5, 'Confirmed', 'Anniversary dinner'),
(13, 2, '2024-09-21', '14:30:00', '2024-09-18 13:20:00', 3, 'Confirmed', NULL),
(15, 3, '2024-09-24', '12:00:00', '2024-09-20 10:15:00', 8, 'Confirmed', 'Business lunch meeting'),
(17, 1, '2024-09-19', '20:00:00', '2024-09-17 14:30:00', 2, 'Completed', NULL),
(19, 2, '2024-09-18', '19:30:00', '2024-09-16 16:45:00', 4, 'Completed', 'Vegetarian preferences'),
(21, 3, '2024-09-17', '18:00:00', '2024-09-15 12:20:00', 6, 'Completed', 'Corporate event'),
(2, 1, '2024-09-16', '12:30:00', '2024-09-14 09:30:00', 2, 'No-show', NULL),
(4, 2, '2024-09-15', '19:00:00', '2024-09-13 17:45:00', 3, 'Cancelled', 'Family emergency'),
(6, 3, '2024-09-25', '17:30:00', '2024-09-20 14:15:00', 4, 'Confirmed', 'Outdoor seating preferred'),
(8, 1, '2024-09-26', '11:30:00', '2024-09-21 16:20:00', 2, 'Confirmed', 'Quiet table for proposal');

-- 10. SHIFT Table
CREATE TABLE SHIFT (
    Shift_ID INT PRIMARY KEY AUTO_INCREMENT,
    Outlet_ID INT NOT NULL,
    Shift_Date DATE NOT NULL,
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,
    Shift_Type ENUM('Morning', 'Afternoon', 'Evening', 'Night') NOT NULL,
    FOREIGN KEY (Outlet_ID)
        REFERENCES OUTLET (Outlet_ID),
    CONSTRAINT chk_shift_times CHECK (End_Time > Start_Time)
);

-- 10. SHIFT Table 
INSERT INTO SHIFT (Outlet_ID, Shift_Date, Start_Time, End_Time, Shift_Type) VALUES
-- Sydney shifts
(1, '2024-09-18', '06:00:00', '14:00:00', 'Morning'),
(1, '2024-09-18', '14:00:00', '22:00:00', 'Evening'),
(1, '2024-09-17', '06:00:00', '14:00:00', 'Morning'),
(1, '2024-09-17', '14:00:00', '22:00:00', 'Evening'),
(1, '2024-09-16', '06:00:00', '14:00:00', 'Morning'),
(1, '2024-09-16', '14:00:00', '22:00:00', 'Evening'),
(1, '2024-09-15', '06:00:00', '14:00:00', 'Morning'),
-- Melbourne shifts
(2, '2024-09-18', '07:00:00', '15:00:00', 'Morning'),
(2, '2024-09-18', '15:00:00', '23:00:00', 'Evening'),
(2, '2024-09-17', '07:00:00', '15:00:00', 'Morning'),
(2, '2024-09-17', '15:00:00', '23:00:00', 'Evening'),
(2, '2024-09-16', '07:00:00', '15:00:00', 'Morning'),
(2, '2024-09-16', '15:00:00', '23:00:00', 'Evening'),
-- Brisbane shifts
(3, '2024-09-18', '06:30:00', '14:30:00', 'Morning'),
(3, '2024-09-18', '14:30:00', '22:30:00', 'Evening'),
(3, '2024-09-17', '06:30:00', '14:30:00', 'Morning'),
(3, '2024-09-17', '14:30:00', '22:30:00', 'Evening'),
(3, '2024-09-16', '06:30:00', '14:30:00', 'Morning'),
(3, '2024-09-16', '14:30:00', '22:30:00', 'Evening'),
(3, '2024-09-15', '06:30:00', '14:30:00', 'Morning');

-- 11. STAFF_SHIFT Table (Associative Entity)
CREATE TABLE STAFF_SHIFT (
    Staff_ID INT NOT NULL,
    Shift_ID INT NOT NULL,
    Check_In_Time DATETIME,
    Check_Out_Time DATETIME,
    Hours_Worked DECIMAL(4 , 2 ) DEFAULT 0,
    PRIMARY KEY (Staff_ID , Shift_ID),
    FOREIGN KEY (Staff_ID)
        REFERENCES STAFF (Staff_ID),
    FOREIGN KEY (Shift_ID)
        REFERENCES SHIFT (Shift_ID),
    CONSTRAINT chk_checkout_after_checkin 
		CHECK (Check_Out_Time > Check_In_Time OR Check_Out_Time IS NULL)
);

-- 11. STAFF_SHIFT Table 
INSERT INTO STAFF_SHIFT (Staff_ID, Shift_ID, Check_In_Time, Check_Out_Time, Hours_Worked) VALUES
-- Sydney Morning Shifts
(1, 1, '2024-09-18 05:55:00', '2024-09-18 14:05:00', 8.17), -- Manager Tom
(2, 1, '2024-09-18 06:00:00', '2024-09-18 14:00:00', 8.00), -- Chef Maria
(3, 1, '2024-09-18 06:05:00', '2024-09-18 14:10:00', 8.08), -- Barista Jake
(4, 1, '2024-09-18 06:00:00', '2024-09-18 14:00:00', 8.00), -- Server Emma
(5, 1, '2024-09-18 06:10:00', '2024-09-18 14:15:00', 8.08), -- Kitchen Staff Alex

-- Sydney Evening Shifts
(1, 2, '2024-09-18 13:55:00', '2024-09-18 22:10:00', 8.25), -- Manager Tom
(6, 2, '2024-09-18 14:00:00', '2024-09-18 22:00:00', 8.00), -- Barista Sophie
(7, 2, '2024-09-18 14:05:00', '2024-09-18 22:05:00', 8.00), -- Server Ryan
(5, 2, '2024-09-18 14:00:00', '2024-09-18 22:15:00', 8.25), -- Kitchen Staff Alex

-- Sydney Previous Days
(1, 3, '2024-09-17 06:00:00', '2024-09-17 14:00:00', 8.00),
(2, 3, '2024-09-17 06:05:00', '2024-09-17 14:05:00', 8.00),
(3, 3, '2024-09-17 06:00:00', '2024-09-17 14:00:00', 8.00),
(4, 3, '2024-09-17 06:10:00', '2024-09-17 14:10:00', 8.00),

(6, 4, '2024-09-17 14:00:00', '2024-09-17 22:00:00', 8.00),
(7, 4, '2024-09-17 14:05:00', '2024-09-17 22:05:00', 8.00),
(5, 4, '2024-09-17 14:00:00', '2024-09-17 22:00:00', 8.00),

-- Melbourne Morning Shifts
(8, 8, '2024-09-18 06:55:00', '2024-09-18 15:05:00', 8.17), -- Manager Lisa
(9, 8, '2024-09-18 07:00:00', '2024-09-18 15:00:00', 8.00), -- Chef Marco
(10, 8, '2024-09-18 07:05:00', '2024-09-18 15:10:00', 8.08), -- Barista Chloe
(11, 8, '2024-09-18 07:00:00', '2024-09-18 15:00:00', 8.00), -- Server James
(12, 8, '2024-09-18 07:10:00', '2024-09-18 15:15:00', 8.08), -- Kitchen Staff Priya

-- Melbourne Evening Shifts
(8, 9, '2024-09-18 14:55:00', '2024-09-18 23:10:00', 8.25), -- Manager Lisa
(13, 9, '2024-09-18 15:00:00', '2024-09-18 23:00:00', 8.00), -- Barista Daniel
(11, 9, '2024-09-18 15:05:00', '2024-09-18 23:05:00', 8.00), -- Server James
(12, 9, '2024-09-18 15:00:00', '2024-09-18 23:15:00', 8.25), -- Kitchen Staff Priya

-- Brisbane Morning Shifts
(14, 14, '2024-09-18 06:25:00', '2024-09-18 14:35:00', 8.17), -- Manager Sarah
(15, 14, '2024-09-18 06:30:00', '2024-09-18 14:30:00', 8.00), -- Chef Tony
(16, 14, '2024-09-18 06:35:00', '2024-09-18 14:40:00', 8.08), -- Barista Jessica
(17, 14, '2024-09-18 06:30:00', '2024-09-18 14:30:00', 8.00), -- Server Michael
(18, 14, '2024-09-18 06:40:00', '2024-09-18 14:45:00', 8.08), -- Kitchen Staff Amy

-- Brisbane Evening Shifts
(14, 15, '2024-09-18 14:25:00', '2024-09-18 22:40:00', 8.25), -- Manager Sarah
(19, 15, '2024-09-18 14:30:00', '2024-09-18 22:30:00', 8.00), -- Server Chris
(20, 15, '2024-09-18 14:35:00', '2024-09-18 22:35:00', 8.00), -- Barista Zoe
(18, 15, '2024-09-18 14:30:00', '2024-09-18 22:45:00', 8.25), -- Kitchen Staff Amy

-- Previous day shifts for Melbourne
(8, 10, '2024-09-17 07:00:00', '2024-09-17 15:00:00', 8.00),
(9, 10, '2024-09-17 07:05:00', '2024-09-17 15:05:00', 8.00),
(10, 10, '2024-09-17 07:00:00', '2024-09-17 15:00:00', 8.00),
(11, 10, '2024-09-17 07:10:00', '2024-09-17 15:10:00', 8.00),

(13, 11, '2024-09-17 15:00:00', '2024-09-17 23:00:00', 8.00),
(11, 11, '2024-09-17 15:05:00', '2024-09-17 23:05:00', 8.00),
(12, 11, '2024-09-17 15:00:00', '2024-09-17 23:00:00', 8.00),

-- Brisbane previous shifts
(14, 16, '2024-09-17 06:30:00', '2024-09-17 14:30:00', 8.00),
(15, 16, '2024-09-17 06:35:00', '2024-09-17 14:35:00', 8.00),
(16, 16, '2024-09-17 06:30:00', '2024-09-17 14:30:00', 8.00),
(17, 16, '2024-09-17 06:40:00', '2024-09-17 14:40:00', 8.00);




















