--Create and Load DimRateCode

USE NYC_Taxi_Staging;
GO

SELECT
    RatecodeID,
    COUNT(*) AS TripCount
FROM dbo.StgYellowTaxiTrip
GROUP BY RatecodeID
ORDER BY RatecodeID;


USE NYC_Taxi_DW;
GO


CREATE TABLE dbo.DimRateCode
(
    RateCodeKey INT IDENTITY(1,1) NOT NULL,
    RateCodeID INT NULL,
    RateCodeName VARCHAR(100) NOT NULL,

    CONSTRAINT PK_DimRateCode
        PRIMARY KEY (RateCodeKey),

    CONSTRAINT UQ_DimRateCode_RateCodeID
        UNIQUE (RateCodeID)
);
GO


-- Create the warehouse Unknown member
SET IDENTITY_INSERT dbo.DimRateCode ON;

INSERT INTO dbo.DimRateCode
(
    RateCodeKey,
    RateCodeID,
    RateCodeName
)
VALUES
(
    0,
    NULL,
    'Unknown'
);

SET IDENTITY_INSERT dbo.DimRateCode OFF;
GO


-- Insert documented TLC rate codes
INSERT INTO dbo.DimRateCode
(
    RateCodeID,
    RateCodeName
)
VALUES
    (1, 'Standard Rate'),
    (2, 'JFK'),
    (3, 'Newark'),
    (4, 'Nassau or Westchester'),
    (5, 'Negotiated Fare'),
    (6, 'Group Ride');
GO

--Verify

SELECT *
FROM dbo.DimRateCode
ORDER BY RateCodeKey;

SELECT COUNT(*) AS TotalRateCodes
FROM dbo.DimRateCode;