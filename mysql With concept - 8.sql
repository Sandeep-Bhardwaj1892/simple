SELECT
		 "From Unit",
		 "To Unit",
		 "Variety Name",
		 "Planning Movement ID",
		 "Vehicle No",
		 "Qnty",
		 "Modified Time"
FROM  "Load Jumbo Breakup" 
WHERE	 ("From Unit"  = 'UNIT 2'
 OR	"To Unit"  = 'UNIT 2')
 AND	"From Unit"  <> "To Unit"
 AND	"Planning Movement ID"  NOT IN
	(
 	SELECT "Planning Movement ID SF"
	FROM  "Unload Jumbo Breakup" 
	WHERE	 ("From Unit"  = 'UNIT 2'
	 OR	"To Unit"  = 'UNIT 2')
	 AND	"From Unit"  <> "To Unit"
	)
