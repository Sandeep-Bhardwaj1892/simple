SELECT
		 pe."From Bin" AS "From Bin",
		 pe."To Bin 1" AS "To Bin 1",
		 k."From Lot" AS "Lot No",
		 k."Total Paddy From Lot to Bin" AS "Total Paddy From Lot to Bin",
		 pe."Total Paddy Outward" AS "Total Paddy Outward",
		 pe."Total Rice Inward" AS "Total Rice Inward",
		 pe."Total Paddy Outward Per From Bin" AS "Total Paddy Outward Per From Bin",
		 pe."Total Rice Inward Per To Bin 1" AS "Total Rice Inward Per To Bin 1"
FROM (	SELECT
			 "From Bin",
			 "To Bin 1",
			 SUM("Paddy Out Qnty") AS "Total Paddy Outward",
			 SUM("Rice Qnty1") AS "Total Rice Inward",
			 SUM(SUM("Paddy Out Qnty")) OVER(PARTITION BY "From Bin"  ) AS "Total Paddy Outward Per From Bin",
			 SUM(SUM("Rice Qnty1")) OVER(PARTITION BY "To Bin 1"  ) AS "Total Rice Inward Per To Bin 1"
	FROM  "Prod Entry" 
	WHERE	 "Added Time"  >= '2026-04-01'
	GROUP BY "From Bin",
		  "To Bin 1" 
) pe
INNER JOIN(	SELECT
			 "To Bin",
			 "From Lot",
			 SUM("Paddy Qnty") AS "Total Paddy From Lot to Bin"
	FROM  "Katwai" 
	WHERE	 "Added Time"  >= '2026-04-01'
	GROUP BY "To Bin",
		  "From Lot" 
) k ON k."To Bin"  = pe."From Bin"  
ORDER BY pe."From Bin",
	 k."From Lot" 
