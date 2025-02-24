-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column
.mode box
-- Enable foreign key support
PRAGMA foreign_keys = ON;  
-- Payment Management Queries

-- 1. Record a payment for a membership
-- TODO: Write a query to record a payment for a membership
insert into payments(member_id, amount, payment_date, payment_method, payment_type)
values (11, '50', datetime('now'), 'Credit Card', 'Monthly membership fee');

-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year

SELECT 
    strftime('%m', p.payment_date) as month, -- to get only the month from payment_date
    sum(p.amount) as total_revenue -- sum the payment amountys
from payments p
WHERE
    p.payment_type = 'Monthly membership fee' AND -- filter for only 'monthly membership fee' and only this year - '2025'
    strftime('%Y', p.payment_date) = '2025'
GROUP BY   
    month  
ORDER BY   
    month;

-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases

select 
    payment_id,
    amount,
    payment_date,
    payment_method
from payments
where payment_type = 'Day pass'; --filter for only payment type day pass