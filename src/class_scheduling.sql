-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON; 
-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

SELECT
    c.class_id,
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name
FROM 
    classes c
JOIN 
    class_schedule cs ON c.class_id = cs.class_id
JOIN 
    staff s ON cs.staff_id = s.staff_id;

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

SELECT
    c.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    (c.capacity - COUNT(ca.member_id)) AS available_spots
FROM
    class_schedule cs
JOIN
    classes c ON cs.class_id = c.class_id
LEFT JOIN
    class_attendance ca ON cs.schedule_id = ca.schedule_id AND ca.attendance_status IN ('Registered', 'Attended')
WHERE
    DATE(cs.start_time) = '2025-02-01' 
GROUP BY
    c.class_id, c.name, cs.start_time, cs.end_time, c.capacity
ORDER BY
    cs.start_time;

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES(3, 11, 'Registered');

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
DELETE FROM class_attendance
WHERE schedule_id = 7 AND member_id = 2;

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

SELECT
    c.class_id,
    c.name AS class_name,
    COUNT(ca.class_attendance_id) AS registration_count
FROM 
    classes c
JOIN 
    class_schedule cs ON c.class_id = cs.class_id
JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE
    ca.attendance_status IN ('Registered', 'Attended')
GROUP BY 
    c.class_id, c.name
ORDER BY 
    registration_count DESC
LIMIT 3;

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member

SELECT 
    AVG(class_count) AS average_classes_per_member
FROM (
    SELECT 
        COUNT(DISTINCT ca.schedule_id) AS class_count
    FROM 
        members m
    LEFT JOIN 
        class_attendance ca ON m.member_id = ca.member_id
    WHERE 
        ca.attendance_status IN ('Registered', 'Attended')
    GROUP BY 
        m.member_id
);