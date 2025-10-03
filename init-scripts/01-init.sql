-- OdontoSys Database Initialization Script
-- This script runs automatically when the database is first created

-- Create extensions that might be useful for a dental management system
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Set timezone to a Latin America timezone (adjust as needed)
ALTER DATABASE odontosys SET timezone TO 'America/New_York';

-- Grant necessary privileges
GRANT ALL PRIVILEGES ON DATABASE odontosys TO odontosys_admin;

-- Log successful initialization
DO $$
BEGIN
    RAISE NOTICE 'OdontoSys database initialized successfully at %', now();
END $$;
