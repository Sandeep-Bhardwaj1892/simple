SELECT
		 "Rice Batch Number" AS 'RICE BATCH',
		 MAX("Rice Variety") AS 'RICE VARIETY',
		 COUNT(*) AS 'NO OF JUMBO BAGS',
		 "Current Location" AS 'CURRENT LOCATION',
		 DATEDIFF(GETDATE(), (MAX("Modified Time"))) AS "DAYS SINCE LAST MOVEMENT",
		 SUM("Rice Quantity") AS 'TOTAL RICE QUANTITY'
FROM  "Jumbo Master" 
WHERE	 "Jumbo Status"  = 'Active' /* AND	"Current Location"  = 'Open Shed U1' */

 AND	"Current Usage Status"  NOT IN ( 'Available'  , 'Empty'  )
GROUP BY "Rice Batch Number",
	  "Current Location" 
ORDER BY "DAYS SINCE LAST MOVEMENT" DESC /* This is a sample SQL SELECT Query */
/*Use "Control + Space Bar" to see other keywords*/ 
