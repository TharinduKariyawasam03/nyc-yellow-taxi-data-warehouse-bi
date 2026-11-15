USE NYC_Taxi_DW;
GO

SELECT TOP 10

    -- Original source values
    S.VendorID,
    S.payment_type,
    S.RatecodeID,
    S.PULocationID,
    S.DOLocationID,
    S.tpep_pickup_datetime,
    S.tpep_dropoff_datetime,

    -- Warehouse dimension keys
    V.VendorKey,
    P.PaymentTypeKey,

    COALESCE(R.RateCodeKey, 0) AS RateCodeKey,

    PU.LocationKey AS PickupLocationKey,
    DO.LocationKey AS DropoffLocationKey,

    -- Date keys
    YEAR(S.tpep_pickup_datetime) * 10000
        + MONTH(S.tpep_pickup_datetime) * 100
        + DAY(S.tpep_pickup_datetime) AS PickupDateKey,

    YEAR(S.tpep_dropoff_datetime) * 10000
        + MONTH(S.tpep_dropoff_datetime) * 100
        + DAY(S.tpep_dropoff_datetime) AS DropoffDateKey,

    -- Time keys
    DATEPART(HOUR, S.tpep_pickup_datetime) * 100
        + DATEPART(MINUTE, S.tpep_pickup_datetime)
        AS PickupTimeKey,

    DATEPART(HOUR, S.tpep_dropoff_datetime) * 100
        + DATEPART(MINUTE, S.tpep_dropoff_datetime)
        AS DropoffTimeKey

FROM NYC_Taxi_Staging.dbo.StgYellowTaxiTrip S

LEFT JOIN dbo.DimVendor V
    ON S.VendorID = V.VendorID

LEFT JOIN dbo.DimPaymentType P
    ON S.payment_type = P.PaymentTypeID

LEFT JOIN dbo.DimRateCode R
    ON S.RatecodeID = R.RateCodeID

LEFT JOIN dbo.DimLocation PU
    ON S.PULocationID = PU.LocationID

LEFT JOIN dbo.DimLocation DO
    ON S.DOLocationID = DO.LocationID;




    -- Validate All Dimension Mappings

    USE NYC_Taxi_DW;
GO

SELECT
    COUNT(*) AS TotalStagingRows,

    SUM(CASE WHEN V.VendorKey IS NULL
             THEN 1 ELSE 0 END) AS UnmappedVendor,

    SUM(CASE WHEN P.PaymentTypeKey IS NULL
             THEN 1 ELSE 0 END) AS UnmappedPaymentType,

    SUM(CASE WHEN R.RateCodeKey IS NULL
             THEN 1 ELSE 0 END) AS UnmappedRateCode,

    SUM(CASE WHEN PU.LocationKey IS NULL
             THEN 1 ELSE 0 END) AS UnmappedPickupLocation,

    SUM(CASE WHEN DO.LocationKey IS NULL
             THEN 1 ELSE 0 END) AS UnmappedDropoffLocation,

    SUM(CASE WHEN PD.DateKey IS NULL
             THEN 1 ELSE 0 END) AS UnmappedPickupDate,

    SUM(CASE WHEN DD.DateKey IS NULL
             THEN 1 ELSE 0 END) AS UnmappedDropoffDate,

    SUM(CASE WHEN PT.TimeKey IS NULL
             THEN 1 ELSE 0 END) AS UnmappedPickupTime,

    SUM(CASE WHEN DT.TimeKey IS NULL
             THEN 1 ELSE 0 END) AS UnmappedDropoffTime

FROM NYC_Taxi_Staging.dbo.StgYellowTaxiTrip S

LEFT JOIN dbo.DimVendor V
    ON S.VendorID = V.VendorID

LEFT JOIN dbo.DimPaymentType P
    ON S.payment_type = P.PaymentTypeID

LEFT JOIN dbo.DimRateCode R
    ON S.RatecodeID = R.RateCodeID

LEFT JOIN dbo.DimLocation PU
    ON S.PULocationID = PU.LocationID

LEFT JOIN dbo.DimLocation DO
    ON S.DOLocationID = DO.LocationID

LEFT JOIN dbo.DimDate PD
    ON PD.DateKey =
       YEAR(S.tpep_pickup_datetime) * 10000
       + MONTH(S.tpep_pickup_datetime) * 100
       + DAY(S.tpep_pickup_datetime)

LEFT JOIN dbo.DimDate DD
    ON DD.DateKey =
       YEAR(S.tpep_dropoff_datetime) * 10000
       + MONTH(S.tpep_dropoff_datetime) * 100
       + DAY(S.tpep_dropoff_datetime)

LEFT JOIN dbo.DimTime PT
    ON PT.TimeKey =
       DATEPART(HOUR, S.tpep_pickup_datetime) * 100
       + DATEPART(MINUTE, S.tpep_pickup_datetime)

LEFT JOIN dbo.DimTime DT
    ON DT.TimeKey =
       DATEPART(HOUR, S.tpep_dropoff_datetime) * 100
       + DATEPART(MINUTE, S.tpep_dropoff_datetime);