SELECT
		 el."LotNo" AS "Lot No",
		 el."Variety" AS "Variety",
		 COALESCE(loc."Lot Location", 'DK') AS "Lot Location",
		 COALESCE(MAX(el."Opening Balance"), 0) AS "Lot Opening Balance",
		 COALESCE(MAX(inward."Inwards"), 0) AS "Lot Inwards",
		 COALESCE(MAX(k."Lot To Bin"), 0) AS "Lot To Bin",
		 COALESCE(MAX(btl."Bin To Lot"), 0) AS "Bin To Lot",
		 
			CASE
				 WHEN ROUND(COALESCE(MAX(el."Opening Balance"), 0) + COALESCE(MAX(inward."Inwards"), 0) -COALESCE(MAX(k."Lot To Bin"), 0) + COALESCE(MAX(btl."Bin To Lot"), 0), 2)  = 0 THEN 0
				 ELSE COALESCE(MAX(el."Opening Balance"), 0) + COALESCE(MAX(inward."Inwards"), 0) -COALESCE(MAX(k."Lot To Bin"), 0) + COALESCE(MAX(btl."Bin To Lot"), 0)
			 END AS "Lot Closing Balance"
FROM  "QT_Eligible_Opening" el
LEFT JOIN(	SELECT
			 "Lot No",
			 "Variety Name",
			 SUM("Qnty") AS "Inwards"
	FROM  "Paddy Unloading" 
	WHERE	 "Added Time"  >= '2026-04-01'
	GROUP BY "Lot No",
		  "Variety Name" 
) inward ON el."LotNo"  = inward."Lot No"
	 AND	el."Variety"  = inward."Variety Name" 
LEFT JOIN(	SELECT
			 "From Lot",
			 "Variety",
			 SUM("Paddy Qnty") AS "Lot To Bin"
	FROM  "Katwai" 
	WHERE	 "Added Time"  >= '2026-04-01'
	GROUP BY "From Lot",
		  "Variety" 
) k ON el."LotNo"  = k."From Lot"
	 AND	el."Variety"  = k."Variety" 
LEFT JOIN(	SELECT
			 "To Lot",
			 "Variety",
			 SUM("Qnty To Lot") AS "Bin To Lot"
	FROM  "Bin To Lot Popup" 
	WHERE	 "Added Time"  >= '2026-04-01'
	GROUP BY "To Lot",
		  "Variety" 
) btl ON el."LotNo"  = btl."To Lot"
	 AND	el."Variety"  = btl."Variety" 
LEFT JOIN(	SELECT
			 "Lot No",
			 "Variety Name",
			 MAX("Lot Location") AS "Lot Location"
	FROM  "Paddy Unloading" 
	WHERE	 "Added Time"  >= '2026-04-01'
	GROUP BY "Lot No",
		  "Variety Name" 
) loc ON el."LotNo"  = loc."Lot No"
	 AND	el."Variety"  = loc."Variety Name"  
GROUP BY el."LotNo",
	 el."Variety",
	  loc."Lot Location" 
ORDER BY el."LotNo" 
