-- create the Staging database
CREATE DATABASE NYC_Taxi_Staging;
GO

-- create the actual Data Warehouse
CREATE DATABASE NYC_Taxi_DW;
GO

-- verify both databases
SELECT name
FROM sys.databases
WHERE name IN ('NYC_Taxi_Staging', 'NYC_Taxi_DW');

