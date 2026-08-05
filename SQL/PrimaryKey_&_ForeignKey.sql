/*
# Create Primary Keys

### Objective
Create Primary Keys for all dimension and fact tables.

Primary Keys uniquely identify each record and form the foundation 
for relationships between dimensions and fact tables.
*/


-- Banking Dimensions

ALTER TABLE warehouse.dim_customer
ADD CONSTRAINT pk_dim_customer
PRIMARY KEY (customer_key);

ALTER TABLE warehouse.dim_date
ADD CONSTRAINT pk_dim_date
PRIMARY KEY (date_key);

ALTER TABLE warehouse.dim_merchant
ADD CONSTRAINT pk_dim_merchant
PRIMARY KEY (merchant_key);

-- AML Dimensions
ALTER TABLE warehouse.dim_account
ADD CONSTRAINT pk_dim_account
PRIMARY KEY (account_key);

ALTER TABLE warehouse.dim_transaction_type
ADD CONSTRAINT pk_dim_transaction_type
PRIMARY KEY (type_key);

ALTER TABLE warehouse.dim_category
ADD CONSTRAINT pk_dim_category
PRIMARY KEY (category_key);

ALTER TABLE warehouse.dim_typology
ADD CONSTRAINT pk_dim_typology
PRIMARY KEY (typology_key);

-- Banking Fact
ALTER TABLE warehouse.fact_transactions
ADD CONSTRAINT pk_fact_transactions
PRIMARY KEY (transaction_id); 

-- AML Fact 
ALTER TABLE warehouse.fact_aml_transactions
ADD CONSTRAINT pk_fact_aml_transactions
PRIMARY KEY (aml_transaction_key);

----------------------------------------------------------------------------------------------

/*
# Create Foreign Keys

### Objective
Create Foreign Keys between the Fact tables and their corresponding Dimension tables.

Foreign Keys enforce referential integrity by ensuring 
every key stored in a Fact table exists in the related Dimension table.
*/


-- Banking Foreign Keys

ALTER TABLE warehouse.fact_transactions
ADD CONSTRAINT fk_fact_transactions_customer
FOREIGN KEY (customer_key)
REFERENCES warehouse.dim_customer(customer_key);

ALTER TABLE warehouse.fact_transactions
ADD CONSTRAINT fk_fact_transactions_date
FOREIGN KEY (date_key)
REFERENCES warehouse.dim_date(date_key);

ALTER TABLE warehouse.fact_transactions
ADD CONSTRAINT fk_fact_transactions_merchant
FOREIGN KEY (merchant_key)
REFERENCES warehouse.dim_merchant(merchant_key);

/*
# Create AML Foreign Keys

### Objective
Create Foreign Key relationships between the AML Fact table and the corresponding Dimension tables.
These constraints enforce referential integrity and ensure that every key stored in the Fact table exists in the related Dimension table.
*/


ALTER TABLE warehouse.fact_aml_transactions
ADD CONSTRAINT fk_fact_aml_origin_account
FOREIGN KEY (origin_account_key)
REFERENCES warehouse.dim_account(account_key);

ALTER TABLE warehouse.fact_aml_transactions
ADD CONSTRAINT fk_fact_aml_destination_account
FOREIGN KEY (destination_account_key)
REFERENCES warehouse.dim_account(account_key);

ALTER TABLE warehouse.fact_aml_transactions
ADD CONSTRAINT fk_fact_aml_type
FOREIGN KEY (type_key)
REFERENCES warehouse.dim_transaction_type(type_key);

ALTER TABLE warehouse.fact_aml_transactions
ADD CONSTRAINT fk_fact_aml_category
FOREIGN KEY (category_key)
REFERENCES warehouse.dim_category(category_key);

ALTER TABLE warehouse.fact_aml_transactions
ADD CONSTRAINT fk_fact_aml_typology
FOREIGN KEY (typology_key)
REFERENCES warehouse.dim_typology(typology_key);

