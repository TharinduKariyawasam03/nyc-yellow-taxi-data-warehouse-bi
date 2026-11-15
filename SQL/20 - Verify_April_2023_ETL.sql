USE NYC_Taxi_DW;
GO

-- Check monthly FactTrip counts
SELECT
    D.Year,
    D.Month,
    D.MonthName,
    COUNT(*) AS TotalTrips
FROM dbo.FactTrip F
INNER JOIN dbo.DimDate D
    ON F.PickupDateKey = D.DateKey
GROUP BY
    D.Year,
    D.Month,
    D.MonthName
ORDER BY
    D.Year,
    D.Month;


-- Check ETL audit log
SELECT
    SourceFile,
    SourceYear,
    SourceMonth,
    RecordsLoaded,
    LoadStatus,
    LoadDateTime
FROM dbo.ETL_LoadLog
ORDER BY
    SourceYear,
    SourceMonth;