SELECT
		 
			CASE
				 WHEN HOUR(pu."Added Time")  >= 0
				 AND	HOUR(pu."Added Time")  < 6 THEN SUBDATE(DATE(pu."Added Time"), 1)
				 ELSE DATE(pu."Added Time")
			 END AS "Shift Date",
		 
			CASE
				 WHEN HOUR(pu."Added Time")  >= 6
				 AND	HOUR(pu."Added Time")  < 14 THEN 1
				 WHEN HOUR(pu."Added Time")  >= 14
				 AND	HOUR(pu."Added Time")  < 22 THEN 2
				 ELSE 3
			 END AS "Shift No",
		 
			CASE
				 WHEN HOUR(pu."Added Time")  >= 6
				 AND	HOUR(pu."Added Time")  < 14 THEN 'Shift 1 (6AM-2PM)'
				 WHEN HOUR(pu."Added Time")  >= 14
				 AND	HOUR(pu."Added Time")  < 22 THEN 'Shift 2 (2PM-10PM)'
				 ELSE 'Shift 3 (10PM-6AM)'
			 END AS "Shift",
		 pu."Lot No" AS "Lot No",
		 pu."Variety Name" AS "Variety Name",
		 pu."Added Time" AS "Added Time",
		 pu."Vehicle Number" AS "Vehicle No",
		 pu."Net Weight" AS "Raw Qnty",
		 COALESCE(pu."Net Weight" -(pu."Net Weight" * 5 / 1000) -(pu."Net Weight" * GREATEST(pp."Paddy Moisture %" -13, 0) / 100) -(pp."Big Bags" * 1 / 100) -(pp."Small Bags" * 0.7 / 100) -(pp."Plastic Bags" * 0.5 / 100), pu."Qnty") AS "Adjusted Qnty",
		 pu."Net Weight" -COALESCE(pu."Net Weight" -(pu."Net Weight" * 5 / 1000) -(pu."Net Weight" * GREATEST(pp."Paddy Moisture %" -13, 0) / 100) -(pp."Big Bags" * 1 / 100) -(pp."Small Bags" * 0.7 / 100) -(pp."Plastic Bags" * 0.5 / 100), pu."Qnty") AS "Deduction",
		 (pu."Net Weight" -COALESCE(pu."Net Weight" -(pu."Net Weight" * 5 / 1000) -(pu."Net Weight" * GREATEST(pp."Paddy Moisture %" -13, 0) / 100) -(pp."Big Bags" * 1 / 100) -(pp."Small Bags" * 0.7 / 100) -(pp."Plastic Bags" * 0.5 / 100), pu."Qnty")) * 100 / pu."Net Weight" AS "Deduction %",
		 pp."Rate" AS "Rate",
		 pp."Inward No" AS "Inward No"
FROM  "Paddy Unloading" pu
INNER JOIN "Paddy Payment" pp ON pu."Paddy Transaction ID"  = pp."Inward No"  
WHERE	 pu."Added Time"  >= '2026-04-01'
ORDER BY "Shift Date",
	 "Shift No",
	 pu."Lot No",
	 pu."Added Time" 
