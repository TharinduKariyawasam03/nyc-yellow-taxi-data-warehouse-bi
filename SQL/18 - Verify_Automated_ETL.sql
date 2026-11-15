USE NYC_Taxi_DW;
GO

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