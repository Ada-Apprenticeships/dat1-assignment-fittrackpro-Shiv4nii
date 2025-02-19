-- FitTrack Pro Database Schema
-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Drop and create tables
-- 1. locations

CREATE TABLE locations(
    location_id integer PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone_number TEXT CHECK (phone_number LIKE '___-____'),
    email VARCHAR(255) CHECK (email LIKE '%@%'),
    opening_hours VARCHAR(20)
);

-- 2. members

CREATE TABLE members(
    member_id integer PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) CHECK (email LIKE '%@%'),
    phone_number CHAR(8) CHECK (phone_number LIKE '___-____'),
    date_of_birth DATE CHECK (date_of_birth < CURRENT_DATE),
    join_date DATE CHECK (join_date <= CURRENT_DATE),
    emergency_contact_name VARCHAR(50) NOT NULL,
    emergency_contact_phone CHAR(8) NOT NULL CHECK (emergency_contact_phone LIKE '___-____')
);

-- 3. staff

CREATE TABLE staff(
    staff_id integer PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) CHECK (email LIKE '%@%'),
    phone_number CHAR(8) CHECK (phone_number LIKE '___-____'),
    position VARCHAR(20) CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATE CHECK (hire_date <= CURRENT_DATE),
    location_id integer,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- 4. equipment

CREATE TABLE equipment(
    equipment_id integer PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE CHECK (purchase_date <= CURRENT_DATE),
    last_maintenance_date DATE CHECK (last_maintenance_date <= CURRENT_DATE),
    next_maintenance_date DATE CHECK (next_maintenance_date > last_maintenance_date),
    location_id integer,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- 5. classes
CREATE TABLE classes(
    class_id integer PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    capacity integer CHECK (capacity > 0),
    duration integer CHECK (duration > 0),
    location_id integer,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- 6. class_schedule
CREATE TABLE class_schedule(
    schedule_id integer PRIMARY KEY,
    class_id integer,
    staff_id integer,
    start_time DATETIME CHECK (start_time < end_time),
    end_time DATETIME CHECK (end_time > start_time),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- 7. memberships
CREATE TABLE memberships(
    membership_id integer PRIMARY KEY,
    member_id integer,
    type VARCHAR(20) CHECK (type IN ('Basic', 'Premium')),
    start_date DATE CHECK (start_date < end_date),
    end_date DATE CHECK (end_date > start_date),
    status VARCHAR(20) CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 8. attendance
CREATE TABLE attendance(
    attendance_id integer PRIMARY KEY,
    member_id integer,
    location_id integer,
    check_in_time DATETIME CHECK (check_in_time < check_out_time),
    check_out_time DATETIME CHECK (check_out_time > check_in_time),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- 9. class_attendance
CREATE TABLE class_attendance(
    class_attendance_id integer PRIMARY KEY,
    schedule_id integer,
    member_id integer,
    attendance_status VARCHAR(20) NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id)
);

-- 10. payments
CREATE TABLE payments(
    payment_id integer PRIMARY KEY,
    member_id integer,
    amount DECIMAL(4,2) NOT NULL CHECK (amount > 0),
    payment_date DATETIME NOT NULL CHECK (payment_date <= CURRENT_TIMESTAMP),
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type VARCHAR(20) NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 11. personal_training_sessions
CREATE TABLE personal_training_sessions(
    session_id integer PRIMARY KEY,
    member_id integer,
    staff_id integer,
    session_date DATE,
    start_time TIME CHECK (start_time < end_time),
    end_time TIME CHECK (end_time > start_time),
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- 12. member_health_metrics
CREATE TABLE member_health_metrics(
    metric_id integer PRIMARY KEY,
    member_id integer,
    measurement_date DATE CHECK (measurement_date <= CURRENT_DATE),
    weight DECIMAL(4,1) CHECK (weight > 0),
    body_fat_percentage DECIMAL(4,1) CHECK (body_fat_percentage > 0),
    muscle_mass DECIMAL(4,1) CHECK (muscle_mass > 0),
    bmi DECIMAL(4,1) CHECK (bmi > 0),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 13. equipment_maintenance_log
CREATE TABLE equipment_maintenance_log(
    log_id integer PRIMARY KEY,
    equipment_id INTEGER,
    maintenance_date DATE CHECK (maintenance_date <= CURRENT_DATE),
    description TEXT,
    staff_id integer,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or npm run import in the terminal
