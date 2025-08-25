-- Medical Call Tracker Database Schema
-- Run this in your Supabase SQL Editor

-- Enable Row Level Security
ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email VARCHAR UNIQUE NOT NULL,
  name VARCHAR NOT NULL,
  hospital VARCHAR,
  specialty VARCHAR,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create shifts table
CREATE TABLE IF NOT EXISTS shifts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE,
  shift_date DATE NOT NULL,
  status VARCHAR DEFAULT 'active' CHECK (status IN ('active', 'completed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create calls table
CREATE TABLE IF NOT EXISTS calls (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  shift_id UUID REFERENCES shifts(id) ON DELETE CASCADE,
  call_type VARCHAR NOT NULL CHECK (call_type IN ('incoming', 'callback')),
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE,
  duration_seconds INTEGER,
  caller_info TEXT,
  mrn VARCHAR,
  notes TEXT,
  priority VARCHAR DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_shifts_user_id ON shifts(user_id);
CREATE INDEX IF NOT EXISTS idx_shifts_date ON shifts(shift_date);
CREATE INDEX IF NOT EXISTS idx_calls_shift_id ON calls(shift_id);
CREATE INDEX IF NOT EXISTS idx_calls_start_time ON calls(start_time);

-- Enable RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE shifts ENABLE ROW LEVEL SECURITY;
ALTER TABLE calls ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Users can only see their own data
CREATE POLICY "Users can view own profile" ON users
  FOR ALL USING (auth.uid()::text = id::text);

-- Users can only see their own shifts
CREATE POLICY "Users can view own shifts" ON shifts
  FOR ALL USING (auth.uid()::text = user_id::text);

-- Users can only see calls from their own shifts
CREATE POLICY "Users can view own calls" ON calls
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM shifts 
      WHERE shifts.id = calls.shift_id 
      AND shifts.user_id::text = auth.uid()::text
    )
  );

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at for users table
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to auto-end shifts at 8 AM
CREATE OR REPLACE FUNCTION auto_end_shifts()
RETURNS void AS $$
BEGIN
  UPDATE shifts 
  SET 
    status = 'completed',
    end_time = CURRENT_DATE + INTERVAL '8 hours'
  WHERE 
    status = 'active' 
    AND shift_date < CURRENT_DATE
    AND end_time IS NULL;
END;
$$ LANGUAGE plpgsql;

-- Insert sample data (optional - for testing)
-- You can remove this section if you don't want test data
INSERT INTO users (id, email, name, hospital, specialty) VALUES 
  ('550e8400-e29b-41d4-a716-446655440000', 'dr.sarah@hospital.com', 'Dr. Sarah Chen', 'General Hospital', 'Emergency Medicine')
ON CONFLICT (email) DO NOTHING;