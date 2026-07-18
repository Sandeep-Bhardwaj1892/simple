SELECT
		 d."Reg Date" AS "Date",
		 /* PADDY */ MAX(COALESCE(c."Opening Paddy Quantity", 0)) AS "Paddy Opening",
		 SUM(COALESCE(c."Shift Inward", 0)) AS "Paddy Inward",
		 SUM(COALESCE(pr."Out Qty", 0)) AS "Paddy Return",
		 SUM(COALESCE(c."Shift Milling Quantity", 0)) AS "Paddy Milling",
		 MAX(COALESCE(c."Closing Paddy Quantity", 0)) AS "Paddy Closing",
		 /* RICE */ MAX(COALESCE(r."Opening Quantity", 0)) AS "Rice Opening",
		 SUM(COALESCE(r."Shift Inward", 0)) AS "Rice Inward",
		 SUM(COALESCE(r."Shift Outward", 0)) AS "Rice Outward",
		 MAX(COALESCE(r."Closing Quantity", 0)) AS "Rice Closing",
		 /* BROKEN */ MAX(CASE
				 WHEN b."Product Type"  = 'Broken' THEN COALESCE(b."Opening Quantity", 0)
				 ELSE 0
			 END) AS "Broken Opening",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Broken' THEN COALESCE(b."Shift Inward", 0)
				 ELSE 0
			 END) AS "Broken Inward",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Broken' THEN COALESCE(b."Shift Outward", 0)
				 ELSE 0
			 END) AS "Broken Outward",
		 MAX(CASE
				 WHEN b."Product Type"  = 'Broken' THEN COALESCE(b."Closing Quantity", 0)
				 ELSE 0
			 END) AS "Broken Closing",
		 /* BROKEN 2/3 */ MAX(CASE
				 WHEN b."Product Type"  = 'Broken 2/3' THEN COALESCE(b."Opening Quantity", 0)
				 ELSE 0
			 END) AS "Broken 2/3 Opening",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Broken 2/3' THEN COALESCE(b."Shift Inward", 0)
				 ELSE 0
			 END) AS "Broken 2/3 Inward",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Broken 2/3' THEN COALESCE(b."Shift Outward", 0)
				 ELSE 0
			 END) AS "Broken 2/3 Outward",
		 MAX(CASE
				 WHEN b."Product Type"  = 'Broken 2/3' THEN COALESCE(b."Closing Quantity", 0)
				 ELSE 0
			 END) AS "Broken 2/3 Closing",
		 /* BRAN */ MAX(CASE
				 WHEN b."Product Type"  = 'Bran' THEN COALESCE(b."Opening Quantity", 0)
				 ELSE 0
			 END) AS "Bran Opening",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Bran' THEN COALESCE(b."Shift Inward", 0)
				 ELSE 0
			 END) AS "Bran Inward",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Bran' THEN COALESCE(b."Shift Outward", 0)
				 ELSE 0
			 END) AS "Bran Outward",
		 MAX(CASE
				 WHEN b."Product Type"  = 'Bran' THEN COALESCE(b."Closing Quantity", 0)
				 ELSE 0
			 END) AS "Bran Closing",
		 /* PARAM */ MAX(CASE
				 WHEN b."Product Type"  = 'Param' THEN COALESCE(b."Opening Quantity", 0)
				 ELSE 0
			 END) AS "Param Opening",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Param' THEN COALESCE(b."Shift Inward", 0)
				 ELSE 0
			 END) AS "Param Inward",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Param' THEN COALESCE(b."Shift Outward", 0)
				 ELSE 0
			 END) AS "Param Outward",
		 MAX(CASE
				 WHEN b."Product Type"  = 'Param' THEN COALESCE(b."Closing Quantity", 0)
				 ELSE 0
			 END) AS "Param Closing",
		 /* LALDANA */ MAX(CASE
				 WHEN b."Product Type"  = 'Laldana' THEN COALESCE(b."Opening Quantity", 0)
				 ELSE 0
			 END) AS "Laldana Opening",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Laldana' THEN COALESCE(b."Shift Inward", 0)
				 ELSE 0
			 END) AS "Laldana Inward",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Laldana' THEN COALESCE(b."Shift Outward", 0)
				 ELSE 0
			 END) AS "Laldana Outward",
		 MAX(CASE
				 WHEN b."Product Type"  = 'Laldana' THEN COALESCE(b."Closing Quantity", 0)
				 ELSE 0
			 END) AS "Laldana Closing",
		 /* DISCOLOUR */ MAX(CASE
				 WHEN b."Product Type"  = 'Discolour' THEN COALESCE(b."Opening Quantity", 0)
				 ELSE 0
			 END) AS "Discolour Opening",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Discolour' THEN COALESCE(b."Shift Inward", 0)
				 ELSE 0
			 END) AS "Discolour Inward",
		 SUM(CASE
				 WHEN b."Product Type"  = 'Discolour' THEN COALESCE(b."Shift Outward", 0)
				 ELSE 0
			 END) AS "Discolour Outward",
		 MAX(CASE
				 WHEN b."Product Type"  = 'Discolour' THEN COALESCE(b."Closing Quantity", 0)
				 ELSE 0
			 END) AS "Discolour Closing"
FROM  "QT_BReg_Dates_Spine" d
LEFT JOIN "QT_Consolidated_Shift_Totals" c ON c."Shift Date"  = d."Reg Date" 
LEFT JOIN "Paddy Return" pr ON DATE(pr."Added Time")  = d."Reg Date"
	 AND	pr."Added Time"  >= '2026-04-01' 
LEFT JOIN "QT_Brown_Rice_Consolidated_Base" r ON r."Shift Date"  = d."Reg Date" 
LEFT JOIN "QT_ByProduct_Shift_Totals" b ON b."Shift Date"  = d."Reg Date"  
GROUP BY  d."Reg Date" 
ORDER BY d."Reg Date" 
