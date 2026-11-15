# NYC Yellow Taxi Data Warehouse & Business Intelligence

An end-to-end Data Warehousing and Business Intelligence project built using the **2023 NYC Yellow Taxi Trip Records**. The solution integrates monthly taxi trip data with taxi-zone reference data, processes the data through a Python ETL workflow, stores it in Microsoft SQL Server using a dimensional star schema, creates an analytical data mart, and presents operational insights through Microsoft Power BI.

## Project Overview

The project focuses on analysing NYC Yellow Taxi operations across January–December 2023. It provides a centralised analytical environment for exploring:

- Taxi demand over time
- Trip demand by borough and pickup zone
- Revenue, fares, and tips
- Trip distance and duration
- Passenger and payment patterns
- Differences in operational activity across locations and months

### Dataset

| Dataset | Format | Purpose |
|---|---|---|
| NYC Yellow Taxi Trip Records (12 monthly files, 2023) | Parquet | Transaction-level taxi trip data |
| NYC Taxi Zone Lookup | CSV | Maps location IDs to boroughs, zones, and service zones |

The 12 monthly trip files contain **38,310,226 raw records**. After data preparation and validation, **38,293,718 trips** were loaded into the Data Warehouse.

## Technology Stack

- **Python** – data extraction, profiling, preparation, transformation, and loading
- **pandas** – data manipulation and transformation
- **Jupyter Notebook** – ETL workflow and data profiling
- **Microsoft SQL Server** – staging database, dimensional Data Warehouse, and Data Mart
- **T-SQL** – database objects, dimension/fact loading, stored procedure, and validation
- **Microsoft Power BI** – data modelling, OLAP-style exploration, KPIs, and dashboards
- **Parquet and CSV** – source-data formats

## Data Warehouse Architecture

```text
NYC Yellow Taxi Trip Records (Parquet) ─┐
                                       ├─> Python ETL
NYC Taxi Zone Lookup (CSV) ────────────┘
                                             |
                                             v
                                  SQL Server Staging
                                  NYC_Taxi_Staging
                                             |
                                             v
                                  Dimensional Data Warehouse
                                      NYC_Taxi_DW
                                             |
                                  +----------+----------+
                                  |                     |
                                  v                     v
                              FactTrip          Dimension Tables
                                  |
                                  v
                         Taxi Operations Data Mart
                       mart.DailyLocationOperations
                                  |
                                  v
                              Power BI
```

## Dimensional Model

The Data Warehouse follows a **star schema**.

### Fact table

`dbo.FactTrip`

**Grain:** One row represents one completed Yellow Taxi trip.

The fact table stores dimension keys and trip-level measures/attributes, including:

- Passenger count
- Trip distance
- Trip duration in minutes
- Fare amount and total amount
- Extra charges, MTA tax, tips, tolls, and surcharges
- Trip count

### Dimension tables

| Dimension | Description |
|---|---|
| `dbo.DimDate` | Calendar attributes for pickup and drop-off dates |
| `dbo.DimTime` | Hour, minute, and time-of-day attributes |
| `dbo.DimLocation` | Borough, taxi zone, and service zone |
| `dbo.DimVendor` | Taxi technology/vendor information |
| `dbo.DimPaymentType` | Payment type descriptions |
| `dbo.DimRateCode` | Rate-code descriptions |

Date, time, and location are role-playing dimensions because they are used for both pickup and drop-off information. Unknown dimension members are used where applicable to support unmatched or undocumented values.

## ETL Process

The ETL workflow consists of the following stages:

1. **Extract** – read the monthly Yellow Taxi Parquet files and Taxi Zone Lookup CSV.
2. **Profile and prepare** – inspect source structure, data types, missing values, invalid records, and location identifiers.
3. **Transform** – clean and standardise data, derive trip duration and date/time keys, and retain source metadata such as source file, year, and month.
4. **Stage** – load prepared trip and taxi-zone data into `NYC_Taxi_Staging`.
5. **Load dimensions** – populate the dimension tables in `NYC_Taxi_DW`.
6. **Load facts** – map staging records to dimension keys and load trip-level records into `dbo.FactTrip`.
7. **Automate and audit** – use the `dbo.LoadFactTripFromStaging` stored procedure and `dbo.ETL_LoadLog` to support and track monthly loading.
8. **Validate** – check record counts, date coverage, monthly totals, dimension mappings, and Data Mart totals.

## Data Mart

The project includes a Taxi Operations Analytics Data Mart:

`mart.DailyLocationOperations`

**Grain:** One row represents taxi operations for one pickup location on one calendar date.

It contains aggregated measures such as total trips, total revenue, total fares, total tips, total trip distance, average trip distance, average trip duration, average fare, average tip, and average passenger count.

The Data Mart reduces the amount of trip-level data that Power BI needs to process and supports daily, monthly, and location-based analysis.

## Power BI Reports

The Power BI solution contains three report pages:

1. **Executive Summary** – high-level KPIs and monthly performance.
2. **Trend Analysis** – comparisons of taxi activity and performance over time and across boroughs.
3. **Interactive Analysis** – more detailed exploration using filters, slicers, and Date and Location hierarchies.

The report supports filtering and drill-down/roll-up analysis using the date and location dimensions.

## Key Findings

The analysis reported the following broad findings:

- Manhattan accounts for the largest share of Yellow Taxi demand and revenue.
- Queens is an important secondary operating area.
- Upper East Side South and several Midtown zones show particularly high pickup activity.
- Trip activity and revenue vary across months, indicating seasonal patterns.
- A higher average fare or longer average trip distance does not necessarily mean a location generates the highest total revenue.

These findings can support fleet allocation, driver positioning, seasonal capacity planning, revenue monitoring, and location-based operational planning.

## Repository Contents

The repository contains the data profiling/ETL notebook and numbered SQL scripts used to build, load, and validate the solution.

| File / file group | Purpose |
|---|---|
| `data_profiling.ipynb` | Source data profiling and Python-based ETL workflow |
| `1 - Create_Databases.sql` | Creates the staging and Data Warehouse databases |
| `2 - Create_Staging_table.sql` | Creates staging tables |
| `3 - Verify_the_ETL_in_SQL_Server.sql` | Checks staging data and load results |
| `4 - Create_And_Load_DimLocation.sql` | Creates and loads the location dimension |
| `5 - Create_And_Load_DimDate.sql` | Creates and loads the date dimension |
| `6 - Create_And_Load_DimTime.sql` | Creates and loads the time dimension |
| `7 - Create_And_Load_DimVendor.sql` | Creates and loads the vendor dimension |
| `8 - Create_And_Load_DimPaymentType.sql` | Creates and loads the payment type dimension |
| `9 - Create_And_Load_DimRateCode.sql` | Creates and loads the rate-code dimension |
| `10 - Create_FactTrip.sql` | Creates the trip fact table |
| `11 - Test_FactTrip_Dimension_Mapping.sql` | Tests dimension-key mappings |
| `12 - Load_January_2023_FactTrip.sql` | Loads January 2023 fact records |
| `13 - Validate_January_2023_DW_Load.sql` | Validates the January load |
| `14 - Extend_DimDate_For_Dropoff.sql` | Extends the date dimension for drop-off dates |
| `15 - Verify_February_2023_Staging.sql` | Checks February staging data |
| `16 - Create_LoadFactTrip_Procedure.sql` | Creates the automated fact-loading procedure |
| `17 - Load_February_2023_FactTrip.sql` | Executes the fact-loading procedure |
| `18 - Verify_Automated_ETL.sql` | Verifies automated ETL results |
| `19 - Create_ETL_LoadLog.sql` | Creates and initialises the ETL audit log |
| `20 - Verify_April_2023_ETL.sql` | Checks ETL audit and loading results |
| `21 - Validate_Complete_2023_DW.sql` | Validates the completed 2023 Data Warehouse |
| `22 - Create_Taxi_Operations_DataMart.sql` | Creates, loads, and validates the Data Mart |

> Keep the source Parquet and CSV files, Power BI report (`.pbix`), and any screenshots/diagrams in the repository only if you intend to share them. They are not assumed to be included with the SQL scripts and notebook.

## Getting Started

### Prerequisites

- Python 3
- Jupyter Notebook or JupyterLab
- Python packages used by the notebook (at minimum, `pandas` and a Parquet reader such as `pyarrow`; install any additional packages imported by the notebook)
- Microsoft SQL Server
- SQL Server Management Studio (SSMS) or another SQL client
- Microsoft Power BI Desktop
- The 2023 NYC Yellow Taxi monthly Parquet files and Taxi Zone Lookup CSV

### 1. Prepare the source data

Download the 2023 Yellow Taxi Trip Records and Taxi Zone Lookup dataset from the NYC Taxi & Limousine Commission (TLC) data portal.

Place the monthly Parquet files and the taxi-zone CSV in the input directory expected by `data_profiling.ipynb`. Review the notebook's file paths and update them to match your computer before running it.

### 2. Run the Python notebook

Open `data_profiling.ipynb` in Jupyter Notebook/JupyterLab. Run the cells in order to profile, prepare, transform, and load the source data as implemented in the notebook.

### 3. Create the SQL databases and tables

Open the numbered SQL scripts in SQL Server Management Studio and execute them in the intended order. Start with scripts `1` and `2` to create the databases and staging tables. Run the notebook's data-loading workflow before executing scripts that depend on populated staging data.

Continue with the dimension and fact table scripts, then run the validation and Data Mart scripts. Check each script's database context and prerequisites before execution.

### 4. Connect Power BI

Open the Power BI report if the `.pbix` file is included in the repository. Otherwise, create/open a Power BI report and connect it to the SQL Server Data Mart:

- Database: `NYC_Taxi_DW`
- Schema: `mart`
- Table: `DailyLocationOperations`

Include `dbo.DimDate` and `dbo.DimLocation` in the model and create relationships using `DateKey` and `PickupLocationKey`, respectively.

> Update the SQL Server instance name and file paths for your own environment. The original report's SQL Server instance name is specific to the development machine and may not exist on another computer.

## Validation

The SQL scripts include checks for:

- Staging record counts and source date ranges
- Dimension records and duplicate location IDs
- Unmapped dimension keys
- Fact table row counts and monthly trip totals
- Unknown dimension mappings
- ETL audit-log entries and successful source files
- Data Mart record counts, date range, and total trips

The final report records **38,293,718 trips** loaded into the Data Warehouse and confirms that the Data Mart's aggregated `TotalTrips` reconciles to the loaded trip total.

## Data Sources and Acknowledgement

The project uses NYC Yellow Taxi Trip Records and the Taxi Zone Lookup dataset published by the **New York City Taxi & Limousine Commission (TLC)**. Please refer to the TLC data portal for the original datasets and their documentation.

## Notes

- The source dataset contains 38,310,226 raw 2023 records; the implemented Data Warehouse contains 38,293,718 loaded trips. These are different stages of the pipeline and should not be treated as identical counts.
- The SQL scripts are numbered to reflect the development workflow, but some scripts require data to have already been loaded by the notebook or an earlier SQL script.
- Confirm paths, SQL Server instance names, database state, and whether a script has already been executed before rerunning load scripts. Re-running insert scripts may create duplicate data unless the relevant load is designed to be repeatable.
