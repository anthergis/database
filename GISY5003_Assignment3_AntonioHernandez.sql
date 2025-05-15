--
--	Program: GISY5003_Assignment3_AntonioHernandez.sql
--	Programmer: Antonio Hernandez
--	Date: November 17l 2024
--	Purpose: To complete the list of queries for Assignment 3 in GISY5003
--

--------------------------------------------------------------
-- SINGLE TABLE QUERIES
--------------------------------------------------------------

-- 1. Display the date and time of readings that were in motion in July 2004, sorted by date and time.

SELECT readdatetime AS "Date and Time of Motion Readings in July 2004"
FROM reading
WHERE motion = 'true' AND readdatetime BETWEEN '2004-07-01' AND '2004-07-31'
ORDER by readdatetime;
	
-- 2. Display the reading ID and date and time for readings with a speed greater than 100, sorted by date and time.

SELECT id AS "ID of Readings with a speed greater than 100", readdatetime AS "Date and Time" 
FROM reading 
WHERE speed > '100' 
ORDER BY readdatetime;

-- 3. In 2006, show the names of projects that started in that year, sorted by date.

SELECT name AS "Name of Projects that started in 2006", to_char(startdate, 'DD Mon YYYY') AS "Starting Date"
FROM project
WHERE startdate BETWEEN '2006-01-01' AND '2006-12-31'
ORDER by startdate;

-- 4. In the city of Halifax, show the concatenated “Last, First” name of persons of interest, sorted by last then first POI name.

SELECT lastname || ', ' || firstname AS "Persons of Interest in Halifax"
FROM poi
WHERE city like 'Halifax'
ORDER BY lastname, firstname;

--------------------------------------------------------------
-- MULTIPLE TABLE QUERIES
--------------------------------------------------------------

-- 5. List the concatenated “Last, First” name of persons of interest and their vehicle make and model
-- associated with GPS serial number 254, sorted by last then first POI name.

SELECT p.lastname || ', ' || p.firstname AS "Persons of Interest", v.make || ' ' || v.model  AS "Vehicles Associated with GPS Serial Number 254"
FROM poi p INNER JOIN vehicle v
ON p.poiid = v.poiid
WHERE v.gps = '254'
ORDER by p.lastname, p.firstname;

-- 6. List the concatenated ‘latitude, longitude’ for all readings in September 2004 (showing the date column)
-- that contain ‘Call’ in their record type description, sorted by latitude.

SELECT r.latitude || ', ' || r.longitude AS "Latitude and Longitude for Call Readings in September 2004", r.readdatetime AS "Date"
FROM reading r INNER JOIN rectype rt
ON r.recordtype = rt.rectypeid
WHERE rt.description like '%Call%' AND r.readdatetime BETWEEN '2004-09-01' AND '2004-09-30'
ORDER BY r.latitude;

-- 7. List the project name, and the concatenated “Last, First” name of persons of interest and police associated with the project,
-- for all projects, sorted by project name.

SELECT pj.name AS "Project Name", p.lastname || ', ' || p.firstname AS "Persons of Interest", pl.lastname || ', ' || pl.firstname AS "Police"
FROM project pj INNER JOIN poi p
ON pj.poiid = p.poiid
INNER JOIN projpolice pp
ON pj.projectid = pp.projectid
INNER JOIN police pl
ON pp.policeid = pl.policeid
ORDER by pj.name;

----------------------------------------------------------------
-- OUTER JOIN
----------------------------------------------------------------

-- 8. List all GPS units Models and Serial Numbers and any Vehicle VIN, Make and Model that they are/were attached to,
-- sorted by GPS Serial Number.

SELECT g.model AS "GPS Models", g.serialnumber AS "GPS Serial Numbers", v.vin AS "Vehicle Identification Number", v.make AS "Vehicle's Make", v.model AS "Vehicle's Models"
FROM gpsunit g LEFT JOIN vehicle v
ON g.serialnumber = v.gps
ORDER BY g.serialnumber;

----------------------------------------------------------------
-- SUBQUERY
----------------------------------------------------------------

-- 9. How many readings were above the average speed, for readings that had a speed greater than 0?

SELECT count(id) AS "Number of Readings above the average that are greater than 0"
FROM reading
WHERE speed >
(SELECT avg(speed)
	FROM reading 
	WHERE speed > 0);

----------------------------------------------------------------
-- AGGREGATE
----------------------------------------------------------------

--10. What are the extents of the readings – i.e. the maximum and minimum longitude and latitude of GPS FIX readings?

SELECT max(latitude) ||', ' || max(longitude) AS "Maximum Extent of GPS FIX readings", min(latitude) ||', '|| min(longitude) AS "Minumum Extent of GPS FIX reading"
FROM reading r INNER JOIN rectype rt
ON r.recordtype = rt.rectypeid
WHERE r.recordtype = 'GPS FIX';

----------------------------------------------------------------
-- GROUP BY
----------------------------------------------------------------

-- 11. List the average latitude and longitude for each record type.

SELECT recordtype AS "Record Type", avg(latitude)::numeric(5,3) AS "Average Latitude", avg(longitude)::numeric(5,3) AS "Average Longitude" 
FROM reading
GROUP BY recordtype;

-- 12. List the dates and the corresponding total number GPS FIX readings taken on each day. 
-- Only show the dates where the total number of GPS FIX readings is more than 30 in a day? Sorted from the most to the least readings per day.

SELECT 
    to_char(readdatetime, 'DD Mon YYYY') AS "Date",
    COUNT(*) AS "Total Number of GPS FIX Readings Taken"
FROM reading
WHERE recordtype = 'GPS FIX'
GROUP BY TO_CHAR(readdatetime, 'DD Mon YYYY')
HAVING count(*) > 30
ORDER BY "Total Number of GPS FIX Readings Taken" DESC;
