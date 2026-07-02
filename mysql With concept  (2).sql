SELECT
		 "Purchase Order_Products"."Modified Time",
		 "Purchase Order_Products"."Area",
		 "Purchase Order_Products"."Spare Category",
		 "Purchase Order_Products"."Machine",
		 "Purchase Order_Products"."Product Name",
		 "Purchase Order_Products"."GRN No",
		 ITPS_Summary."Amount"
FROM  "Purchase Order_Products"
LEFT JOIN(	SELECT
			 "GRN No",
			 MAX("Amount") AS "Amount"
	FROM  "ITPS" 
	GROUP BY  "GRN No" 
) AS  "ITPS_Summary" ON "Purchase Order_Products"."GRN No"  = "ITPS_Summary"."GRN No"  
WHERE	 "ITPS_Summary"."Amount"  IS NOT NULL /* This is a sample SQL SELECT Query */
/*Use "Control + Space Bar" to see other keywords*/
