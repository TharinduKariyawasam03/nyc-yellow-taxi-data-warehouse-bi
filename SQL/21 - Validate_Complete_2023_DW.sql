-- Check the ETL Audit Log
USE NYC_Taxi_DW;
GO

SELECT
    SourceYear,
    SourceMonth,
    SourceFile,
    RecordsLoaded,
    LoadStatus,
    LoadDateTime
FROM dbo.ETL_LoadLog
WHERE SourceYear = 2023
ORDER BY SourceMonth;


--get the overall audit summary
SELECT
    COUNT(*) AS SuccessfulFiles,
    SUM(RecordsLoaded) AS TotalRecordsLoaded
FROM dbo.ETL_LoadLog
WHERE SourceYear = 2023
  AND LoadStatus = 'Success';

  --Check FactTrip
  SELECT
    COUNT_BIG(*) AS FactTripRecords,
    SUM(CAST(TripCount AS BIGINT)) AS TotalTrips
FROM dbo.FactTrip;

--Validate All 12 Months
SELECT
    D.Year,
    D.Month,
    D.MonthName,
    COUNT_BIG(*) AS TotalTrips
FROM dbo.FactTrip AS F
INNER JOIN dbo.DimDate AS D
    ON F.PickupDateKey = D.DateKey
WHERE D.Year = 2023
GROUP BY
    D.Year,
    D.Month,
    D.MonthName
ORDER BY
    D.Month;


 --Validate the Date Range
 SELECT
    MIN(D.FullDate) AS FirstPickupDate,
    MAX(D.FullDate) AS LastPickupDate
FROM dbo.FactTrip AS F
INNER JOIN dbo.DimDate AS D
    ON F.PickupDateKey = D.DateKey;

--Check Unknown Dimension Mappings
SELECT
    SUM(CASE WHEN VendorKey = 0
             THEN 1 ELSE 0 END) AS UnknownVendorTrips,

    SUM(CASE WHEN RateCodeKey = 0
             THEN 1 ELSE 0 END) AS UnknownRateCodeTrips,

    SUM(CASE WHEN PickupLocationKey = 0
             THEN 1 ELSE 0 END) AS UnknownPickupLocations,

    SUM(CASE WHEN DropoffLocationKey = 0
             THEN 1 ELSE 0 END) AS UnknownDropoffLocations

FROM dbo.FactTrip;

--Produce a Basic Warehouse Summary
SELECT
    COUNT_BIG(*) AS TotalTrips,

    ROUND(SUM(TotalAmount), 2)
        AS TotalAmount,

    ROUND(AVG(TripDistance), 2)
        AS AverageTripDistance,

    ROUND(AVG(TripDurationMinutes), 2)
        AS AverageTripDurationMinutes,

    ROUND(AVG(FareAmount), 2)
        AS AverageFareAmount,

    ROUND(AVG(TipAmount), 2)
        AS AverageTipAmount

FROM dbo.FactTrip;


