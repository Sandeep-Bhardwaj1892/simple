SELECT DISTINCT DATE("Added Time") AS "TxnDate"
FROM  "Paddy Unloading" 
WHERE	 "Added Time"  >= '2026-04-01'
UNION
 SELECT DISTINCT DATE("Added Time")
FROM  "Katwai" 
WHERE	 "Added Time"  >= '2026-04-01'
UNION
 SELECT DISTINCT DATE("Added Time")
FROM  "Bin To Lot Popup" 
WHERE	 "Added Time"  >= '2026-04-01'
UNION
 SELECT DISTINCT DATE("Added Time")
FROM  "Lot to Lot Movement Popup" 
WHERE	 "Added Time"  >= '2026-04-01'
UNION
 SELECT DISTINCT DATE("Added Time")
FROM  "Prod Entry" 
WHERE	 "Added Time"  >= '2026-04-01'
UNION
 SELECT DISTINCT DATE("Added Time")
FROM  "Bin to Bin Popup" 
WHERE	 "Added Time"  >= '2026-04-01'
UNION
 SELECT DISTINCT DATE("Added Time")
FROM  "Update Bin Status" 
WHERE	 "Added Time"  >= '2026-04-01'
 
 
 
 
 
 
