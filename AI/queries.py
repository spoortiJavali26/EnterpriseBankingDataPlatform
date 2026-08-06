import pandas as pd
from sqlalchemy import text
from datetime import datetime


# ---------------------------------------------------------
# Load Banking KPIs
# ---------------------------------------------------------

def load_banking_kpis(engine):

    banking_kpi_query = """
    SELECT
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_transaction_amount,
        COUNT(DISTINCT customer_id) AS customer_count,
        AVG(amount) AS average_transaction_amount
    FROM reporting.vw_transactions;
    """

    banking_kpis = pd.read_sql(banking_kpi_query, engine)

    return banking_kpis

# ---------------------------------------------------------
# Load Merchant Summary
# ---------------------------------------------------------

def load_merchant_summary(engine):

    merchant_query = """
    SELECT
        merchant_category,
        COUNT(*) AS transaction_count
    FROM reporting.vw_transactions
    GROUP BY merchant_category
    ORDER BY transaction_count DESC;
    """

    merchant_summary = pd.read_sql(merchant_query, engine)

    return merchant_summary

# ---------------------------------------------------------
# Load Peak Banking Month
# ---------------------------------------------------------

def load_peak_month(engine):

    peak_month_query = """
    SELECT
        month_name,
        COUNT(*) AS transaction_count
    FROM reporting.vw_transactions
    GROUP BY month_name, month
    ORDER BY transaction_count DESC
    LIMIT 1;
    """

    peak_month = pd.read_sql(peak_month_query, engine)

    return peak_month

# ---------------------------------------------------------
# Load Fraud KPIs
# ---------------------------------------------------------

def load_fraud_kpis(engine):

    fraud_kpi_query = """
    SELECT
        COUNT(*) FILTER (WHERE "isFraud" = 1) AS fraud_transaction_count,
        SUM(amount) FILTER (WHERE "isFraud" = 1) AS fraud_amount,
        AVG(fraud_probability) FILTER (WHERE "isFraud" = 1) AS average_fraud_probability,
        COUNT(*) FILTER (WHERE "isMoneyLaundering" = 1) AS money_laundering_cases
    FROM reporting.vw_aml_transactions;
    """

    fraud_kpis = pd.read_sql(fraud_kpi_query, engine)

    return fraud_kpis

# ---------------------------------------------------------
# Load Fraud Typology Summary
# ---------------------------------------------------------

def load_typology_summary(engine):

    typology_query = """
    SELECT
        typology,
        COUNT(*) AS fraud_transactions
    FROM reporting.vw_aml_transactions
    WHERE "isFraud" = 1
    GROUP BY typology
    ORDER BY fraud_transactions DESC;
    """

    typology_summary = pd.read_sql(typology_query, engine)

    return typology_summary

# ---------------------------------------------------------
# Load Transaction Type Summary
# ---------------------------------------------------------

def load_transaction_type_summary(engine):

    transaction_type_query = """
    SELECT
        transaction_type,
        COUNT(*) AS fraud_transactions
    FROM reporting.vw_aml_transactions
    WHERE "isFraud" = 1
    GROUP BY transaction_type
    ORDER BY fraud_transactions DESC;
    """

    transaction_type_summary = pd.read_sql(transaction_type_query, engine)

    return transaction_type_summary

# ---------------------------------------------------------
# Load Fraud Category Summary
# ---------------------------------------------------------

def load_category_summary(engine):

    category_query = """
    SELECT
        category,
        COUNT(*) AS fraud_transactions
    FROM reporting.vw_aml_transactions
    WHERE "isFraud" = 1
    GROUP BY category
    ORDER BY fraud_transactions DESC;
    """

    category_summary = pd.read_sql(category_query, engine)

    return category_summary


# ---------------------------------------------------------
# Save AI Summary
# ---------------------------------------------------------

def save_ai_summary(engine, summary_type, summary_text):

    from sqlalchemy import text
    from datetime import datetime

    with engine.begin() as conn:

        conn.execute(
            text("""
                UPDATE reporting.ai_dashboard_summary
                SET
                    summary_text = :summary_text,
                    generated_on = :generated_on
                WHERE summary_type = :summary_type
            """),
            {
                "summary_text": summary_text,
                "generated_on": datetime.now(),
                "summary_type": summary_type
            }
        )

