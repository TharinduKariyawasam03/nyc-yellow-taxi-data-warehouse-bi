USE NYC_Taxi_DW;
GO

--Create the dimLocation
CREATE TABLE dbo.DimLocation
(
    LocationKey INT IDENTITY(1,1) NOT NULL,
    LocationID INT NOT NULL,
    Borough VARCHAR(100) NOT NULL,
    Zone VARCHAR(150) NOT NULL,
    ServiceZone VARCHAR(100) NOT NULL,

    CONSTRAINT PK_DimLocation
        PRIMARY KEY (LocationKey),

    CONSTRAINT UQ_DimLocation_LocationID
        UNIQUE (LocationID)
);
GO

--Verify the empty table
SELECT *
FROM dbo.DimLocation;

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimLocation'
ORDER BY ORDINAL_POSITION;


-- Load DimLocation

-- Create the Unknown dimension member with LocationKey = 0
SET IDENTITY_INSERT dbo.DimLocation ON;

INSERT INTO dbo.DimLocation
(
    LocationKey,
    LocationID,
    Borough,
    Zone,
    ServiceZone
)
VALUES
(
    0,
    0,
    'Unknown',
    'Unknown',
    'Unknown'
);

SET IDENTITY_INSERT dbo.DimLocation OFF;
GO


-- Load the actual Taxi Zone records
INSERT INTO dbo.DimLocation
(
    LocationID,
    Borough,
    Zone,
    ServiceZone
)
SELECT
    LocationID,
    Borough,
    Zone,
    service_zone
FROM NYC_Taxi_Staging.dbo.StgTaxiZone
WHERE LocationID <> 0;
GO

-- Verify the load
SELECT COUNT(*) AS TotalLocationRecords
FROM dbo.DimLocation;

SELECT TOP 10 *
FROM dbo.DimLocation
ORDER BY LocationKey;

--verify uniqueness
SELECT
    LocationID,
    COUNT(*) AS RecordCount
FROM dbo.DimLocation
GROUP BY LocationID
HAVING COUNT(*) > 1;