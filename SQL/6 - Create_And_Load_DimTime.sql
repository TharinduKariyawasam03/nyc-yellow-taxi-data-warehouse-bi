-- Create DimTime

CREATE TABLE dbo.DimTime
(
    TimeKey INT NOT NULL,
    Hour INT NOT NULL,
    Minute INT NOT NULL,
    TimeOfDay VARCHAR(20) NOT NULL,

    CONSTRAINT PK_DimTime
        PRIMARY KEY (TimeKey)
);
GO


DECLARE @Hour INT = 0;
DECLARE @Minute INT;

WHILE @Hour <= 23
BEGIN
    SET @Minute = 0;

    WHILE @Minute <= 59
    BEGIN

        INSERT INTO dbo.DimTime
        (
            TimeKey,
            Hour,
            Minute,
            TimeOfDay
        )
        VALUES
        (
            (@Hour * 100) + @Minute,
            @Hour,
            @Minute,

            CASE
                WHEN @Hour >= 5 AND @Hour < 12
                    THEN 'Morning'

                WHEN @Hour >= 12 AND @Hour < 17
                    THEN 'Afternoon'

                WHEN @Hour >= 17 AND @Hour < 21
                    THEN 'Evening'

                ELSE 'Night'
            END
        );

        SET @Minute = @Minute + 1;
    END;

    SET @Hour = @Hour + 1;
END;
GO

-- Verify
SELECT COUNT(*) AS TotalTimeRecords
FROM dbo.DimTime;

SELECT TOP 10 *
FROM dbo.DimTime
ORDER BY TimeKey;

SELECT
    TimeOfDay,
    COUNT(*) AS NumberOfMinutes
FROM dbo.DimTime
GROUP BY TimeOfDay
ORDER BY MIN(Hour);