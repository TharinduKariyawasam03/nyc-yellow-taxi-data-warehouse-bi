-- Load January 2023 into FactTrip

USE NYC_Taxi_DW;
GO

INSERT INTO dbo.FactTrip
(
    PickupDateKey,
    DropoffDateKey,
    PickupTimeKey,
    DropoffTimeKey,
    PickupLocationKey,
    DropoffLocationKey,
    VendorKey,
    PaymentTypeKey,
    RateCodeKey,
    PassengerCount,
    TripDistance,
    TripDurationMinutes,
    FareAmount,
    ExtraAmount,
    MTATax,
    TipAmount,
    TollsAmount,
    ImprovementSurcharge,
    TotalAmount,
    CongestionSurcharge,
    AirportFee,
    CBDCongestionFee,
    StoreAndForwardFlag,
    TripCount
)
SELECT
    -- Date Keys
    PD.DateKey,
    DD.DateKey,

    -- Time Keys
    PT.TimeKey,
    DT.TimeKey,

    -- Location Keys
    PU.LocationKey,
    DO.LocationKey,

    -- Other Dimension Keys
    V.VendorKey,
    P.PaymentTypeKey,

    -- NULL / undocumented RateCodes → Unknown
    COALESCE(R.RateCodeKey, 0),

    -- Measures
    S.passenger_count,
    S.trip_distance,

    -- Derived trip duration in minutes
    CAST(
        DATEDIFF(SECOND,
            S.tpep_pickup_datetime,
            S.tpep_dropoff_datetime
        ) / 60.0
        AS DECIMAL(10,2)
    ),

    S.fare_amount,
    S.extra,
    S.mta_tax,
    S.tip_amount,
    S.tolls_amount,
    S.improvement_surcharge,
    S.total_amount,
    S.congestion_surcharge,
    S.airport_fee,
    S.cbd_congestion_fee,

    S.store_and_fwd_flag,

    -- Each row represents one trip
    1

FROM NYC_Taxi_Staging.dbo.StgYellowTaxiTrip S

INNER JOIN dbo.DimVendor V
    ON S.VendorID = V.VendorID

INNER JOIN dbo.DimPaymentType P
    ON S.payment_type = P.PaymentTypeID

LEFT JOIN dbo.DimRateCode R
    ON S.RatecodeID = R.RateCodeID

INNER JOIN dbo.DimLocation PU
    ON S.PULocationID = PU.LocationID

INNER JOIN dbo.DimLocation DO
    ON S.DOLocationID = DO.LocationID

INNER JOIN dbo.DimDate PD
    ON PD.DateKey =
       YEAR(S.tpep_pickup_datetime) * 10000
       + MONTH(S.tpep_pickup_datetime) * 100
       + DAY(S.tpep_pickup_datetime)

INNER JOIN dbo.DimDate DD
    ON DD.DateKey =
       YEAR(S.tpep_dropoff_datetime) * 10000
       + MONTH(S.tpep_dropoff_datetime) * 100
       + DAY(S.tpep_dropoff_datetime)

INNER JOIN dbo.DimTime PT
    ON PT.TimeKey =
       DATEPART(HOUR, S.tpep_pickup_datetime) * 100
       + DATEPART(MINUTE, S.tpep_pickup_datetime)

INNER JOIN dbo.DimTime DT
    ON DT.TimeKey =
       DATEPART(HOUR, S.tpep_dropoff_datetime) * 100
       + DATEPART(MINUTE, S.tpep_dropoff_datetime);
GO

-- Then verify the load
SELECT COUNT(*) AS FactTripRecords
FROM dbo.FactTrip;

-- verify our Unknown RateCode mapping
SELECT COUNT(*) AS UnknownRateCodeTrips
FROM dbo.FactTrip
WHERE RateCodeKey = 0;

SELECT TOP 10 *
FROM dbo.FactTrip
ORDER BY TripKey;