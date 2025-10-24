-- Create grounds table
CREATE TABLE IF NOT EXISTS grounds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    facilities TEXT[], -- Array of facilities: floodlights, parking, wifi, etc.
    hourly_price DECIMAL(10, 2),
    half_day_price DECIMAL(10, 2),
    full_day_price DECIMAL(10, 2),
    images TEXT[], -- Array of image URLs
    rating DECIMAL(3, 2) DEFAULT 0.0,
    total_reviews INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ground_id UUID NOT NULL REFERENCES grounds(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    duration_type VARCHAR(20) NOT NULL, -- hourly, half_day, full_day
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending', -- pending, confirmed, cancelled, completed
    payment_status VARCHAR(20) DEFAULT 'pending', -- pending, paid, refunded
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(ground_id, booking_date, start_time) -- Prevent double booking
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_grounds_location ON grounds(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_grounds_owner ON grounds(owner_id);
CREATE INDEX IF NOT EXISTS idx_bookings_ground ON bookings(ground_id);
CREATE INDEX IF NOT EXISTS idx_bookings_user ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

-- Insert sample grounds data
INSERT INTO grounds (owner_id, name, description, address, latitude, longitude, facilities, hourly_price, half_day_price, full_day_price, images, rating, total_reviews)
SELECT 
    id,
    'City Cricket Stadium',
    'Premier cricket facility with modern amenities and professional-grade turf pitch. Perfect for matches and practice sessions.',
    '123 Stadium Road, Cricket Complex, Delhi',
    28.6139,
    77.2090,
    ARRAY['floodlights', 'pavilion', 'parking', 'wifi', 'changing_rooms', 'scoreboard'],
    1000.00,
    4000.00,
    7000.00,
    ARRAY['https://images.unsplash.com/photo-1540747913346-19e32dc3e97e'],
    4.5,
    120
FROM users
WHERE email = 'testuser@cricket.com'
ON CONFLICT DO NOTHING;

INSERT INTO grounds (owner_id, name, description, address, latitude, longitude, facilities, hourly_price, half_day_price, full_day_price, images, rating, total_reviews)
SELECT 
    id,
    'Green Valley Sports Ground',
    'Beautiful ground surrounded by nature. Ideal for weekend matches and tournaments.',
    '456 Valley Road, Sports Complex, Mumbai',
    19.0760,
    72.8777,
    ARRAY['floodlights', 'parking', 'cafe', 'first_aid'],
    800.00,
    3500.00,
    6000.00,
    ARRAY['https://images.unsplash.com/photo-1531415074968-036ba1b575da'],
    4.2,
    85
FROM users
WHERE email = 'testuser@cricket.com'
ON CONFLICT DO NOTHING;

INSERT INTO grounds (owner_id, name, description, address, latitude, longitude, facilities, hourly_price, half_day_price, full_day_price, images, rating, total_reviews)
SELECT 
    id,
    'Sunset Cricket Arena',
    'Well-maintained ground with excellent drainage. Available for night matches.',
    '789 Arena Street, Bangalore',
    12.9716,
    77.5946,
    ARRAY['floodlights', 'parking', 'wifi', 'seating'],
    1200.00,
    4500.00,
    8000.00,
    ARRAY['https://images.unsplash.com/photo-1624526267942-ab0ff8a3e972'],
    4.7,
    200
FROM users
WHERE email = 'testuser@cricket.com'
ON CONFLICT DO NOTHING;
