CREATE TABLE IF NOT EXISTS physiotherapists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    specialization TEXT NOT NULL,
    experience_years INT NOT NULL,
    qualifications TEXT[],
    clinic_name VARCHAR(255),
    clinic_address TEXT NOT NULL,
    consultation_fee DECIMAL(10, 2) NOT NULL,
    available_days TEXT[],
    available_hours TEXT,
    rating DECIMAL(3, 2) DEFAULT 0.0,
    total_reviews INT DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    bio TEXT,
    profile_image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    physiotherapist_id UUID NOT NULL REFERENCES physiotherapists(id) ON DELETE CASCADE,
    patient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    duration_minutes INT DEFAULT 60,
    status VARCHAR(20) DEFAULT 'scheduled',
    complaint TEXT,
    notes TEXT,
    fee DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(physiotherapist_id, appointment_date, appointment_time)
);
CREATE INDEX IF NOT EXISTS idx_physio_user ON physiotherapists(user_id);
CREATE INDEX IF NOT EXISTS idx_appointments_physio ON appointments(physiotherapist_id);
