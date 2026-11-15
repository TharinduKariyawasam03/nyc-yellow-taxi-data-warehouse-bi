USE NYC_Taxi_DW;
GO

-- Create a separate schema for data mart objects
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'mart'
)
BEGIN
    EXEC('CREATE SCHEMA mart');
END;
GO


CREATE TABLE mart.DailyLocationOperations
(
    DateKey INT NOT NULL,
    PickupLocationKey INT NOT NULL,

    TotalTrips BIGINT NOT NULL,

    TotalRevenue DECIMAL(18,2) NULL,
    TotalFareAmount DECIMAL(18,2) NULL,
    TotalTipAmount DECIMAL(18,2) NULL,
    TotalTripDistance DECIMAL(18,2) NULL,

    AverageTripDistance DECIMAL(10,2) NULL,
    AverageTripDurationMinutes DECIMAL(10,2) NULL,
    AverageFareAmount DECIMAL(12,2) NULL,
    AverageTipAmount DECIMAL(12,2) NULL,
    AveragePassengerCount DECIMAL(10,2) NULL,

    LoadDateTime DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_DailyLocationOperations
        PRIMARY KEY (DateKey, PickupLocationKey),

    CONSTRAINT FK_Mart_Date
        FOREIGN KEY (DateKey)
        REFERENCES dbo.DimDate(DateKey),

    CONSTRAINT FK_Mart_PickupLocation
        FOREIGN KEY (PickupLocationKey)
        REFERENCES dbo.DimLocation(LocationKey)
);
GO


--verify
SELECT
    COUNT(*) AS DataMartRecords
FROM mart.DailyLocationOperations;



-- table creation
USE NYC_Taxi_DW;
GO

INSERT INTO mart.DailyLocationOperations
(
    DateKey,
    PickupLocationKey,
    TotalTrips,
    TotalRevenue,
    TotalFareAmount,
    TotalTipAmount,
    TotalTripDistance,
    AverageTripDistance,
    AverageTripDurationMinutes,
    AverageFareAmount,
    AverageTipAmount,
    AveragePassengerCount
)
SELECT
    PickupDateKey,
    PickupLocationKey,

    COUNT_BIG(*) AS TotalTrips,

    SUM(TotalAmount) AS TotalRevenue,
    SUM(FareAmount) AS TotalFareAmount,
    SUM(TipAmount) AS TotalTipAmount,
    SUM(TripDistance) AS TotalTripDistance,

    AVG(TripDistance) AS AverageTripDistance,
    AVG(TripDurationMinutes) AS AverageTripDurationMinutes,
    AVG(FareAmount) AS AverageFareAmount,
    AVG(TipAmount) AS AverageTipAmount,
    AVG(CAST(PassengerCount AS DECIMAL(10,2)))
        AS AveragePassengerCount

FROM dbo.FactTrip

GROUP BY
    PickupDateKey,
    PickupLocationKey;
GO


--Validate the Data Mart
SELECT
    COUNT(*) AS DataMartRecords,
    MIN(DateKey) AS FirstDateKey,
    MAX(DateKey) AS LastDateKey,
    SUM(TotalTrips) AS TotalTrips
FROM mart.DailyLocationOperations;


SELECT TOP 20
    D.FullDate,
    L.Borough,
    L.Zone,
    M.TotalTrips,
    M.TotalRevenue,
    M.AverageTripDistance,
    M.AverageTripDurationMinutes,
    M.AverageFareAmount,
    M.AverageTipAmount
FROM mart.DailyLocationOperations AS M

INNER JOIN dbo.DimDate AS D
    ON M.DateKey = D.DateKey

INNER JOIN dbo.DimLocation AS L
    ON M.PickupLocationKey = L.LocationKey

ORDER BY
    D.FullDate,
    M.TotalTrips DESC;






