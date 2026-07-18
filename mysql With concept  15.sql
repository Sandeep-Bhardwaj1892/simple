WITH LatestRates AS (SELECT
		 "Pack Mtrl Name",
		 "Rate Per Qnty",
		 ROW_NUMBER() OVER(PARTITION BY "Pack Mtrl Name"  ORDER BY "Added Time" DESC ) as rn
FROM  "PM Balance Sheet" 
WHERE	 "Rate Per Qnty"  > 0)
SELECT
		 "PMS"."Pack Mtrl Name",
		 COALESCE("LR"."Rate Per Qnty", 0) AS "Rate",
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
	 AND	"LR"."rn"  = 1  
WHERE	 "PMS"."Status"  = 'Active'
 AND	"LR"."Rate Per Qnty"  > 0
 