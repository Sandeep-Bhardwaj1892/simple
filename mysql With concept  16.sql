SELECT
		 jbs."Variety Name" AS "Variety",
		 SUM(jbs."OP Quantity") AS "Opening Quantity",
		 SUM(jbs."OP Bags") AS "Opening Bags"
FROM  "Jumbo Balance Sheet" jbs 
WHERE	 jbs."Modified Time"  >= '2026-04-01'
 AND	jbs."Unit"  = 'UNIT 2'
 AND	jbs."Entry Type"  IN ( 'Rice'  , 'Brown'  )
GROUP BY  jbs."Variety Name" 
ORDER BY jbs."Variety Name" 