-- using the staging database
USE NYC_Taxi_Staging;
GO

CREATE TABLE dbo.StgYellowTaxiTrip
(
    VendorID                INT NULL,
    tpep_pickup_datetime    DATETIME2 NULL,
    tpep_dropoff_datetime   DATETIME2 NULL,
    passenger_count         INT NULL,
    trip_distance           DECIMAL(10,2) NULL,
    RatecodeID              INT NULL,
    store_and_fwd_flag      VARCHAR(10) NULL,
    PULocationID            INT NULL,
    DOLocationID            INT NULL,
    payment_type            INT NULL,

    fare_amount             DECIMAL(12,2) NULL,
    extra                   DECIMAL(12,2) NULL,
    mta_tax                 DECIMAL(12,2) NULL,
    tip_amount              DECIMAL(12,2) NULL,
    tolls_amount            DECIMAL(12,2) NULL,
    improvement_surcharge   DECIMAL(12,2) NULL,
    total_amount            DECIMAL(12,2) NULL,
    congestion_surcharge    DECIMAL(12,2) NULL,
    airport_fee             DECIMAL(12,2) NULL,
    cbd_congestion_fee      DECIMAL(12,2) NULL,

    SourceYear              SMALLINT NULL,
    SourceMonth             TINYINT NULL,
    SourceFile              VARCHAR(255) NULL,
    LoadDateTime            DATETIME2 NOT NULL
        DEFAULT SYSDATETIME()
);
GO


-- Verify the table
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'StgYellowTaxiTrip'
ORDER BY ORDINAL_POSITION;

-- Create the table
CREATE TABLE dbo.StgTaxiZone
(
    LocationID      INT NULL,
    Borough         VARCHAR(100) NULL,
    Zone            VARCHAR(150) NULL,
    service_zone    VARCHAR(100) NULL,

    SourceFile      VARCHAR(255) NULL,
    LoadDateTime    DATETIME2 NOT NULL
        DEFAULT SYSDATETIME()
);
GO


-- Verify it
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'StgTaxiZone'
ORDER BY ORDINAL_POSITION;


-- Find SQL Server name
SELECT @@SERVERNAME AS ServerName;

