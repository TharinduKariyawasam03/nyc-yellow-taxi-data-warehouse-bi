-- Validate January DW Totals
USE NYC_Taxi_DW;
GO

SELECT
    COUNT(*) AS FactRows,
    SUM(CAST(TripCount AS BIGINT)) AS TotalTrips,

    MIN(PickupDateKey) AS FirstPickupDate,
    MAX(PickupDateKey) AS LastPickupDate,

    SUM(CASE WHEN RateCodeKey = 0
        THEN 1 ELSE 0 END) AS UnknownRateCodes,

    SUM(CASE WHEN VendorKey = 0
        THEN 1 ELSE 0 END) AS UnknownVendors,

    SUM(CASE WHEN PickupLocationKey = 0
        THEN 1 ELSE 0 END) AS UnknownPickupLocations,

    SUM(CASE WHEN DropoffLocationKey = 0
        THEN 1 ELSE 0 END) AS UnknownDropoffLocations,

    ROUND(AVG(CAST(TripDistance AS DECIMAL(18,2))), 2)
        AS AverageTripDistance,

    ROUND(AVG(CAST(TripDurationMinutes AS DECIMAL(18,2))), 2)
        AS AverageTripDurationMinutes,

    ROUND(SUM(CAST(TotalAmount AS DECIMAL(18,2))), 2)
        AS TotalAmount
FROM dbo.FactTrip;