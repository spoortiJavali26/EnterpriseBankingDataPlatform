-- Performance Optimization (Indexes)
/*
# Create Performance Indexes

## Objective
Create indexes on frequently joined and filtered columns to improve query performance.

## Why are indexes required?
Primary Keys automatically create indexes.
However, analytical queries frequently filter and join using non-primary key columns.
Creating indexes on these columns reduces scan time and improves query performance for reporting and Power BI dashboards.

## Index Strategy

### Banking Fact

- customer_key
- merchant_key
- date_key
- is_fraud

### AML Fact

- origin_account_key
- destination_account_key
- type_key
- category_key
- typology_key
- isFraud
- isMoneyLaundering
*/


-- Banking Indexes

CREATE INDEX idx_fact_transactions_customer
ON warehouse.fact_transactions(customer_key);

CREATE INDEX idx_fact_transactions_merchant
ON warehouse.fact_transactions(merchant_key);

CREATE INDEX idx_fact_transactions_date
ON warehouse.fact_transactions(date_key);

CREATE INDEX idx_fact_transactions_fraud
ON warehouse.fact_transactions(is_fraud);


-- AML Indexes

CREATE INDEX idx_fact_aml_origin_account
ON warehouse.fact_aml_transactions(origin_account_key);

CREATE INDEX idx_fact_aml_destination_account
ON warehouse.fact_aml_transactions(destination_account_key);

CREATE INDEX idx_fact_aml_type
ON warehouse.fact_aml_transactions(type_key);

CREATE INDEX idx_fact_aml_category
ON warehouse.fact_aml_transactions(category_key);

CREATE INDEX idx_fact_aml_typology
ON warehouse.fact_aml_transactions(typology_key);

CREATE INDEX idx_fact_aml_fraud
ON warehouse.fact_aml_transactions(isFraud);

CREATE INDEX idx_fact_aml_money_laundering
ON warehouse.fact_aml_transactions(isMoneyLaundering);

/*
# Verify Database Indexes

## Objective
Verify that PostgreSQL successfully created the indexes.
Inspecting indexes confirms that performance optimizations have been applied to the warehouse tables.
*/

SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'warehouse'
ORDER BY tablename, indexname;


