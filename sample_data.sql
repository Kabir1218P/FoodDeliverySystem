-- FoodExpress Sample Data
-- sample_data.sql

-- Insert Customers
INSERT INTO customers (name, email, phone, address) VALUES
('Rahul Sharma', 'rahul@example.com', '9876543210', 'Delhi, India'),
('Ananya Mehta', 'ananya@example.com', '9123456780', 'Mumbai, India'),
('Arjun Singh', 'arjun@example.com', '9988776655', 'Bengaluru, India');

-- Insert Restaurants
INSERT INTO restaurants (name, address, phone, cuisine, rating) VALUES
('Tandoori Tales', 'Connaught Place, Delhi', '011-222333444', 'North Indian', 4.5),
('Bombay Bites', 'Bandra, Mumbai', '022-555666777', 'Maharashtrian', 4.2),
('South Spice', 'Indiranagar, Bengaluru', '080-888999000', 'South Indian', 4.7);

-- Insert Menu Items
INSERT INTO menu_items (restaurant_id, name, description, price, available) VALUES
(1, 'Butter Chicken', 'Creamy tomato gravy with chicken', 320.00, TRUE),
(1, 'Paneer Tikka', 'Grilled cottage cheese with spices', 250.00, TRUE),
(2, 'Vada Pav', 'Mumbai street-style snack', 50.00, TRUE),
(2, 'Misal Pav', 'Spicy curry with pav bread', 120.00, TRUE),
(3, 'Masala Dosa', 'Crispy dosa with potato filling', 150.00, TRUE),
(3, 'Idli Sambar', 'Soft idlis with sambar & chutney', 100.00, TRUE);

-- Insert Delivery Partners
INSERT INTO delivery_partners (name, phone, vehicle_type, status) VALUES
('Ravi Kumar', '9000011111', 'Bike', 'available'),
('Priya Verma', '9000022222', 'Scooter', 'busy'),
('Mohit Patel', '9000033333', 'Cycle', 'available');

-- Insert Orders
INSERT INTO orders (customer_id, restaurant_id, delivery_partner_id, status, total_amount) VALUES
(1, 1, 1, 'delivered', 570.00),
(2, 2, 2, 'placed', 50.00),
(3, 3, 3, 'confirmed', 250.00);

-- Insert Order Items
INSERT INTO order_items (order_id, menu_item_id, quantity, price) VALUES
(1, 1, 1, 320.00),
(1, 2, 1, 250.00),
(2, 3, 1, 50.00),
(3, 5, 1, 150.00),
(3, 6, 1, 100.00);

-- Insert Payments
INSERT INTO payments (order_id, amount, method, status, paid_at) VALUES
(1, 570.00, 'upi', 'success', CURRENT_TIMESTAMP),
(2, 50.00, 'cash', 'pending', NULL),
(3, 250.00, 'card', 'success', CURRENT_TIMESTAMP);
