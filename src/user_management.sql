-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;  
-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
select
    member_id,
    first_name,
    last_name,
    email,
    join_date
 from members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information
update members
set 
    phone_number = '555-9876',
    email = 'emily.jones.updated@email.com'
WHERE
    member_id = 5;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
select count(*) as TotalMembers
from members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations

SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    COUNT(ca.class_attendance_id) AS registration_count
FROM 
    members m
JOIN 
    class_attendance ca ON m.member_id = ca.member_id
WHERE
    ca.attendance_status IN ('Registered', 'Attended')  -- to filter for only 'registered' or 'attended', not 'unattended'
GROUP BY 
    m.member_id, m.first_name, m.last_name -- group by the details about the members to aggregate their count
ORDER BY 
    registration_count DESC --starts with the most
LIMIT 1;  --so there's only one row output (find the most class registrations)


-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations

SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    COUNT(ca.class_attendance_id) AS registration_count
FROM 
    members m
JOIN 
    class_attendance ca ON m.member_id = ca.member_id
WHERE
    ca.attendance_status IN ('Registered', 'Attended') 
GROUP BY 
    m.member_id, m.first_name, m.last_name
ORDER BY 
    registration_count ASC --starts with the least
LIMIT 1;  --so there's only one row output (find the least class registrations)


-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class

SELECT
    (CAST(COUNT(DISTINCT attended_members.member_id) AS FLOAT) / COUNT(DISTINCT m.member_id)) * 100 AS percentage_of_members -- used distinct so only single count per member, then can calculated percentage
FROM 
    members m
LEFT JOIN --left join to ensure that all members have been conisdered
    (SELECT DISTINCT member_id FROM class_attendance WHERE attendance_status = 'Attended') attended_members
ON 
    m.member_id = attended_members.member_id;

   
   
   
