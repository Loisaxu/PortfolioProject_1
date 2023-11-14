
----------------------------------------------------------------
-- Bread out start_time into date and time columns --
----------------------------------------------------------------
-- A general view of the table --
SELECT 
    *
FROM
    tripsInfo
LIMIT 200;

-- First, take a peak -- 
SELECT 
    start_time,
    DATE_FORMAT(STR_TO_DATE(start_time, '%Y/%m/%d %H:%i'),
            '%Y/%m/%d %H:%i') AS start_date_time,
    end_time,
    DATE_FORMAT(STR_TO_DATE(end_time, '%Y/%m/%d %H:%i'),
            '%Y/%m/%d %H:%i') AS end_date_time
FROM
    tripsInfo
WHERE
    tripduration > 500;

-- Second, update the start & end time into format yyyy/mm/dd hh:mm --
SET SQL_SAFE_UPDATES = 0;
UPDATE tripsInfo 
SET 
    start_time = DATE_FORMAT(STR_TO_DATE(start_time, '%Y/%m/%d %H:%i'),
            '%Y/%m/%d %H:%i');

UPDATE tripsInfo 
SET 
    end_time = DATE_FORMAT(STR_TO_DATE(end_time, '%Y/%m/%d %H:%i'),
            '%Y/%m/%d %H:%i');

-- Lastly, bread out the date and time and add them into new columns -- 
SELECT 
    DATE_FORMAT(start_time, '%Y/%m/%d') AS date,
    DATE_FORMAT(start_time, '%H:%i') AS time
FROM
    tripsInfo;
    
ALTER TABLE tripsInfo
ADD COLUMN start_date DATE,
ADD COLUMN start_time_slot TIME;

UPDATE tripsInfo 
SET 
    start_date = DATE_FORMAT(start_time, '%Y/%m/%d');

UPDATE tripsInfo 
SET 
    start_time_slot = DATE_FORMAT(start_time, '%H:%i');

-- Voila, let's check the result -- 
SELECT 
    *
FROM
    tripsInfo
WHERE
    TIME(start_time_slot) > '20:00:00';

-----------------------------------------------------------------
-- Add a new column is_subscriber to provide Yes or NO options --
-----------------------------------------------------------------

-- First, create a new column --
ALTER TABLE tripsInfo
ADD COLUMN is_subscriber CHAR(10);

-- Then, populate the column with respect to column usertype --
UPDATE tripsInfo 
SET 
    is_subscriber = CASE
        WHEN usertype = 'Subscriber' THEN 'Yes'
        ELSE 'No'
    END;

--------------------------
-- Check for duplicates --
--------------------------
SELECT 
    trip_id, COUNT(trip_id) AS duplex_trips
FROM
    tripsInfo
GROUP BY trip_id
HAVING duplex_trips > 1


