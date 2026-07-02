SELECT
		 "PMS"."Pack Mtrl Name",
		 MAX("PMBS"."Rate Per Qnty") AS "Rate",
		 SUM("PMS"."Opening Qnty") AS "Total Opening",
		 SUM("PMS"."Opening Qnty" * "PMBS"."Rate Per Qnty") AS "OPValue",
		 SUM("PMS"."Inward Bags") AS "Total Inward",
		 SUM("PMS"."Inward Bags" * "PMBS"."Rate Per Qnty") AS "INValue",
		 SUM("PMS"."Outward Bags") AS "Total Outward",
		 SUM("PMS"."Outward Bags" * "PMBS"."Rate Per Qnty") AS "OUTValue",
		 SUM("PMS"."Opening Qnty" + "PMS"."Inward Bags" -"PMS"."Outward Bags") AS "Balance",
		 SUM(("PMS"."Opening Qnty" + "PMS"."Inward Bags" -"PMS"."Outward Bags") * "PMBS"."Rate Per Qnty") AS "BalValue"
FROM  "PM Stock" AS  "PMS"
LEFT JOIN "PM Balance Sheet" AS  "PMBS" ON "PMS"."Pack Mtrl Name"  = "PMBS"."Pack Mtrl Name"  
WHERE	 "PMS"."Status"  = 'Active'
 AND	"PMBS"."Rate Per Qnty"  > 0 
 AND	"PMBS"."Form Name"  = 'QC Update Popup'
GROUP BY  "PMS"."Pack Mtrl Name" 
ORDER BY "PMS"."Pack Mtrl Name" ASC 



////////////////////////////////

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
		 ("PMS"."Opening Qnty" * COALESCE("LR"."Rate Per Qnty", 0)) AS "OPValue",
		 "PMS"."Inward Bags" AS "Total Inward",
		 ("PMS"."Inward Bags" * COALESCE("LR"."Rate Per Qnty", 0)) AS "INValue",
		 "PMS"."Outward Bags" AS "Total Outward",
		 ("PMS"."Outward Bags" * COALESCE("LR"."Rate Per Qnty", 0)) AS "OUTValue",
		 ("PMS"."Opening Qnty" + "PMS"."Inward Bags" -"PMS"."Outward Bags") AS "Balance",
		 (("PMS"."Opening Qnty" + "PMS"."Inward Bags" -"PMS"."Outward Bags") * COALESCE("LR"."Rate Per Qnty", 0)) AS "BalValue"
FROM  "PM Stock" AS  "PMS"
LEFT JOIN LatestRates AS  "LR" ON "PMS"."Pack Mtrl Name"  = "LR"."Pack Mtrl Name"
	 AND	"LR"."rn"  = 1 /* Sirf latest rate wali row join karega*/
  
WHERE	 "PMS"."Status"  = 'Active'
 