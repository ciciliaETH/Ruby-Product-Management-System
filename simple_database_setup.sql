-- Simplified database setup for testing
-- Run this in Supabase SQL Editor

-- Drop existing tables if they exist
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS products;

-- Create products table
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create purchases table
CREATE TABLE purchases (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id) ON DELETE SET NULL,
    quantity INTEGER NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    purchase_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status TEXT DEFAULT 'completed' CHECK (status IN ('completed', 'cancelled', 'pending')),
    cancelled_at TIMESTAMP WITH TIME ZONE NULL
);

-- Enable RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;

-- Create permissive policies for development
CREATE POLICY "Enable all operations for products" ON products FOR ALL USING (true);
CREATE POLICY "Enable all operations for purchases" ON purchases FOR ALL USING (true);

-- Insert sample data
INSERT INTO products (name, description, price, stock) VALUES 
('Laptop Gaming ASUS ROG', 'Laptop gaming dengan spesifikasi tinggi: Intel i7, RTX 4060, 16GB RAM, SSD 1TB', 15000000, 5),
('Mouse Gaming Logitech G502', 'Mouse gaming dengan sensor HERO 25K DPI dan 11 tombol yang dapat diprogram', 850000, 20),
('Keyboard Mechanical Corsair K70', 'Keyboard mechanical dengan Cherry MX Red switches dan RGB per-key lighting', 1800000, 15),
('Monitor Gaming ASUS VG248QE', 'Monitor gaming 24 inch Full HD dengan refresh rate 144Hz dan response time 1ms', 3200000, 8),
('Headset Gaming SteelSeries Arctis 7', 'Headset gaming wireless dengan DTS Headphone:X 2.0 surround sound', 2200000, 12);

-- Verify tables were created
SELECT 'Products table' as table_name, count(*) as row_count FROM products
UNION ALL
SELECT 'Purchases table' as table_name, count(*) as row_count FROM purchases;
