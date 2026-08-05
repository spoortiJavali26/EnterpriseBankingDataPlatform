/*
# Reporting Layer

## Objective
Create SQL Reporting Views that provide business-ready datasets for Power BI.

## Why Reporting Views?
Instead of connecting Power BI directly to warehouse tables, a dedicated reporting layer provides:

- Simplified business-friendly datasets
- Consistent business logic
- Better maintainability
- Improved security by exposing only required columns
- Decoupling of reports from physical warehouse tables

## Power BI relationships require surrogate keys to build a proper Star Schema model.
The reporting view now contains:
- Surrogate Keys (for relationships)
- Business Attributes (for reporting)

## Architecture

Raw Data
        ↓
Python ETL
        ↓
Warehouse Tables
        ↓
Reporting Views & Dimensions 
        ↓
Power BI
*/

------------------------------------------------
-- Reporting View 1 : reporting.vw_transactions 
------------------------------------------------
CREATE OR REPLACE VIEW reporting.vw_transactions AS

SELECT

    ft.transaction_id,

    -- Keys
    ft.customer_key,
    ft.merchant_key,
    ft.date_key,

    -- Business Attributes
    dc.customer_id,
    dm.merchant_category,

    dd.full_date,
    dd.year,
    dd.quarter,
    dd.month,
    dd.month_name,
    dd.day,
    dd.day_name,
	
    ft.amount,
    ft.is_fraud

FROM warehouse.fact_transactions ft

JOIN warehouse.dim_customer dc
ON ft.customer_key = dc.customer_key

JOIN warehouse.dim_merchant dm
ON ft.merchant_key = dm.merchant_key

JOIN warehouse.dim_date dd
ON ft.date_key = dd.date_key;

----------------------------------------------------
-- Reporting View 2 : reporting.vw_aml_transactions 
----------------------------------------------------

CREATE VIEW reporting.vw_aml_transactions AS

SELECT

    -- Fact Key
    fat.aml_transaction_key,

    -- Surrogate Keys (for Power BI relationships)
    fat.origin_account_key,
    fat.destination_account_key,
    fat.type_key,
    fat.category_key,
    fat.typology_key,

    -- Business Attributes
    oa.account_id AS origin_account,
    da.account_id AS destination_account,
    dtt.transaction_type,
    dc.category,
    dt.typology,

    -- Measures
    fat.amount,
    fat."oldbalanceOrg",
    fat."newbalanceOrig",
    fat.fraud_probability,
    fat."isFraud",
    fat."isMoneyLaundering",

    -- Time Attributes
    fat.step,
    fat.hour,
    fat.day_of_week,
    fat.day_of_month,
    fat.month

FROM warehouse.fact_aml_transactions fat

INNER JOIN warehouse.dim_account oa
    ON fat.origin_account_key = oa.account_key

INNER JOIN warehouse.dim_account da
    ON fat.destination_account_key = da.account_key

INNER JOIN warehouse.dim_transaction_type dtt
    ON fat.type_key = dtt.type_key

INNER JOIN warehouse.dim_category dc
    ON fat.category_key = dc.category_key

INNER JOIN warehouse.dim_typology dt
    ON fat.typology_key = dt.typology_key;


----------------
-- Verify Views
----------------

SELECT *
FROM reporting.vw_transactions
LIMIT 5;

SELECT *
FROM reporting.vw_aml_transactions
LIMIT 5;

