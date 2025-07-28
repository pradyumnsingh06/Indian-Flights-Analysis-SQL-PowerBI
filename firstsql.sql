create database project;
 
use  project;

create table economy(
`date` VARCHAR(255),
`airline` VARCHAR(255),
`ch_code` VARCHAR(255),
`num_code` VARCHAR(255),
`dep_time` VARCHAR(255),
`source_city` VARCHAR(255),
`time_taken` VARCHAR(255),
`stop` VARCHAR(255),
`arr_time` VARCHAR(255),
`destination_city` VARCHAR(255),
`price` VARCHAR(255)
);


 drop table business ;
 
 SHOW VARIABLES LIKE "secure_file_priv";
 
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/economy.csv"
into table economy
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

CREATE TABLE business (
    `date` VARCHAR(255),
    `airline` VARCHAR(255),
    `ch_code` VARCHAR(255),
    `num_code` VARCHAR(255),
    `dep_time` VARCHAR(255),
    `source_city` VARCHAR(255),
    `time_taken` VARCHAR(255),
    `stop` VARCHAR(255),
    `arr_time` VARCHAR(255),
    `destination_city` VARCHAR(255),
    `price` VARCHAR(255)
);


load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/business.csv"
into table business
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

SELECT
    *,
    'Economy' AS class
FROM
    economy
UNION ALL
SELECT
    *,
    'Business' AS class
FROM
    business;
    
    



drop table combined_flights;



CREATE TABLE combined_flights AS
SELECT
    *,  
    'Economy' AS class
FROM
    economy
UNION ALL
SELECT
    *, -- Using '*' ensures we get all columns
    'Business' AS class
FROM
    business;
    
alter table combined_flights
drop column duration_minutes;

ALTER TABLE combined_flights ADD COLUMN price_cleaned INT;
ALTER TABLE combined_flights ADD COLUMN stops_cleaned INT;
ALTER TABLE combined_flights ADD COLUMN duration_minutes DECIMAL(10,2);

SET SQL_SAFE_UPDATES = 0;

UPDATE combined_flights
SET price_cleaned = CAST(TRIM(REPLACE(price, ',', '')) AS UNSIGNED);


UPDATE combined_flights
SET stops_cleaned = CASE
    WHEN TRIM(stop) LIKE 'non-stop%' THEN 0
    ELSE CAST(SUBSTRING(TRIM(stop), 1, 1) AS UNSIGNED)
END;



UPDATE combined_flights
SET duration_minutes = (
    (CASE
        WHEN LOCATE('h', time_taken) > 0
        THEN CAST(REGEXP_SUBSTR(time_taken, '[0-9]+(\\.[0-9]+)?') AS DECIMAL(10,2))
        ELSE 0.0
    END * 60)
    +
    (CASE
        WHEN LOCATE('h', time_taken) > 0 AND LOCATE('m', time_taken) > 0
        THEN CAST(REGEXP_SUBSTR(SUBSTRING(time_taken, LOCATE('h', time_taken) + 1), '[0-9]+') AS DECIMAL(10,2))
        WHEN LOCATE('h', time_taken) = 0 AND LOCATE('m', time_taken) > 0
        THEN CAST(REGEXP_SUBSTR(time_taken, '[0-9]+') AS DECIMAL(10,2))
        ELSE 0.0
    END)
);

ALTER TABLE combined_flights
ADD COLUMN journey_date DATE;


UPDATE combined_flights
SET journey_date = STR_TO_DATE(date, '%d-%m-%Y');

select source_city from combined_flights;


ALTER TABLE combined_flights
ADD COLUMN departure_time TIME;


UPDATE combined_flights
SET departure_time = CAST(dep_time AS TIME);


select departure_time from combined_flights;


ALTER TABLE combined_flights
ADD COLUMN arrival_time TIME;


UPDATE combined_flights
SET arrival_time = CAST(arr_time AS TIME);

ALTER TABLE combined_flights
ADD COLUMN flight_number VARCHAR(20);

-- Turn off safe update mode first
SET SQL_SAFE_UPDATES = 1;

-- Now run the update
UPDATE combined_flights
SET flight_number = CONCAT(ch_code, '-', num_code);


SELECT
    airline,
    class,
    ROUND(AVG(price_cleaned)) AS average_price
FROM
    combined_flights
GROUP BY
    airline,
    class
ORDER BY
    airline,
    average_price DESC ;
    
    
SELECT
source_city,
destination_city,
ROUND(AVG(price_cleaned)) AS average_price,
COUNT(*) AS number_of_flights
FROM
    combined_flights
GROUP BY
    source_city,
    destination_city
ORDER BY
    average_price 
LIMIT 10;


SELECT
    class,
    stops_cleaned,
    ROUND(AVG(price_cleaned)) AS average_price
FROM
    combined_flights
GROUP BY
    class,
    stops_cleaned
ORDER BY
    class,
    stops_cleaned;
    
SELECT
source_city,
destination_city,
COUNT(*) AS number_of_flights
FROM
    combined_flights
GROUP BY
    source_city,
    destination_city
ORDER BY
    number_of_flights DESC
LIMIT 10;


SELECT
    airline,
    ROUND(AVG(duration_minutes)) AS avg_duration_in_minutes
FROM
    combined_flights
WHERE
    source_city = 'Delhi' AND destination_city = 'Mumbai'
GROUP BY
    airline
ORDER BY
    avg_duration_in_minutes ASC;
    
    
SELECT
airline,
ROUND(AVG(duration_minutes)) AS avg_duration_in_minutes
FROM
    combined_flights
WHERE
    source_city = 'Delhi' AND destination_city = 'Mumbai'
    AND stops_cleaned = 0  -- This is the new, important filter
GROUP BY
    airline
ORDER BY
    avg_duration_in_minutes ASC;
    
    
    
SELECT
    DAYNAME(journey_date) AS day_of_week,
    ROUND(AVG(price_cleaned)) AS average_price
FROM
    combined_flights
GROUP BY
    day_of_week,
    DAYOFWEEK(journey_date) -- Add this for correct sorting
ORDER BY
    DAYOFWEEK(journey_date); -- Sort chronologically (Sun, Mon, Tue...)
    
    