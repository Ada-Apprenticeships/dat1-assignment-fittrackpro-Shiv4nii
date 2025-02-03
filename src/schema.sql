-- FitTrack Pro Database Schema
-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;  

-- Create your tables here
-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );

-- TODO: Create the following tables:
-- 1. locations
create table if not exists locations(
    location_id integer PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255),
    phone_number text CHAR(8) CHECK (phone_number like '___-____'),
    email VARCHAR(255) CHECK (email LIKE '%@%'),
    opening_hours VARCHAR(20)
);

-- 2. members
create table if not exists members(
    member_id integer PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(255) CHECK (email LIKE '%@%'),
    phone_number CHAR(8) CHECK (phone_number like '___-____'),
    date_of_birth date,
    join_date date,
    emergency_contact_name VARCHAR(50),
    emergency_contact_phone CHAR(8) CHECK (emergency_contact_phone like '___-____')
);

-- 3. staff
create table if not exists staff(
    staff_id integer PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(255) CHECK (email LIKE '%@%'),
    phone_number CHAR(8) CHECK (phone_number like '___-____'),
    position VARCHAR(20) CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date date,
    location_id integer,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 4. equipment
create table if not exists equipment(
    equipment_id integer PRIMARY KEY,
    name VARCHAR(100),
    type VARCHAR(20) CHECK (type IN ('Cardio', 'Strength')),
    purchase_date date,
    last_maintenance_date date,
    next_maintenance_date date,
    location_id integer,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- 5. classes
create table if not exists classes(
    class_id integer PRIMARY KEY,
    name VARCHAR(100),
    description text,
    capacity integer,
    duration integer,
    location_id integer,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 6. class_schedule
create table if not exists class_schedule(
    schedule_id integer PRIMARY KEY,
    class_id integer,
    staff_id integer,
    start_time datetime,
    end_time datetime,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),  
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) 
);
-- 7. memberships
create table if not exists memberships(
    membership_id integer PRIMARY KEY,
    member_id integer,
    type VARCHAR(20) CHECK (type IN ('Basic','Premium')),
    start_date date,
    end_date date,
    status VARCHAR(20) CHECK (status IN ('Active','Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 8. attendance
create table if not exists attendance(
    attendance_id integer PRIMARY KEY,
    member_id integer,
    location_id integer,
    check_in_time datetime,
    check_out_time datetime,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- 9. class_attendance
create table if not exists class_attendance(
    class_attendance_id integer PRIMARY KEY,
    schedule_id integer,
    member_id integer,
    attendance_status VARCHAR(20) CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id)
);
-- 10. payments
create table if not exists payments(
    payment_id integer PRIMARY KEY,
    member_id integer,
    amount integer,
    payment_date date,
    payment_method VARCHAR(20) CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type VARCHAR(20) CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)

);

-- 11. personal_training_sessions
create table if not exists personal_training_sessions(
    session_id integer PRIMARY KEY,
    member_id integer,
    staff_id integer,
    session_date date,
    start_time VARCHAR(20),
    end_time VARCHAR(20),
    notes text,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) 
);

-- 12. member_health_metrics
create table if not exists member_health_metrics(
    metric_id integer PRIMARY KEY,
    member_id integer,
    measurement_date date,
    weight DECIMAL(4,1),
    body_fat_percentage DECIMAL(4,1),
    muscle_mass DECIMAL(4,1),
    bmi DECIMAL(4,1),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 13. equipment_maintenance_log
create table if not exists equipment_maintenance_log(
    log_id integer PRIMARY KEY,
    equipment_id text,
    maintenance_date date,
    description text,
    staff_id integer,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    
);
-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or npm run import in the terminal
