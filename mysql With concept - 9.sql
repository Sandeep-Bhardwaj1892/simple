SELECT
		 "Invoice Date" AS "Month-Year",
		 "Invoice Quantity in MT" -"Return Quantity" / 10 AS "Data from Invoice",
		 0 AS "Data from CO",
		 "Sale Type Group",
		 "Process",
		 "Customers Name",
		 "Product Type",
		 days_between(start_day(month, "Invoice Breakup"."Invoice Date"), end_day(month, "Invoice Breakup"."Invoice Date")) + 1 AS "Days in Month Dispatch"
FROM  "Invoice Breakup" 
WHERE	 "Invoice Date"  IS NOT NULL
UNION ALL
 SELECT
		 "Entry Date" AS "Month-Year",
		 0 AS "Data from CO",
		 "CO MTons" AS "Data from CO",
		 "Sale Group",
		 "Process",
		 "Name of the Customer",
		 "Rice Products",
		 days_between(start_day(month, "CO Prod"."Entry Date"), end_day(month, "CO Prod"."Entry Date")) + 1 AS "Days in Month Orders"
FROM  "CO Prod" 
WHERE	 "Entry Date"  IS NOT NULL
 AND	"Status"  NOT IN ( 'Cancelled'  , 'Reject'  , 'Rejected'  )
 
