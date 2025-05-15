CREATE OR REPLACE FUNCTION COGS_CONVERT_UNIT(input_value NUMBER, input_unit VARCHAR2, target_unit VARCHAR2) RETURN NUMBER IS

    -- declare variables for use
    -- stores the FACTOR_B and FACTOR_C for the input unit
    input_factor_b  NUMBER;      
    input_factor_c  NUMBER;
    -- stores the FACTOR_B and FACTOR_C for the target unit         
    target_factor_b  NUMBER;         
    target_factor_c  NUMBER;
    -- stores the unit type for the input unit
    input_type VARCHAR2(50);
    -- stores the unit type for the target unit
    target_type VARCHAR2(50);
    -- stores the SI value of the input unit after conversion
    si_value NUMBER;
    -- stores the converted value of the target unit.
    target_value NUMBER;
    
BEGIN

    -- returns input_value if both units are the same.
    IF lower(input_unit) = lower(target_unit) THEN
        RETURN input_value;

    ELSE

    -- Stores input unit values from the SDO_UNITS_OF_MEASURE table to the respective variables
    SELECT UNIT_OF_MEAS_TYPE, FACTOR_B, FACTOR_C
    INTO input_type, input_factor_b, input_factor_c
    FROM SDO_UNITS_OF_MEASURE

    WHERE lower(SHORT_NAME) = lower(input_unit);

    -- Stores target unit values from the SDO_UNITS_OF_MEASURE table to the respective variables
    SELECT UNIT_OF_MEAS_TYPE, FACTOR_B, FACTOR_C
    INTO target_type, target_factor_b, target_factor_c
    FROM SDO_UNITS_OF_MEASURE
    WHERE lower(SHORT_NAME) = lower(target_unit);

    -- Raise an error if the function is called with units of different types
    IF input_type <> target_type THEN
        RAISE_APPLICATION_ERROR(-20001, 'Units must be of the same type for conversion.');

    END IF;

    -- Convert input unit value to SI unit value
    si_value := input_value * (input_factor_b / input_factor_c);

    -- Convert SI unit value to target unit unit
    target_value := si_value * (target_factor_c / target_factor_b);

    RETURN target_value;

    END IF;

END;

--------- TEST CASES ------------

-- This select statement should return 0.001
select cogs_convert_unit(1, 'metre', 'kilometre')
from dual;

-- This select statement should return 0.001
select cogs_convert_unit(1, 'Metre', 'KILOMETRE')
from dual;

-- This select statement should return 0.001
select cogs_convert_unit(1, 'mEtRe', 'KiLoMeTrE')
from dual;

-- This select statement should cause your error related to
-- converting between units of different types is raised
select cogs_convert_unit(1, 'radian', 'kilometre')
from dual;

--------- ANALYSIS --------------

--  Calculate the area of potatoes grown in each province in acres
SELECT pr.province_name AS "Name of Province", c.crop_name AS "Name of Crop", COGS_CONVERT_UNIT(SUM(r.crop_area_ha), 'hectare', 'acre') AS "Total Area in Acres"
FROM REPORT r
INNER JOIN CCS s
ON r.ccs_uid = s.ccs_uid
INNER JOIN PROVINCE pr
ON s.province_uid = pr.province_uid
INNER JOIN CROP c
ON r.crop_uid = c.crop_uid
WHERE c.crop_name = 'Potatoes'
GROUP BY pr.province_name, c.crop_name;