-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column
.mode box
-- Enable foreign key support
PRAGMA foreign_keys = ON; 
-- Equipment Management Queries

-- 1. Find equipment due for maintenance
-- TODO: Write a query to find equipment due for maintenance
SELECT
    equipment_id,
    name,
    next_maintenance_date
from equipment
where next_maintenance_date BETWEEN date('now') AND date('now', '+30 days'); -- to filter for the next 30 days

-- 2. Count equipment types in stock
-- TODO: Write a query to count equipment types in stock
SELECT   
    type as equipment_type,   
    COUNT(*) AS count  
FROM   
    equipment  
GROUP BY   
    type;  


-- 3. Calculate average age of equipment by type (in days)
-- TODO: Write a query to calculate average age of equipment by type (in days)

SELECT   
    type AS equipment_type,  
    AVG(julianday('now') - julianday(purchase_date)) as avg_age_days 
FROM   
    equipment  
GROUP BY   
    type;  

