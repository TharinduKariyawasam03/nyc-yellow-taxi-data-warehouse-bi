--Create and Load DimVendor

USE NYC_Taxi_Staging;
GO

SELECT
    VendorID,
    COUNT(*) AS TripCount
FROM dbo.StgYellowTaxiTrip
GROUP BY VendorID
ORDER BY VendorID;

USE NYC_Taxi_DW;
GO

CREATE TABLE dbo.DimVendor
(
    VendorKey INT IDENTITY(1,1) NOT NULL,
    VendorID INT NOT NULL,
    VendorName VARCHAR(100) NOT NULL,

    CONSTRAINT PK_DimVendor
        PRIMARY KEY (VendorKey),

    CONSTRAINT UQ_DimVendor_VendorID
        UNIQUE (VendorID)
);
GO


-- Add Unknown member
SET IDENTITY_INSERT dbo.DimVendor ON;

INSERT INTO dbo.DimVendor
(
    VendorKey,
    VendorID,
    VendorName
)
VALUES
(
    0,
    0,
    'Unknown'
);

SET IDENTITY_INSERT dbo.DimVendor OFF;
GO


-- Load official vendor values
INSERT INTO dbo.DimVendor
(
    VendorID,
    VendorName
)
VALUES
    (1, 'Creative Mobile Technologies, LLC'),
    (2, 'Curb Mobility, LLC'),
    (6, 'Myle Technologies Inc'),
    (7, 'Helix');
GO

-- Verify
SELECT *
FROM dbo.DimVendor
ORDER BY VendorKey;

SELECT COUNT(*) AS TotalVendorRecords
FROM dbo.DimVendor;