SELECT
    PMS."Pack Mtrl Name",
    LatestRates."Rate Per Qnty" AS "Rate",
    SUM(PMS."Opening Qnty") AS "Total Opening",
    SUM(PMS."Opening Qnty" * LatestRates."Rate Per Qnty") AS "OPValue",
    SUM(PMS."Inward Bags") AS "Total Inward",
    SUM(PMS."Inward Bags" * LatestRates."Rate Per Qnty") AS "INValue",
    SUM(PMS."Outward Bags") AS "Total Outward",
    SUM(PMS."Outward Bags" * LatestRates."Rate Per Qnty") AS "OUTValue",
    SUM(PMS."Opening Qnty" + PMS."Inward Bags" - PMS."Outward Bags") AS "Balance",
    SUM((PMS."Opening Qnty" + PMS."Inward Bags" - PMS."Outward Bags") * LatestRates."Rate Per Qnty") AS "BalValue"
FROM "PM Stock" AS PMS
-- Join with a pre-calculated table of latest rates
LEFT JOIN (
    SELECT 
        "Pack Mtrl Name", 
        "Rate Per Qnty", 
        "Added Time"
    FROM "PM Balance Sheet"
    WHERE ("Pack Mtrl Name", "Added Time") IN (
        SELECT "Pack Mtrl Name", MAX("Added Time")
        FROM "PM Balance Sheet"
        GROUP BY "Pack Mtrl Name"
    )
) AS LatestRates ON PMS."Pack Mtrl Name" = LatestRates."Pack Mtrl Name"
WHERE PMS."Status" = 'Active'
  AND LatestRates."Rate Per Qnty" > 0
GROUP BY
    PMS."Pack Mtrl Name",
    LatestRates."Rate Per Qnty",
    LatestRates."Added Time"
ORDER BY LatestRates."Added Time" ASC;