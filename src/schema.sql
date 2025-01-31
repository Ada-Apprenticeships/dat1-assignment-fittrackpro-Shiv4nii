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
    name text,
    address text,
    phone_number text CHECK (phone_number like '___-____'),
    email text CHECK (email LIKE '%@%'),
    opening_hours text
);

-- 2. members
create table if not exists members(
    member_id integer,
    first_name text,
    last_name text,
    email text CHECK (email LIKE '%@%'),
    phone_number text CHECK (phone_number like '___-____'),
    date_of_birth date,
    join_date date,
    emergency_contact_name text,
    emergency_contact_phone text CHECK (emergency_contact_phone like '___-____')
);

-- 3. staff
create table if not exists staff(
    staff_id integer,
    first_name text,
    last_name text,
    email text CHECK (email LIKE '%@%'),
    phone_number text CHECK (phone_number like '___-____'),
    position text CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date date,
    location_id integer
);
-- 4. equipment
create table if not exists equipment(
    equipment_id integer,
    name text,
    type text CHECK (type IN ('Cardio', 'Strength')),
    purchase_date date,
    last_maintenance_date date,
    next_maintenance_date date,
    location_id integer
);

-- 5. classes
create table if not exists classes(
    class_id integer,
    name text,
    description text,
    capacity integer,
    duration integer,
    location_id integer
);
-- 6. class_schedule
create table if not exists class_schedule(
    schedule_id text,
    class_id integer,
    staff_id integer,
    start_time text,
    end_time text
);
-- 7. memberships
create table if not exists memberships(
    membership_id text,
    member_id text,
    type text CHECK (type IN ('Basic','Premium')),
    start_date date,
    end_date date,
    status text CHECK (status IN ('Active','Inactive'))
);

-- 8. attendance
create table if not exists attendance(
    attendance_id integer,
    member_id integer,
    location_id integer,
    check_in_time text,
    check_out_time text
);

-- 9. class_attendance
create table if not exists class_attendance(
    class_attendance_id text,
    schedule_id integer,
    member_id integer,
    attendance_status text CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended'))
);
-- 10. payments
create table if not exists payments(
    payment_id integer,
    member_id integer,
    amount integer,
    payment_date date,
    payment_method text CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type text CHECK (payment_type IN ('Monthly membership fee', 'Day pass'))
);

-- 11. personal_training_sessions
create table if not exists personal_training_sessions(
    session_id integer,
    member_id integer,
    staff_id integer,
    session_date date,
    start_time text,
    end_time text,
    notes text
);

-- 12. member_health_metrics
create table if not exists member_health_metrics(
    metric_id t,
    member_id text,
    measurement_date date,
    weight integer,
    body_fat_percentage text,
    muscle_mass integer,
    bmi text
);

-- 13. equipment_maintenance_log
create table if not exists equipment_maintenance_log(
    log_id text,
    equipment_id text,
    maintenance_date date,
    description text,
    staff_id text
);
-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or  in the terminal
