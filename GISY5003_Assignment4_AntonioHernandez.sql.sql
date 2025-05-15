--
--	Program: GISY5003_Assignment4_AntonioHernandez.sql
--	Programmer: Antonio Hernandez
--	Date: December 4, 2024
--	Purpose: To create and populate tables for the State Parks database.
--

---------------------------------------------------------------------------------------
-- PART A: CREATE AND POPULATE STATE PARK TABLES
---------------------------------------------------------------------------------------

-- CREATE TABLES

-- drop tables from database if they exists
DROP TABLE IF EXISTS facility CASCADE;
DROP TABLE IF EXISTS river CASCADE;
DROP TABLE IF EXISTS road CASCADE;
DROP TABLE IF EXISTS foreststand CASCADE;
DROP TABLE IF EXISTS forest CASCADE;

-- create table for the "facility" entity
CREATE TABLE facility(
    facilityid SERIAL PRIMARY KEY,
	name VARCHAR(50),
	facilitycode CHAR(2)
);

-- create table for the "river" entity
CREATE TABLE river(
    riverid SERIAL PRIMARY KEY,
	name VARCHAR(50)
);

-- create table for the "road" entity
CREATE TABLE road(
	roadid SERIAL PRIMARY KEY,
	name VARCHAR(50),
	composition CHAR(2)
);

-- create table for the "forest stand" entity
CREATE TABLE foreststand(
	foreststandid SERIAL PRIMARY KEY,
	species VARCHAR(50)
);

-- create table for the "forest" entity
CREATE TABLE forest(
	forestid SERIAL PRIMARY KEY,
	name VARCHAR(50)
);

-- ALTER TABLES

-- drop columns from tables if they exist
ALTER TABLE facility DROP COLUMN IF EXISTS shape;
ALTER TABLE river DROP COLUMN IF EXISTS shape;
ALTER TABLE road DROP COLUMN IF EXISTS shape;
ALTER TABLE foreststand DROP COLUMN IF EXISTS shape;
ALTER TABLE forest DROP COLUMN IF EXISTS shape;


-- adds point geometry column to facility table
ALTER TABLE facility ADD COLUMN shape geometry('POINT',0,2);

-- adds line geometry column to river table
ALTER TABLE river ADD COLUMN shape geometry('LINESTRING',0,2);

-- adds line geometry column to road table
ALTER TABLE road ADD COLUMN shape geometry('LINESTRING',0,2);

-- adds polygon geometry column to foreststand table
ALTER TABLE foreststand ADD COLUMN shape geometry('POLYGON',0,2);

-- adds polygon geometry column to forest table
ALTER TABLE forest ADD COLUMN shape geometry('POLYGON',0,2);

--- POPULATE TABLES

-- drop records from tables
DELETE FROM facility;
DELETE FROM river;
DELETE FROM road;
DELETE FROM forest;
DELETE FROM foreststand;

-- adds records to facility table
INSERT INTO facility (name, facilitycode, shape) VALUES 
('Outlander', 'CG', ST_GeomFromText('POINT(5.000 32.000)',0)),
('Park Ranger', 'OF', ST_GeomFromText('POINT(16.000 6.000)',0)),
('River Rider', 'CG', ST_GeomFromText('POINT(9.000 18.000)',0)),
('Treeview', 'CG', ST_GeomFromText('POINT(10.000 16.000)',0)),
('NorthEast Office', 'OF', ST_GeomFromText('POINT(22.000 28.000)',0));

-- adds records to river table
INSERT INTO river (name, shape) VALUES 
('Old Man River', ST_GeomFromText('LINESTRING(11.000 3.000, 11.000 16.000, 4.000 35.000)',0)),
('Annapolis River', ST_GeomFromText('LINESTRING(17.500 5.000, 16.000 12.000, 19.500 17.000, 22.500 28.000, 36.000 19.000)',0));

-- adds records to road tabe
INSERT INTO road (name,composition, shape) VALUES
('Backwoods Road', 'PV', ST_GeomFromText('LINESTRING(16.000 4.000, 15.000 11.000, 14.000 15.000, 14.000 26.000, 5.000 32.000)',0)),
('Old Clements Road', 'GR', ST_GeomFromText('LINESTRING(3.000 10.000, 11.000 22.000, 19.000 22.000, 19.000 36.000)',0)),
('UpDown Road', 'GR', ST_GeomFromText('LINESTRING(26.000 5.000, 22.000 15.000, 23.000 26.000, 23.000 34.000)',0)),
('NorthSouth Road', 'PV', ST_GeomFromText('LINESTRING(18.500 5.000, 18.500 9.000, 24.500 17.000, 24.500 33.000)',0)),
('Bourbon Street', 'GR', ST_GeomFromText('LINESTRING(9.000 3.000, 9.000 10.000, 5.000 21.000, 5.000 35.000)',0)),
('ABC Road', 'PV', ST_GeomFromText('LINESTRING(23.000 5.000, 20.000 16.000, 6.500 20.500, 4.000 30.000)',0));

-- adds records to forest table
INSERT INTO forest (name, shape) VALUES
('Keji Forest', ST_GeomFromText('POLYGON((1.500 8.000, 6.000 2.000, 26.500 2.000, 26.500 32.000, 19.000 37.000, 2.000 37.000, 1.500 8.000))', 0)),
('Spooky Old Forest', ST_GeomFromText('POLYGON((6.000 4.000, 11.000 4.000, 13.000 5.000, 11.000 5.000, 7.000 6.000, 4.000 8.000, 3.000 9.000, 2.000 10.000, 3.000 7.000, 6.000 4.000))', 0));

-- adds records to foreststand table
INSERT INTO foreststand (species, shape) VALUES
('Oak', ST_GeomFromText('POLYGON((13.000 5.000, 26.000 12.000, 26.000 20.000, 14.000 15.000, 15.000 11.000, 13.000 5.000))',0)),
('Mixed', ST_GeomFromText('POLYGON((15.000 5.000, 26.000 5.000, 26.000 12.000, 15.000 5.000))',0)),
('Beech', ST_GeomFromText('POLYGON((14.000 15.000, 26.000 20.000, 26.000 26.000, 20.000 23.000, 17.000 24.000, 14.000 21.000, 14.000 15.000))',0)),
('Spruce', ST_GeomFromText('POLYGON((20.000 23.000, 26.000 26.000, 26.000 32.000, 25.000 33.000, 19.000 36.000, 14.000 35.000, 14.000 26.000, 20.000 23.000))',0)),
('Ash', ST_GeomFromText('POLYGON((9.000 20.000, 14.000 20.000, 14.000 35.000, 4.000 30.000, 9.000 20.000))',0)),
('Cat Spruce', ST_GeomFromText('POLYGON((4.000 30.000, 14.000 35.000, 4.000 35.000, 4.000 30.000))',0)),
('Pine', ST_GeomFromText('POLYGON((2.000 10.000, 10.000 18.000, 4.000 30.000, 2.000 10.000))',0)),
('Elm', ST_GeomFromText('POLYGON((2.000 10.000, 13.000 5.000, 15.000 11.000, 14.000 15.000, 14.000 20.000, 9.000 20.000, 10.000 18.000, 2.000 10.000 ))',0));

------------------------------------------------------------------------------
-- PART B: QUERIES
------------------------------------------------------------------------------

-- 1. What is the area of the largest stand?

SELECT ST_Area(shape) AS "Area of the largest stand (grid units)"
FROM foreststand
WHERE ST_Area(shape) = (
SELECT max(ST_Area(shape) )
FROM foreststand
);

-- 2. What is the area of the Beech stand?

SELECT ST_Area(shape) AS "Area (grid units) of the Beech stand"
FROM foreststand
WHERE species = 'Beech';

-- 3. List the total length of roads, by composition (i.e., gravel and paved).

SELECT composition AS "Road Composition", 
ROUND(sum(ST_Length(shape))::numeric, 2) AS "Total Length (grid units)"
FROM road
GROUP BY composition;

-- 4. How long is the shortest road?

SELECT round(ST_Length(shape)::numeric, 2) AS "Length of the shortest road (grid units)"
FROM road
WHERE ST_Length(shape) = (SELECT MIN(ST_Length(shape))
FROM road);

-- 5. List the names of facilities within the Spruce stand.

SELECT f.name AS "Names of Facilities within the Spruce Stand"
FROM facility f
JOIN foreststand s ON ST_Within(f.shape, s.shape)
WHERE s.species = 'Spruce';

-- 6. List the stands that Old Man River crosses.

SELECT f.species AS "List of Forest Stands that Old Man River crosses"
FROM foreststand f
JOIN river r ON ST_Intersects(f.shape, r.shape)
WHERE r.name = 'Old Man River';

-- 7. List the names of roads that cross rivers, and the rivers they cross.

SELECT ro.name AS "Roads that cross rivers", ri.name AS "Rivers they cross"
FROM road ro
JOIN river ri ON ST_Intersects(ro.shape, ri.shape)
ORDER BY ro.name;

-- 8. What is the distance between the Treeview and the River Rider facilities?

SELECT round(ST_Distance(
(SELECT shape FROM facility WHERE name = 'Treeview'),
(SELECT shape FROM facility WHERE name = 'River Rider'))::numeric, 2)
AS "Distance between Treeview and River Rider facilities (grid units)";

-- 9. What is the distance between the NorthEast Office and the Annapolis River?

SELECT ROUND(ST_Distance(f.shape, r.shape)::numeric, 2) AS "Distance between NorthEast Office and Annapolis River (grid units)"
FROM facility f, river r
WHERE f.name = 'NorthEast Office' AND r.name = 'Annapolis River';
	   
-- 10. Which facilities are within 1 map unit of a road, and which road(s) are they close to?

SELECT f.name AS "Facilities within 1 map unit of a road", r.name AS "Roads they are close to"
FROM facility f
JOIN road r
ON ST_DWithin(f.shape, r.shape,.5)
ORDER BY f.name;
