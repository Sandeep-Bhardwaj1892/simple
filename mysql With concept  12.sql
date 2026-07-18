SELECT
		 pu."Lot No" AS "Lot No",
		 pu."Variety Name" AS "Variety Name",
		 lm."Opening Qnty" AS "Opening Balance",
		 pu."Inward" AS "Inward",
		 COALESCE(k."Outward", 0) AS "Outward",
		 (lm."Opening Qnty" + pu."Inward" -COALESCE(k."Outward", 0)) AS "Balance"
FROM (	SELECT
			 "Lot No",
			 "Variety Name",
			 SUM("Qnty") AS "Inward"
	FROM  "Paddy Unloading" 
	WHERE	 "Added Time"  >= '2026-04-01 00:00:00'
	GROUP BY "Lot No",
		  "Variety Name" 
) pu
LEFT JOIN(	SELECT
			 "From Lot",
			 "Variety",
			 SUM("Paddy Qnty") AS "Outward"
	FROM  "Katwai" 
	WHERE	 "Added Time"  >= '2026-04-01'
	GROUP BY "From Lot",
		  "Variety" 
) k ON pu."Lot No"  = k."From Lot"
	 AND	pu."Variety Name"  = k."Variety" 
INNER JOIN "Lot Master" lm ON pu."Lot No"  = lm."Lot No"  
