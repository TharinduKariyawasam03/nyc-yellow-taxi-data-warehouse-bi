-- Create DimDate

CREATE TABLE dbo.DimDate
(
    DateKey INT NOT NULL,
    FullDate DATE NOT NULL,
    Day INT NOT NULL,
    DayName VARCHAR(20) NOT NULL,
    DayOfWeek INT NOT NULL,
    Month INT NOT NULL,
    MonthName VARCHAR(20) NOT NULL,
    Quarter INT NOT NULL,
    Year INT NOT NULL,
    IsWeekend BIT NOT NULL,

    CONSTRAINT PK_DimDate
        PRIMARY KEY (DateKey),

    CONSTRAINT UQ_DimDate_FullDate
        UNIQUE (FullDate)
);
GO

SELECT *
FROM dbo.DimDate;


-- Insert the Date Dimension
DECLARE @CurrentDate DATE = '2023-01-01';
DECLARE @EndDate DATE = '2025-12-31';

WHILE @CurrentDate <= @EndDate
BEGIN

    INSERT INTO dbo.DimDate
    (
        DateKey,
        FullDate,
        Day,
        DayName,
        DayOfWeek,
        Month,
        MonthName,
        Quarter,
        Year,
        IsWeekend
    )
    VALUES
    (
        CONVERT(INT, CONVERT(CHAR(8), @CurrentDate, 112)),
        @CurrentDate,
        DAY(@CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        DATEPART(WEEKDAY, @CurrentDate),
        MONTH(@CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        DATEPART(QUARTER, @CurrentDate),
        YEAR(@CurrentDate),

        CASE
            WHEN DATENAME(WEEKDAY, @CurrentDate)
                 IN ('Saturday', 'Sunday')
            THEN 1
            ELSE 0
        END
    );

    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);

END;
GO

-- Verify it
SELECT COUNT(*) AS TotalDates
FROM dbo.DimDate;

SELECT TOP 10 *
FROM dbo.DimDate
ORDER BY FullDate;

SELECT
    Year,
    COUNT(*) AS NumberOfDays
FROM dbo.DimDate
GROUP BY Year
ORDER BY Year;