-- Create the procedure

USE NYC_Taxi_DW;
GO

CREATE OR ALTER PROCEDURE dbo.LoadFactTripFromStaging
AS
BEGIN
    SET NOCOUNT ON;

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
        PD.DateKey,
        DD.DateKey,

        PT.TimeKey,
        DT.TimeKey,

        PU.LocationKey,
        DO.LocationKey,

        V.VendorKey,
        P.PaymentTypeKey,

        COALESCE(R.RateCodeKey, 0),

        S.passenger_count,
        S.trip_distance,

        CAST(
            DATEDIFF(
                SECOND,
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

END;
GO