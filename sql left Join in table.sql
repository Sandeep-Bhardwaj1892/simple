SELECT DISTINCT
		 "Lot Master"."Lot No" AS "Lot No",
		 "Lot Master"."Variety" AS "Variety",
		 COALESCE(pu."Lot Location", '') AS "Godown"
FROM  "Lot Master"
LEFT JOIN(	SELECT
			 "Lot No",
			 MAX("Lot Location") AS "Lot Location"
	FROM  "Paddy Unloading" 
	GROUP BY  "Lot No" 
) pu ON "Lot Master"."Lot No"  = pu."Lot No"  
ORDER BY "Lot Master"."Lot No" 
