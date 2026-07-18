SELECT
		 "Prod Entry GP"."Plan Ref No" AS "Plan Reference Number",
		 "Prod Entry GP"."Added Time" AS "GP Added Time",
		 "Prod Entry"."End Time" AS "Plan End Time",
		 CONCAT(FLOOR(TIMESTAMPDIFF(SECOND, "Prod Entry"."End Time", "Prod Entry GP"."Added Time") / 86400), ' Days ', FLOOR(MOD(TIMESTAMPDIFF(SECOND, "Prod Entry"."End Time", "Prod Entry GP"."Added Time"), 86400) / 3600), ' Hours ', FLOOR(MOD(TIMESTAMPDIFF(SECOND, "Prod Entry"."End Time", "Prod Entry GP"."Added Time"), 3600) / 60), ' Mins ', MOD(TIMESTAMPDIFF(SECOND, "Prod Entry"."End Time", "Prod Entry GP"."Added Time"), 60), ' Secs') AS "Difference"
FROM  "Prod Entry GP"
LEFT JOIN "Prod Entry" ON "Prod Entry GP"."Plan Ref No"  = "Prod Entry"."Planning Ref No"  
WHERE	 "Prod Entry"."End Time"  >= '2026-04-01'
 AND	"Prod Entry"."Finish"  = 'Yes'
 AND	"Prod Entry GP"."Finish"  = 'Yes'
ORDER BY "Prod Entry GP"."Added Time" 
