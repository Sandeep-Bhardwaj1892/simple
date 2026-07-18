SELECT
		 
			CASE
				 WHEN HOUR("Added Time")  >= 0
				 AND	HOUR("Added Time")  < 6 THEN SUBDATE(DATE("Added Time"), 1)
				 ELSE DATE("Added Time")
			 END AS "Shift Date",
		 
			CASE
				 WHEN HOUR("Added Time")  >= 6
				 AND	HOUR("Added Time")  < 14 THEN 1
				 WHEN HOUR("Added Time")  >= 14
				 AND	HOUR("Added Time")  < 22 THEN 2
				 ELSE 3
			 END AS "Shift No",
		 
			CASE
				 WHEN HOUR("Added Time")  >= 6
				 AND	HOUR("Added Time")  < 14 THEN 'Shift 1 (6AM-2PM)'
				 WHEN HOUR("Added Time")  >= 14
				 AND	HOUR("Added Time")  < 22 THEN 'Shift 2 (2PM-10PM)'
				 ELSE 'Shift 3 (10PM-6AM)'
			 END AS "Shift",
		 "Variety Name" AS "Variety",
		 SUM("Total Quintals") AS "Bin Adjustments"
FROM  "Update Bin Status" 
WHERE	 "Added Time"  >= '2026-04-01'
 AND	"Bin Type"  IN ( 'Paddy'  , 'Dryer'  , 'Storage'  )
GROUP BY 
		CASE
			 WHEN HOUR("Added Time")  >= 0
			 AND	HOUR("Added Time")  < 6 THEN SUBDATE(DATE("Added Time"), 1)
			 ELSE DATE("Added Time")
		 END,
	 
		CASE
			 WHEN HOUR("Added Time")  >= 6
			 AND	HOUR("Added Time")  < 14 THEN 1
			 WHEN HOUR("Added Time")  >= 14
			 AND	HOUR("Added Time")  < 22 THEN 2
			 ELSE 3
		 END,
	 
		CASE
			 WHEN HOUR("Added Time")  >= 6
			 AND	HOUR("Added Time")  < 14 THEN 'Shift 1 (6AM-2PM)'
			 WHEN HOUR("Added Time")  >= 14
			 AND	HOUR("Added Time")  < 22 THEN 'Shift 2 (2PM-10PM)'
			 ELSE 'Shift 3 (10PM-6AM)'
		 END,
	  "Variety Name" 
ORDER BY "Shift Date",
	 "Shift No",
	 "Variety Name" 
