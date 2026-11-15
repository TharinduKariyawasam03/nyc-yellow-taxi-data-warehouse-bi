--Create the table

USE NYC_Taxi_DW;
GO

CREATE TABLE dbo.ETL_LoadLog
(
    LoadLogID INT IDENTITY(1,1) NOT NULL,
    SourceFile VARCHAR(255) NOT NULL,
    SourceYear SMALLINT NOT NULL,
    SourceMonth TINYINT NOT NULL,
    RecordsLoaded BIGINT NOT NULL,
    LoadDateTime DATETIME2 NOT NULL
        CONSTRAINT DF_ETL_LoadLog_LoadDateTime
        DEFAULT SYSDATETIME(),
    LoadStatus VARCHAR(20) NOT NULL,

    CONSTRAINT PK_ETL_LoadLog
        PRIMARY KEY (LoadLogID),

    CONSTRAINT UQ_ETL_LoadLog_SourceFile
        UNIQUE (SourceFile)
);
GO

--Add the three months we've already completed
INSERT INTO dbo.ETL_LoadLog
(
    SourceFile,
    SourceYear,
    SourceMonth,
    RecordsLoaded,
    LoadStatus
)
VALUES
    ('yellow_tripdata_2023-01.parquet', 2023, 1, 3065572, 'Success'),
    ('yellow_tripdata_2023-02.parquet', 2023, 2, 2912613, 'Success'),
    ('yellow_tripdata_2023-03.parquet', 2023, 3, 3402103, 'Success');
GO

--verify
SELECT *
FROM dbo.ETL_LoadLog
ORDER BY SourceYear, SourceMonth;