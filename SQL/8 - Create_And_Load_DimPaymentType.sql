--Create and Load DimPaymentType

CREATE TABLE dbo.DimPaymentType
(
    PaymentTypeKey INT IDENTITY(1,1) NOT NULL,
    PaymentTypeID INT NOT NULL,
    PaymentTypeName VARCHAR(50) NOT NULL,

    CONSTRAINT PK_DimPaymentType
        PRIMARY KEY (PaymentTypeKey),

    CONSTRAINT UQ_DimPaymentType_PaymentTypeID
        UNIQUE (PaymentTypeID)
);
GO


INSERT INTO dbo.DimPaymentType
(
    PaymentTypeID,
    PaymentTypeName
)
VALUES
    (0, 'Flex Fare Trip'),
    (1, 'Credit Card'),
    (2, 'Cash'),
    (3, 'No Charge'),
    (4, 'Dispute'),
    (5, 'Unknown'),
    (6, 'Voided Trip');
GO

USE NYC_Taxi_DW;
GO

-- Verify
SELECT *
FROM dbo.DimPaymentType
ORDER BY PaymentTypeID;

SELECT COUNT(*) AS TotalPaymentTypes
FROM dbo.DimPaymentType;








