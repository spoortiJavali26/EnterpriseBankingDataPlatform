/*
# Summary Reporting Views

## Objective
Create pre-aggregated SQL reporting views to demonstrate SQL reporting capabilities.

## Purpose
The summary views provide business-level aggregated metrics directly from the data warehouse.

These views demonstrate:
- SQL aggregation (GROUP BY)
- Business reporting logic
- Creation of reusable reporting datasets
- Enterprise reporting layer concepts

## Note
For this project, these summary views are **not imported into Power BI**.
Since the detailed reporting views are available, Power BI can generate the same summaries using DAX measures and visualizations.
The summary views are retained to showcase SQL reporting skills and represent an additional reporting layer commonly found in enterprise environments.
*/


---------------------------------------------------------
-- Reporting Summary View 1 : reporting.vw_fraud_summary 
---------------------------------------------------------

CREATE OR REPLACE VIEW reporting.vw_fraud_summary AS

SELECT
    dd.year,
    dd.month_name,
    dm.merchant_category,

    COUNT(*) AS total_transactions,

    SUM(ft.is_fraud) AS fraud_transactions,

    SUM(ft.amount) AS total_amount,

    SUM(
        CASE
            WHEN ft.is_fraud = 1
            THEN ft.amount
            ELSE 0
        END
    ) AS fraud_amount

FROM warehouse.fact_transactions ft

JOIN warehouse.dim_date dd
ON ft.date_key = dd.date_key
JOIN warehouse.dim_merchant dm
ON ft.merchant_key = dm.merchant_key

GROUP BY
    dd.year,
    dd.month_name,
    dm.merchant_category;


--------------------------------------------------------------------
-- Reporting Summary View 2 : reporting.vw_money_laundering_summary
--------------------------------------------------------------------

CREATE OR REPLACE VIEW reporting.vw_money_laundering_summary AS

SELECT
    dt.typology,
    dtt.transaction_type,
    dc.category,

    COUNT(*) AS total_transactions,

    SUM(fat."isFraud") AS fraud_transactions,

    SUM(fat."isMoneyLaundering") AS laundering_transactions,

    SUM(fat.amount) AS total_amount,

    AVG(fat.amount) AS average_amount

FROM warehouse.fact_aml_transactions fat

JOIN warehouse.dim_typology dt
ON fat.typology_key = dt.typology_key
JOIN warehouse.dim_transaction_type dtt
ON fat.type_key = dtt.type_key
JOIN warehouse.dim_category dc
ON fat.category_key = dc.category_key

GROUP BY
    dt.typology,
    dtt.transaction_type,
    dc.category;



----------------
-- Verify Summary Views
----------------

SELECT *
FROM reporting.vw_fraud_summary
LIMIT 5;

SELECT *
FROM reporting.vw_money_laundering_summary
LIMIT 5;