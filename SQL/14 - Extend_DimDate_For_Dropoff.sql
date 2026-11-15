-- Extend DimDate to 2026-01-01

USE NYC_Taxi_DW;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.DimDate
    WHERE DateKey = 20260101
)
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
        20260101,
        '2026-01-01',
        1,
        DATENAME(WEEKDAY, '2026-01-01'),
        DATEPART(WEEKDAY, '2026-01-01'),
        1,
        'January',
        1,
        2026,
        CASE
            WHEN DATENAME(WEEKDAY, '2026-01-01')
                 IN ('Saturday', 'Sunday')
            THEN 1
            ELSE 0
        END
    );

END;
GO

-- Verify
SELECT *
FROM dbo.DimDate
WHERE DateKey = 20260101;

SELECT
    MIN(FullDate) AS FirstDate,
    MAX(FullDate) AS LastDate,
    COUNT(*) AS TotalDates
FROM dbo.DimDate;