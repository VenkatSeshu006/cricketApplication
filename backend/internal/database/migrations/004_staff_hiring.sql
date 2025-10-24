-- Staff Hiring Service Tables

-- Job Postings Table
CREATE TABLE IF NOT EXISTS job_postings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    job_type VARCHAR(50) NOT NULL, -- coach, groundsman, umpire, scorer, physio, trainer, manager
    experience_required VARCHAR(50), -- entry, intermediate, senior, expert
    location VARCHAR(255) NOT NULL,
    salary_range VARCHAR(100),
    employment_type VARCHAR(50) NOT NULL, -- full-time, part-time, contract, freelance
    requirements TEXT[],
    responsibilities TEXT[],
    benefits TEXT[],
    application_deadline DATE,
    status VARCHAR(20) DEFAULT 'open', -- open, closed, filled
    total_applications INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Job Applications Table
CREATE TABLE IF NOT EXISTS job_applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
    applicant_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    cover_letter TEXT NOT NULL,
    resume_url TEXT,
    experience_years INT NOT NULL,
    relevant_experience TEXT,
    availability VARCHAR(50), -- immediate, 2weeks, 1month, negotiable
    expected_salary VARCHAR(100),
    status VARCHAR(20) DEFAULT 'pending', -- pending, reviewing, shortlisted, rejected, accepted
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP,
    notes TEXT,
    UNIQUE(job_id, applicant_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_jobs_employer ON job_postings(employer_id);
CREATE INDEX IF NOT EXISTS idx_jobs_type ON job_postings(job_type);
CREATE INDEX IF NOT EXISTS idx_jobs_status ON job_postings(status);
CREATE INDEX IF NOT EXISTS idx_applications_job ON job_applications(job_id);
CREATE INDEX IF NOT EXISTS idx_applications_applicant ON job_applications(applicant_id);
CREATE INDEX IF NOT EXISTS idx_applications_status ON job_applications(status);

-- Sample Job Postings
INSERT INTO job_postings (
    id, employer_id, title, description, job_type, experience_required,
    location, salary_range, employment_type, requirements, responsibilities,
    benefits, application_deadline, status
) VALUES
(
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    '9a8e3277-1c4b-4f0c-84ed-b637fe461f89',
    'Senior Cricket Coach',
    'Looking for an experienced cricket coach to train our academy players. Must have professional playing or coaching experience.',
    'coach',
    'senior',
    'Bangalore, Karnataka',
    '₹50,000 - ₹80,000/month',
    'full-time',
    ARRAY['Level 2 Coaching Certification', 'Minimum 5 years coaching experience', 'Experience with youth players', 'Good communication skills'],
    ARRAY['Conduct daily training sessions', 'Develop training programs', 'Assess player performance', 'Mentor junior coaches', 'Organize practice matches'],
    ARRAY['Health insurance', 'Performance bonus', 'Equipment allowance', 'Professional development opportunities'],
    '2025-11-30',
    'open'
),
(
    'dddddddd-dddd-dddd-dddd-dddddddddddd',
    '9a8e3277-1c4b-4f0c-84ed-b637fe461f89',
    'Cricket Ground Manager',
    'Seeking an experienced ground manager to maintain our cricket grounds to professional standards.',
    'groundsman',
    'intermediate',
    'Mumbai, Maharashtra',
    '₹35,000 - ₹55,000/month',
    'full-time',
    ARRAY['Diploma in Sports Turf Management', 'Knowledge of pitch preparation', 'Equipment maintenance skills', '3+ years experience'],
    ARRAY['Maintain cricket pitches', 'Prepare grounds for matches', 'Manage ground staff', 'Equipment maintenance', 'Coordinate with match officials'],
    ARRAY['Accommodation provided', 'Health insurance', 'Annual bonus'],
    '2025-11-15',
    'open'
),
(
    'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
    'eba4cb24-307c-454b-982a-0c730efa8703',
    'Part-Time Cricket Umpire',
    'Looking for certified umpires for weekend matches and tournaments.',
    'umpire',
    'entry',
    'Delhi NCR',
    '₹1,500 - ₹3,000/match',
    'part-time',
    ARRAY['BCCI Level 1 Umpiring Certificate', 'Knowledge of cricket laws', 'Good fitness level', 'Available on weekends'],
    ARRAY['Officiate matches', 'Make fair decisions', 'Maintain match records', 'Coordinate with scorers'],
    ARRAY['Flexible schedule', 'Travel allowance', 'Training opportunities', 'Tournament participation'],
    '2025-11-20',
    'open'
);
