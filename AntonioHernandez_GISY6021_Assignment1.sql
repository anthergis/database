/*

---------------- ASSIGNMENT 1 --------------

Functional Dependancies:

CCS_UID -> CCS_NAME, PROVINCE_UID
PROVINCE_UID -> PROVINCE_NAME
CROP_UID -> CROP_NAME
CCS_UID, CROP_UID -> FARMS_REPORTING, CROP_AREA_HA

*/

-- Set CCS_UID and CROP_UID as primary keys.
ALTER TABLE FIELD_CROPS_HAY
ADD CONSTRAINT FIELD_CROPS_HAY_pk
PRIMARY KEY (CCS_UID, CROP_UID);

/* SECOND NORMAL FORM:

SEPARATE INTO THREE TABLES: CSS + PROVINCE, CROPS, FARMS_REPORTING

*/

-- create CCS table
CREATE TABLE CCS AS
SELECT DISTINCT CCS_UID, CCS_NAME, PROVINCE_UID, PROVINCE_NAME
FROM FIELD_CROPS_HAY
ORDER BY CCS_UID, PROVINCE_UID;

-- Add primary key to CCS table
ALTER TABLE CCS
ADD CONSTRAINT CCS_pk
PRIMARY KEY (CCS_UID);

-- Adds foreign key to original table that references CCS_UID in CCS table
ALTER TABLE FIELD_CROPS_HAY 
ADD CONSTRAINT FIELD_CROPS_HAY_fk 
FOREIGN key (CCS_UID)
REFERENCES CCS(CCS_UID);

-- Delete duplicate columns from the original table
ALTER TABLE FIELD_CROPS_HAY
DROP (CCS_NAME, PROVINCE_UID, PROVINCE_NAME);

-- create crops table since crop name only depends on crop uid and not CSS_UID
CREATE TABLE CROP AS
SELECT DISTINCT CROP_UID, CROP_NAME
FROM FIELD_CROPS_HAY
ORDER BY CROP_UID;

-- Add primary key to crop table
ALTER TABLE CROP
ADD CONSTRAINT CROP_pk
PRIMARY KEY (CROP_UID);

-- Add foreign Key in original table that references CROP_UID in CROP table
ALTER TABLE FIELD_CROPS_HAY
ADD CONSTRAINT FIELD_CROPS_HAY_fk_crop
FOREIGN KEY (CROP_UID)
REFERENCES CROP(CROP_UID);

-- Delete duplicate column in original table
ALTER TABLE FIELD_CROPS_HAY
DROP (CROP_NAME);

/* THIRD NORMAL FORM:

Create a Province table since PROVINCE_NAME does not depend on CSS_UID.

*/

-- Create Province table
CREATE TABLE PROVINCE AS
SELECT DISTINCT PROVINCE_UID, PROVINCE_NAME
FROM CCS;

-- Add primary key to province table
ALTER TABLE PROVINCE
ADD CONSTRAINT PROVINCE_pk
PRIMARY KEY (PROVINCE_UID);

-- Add foreign key to CSS table that references primary key in Province table
ALTER TABLE CCS
ADD CONSTRAINT CCS_fk
FOREIGN KEY (PROVINCE_UID)
REFERENCES PROVINCE(PROVINCE_UID);

-- Drop duplicate column in CSS table
ALTER TABLE CCS
DROP (PROVINCE_NAME);

-- Rename FIELD_CROPS_HAY to REPORT
RENAME FIELD_CROPS_HAY to REPORT;

-- Rename Primary Key in REPORT table
ALTER TABLE REPORT
RENAME CONSTRAINT FIELD_CROPS_HAY_pk TO REPORT_pk;

ALTER INDEX FIELD_CROPS_HAY_pk RENAME TO REPORT_pk;



--  ====================== ANALYSIS =========================

-- Query to calculate the total area of Potatoes grown in PEI.

SELECT p.PROVINCE_NAME AS "Name of Province", c.CROP_NAME AS "Name of crop", sum(r.CROP_AREA_HA) AS "Total area grown"
FROM REPORT r
INNER JOIN CCS s 
ON r.CCS_UID = s.CCS_UID
INNER JOIN PROVINCE p 
ON s.PROVINCE_UID = p.PROVINCE_UID
INNER JOIN CROP c 
ON r.CROP_UID = c.CROP_UID
WHERE p.PROVINCE_NAME = 'Prince Edward Island'
AND c.CROP_NAME = 'Potatoes'
GROUP BY p.PROVINCE_NAME, c.CROP_NAME;