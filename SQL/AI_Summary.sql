
CREATE TABLE reporting.ai_dashboard_summary
(
    summary_type VARCHAR(50) PRIMARY KEY,
    summary_text TEXT,
    generated_on TIMESTAMP
);

INSERT INTO reporting.ai_dashboard_summary
(summary_type, summary_text, generated_on)

VALUES
(
'Banking',
'AI summary will be generated here.',
CURRENT_TIMESTAMP
),

(
'AML',
'AI summary will be generated here.',
CURRENT_TIMESTAMP
);



SELECT *
FROM reporting.ai_dashboard_summary;

-----------------------------------------------


SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name ILIKE '%date%';


SELECT table_schema, table_name
FROM information_schema.tables
ORDER BY table_schema, table_name;


SELECT *
FROM reporting.vw_transactions
LIMIT 1;


SELECT *
FROM warehouse.dim_date
LIMIT 1;


SELECT *
FROM reporting.vw_aml_transactions
LIMIT 1;


