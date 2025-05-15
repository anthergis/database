/*
    GISY6021 Assignment 3
    Name: Antonio Hernandez
*/

-- add geometry column to CCS table
ALTER TABLE census_consolidated_subdivision
ADD (GEOMETRY SDO_GEOMETRY);

-- adds the necessary geometry metadata for the CCS table. 
insert into user_sdo_geom_metadata 
values (
    'CENSUS_CONSOLIDATED_SUBDIVISION',
    'GEOMETRY',
    sdo_dim_array(
        sdo_dim_element('X', -180, 180, 0.005),
        sdo_dim_element('Y', -90, 90, 0.005)
    ),
    3347
);

-- validates the geometry that has been loaded
SELECT CCS_UID, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(GEOMETRY, 0.005) AS VALIDITY
FROM CENSUS_CONSOLIDATED_SUBDIVISION
WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(GEOMETRY, 0.005) IS NOT NULL;

-- Error number is 13367: wrong orientation for interior/exterior rings

-- statement to fix the error
EXECUTE SDO_MIGRATE.TO_CURRENT('CENSUS_CONSOLIDATED_SUBDIVISION');

-- add a spatial index to the geometry column
create index ccs_idx 
on CENSUS_CONSOLIDATED_SUBDIVISION (GEOMETRY)
indextype is mdsys.spatial_index_v2;


-- ANALYSIS
-- Query that includes the province name, the area of the province and the area of potatoes grown as a proportion of the total province area in square kilometres

SELECT 
    p.PROVINCE_NAME AS "Province Name",
    SUM(COGS_CONVERT_UNIT(SDO_GEOM.SDO_AREA(ccs.GEOMETRY, 0.005), 'SQ_METER', 'SQ_KILOMETER')) AS "Area in Square Kilometers",
    SUM(COGS_CONVERT_UNIT(r.CROP_AREA_HA, 'HECTARE', 'SQ_KILOMETER')) /
    SUM(COGS_CONVERT_UNIT(SDO_GEOM.SDO_AREA(ccs.GEOMETRY, 0.005), 'SQ_METER', 'SQ_KILOMETER')) AS "The area of potatoes grown as a proportion of the total province area"
FROM PROVINCE p
JOIN CENSUS_CONSOLIDATED_SUBDIVISION ccs ON ccs.PROVINCE_UID = p.PROVINCE_UID
JOIN REPORT r ON r.CCS_UID = ccs.CCS_UID
JOIN CROP c ON c.CROP_UID = r.CROP_UID
WHERE c.CROP_NAME = 'Potatoes'
GROUP BY p.PROVINCE_NAME;