-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column
.mode box
-- Enable foreign key support
PRAGMA foreign_keys = ON; 
-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit

INSERT INTO attendance 
    (member_id, location_id, check_in_time)
VALUES 
    (7, 1, datetime('now'));

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history

SELECT 
    DATE(a.check_in_time) AS visit_date,
    TIME(a.check_in_time) AS check_in_time,
    TIME(a.check_out_time) AS check_out_time
FROM 
    attendance a
WHERE 
    a.member_id = 5
ORDER BY 
    visit_date, check_in_time;


-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits

SELECT 
    strftime('%w', a.check_in_time) AS day_of_week,
    COUNT(*) AS visit_count
FROM 
    attendance a
GROUP BY 
    day_of_week
ORDER BY 
    visit_count DESC -- starts with the highest visit count
LIMIT 1; -- only gives the first output to only get the busiest day

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location

SELECT 
    l.name AS location_name,
    AVG(daily_visits) AS avg_daily_attendance
FROM (
    SELECT
        a.location_id,
        DATE(a.check_in_time) AS visit_date,
        COUNT(*) AS daily_visits
    FROM 
        attendance a
    GROUP BY 
        a.location_id, visit_date
) daily_counts
JOIN 
    locations l ON daily_counts.location_id = l.location_id -- join to associate every visit count with a location name
GROUP BY 
    l.name
ORDER BY 
    avg_daily_attendance DESC;


