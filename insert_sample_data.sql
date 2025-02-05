-- Insert Users
INSERT INTO users (name, email, password_hash) VALUES
('Alice Johnson', 'alice@example.com', 'hashed_password1'),
('Bob Smith', 'bob@example.com', 'hashed_password2'),
('Charlie Brown', 'charlie@example.com', 'hashed_password3'),
('David Wilson', 'david@example.com', 'hashed_password4'),
('Emma Davis', 'emma@example.com', 'hashed_password5'),
('Franklin Harris', 'frank@example.com', 'hashed_password6'),
('Grace Lee', 'grace@example.com', 'hashed_password7'),
('Henry Clark', 'henry@example.com', 'hashed_password8'),
('Isabella White', 'isabella@example.com', 'hashed_password9'),
('Jack Thompson', 'jack@example.com', 'hashed_password10');

-- Insert Categories
INSERT INTO categories (name, description) VALUES
('Electronics', 'Gadgets and devices'),
('Clothing', 'Apparel and accessories'),
('Home & Kitchen', 'Household and kitchen items'),
('Books', 'Fiction, non-fiction, and educational'),
('Sports', 'Sports gear and outdoor items');

-- Insert Products (20 unique)
INSERT INTO products (name, description, price, stock_quantity, category_id) VALUES
('Smartphone X', 'Latest smartphone with 128GB storage', 699.99, 50, 1),
('Laptop Pro 15', 'High-performance laptop with 16GB RAM', 1299.99, 30, 1),
('Wireless Earbuds', 'Noise-canceling Bluetooth earbuds', 149.99, 100, 1),
('Running Shoes', 'Lightweight running shoes for athletes', 89.99, 75, 5),
('Gaming Console', 'Next-gen gaming console with 4K support', 499.99, 40, 1),
('Cookware Set', '10-piece non-stick cookware set', 79.99, 60, 3),
('T-shirt', '100% cotton graphic tee', 19.99, 200, 2),
('Winter Jacket', 'Warm insulated jacket for winter', 99.99, 50, 2),
('Backpack', 'Durable backpack for daily use', 39.99, 80, 5),
('Desk Chair', 'Ergonomic office chair with lumbar support', 199.99, 20, 3),
('Smartwatch', 'Fitness tracking smartwatch with heart rate monitor', 199.99, 60, 1),
('Blender', 'High-speed blender for smoothies', 49.99, 40, 3),
('Fiction Book', 'Best-selling mystery novel', 14.99, 100, 4),
('Yoga Mat', 'Non-slip yoga mat for home workouts', 29.99, 50, 5),
('Headphones', 'Wireless over-ear noise-canceling headphones', 199.99, 30, 1),
('Sunglasses', 'UV-protected stylish sunglasses', 59.99, 70, 2),
('Coffee Maker', 'Automatic drip coffee machine', 79.99, 35, 3),
('Dumbbell Set', 'Adjustable dumbbell set for home workouts', 129.99, 25, 5),
('Tablet', '10-inch tablet with stylus support', 299.99, 40, 1),
('Wireless Keyboard', 'Compact Bluetooth keyboard', 49.99, 50, 1);

-- Insert Orders (Each user has 5-10 orders)
DO $$ 
DECLARE 
    usr RECORD;
    order_count INT;
    status_arr TEXT[] := ARRAY['pending', 'shipped', 'delivered', 'canceled'];
    order_id INT; -- Declare order_id properly
BEGIN 
    FOR usr IN SELECT id FROM users LOOP
        order_count := 5 + FLOOR(RANDOM() * 6); -- Random number between 5 and 10

        FOR i IN 1..order_count LOOP
            INSERT INTO orders (user_id, total_price, status, created_at)
            VALUES (
                usr.id, 
                50 + FLOOR(RANDOM() * 500), 
                status_arr[1 + FLOOR(RANDOM() * 4)], 
                NOW() - INTERVAL '30 days' * FLOOR(RANDOM() * 60) -- Random past/future date
            )
            RETURNING id INTO order_id;

            -- Add order items (1 to 4 random products)
            INSERT INTO order_items (order_id, product_id, quantity, unit_price)
            SELECT order_id, id, 1 + FLOOR(RANDOM() * 3), price
            FROM products
            ORDER BY RANDOM()
            LIMIT 2 + FLOOR(RANDOM() * 3);
        END LOOP;
    END LOOP;
END $$;

-- Insert Payments (For delivered orders)
INSERT INTO payments (order_id, payment_method, payment_status, transaction_id)
SELECT id, 
       CASE FLOOR(RANDOM() * 4)
           WHEN 0 THEN 'credit_card'
           WHEN 1 THEN 'debit_card'
           WHEN 2 THEN 'paypal'
           ELSE 'cod'
       END,
       'completed',
       md5(random()::text)
FROM orders WHERE status = 'delivered';

-- Insert Reviews (Random subset of users reviewing products)
INSERT INTO reviews (user_id, product_id, rating, review_text)
SELECT 
    (SELECT id FROM users ORDER BY RANDOM() LIMIT 1), 
    (SELECT id FROM products ORDER BY RANDOM() LIMIT 1), 
    1 + FLOOR(RANDOM() * 5), 
    'Great product! Highly recommended.'
FROM generate_series(1, 30);  -- Insert 30 random reviews
