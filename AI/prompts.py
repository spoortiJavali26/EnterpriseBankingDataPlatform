
from config import GEMINI_MODEL


# ---------------------------------------------------------
# Create Banking Prompt
# ---------------------------------------------------------

def create_banking_prompt(peak_month, merchant_summary):

    banking_prompt = f"""
You are a Senior Banking Business Analyst.

Analyze the following banking transaction data.

Peak Banking Month:
{peak_month.to_string(index=False)}

Merchant Category Summary:
{merchant_summary.to_string(index=False)}

Requirements:

Only draw conclusions directly supported by the provided data.
Do NOT assume customer behaviour, loyalty, satisfaction or market conditions.

Generate a professional executive summary in the EXACT format below.

Executive Banking Summary

Business Insights
• Insight 1
• Insight 2
• Insight 3
• Insight 4
• Insight 5

Key Trends
• Trend 1
• Trend 2

Recommendation
• One business recommendation

Rules:
- Do NOT use Markdown.
- Do NOT use ** or ###.
- Keep the summary under 200 words.
- Use simple business language suitable for executives.
"""

    return banking_prompt

# ---------------------------------------------------------
# Create AML Prompt
# ---------------------------------------------------------

def create_aml_prompt(
    fraud_kpis,
    typology_text,
    transaction_type_text,
    category_text
):

    aml_prompt = f"""
You are a Senior Anti-Money Laundering Risk Analyst.

Analyze the following AML and Fraud data.

Fraud KPIs:
{fraud_kpis.to_string(index=False)}

Fraud Typology Summary:
{typology_text}

Fraud Transaction Type Summary:
{transaction_type_text}

Fraud Category Summary:
{category_text}

Requirements:

Only draw conclusions directly supported by the provided data.
Do NOT assume criminal intent beyond the supplied metrics.

Generate the summary in EXACTLY this format.

Executive AML Summary

Business Insights
• Insight 1
• Insight 2
• Insight 3
• Insight 4
• Insight 5

Key Risks
• Risk 1
• Risk 2
• Risk 3

Recommendation
• One AML recommendation

Rules:
- Do NOT use Markdown.
- Do NOT use ** or ###.
- Maximum 200 words.
- Professional executive language.
"""

    return aml_prompt

# ---------------------------------------------------------
# Generate AI Summary
# ---------------------------------------------------------

def generate_ai_summary(client, prompt):

    response = client.models.generate_content(
        model=GEMINI_MODEL,
        contents=prompt
    )

    return response.text


