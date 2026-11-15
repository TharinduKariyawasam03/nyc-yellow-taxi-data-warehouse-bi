-- Verify February in SQL

USE NYC_Taxi_Staging;
GO

SELECT
    COUNT(*) AS TotalRecords,
    MIN(tpep_pickup_datetime) AS EarliestPickup,
    MAX(tpep_pickup_datetime) AS LatestPickup,
    MIN(SourceYear) AS SourceYear,
    MIN(SourceMonth) AS SourceMonth,
    MIN(SourceFile) AS SourceFile
FROM dbo.StgYellowTaxiTrip;