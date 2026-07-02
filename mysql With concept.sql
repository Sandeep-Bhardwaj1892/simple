WITH LatestRates AS (SELECT
		 "Pack Mtrl Name",
		 "Rate Per Qnty",
		 ROW_NUMBER() OVER(PARTITION BY "Pack Mtrl Name"  ORDER BY "Added Time" DESC ) as rn
FROM  "PM Balance Sheet" 
WHERE	 "Rate Per Qnty"  > 0)
SELECT
		 "PMS"."Pack Mtrl Name",
		 /* Agar Rate nahi mila (NULL), toh 0 dikhayega*/ COALESCE("LR"."Rate Per Qnty", 0) AS "Rate",
		 "PMS"."Opening Qnty" AS "Total Opening",
		 ("PMS"."Opening Qnty" * COALESCE("LR"."Rate Per Qnty", 0)) AS "OP Value",
		 "PMS"."Inward Bags" AS "Total Inward",
		 ("PMS"."Inward Bags" * COALESCE("LR"."Rate Per Qnty", 0)) AS "IN Value",
		 "PMS"."Outward Bags" AS "Total Outward",
		 ("PMS"."Outward Bags" * COALESCE("LR"."Rate Per Qnty", 0)) AS "OUT Value",
		 ("PMS"."Opening Qnty" + "PMS"."Inward Bags" -"PMS"."Outward Bags") AS "Balance",
		 (("PMS"."Opening Qnty" + "PMS"."Inward Bags" -"PMS"."Outward Bags") * COALESCE("LR"."Rate Per Qnty", 0)) AS "Bal Value"
FROM  "PM Stock" AS  "PMS"
LEFT JOIN LatestRates AS  "LR" ON "PMS"."Pack Mtrl Name"  = "LR"."Pack Mtrl Name"
	 AND	"LR"."rn"  = 1 /* Sirf latest rate wali row join karega*/
  
WHERE	 "PMS"."Status"  = 'Active'
 AND	"LR"."Rate Per Qnty"  > 0
 




 ////////////////////////////////////////////
 SELECT
    combined.shift_date,
    combined.shift_no,
    MAX(combined.shift_name) AS shift_name,
    combined.variety,

    SUM(COALESCE(combined.inward_qty,0)) AS total_inward_qty,
    SUM(COALESCE(combined.inward_bags,0)) AS total_inward_bags,

    SUM(COALESCE(combined.outward_qty,0)) AS total_outward_qty,
    SUM(COALESCE(combined.outward_bags,0)) AS total_outward_bags

FROM
(
    /* INWARD DATA */
    SELECT

        CASE
            WHEN HOUR(modified_time) >= 0
             AND HOUR(modified_time) < 6
            THEN SUBDATE(DATE(modified_time),1)

            ELSE DATE(modified_time)
        END AS shift_date,

        CASE
            WHEN HOUR(modified_time) >= 6
             AND HOUR(modified_time) < 14
            THEN 1

            WHEN HOUR(modified_time) >= 14
             AND HOUR(modified_time) < 22
            THEN 2

            ELSE 3
        END AS shift_no,

        CASE
            WHEN HOUR(modified_time) >= 6
             AND HOUR(modified_time) < 14
            THEN 'Shift 1'

            WHEN HOUR(modified_time) >= 14
             AND HOUR(modified_time) < 22
            THEN 'Shift 2'

            ELSE 'Shift 3'
        END AS shift_name,

        variety,

        qty AS inward_qty,
        1 AS inward_bags,

        0 AS outward_qty,
        0 AS outward_bags

    FROM inward_stock
    WHERE unit = 'UNIT 2'

    UNION ALL

    /* OUTWARD DATA */
    SELECT

        CASE
            WHEN HOUR(modified_time) >= 0
             AND HOUR(modified_time) < 6
            THEN SUBDATE(DATE(modified_time),1)

            ELSE DATE(modified_time)
        END AS shift_date,

        CASE
            WHEN HOUR(modified_time) >= 6
             AND HOUR(modified_time) < 14
            THEN 1

            WHEN HOUR(modified_time) >= 14
             AND HOUR(modified_time) < 22
            THEN 2

            ELSE 3
        END AS shift_no,

        CASE
            WHEN HOUR(modified_time) >= 6
             AND HOUR(modified_time) < 14
            THEN 'Shift 1'

            WHEN HOUR(modified_time) >= 14
             AND HOUR(modified_time) < 22
            THEN 'Shift 2'

            ELSE 'Shift 3'
        END AS shift_name,

        variety,

        0 AS inward_qty,
        0 AS inward_bags,

        qty AS outward_qty,
        1 AS outward_bags

    FROM outward_stock
    WHERE from_unit = 'UNIT 2'
      AND to_unit = 'UNIT 1'

) combined

GROUP BY
    combined.shift_date,
    combined.shift_no,
    combined.variety

ORDER BY
    combined.shift_date,
    combined.shift_no,
    combined.variety;