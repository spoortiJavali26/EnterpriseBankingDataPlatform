"""
Enterprise Banking Data Platform
AI Summary Generation

Author: Spoorti Javali
""" 

from google import genai
from sqlalchemy import URL, create_engine
import pandas as pd
from datetime import datetime
import logging 

from config import (
    GEMINI_API_KEY,
    GEMINI_MODEL,
    DB_HOST,
    DB_PORT,
    DB_NAME,
    DB_USER,
    DB_PASSWORD
)

from queries import (
    load_banking_kpis,
    load_merchant_summary,
    load_peak_month,
    load_fraud_kpis,
    load_typology_summary,
    load_transaction_type_summary,
    load_category_summary,
    save_ai_summary
)

from prompts import (
    create_banking_prompt,
    create_aml_prompt,
    generate_ai_summary
)

# ---------------------------------------------------------
# PostgreSQL Connection
# ---------------------------------------------------------

connection_url = URL.create(
    drivername="postgresql+psycopg2",
    username=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=int(DB_PORT),
    database=DB_NAME
)

engine = create_engine(connection_url)

# ---------------------------------------------------------
# Logging Configuration
# ---------------------------------------------------------

logging.basicConfig(
    filename="Logs/ai_pipeline.log",
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

logger = logging.getLogger(__name__)

# ---------------------------------------------------------
# Convert DataFrame to Text
# ---------------------------------------------------------

def dataframe_to_text(df, name_column, value_column):

    lines = []

    for _, row in df.iterrows():

        lines.append(
        f"- {row[name_column]} : {row[value_column]}"
         )

    return "\n".join(lines)

# ---------------------------------------------------------
# Initialize Gemini
# ---------------------------------------------------------

def initialize_gemini():

    client = genai.Client(api_key=GEMINI_API_KEY)

    return client



def main():

    print("=" * 60)
    print("Enterprise Banking Data Platform")
    print("AI Summary Generation")
    print("=" * 60)

    logger.info("Initializing Gemini Client...")

    client = initialize_gemini()

    logger.info("Gemini Connected Successfully.")

    logger.info("Connecting to PostgreSQL...")

    try:
        with engine.connect() as conn:

            logger.info("PostgreSQL Connected Successfully.")

            # ---------------------------------------------------------
            # Load Banking Summary
            # ---------------------------------------------------------

            logger.info("Loading Banking Summary...")

            banking_kpis = load_banking_kpis(engine)
            merchant_summary = load_merchant_summary(engine)
            peak_month = load_peak_month(engine)

            logger.info("Banking Summary Loaded.")

            # ---------------------------------------------------------
            # Load AML Summary
            # ---------------------------------------------------------

            logger.info("Loading AML Summary...")

            fraud_kpis = load_fraud_kpis(engine)
            typology_summary = load_typology_summary(engine)
            transaction_type_summary = load_transaction_type_summary(engine)
            category_summary = load_category_summary(engine)

            logger.info("AML Summary Loaded.")

            # ---------------------------------------------------------
            # Convert DataFrames into AI Text
            # ---------------------------------------------------------

            merchant_text = dataframe_to_text(
                merchant_summary,
                "merchant_category",
                "transaction_count"
            )

            typology_text = dataframe_to_text(
                typology_summary,
                "typology",
                "fraud_transactions"
            )

            transaction_type_text = dataframe_to_text(
                transaction_type_summary,
                "transaction_type",
                "fraud_transactions"
            )

            category_text = dataframe_to_text(
                category_summary,
                "category",
                "fraud_transactions"
            )

            logger.info("Data converted for AI prompts.")

            # ---------------------------------------------------------
            # Generate Banking AI Summary
            # ---------------------------------------------------------

            logger.info("Generating Banking AI Summary...")

            banking_prompt = create_banking_prompt(
                peak_month,
                merchant_summary
            )

            banking_summary = generate_ai_summary(
                client,
                banking_prompt
            )

            logger.info("Banking AI Summary Generated.")

            # ---------------------------------------------------------
            # Generate AML AI Summary
            # ---------------------------------------------------------

            logger.info("Generating AML AI Summary...")

            aml_prompt = create_aml_prompt(
                fraud_kpis,
                typology_text,
                transaction_type_text,
                category_text
            )

            aml_summary = generate_ai_summary(
                client,
                aml_prompt
            )

            logger.info("AML AI Summary Generated.")

            # ---------------------------------------------------------
            # Display AI Summaries (Development Only)
            # ---------------------------------------------------------

            print("\n========== BANKING AI SUMMARY ==========")
            print(banking_summary)

            print("\n========== AML AI SUMMARY ==========")
            print(aml_summary)

            # ---------------------------------------------------------
            # Save AI Summaries
            # ---------------------------------------------------------

            logger.info("Saving Banking AI Summary...")

            save_ai_summary(
                engine,
                "Banking",
                banking_summary
            )

            logger.info("Banking AI Summary Saved.")

            logger.info("Saving AML AI Summary...")

            save_ai_summary(
                engine,
                "AML",
                aml_summary
            )

            logger.info("AML AI Summary Saved.")

            logger.info("AI Pipeline Completed Successfully.")

    except Exception as e:

        logger.exception("AI Pipeline Failed")

        print("❌ AI Pipeline Failed")
        print(e)


if __name__ == "__main__":
    main()

