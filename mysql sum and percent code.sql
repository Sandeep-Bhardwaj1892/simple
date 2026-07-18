SELECT
		 fd."Paddy Variety" AS "Paddy Variety",
		 fd."Process Type" AS "Process Type",
		 SUM(fd."Total Paddy Input") AS "Total Paddy Input",
		 /* Brown Rice — Hulling only */
		 SUM(CASE
				 WHEN fd."Process Type"  = 'Hulling' THEN fd."Total Rice Output"
				 ELSE 0
			 END) AS "Total Brown Rice",
		 /* White Rice — Milling only */ 
		 SUM(CASE
				 WHEN fd."Process Type"  = 'Milling' THEN fd."Total Rice Output"
				 ELSE 0
			 END) AS "Total White Rice",
		 SUM(fd."Total Husk") AS "Total Husk",
		 SUM(fd."Total Bran") AS "Total Bran",
		 SUM(fd."Total Broken") AS "Total Broken",
		 SUM(fd."Total Broken 2/3") AS "Total Broken 2/3",
		 SUM(fd."Total Param") AS "Total Param",
		 SUM(fd."Total Laldana") AS "Total Laldana",
		 SUM(fd."Total DGR") AS "Total DGR",
		 SUM(fd."Total Discolour") AS "Total Discolour",
		 SUM(fd."Total Wastage") AS "Total Wastage",
		 /* Yield % */ 
		 ROUND(SUM(CASE
				 WHEN fd."Process Type"  = 'Hulling' THEN fd."Total Rice Output"
				 ELSE 0
			 END) / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "Brown Rice Yield %",
		 ROUND(SUM(CASE
				 WHEN fd."Process Type"  = 'Milling' THEN fd."Total Rice Output"
				 ELSE 0
			 END) / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "White Rice Yield %",
		 ROUND(SUM(fd."Total Husk") / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "Husk Yield %",
		 ROUND(SUM(fd."Total Bran") / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "Bran Yield %",
		 ROUND(SUM(fd."Total Broken") / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "Broken Yield %",
		 ROUND(SUM(fd."Total Broken 2/3") / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "Broken 2/3 Yield %",
		 ROUND(SUM(fd."Total Param") / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "Param Yield %",
		 ROUND(SUM(fd."Total Laldana") / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "Laldana Yield %",
		 ROUND(SUM(fd."Total DGR") / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "DGR Yield %",
		 ROUND(SUM(fd."Total Discolour") / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "Discolour Yield %",
		 ROUND(SUM(fd."Total Wastage") / NULLIF(SUM(fd."Total Paddy Input"), 0) * 100, 2) AS "Wastage Yield %"
FROM (
	/* Prod Entry — Rice output and Paddy Input */
	SELECT
			 "Variety" AS "Paddy Variety",
			 "Process" AS "Process Type",
			 SUM("Paddy Out Qnty") AS "Total Paddy Input",
			 SUM(COALESCE("Rice Qnty1", 0) + COALESCE("Rice Qnty2", 0) + COALESCE("Rice Qnty3", 0) + COALESCE("Rice Qnty4", 0)) AS "Total Rice Output",
			 0 AS "Total Husk",
			 0 AS "Total Bran",
			 0 AS "Total Broken",
			 0 AS "Total Broken 2/3",
			 0 AS "Total Param",
			 0 AS "Total Laldana",
			 0 AS "Total DGR",
			 0 AS "Total Discolour",
			 0 AS "Total Wastage"
	FROM  "Prod Entry" 
	WHERE	 "Added Time"  >= '2026-04-01'
	 AND	"Process"  IN ( 'Hulling'  , 'Milling'  )
	GROUP BY "Variety",
		  "Process" 
	UNION ALL
 /* Prod Entry GP — By-products only, mapped to both Hulling and Milling */
	SELECT
			 "Paddy Variety" AS "Paddy Variety",
			 'Milling' AS "Process Type",
			 0 AS "Total Paddy Input",
			 0 AS "Total Rice Output",
			 COALESCE(SUM("Husk Qnty"), 0) AS "Total Husk",
			 COALESCE(SUM("Bran Qnty"), 0) AS "Total Bran",
			 COALESCE(SUM("Broken Qnty"), 0) AS "Total Broken",
			 COALESCE(SUM("Broken 2_3 Qnty"), 0) AS "Total Broken 2/3",
			 COALESCE(SUM("Param Qnty"), 0) AS "Total Param",
			 COALESCE(SUM("Laldana Qnty"), 0) AS "Total Laldana",
			 COALESCE(SUM("DGR Qnty"), 0) AS "Total DGR",
			 COALESCE(SUM("Discolour Qnty"), 0) AS "Total Discolour",
			 COALESCE(SUM("Wastage Qnty"), 0) AS "Total Wastage"
	FROM  "Prod Entry GP" 
	WHERE	 "Added Time"  >= '2026-04-01'
	GROUP BY  "Paddy Variety" 
 
) fd 
GROUP BY fd."Paddy Variety",
	  fd."Process Type" 
ORDER BY fd."Paddy Variety",
	 fd."Process Type" 
