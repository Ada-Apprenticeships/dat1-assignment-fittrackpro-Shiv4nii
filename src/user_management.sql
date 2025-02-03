-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support

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
    member_id = 5


-- set emergency_contact_name = 
-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
-- select count(*) as totalMembers
-- from members;
-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
-- select
--     max()
-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class