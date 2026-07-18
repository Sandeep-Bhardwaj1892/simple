SELECT
		 combined.customer_name,
		 SUM(combined.open_order) AS open_order,
		 SUM(combined.order_today) AS order_today,
		 SUM(combined.dispatch_today) AS dispatch_today,
		 SUM(combined.open_order) + SUM(combined.order_today) -SUM(combined.dispatch_today) AS closing_order
FROM (/* Open Orders (Confirmed before today)*/
	SELECT
			 co."Name of the Customer" AS customer_name,
			 SUM(co."Total Quintals") AS open_order,
			 0 AS order_today,
			 0 AS dispatch_today
	FROM  "Confirm Order" co 
	WHERE	 co."Entry Date"  < Today()
	GROUP BY  co."Name of the Customer" 
	UNION ALL
 /* Subtract Dispatched before today (as negative open_order)*/
	SELECT
			 dp."Customer Name" AS customer_name,
			 -SUM(dp."Quantity ( Qntl )") AS open_order,
			 0 AS order_today,
			 0 AS dispatch_today
	FROM  "Dispatch Plan" dp 
	WHERE	 dp."Entry Date"  < Today()
	GROUP BY  dp."Customer Name" 
	UNION ALL
 /* Orders Today*/
	SELECT
			 ct."Name of the Customer" AS customer_name,
			 0 AS open_order,
			 SUM(ct."Total Quintals") AS order_today,
			 0 AS dispatch_today
	FROM  "Confirm Order" ct 
	WHERE	 ct."Entry Date"  = Today()
	GROUP BY  ct."Name of the Customer" 
	UNION ALL
 /* Dispatch Today*/
	SELECT
			 dt."Customer Name" AS customer_name,
			 0 AS open_order,
			 0 AS order_today,
			 SUM(dt."Quantity ( Qntl )") AS dispatch_today
	FROM  "Dispatch Plan" dt 
	WHERE	 dt."Entry Date"  = Today()
	GROUP BY  dt."Customer Name" 
 
 
 
) AS  combined 
GROUP BY  combined.customer_name 
HAVING SUM(combined.open_order)  >= 0  
ORDER BY combined.customer_name 
