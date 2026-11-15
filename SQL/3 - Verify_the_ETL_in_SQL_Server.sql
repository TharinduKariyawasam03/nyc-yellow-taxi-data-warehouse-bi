USE NYC_Taxi_Staging;
GO

SELECT COUNT(*) AS TotalRecords
FROM dbo.StgTaxiZone;

SELECT TOP 10  *
FROM dbo.StgTaxiZone
ORDER BY LocationID;

--verify
SELECT COUNT(*) AS TotalRecords
FROM dbo.StgYellowTaxiTrip;

SELECT TOP 10 *
FROM dbo.StgYellowTaxiTrip;

--Verify the Full January 2023 Load
SELECT 
    COUNT(*) AS TotalRecords,
    MIN(tpep_pickup_datetime) AS EarliestPickup,
    MAX(tpep_pickup_datetime) AS LatestPickup,
    MIN(SourceYear) AS MinSourceYear,
    MAX(SourceYear) AS MaxSourceYear,
    MIN(SourceMonth) AS MinSourceMonth,
    MAX(SourceMonth) AS MaxSourceMonth
FROM dbo.StgYellowTaxiTrip;

SELECT
    SourceYear,
    SourceMonth,
    SourceFile,
    COUNT(*) AS RecordCount
FROM dbo.StgYellowTaxiTrip
GROUP BY
    SourceYear,
    SourceMonth,
    SourceFile;