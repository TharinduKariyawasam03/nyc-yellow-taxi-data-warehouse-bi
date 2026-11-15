--Create FactTrip


USE NYC_Taxi_DW;
GO

CREATE TABLE dbo.FactTrip
(
    -- Fact table surrogate key
    TripKey BIGINT IDENTITY(1,1) NOT NULL,

    -- Date dimension keys
    PickupDateKey INT NOT NULL,
    DropoffDateKey INT NOT NULL,

    -- Time dimension keys
    PickupTimeKey INT NOT NULL,
    DropoffTimeKey INT NOT NULL,

    -- Location dimension keys
    PickupLocationKey INT NOT NULL,
    DropoffLocationKey INT NOT NULL,

    -- Other dimension keys
    VendorKey INT NOT NULL,
    PaymentTypeKey INT NOT NULL,
    RateCodeKey INT NOT NULL,

    -- Trip measures / attributes
    PassengerCount INT NULL,
    TripDistance DECIMAL(10,2) NOT NULL,
    TripDurationMinutes DECIMAL(10,2) NOT NULL,

    FareAmount DECIMAL(12,2) NOT NULL,
    ExtraAmount DECIMAL(12,2) NOT NULL,
    MTATax DECIMAL(12,2) NOT NULL,
    TipAmount DECIMAL(12,2) NOT NULL,
    TollsAmount DECIMAL(12,2) NOT NULL,
    ImprovementSurcharge DECIMAL(12,2) NOT NULL,
    TotalAmount DECIMAL(12,2) NOT NULL,

    CongestionSurcharge DECIMAL(12,2) NULL,
    AirportFee DECIMAL(12,2) NULL,
    CBDCongestionFee DECIMAL(12,2) NULL,

    StoreAndForwardFlag VARCHAR(10) NOT NULL,

    TripCount TINYINT NOT NULL
        CONSTRAINT DF_FactTrip_TripCount DEFAULT 1,

    CONSTRAINT PK_FactTrip
        PRIMARY KEY (TripKey),

    CONSTRAINT FK_FactTrip_PickupDate
        FOREIGN KEY (PickupDateKey)
        REFERENCES dbo.DimDate(DateKey),

    CONSTRAINT FK_FactTrip_DropoffDate
        FOREIGN KEY (DropoffDateKey)
        REFERENCES dbo.DimDate(DateKey),

    CONSTRAINT FK_FactTrip_PickupTime
        FOREIGN KEY (PickupTimeKey)
        REFERENCES dbo.DimTime(TimeKey),

    CONSTRAINT FK_FactTrip_DropoffTime
        FOREIGN KEY (DropoffTimeKey)
        REFERENCES dbo.DimTime(TimeKey),

    CONSTRAINT FK_FactTrip_PickupLocation
        FOREIGN KEY (PickupLocationKey)
        REFERENCES dbo.DimLocation(LocationKey),

    CONSTRAINT FK_FactTrip_DropoffLocation
        FOREIGN KEY (DropoffLocationKey)
        REFERENCES dbo.DimLocation(LocationKey),

    CONSTRAINT FK_FactTrip_Vendor
        FOREIGN KEY (VendorKey)
        REFERENCES dbo.DimVendor(VendorKey),

    CONSTRAINT FK_FactTrip_PaymentType
        FOREIGN KEY (PaymentTypeKey)
        REFERENCES dbo.DimPaymentType(PaymentTypeKey),

    CONSTRAINT FK_FactTrip_RateCode
        FOREIGN KEY (RateCodeKey)
        REFERENCES dbo.DimRateCode(RateCodeKey)
);
GO


-- Verify the table
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactTrip'
ORDER BY ORDINAL_POSITION;

SELECT COUNT(*) AS FactTripRecords
FROM dbo.FactTrip;
