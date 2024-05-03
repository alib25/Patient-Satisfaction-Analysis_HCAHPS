-- SELECT *
-- FROM "postgres"."Hospital_Data".hcahps_data; 

CREATE TABLE "postgres"."Hospital_Data".Tableau_File AS

WITH hospital_beds_prep AS
(
SELECT  lpad(CAST(provider_ccn AS text),6,'0') AS provider_ccn,
		hospital_name,
		to_date(fiscal_year_begin_date,'MM/DD/YYYY') AS fiscal_year_begin_date,
		to_date(fiscal_year_end_date, 'MM/DD/YYYY') AS fiscal_year_end_date,
		number_of_beds,
		row_number() OVER (PARTITION BY provider_ccn ORDER BY to_date(fiscal_year_end_date,'MM/DD/YYYY') DESC) AS nth_row 
FROM "postgres"."Hospital_Data".hospital_beds
)

-- SELECT provider_ccn, COUNT(*) AS count_of_rows
--FROM hospital_beds_prep
-- WHERE nth_row = 1 
-- GROUP BY provider_ccn
-- ORDER BY COUNT(*) DESC;


SELECT  lpad(CAST(facility_id AS text),6,'0') AS provider_ccn
		,to_date(start_date,'MM/DD/YYYY') AS start_date_converted
		,to_date(end_date, 'MM/DD/YYYY') AS end_date_converted
		,hcahps.*
		,beds.number_of_beds
		,beds.fiscal_year_begin_date AS beds_start_report_period
		,beds.fiscal_year_end_date AS beds_end_report_perior
FROM "postgres"."Hospital_Data".hcahps_data AS hcahps
LEFT JOIN hospital_beds_prep AS beds
ON lpad(CAST(facility_id AS text),6,'0') = beds.provider_ccn
AND beds.nth_row = 1 

