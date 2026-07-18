SELECT
		 /* 1. Master Keys*/ COALESCE(inv."Inv Date", opn."Opn Date") AS "Consolidated Date",
		 COALESCE(inv."Inv Lot No", opn."Opn Lot No") AS "Consolidated Lot No",
		 COALESCE(inv."Inv Variety", opn."Opn Variety") AS "Consolidated Variety",
		 /* 2. Opening Metrics (From Lot Master)*/ opn."Opn Opening Qnty" AS "Opening Qnty",
		 opn."Opn Paddy Rate" AS "Opening Paddy Rate",
		 opn."Opn Paddy Value" AS "Opening Paddy Value",
		 /* 3. Inward Metrics (From Payment & Unloading)*/ inv."Inv Vehicle Number" AS "Vehicle Number",
		 inv."Inv Vehicle In ID" AS "Vehicle In ID",
		 inv."Inv Approval ID" AS "Approval ID",
		 inv."Inv Unloading ID" AS "Unloading ID",
		 inv."Inv Final Amount" AS "Final Amount",
		 inv."Inv Net Weight" AS "Net Weight",
		 inv."Inv Final Net Weight" AS "Final Net Weight",
		 inv."Inv Quintals" AS "Quintals",
		 inv."Inv PI Approved Qnty" AS "PI Approved Qnty",
		 inv."Inv Inward Rate" AS "Inward Rate",
		 inv."Inv Net Wt Rate" AS "Net Wt Rate",
		 inv."Inv PI Wt Rate" AS "PI Wt Rate",
		 inv."Inv Transport Less Rate" AS "Transport Less Rate",
		 inv."Inv Wt PI Daily Rate" AS "Wt PI Daily Rate",
		 inv."Inv Wt PI Monthly Rate" AS "Wt PI Monthly Rate",
		 inv."Inv Lot Location" AS "Lot Location"
FROM (/* --- INWARD DATA SUBQUERY --- */
	SELECT
			 CAST(pp."Added Time" AS DATE) AS "Inv Date",
			 pp."Vehicle Number" AS "Inv Vehicle Number",
			 pp."Vehicle In ID" AS "Inv Vehicle In ID",
			 pp."Approval ID" AS "Inv Approval ID",
			 pp."Unloading ID" AS "Inv Unloading ID",
			 pp."Final Amount" AS "Inv Final Amount",
			 pp."Net Weight" AS "Inv Net Weight",
			 pp."Final Net Weight" AS "Inv Final Net Weight",
			 pp."Quintals" AS "Inv Quintals",
			 COALESCE(NULLIF(pp."PI Approved Qnty", 0), pp."Final Net Weight") AS "Inv PI Approved Qnty",
			 pp."Rate" AS "Inv Inward Rate",
			 (pp."Final Amount" / NULLIF(pp."Net Weight", 0)) AS "Inv Net Wt Rate",
			 (pp."Final Amount" / NULLIF(COALESCE(NULLIF(pp."PI Approved Qnty", 0), pp."Final Net Weight"), 0)) AS "Inv PI Wt Rate",
			 ((pp."Final Amount" -COALESCE(pp."Less Lorry Frieght Amount", 0)) / NULLIF(pp."Net Weight", 0)) AS "Inv Transport Less Rate",
			 (SUM(pp."Final Amount") OVER(PARTITION BY CAST(pp."Added Time" AS DATE) , pu."Variety Name"  ) / NULLIF(SUM(COALESCE(NULLIF(pp."PI Approved Qnty", 0), pp."Final Net Weight")) OVER(PARTITION BY CAST(pp."Added Time" AS DATE) , pu."Variety Name"  ), 0)) AS "Inv Wt PI Daily Rate",
			 (SUM(pp."Final Amount") OVER(PARTITION BY EXTRACT(YEAR FROM CAST(pp."Added Time" AS DATE)) , EXTRACT(MONTH FROM CAST(pp."Added Time" AS DATE)) , pu."Variety Name"  ) / NULLIF(SUM(COALESCE(NULLIF(pp."PI Approved Qnty", 0), pp."Final Net Weight")) OVER(PARTITION BY EXTRACT(YEAR FROM CAST(pp."Added Time" AS DATE)) , EXTRACT(MONTH FROM CAST(pp."Added Time" AS DATE)) , pu."Variety Name"  ), 0)) AS "Inv Wt PI Monthly Rate",
			 
				CASE
					 WHEN pu."Lot No"  LIKE '% DK' THEN 'DK'
					 ELSE pu."Lot Location"
				 END AS "Inv Lot Location",
			 pu."Lot No" AS "Inv Lot No",
			 pu."Variety Name" AS "Inv Variety"
	FROM  "Paddy Payment" pp
LEFT JOIN "Paddy Unloading" pu ON pp."Unloading ID"  = pu."ID"
		 AND	pp."Approval ID"  = pu."Paddy Approval ID"
		 AND	pp."Vehicle Number"  = pu."Vehicle Number"  
	WHERE	 pp."Added Time"  >= '2026-04-01'
) inv
FULL OUTER JOIN(/* --- OPENING DATA SUBQUERY --- */
	SELECT
			 CAST("Added Time" AS DATE) AS "Opn Date",
			 "Lot No" AS "Opn Lot No",
			 "Paddy Rate" AS "Opn Paddy Rate",
			 "Paddy Value" AS "Opn Paddy Value",
			 "Variety" AS "Opn Variety",
			 "Opening Qnty" AS "Opn Opening Qnty"
	FROM  "Lot Master" 
	WHERE	 "Added Time"  >= '2026-04-01'
) opn ON inv."Inv Date"  = opn."Opn Date"
	 AND	inv."Inv Lot No"  = opn."Opn Lot No"
	 AND	inv."Inv Variety"  = opn."Opn Variety"  
ORDER BY "Consolidated Date" ASC 
