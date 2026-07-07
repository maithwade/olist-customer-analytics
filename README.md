# Olist Customer & Growth Analytics Pipeline

An end-to-end customer analytics pipeline built on a modern data stack, analyzing 100k+ orders and 8k marketing leads from Brazil's largest e-commerce marketplace.

---

## Architecture

```
Raw CSVs (Kaggle)
      ↓
Snowflake (Raw Layer)
      ↓
dbt Cloud (Staging → Marts)
      ↓
Python / Jupyter (Analysis & Visualization)
      ↓
Tableau (Dashboard)
```

---

## Tech Stack

| Layer | Tool |
|---|---|
| Data Warehouse | Snowflake |
| Transformation | dbt Cloud |
| Analysis | Python, Jupyter Notebook |
| Visualization | Tableau |
| Version Control | GitHub |

---

## Datasets

- **Brazilian E-Commerce Public Dataset by Olist** — 100k orders across 9 tables (customers, orders, order items, payments, reviews, products, sellers, geolocation, product category translation)
- **Olist Marketing Funnel Dataset** — 8k marketing qualified leads and closed deals, joined to the e-commerce dataset via `seller_id`

---

## Data Model

### Staging Layer (11 models)
Clean, renamed, and typed versions of each raw table:
`stg_customers`, `stg_orders`, `stg_order_items`, `stg_order_payments`, `stg_order_reviews`, `stg_products`, `stg_sellers`, `stg_geolocation`, `stg_closed_deals`, `stg_marketing_leads`, `stg_product_category_translation`

### Mart Layer (4 models)

| Model | Description |
|---|---|
| `mart_customer_orders` | Customer-level aggregations — total orders, total spent, LTV, avg order value, customer lifespan |
| `mart_rfm_segments` | RFM scoring using window functions (NTILE) — segments customers into Champions, Loyal, Promising, At Risk, Needs Attention |
| `mart_funnel_performance` | Lead-to-seller conversion analysis by marketing channel — conversion rates, revenue generated, days to close |
| `mart_revenue_analysis` | Revenue breakdown by product category and Brazilian state |

---

## Business Questions Answered

1. **Who are our most valuable customers?** — RFM segmentation identifies 491 Champions vs 39k At-Risk customers
2. **What is customer lifetime value across segments?** — Champions spend ~2x more on average (325 BRL) vs other segments (~150 BRL)
3. **Which marketing channels bring in the best quality sellers?** — Paid search converts at 12.3%, outperforming social (5.6%) and email (3%)
4. **How long does it take to convert a lead?** — Tracked via `days_to_close` metric in funnel mart
5. **Which product categories drive the most revenue?** — Health & beauty leads at 1.25M BRL, followed by watches & gifts at 1.15M BRL
6. **Which geographies generate the most revenue?** — São Paulo dominates, followed by Rio de Janeiro and Minas Gerais
7. **How do customers behave over time?** — Cohort analysis reveals very low repeat purchase rates, signaling a retention opportunity

---

## Key Insights

- **Retention is the biggest opportunity** — The vast majority of customers purchase only once. Improving repeat purchase rate by even 10% would significantly impact revenue.
- **Paid search is the most efficient acquisition channel** — Higher conversion rate than organic search with strong revenue output per lead.
- **Champions are few but disproportionately valuable** — Only 491 Champion customers exist but they spend 2x the average. Identifying and retaining these customers is critical.
- **São Paulo drives ~40% of total revenue** — Geographic concentration presents both an opportunity to deepen penetration and a risk if that market softens.
- **Social media underperforms** — Despite being the 3rd largest lead source, social converts at only 5.6% — lowest among major channels.

---

## SQL Techniques Demonstrated

- Window functions (`NTILE`, `DATEDIFF`, `DATE_TRUNC`)
- Multi-step CTEs with layered business logic
- LEFT JOINs for funnel analysis
- Conditional aggregations (`CASE WHEN`)
- Subqueries and derived columns
- Cross-dataset joins via `seller_id`

---

## Project Structure

```
olist_customer_analytics/
├── models/
│   ├── staging/
│   │   ├── sources.yml
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_order_items.sql
│   │   ├── stg_order_payments.sql
│   │   ├── stg_order_reviews.sql
│   │   ├── stg_products.sql
│   │   ├── stg_sellers.sql
│   │   ├── stg_geolocation.sql
│   │   ├── stg_closed_deals.sql
│   │   ├── stg_marketing_leads.sql
│   │   └── stg_product_category_translation.sql
│   └── marts/
│       ├── mart_customer_orders.sql
│       ├── mart_rfm_segments.sql
│       ├── mart_funnel_performance.sql
│       └── mart_revenue_analysis.sql
├── python_analysis/
│   └── olist_analysis.ipynb
├── dbt_project.yml
└── README.md
```

---

## How to Run

### Prerequisites
- Snowflake account
- dbt Cloud account connected to Snowflake via Partner Connect
- Python 3.x with `snowflake-connector-python`, `pandas`, `matplotlib`, `seaborn`, `cryptography`

### Steps

1. Load all 11 CSVs into `OLIST.RAW` schema in Snowflake
2. Connect dbt Cloud to Snowflake and initialize the project
3. Run `dbt run` to build all staging and mart models
4. Configure RSA key pair authentication for Python connectivity
5. Run `olist_analysis.ipynb` for visualizations
6. Connect Tableau to exported mart CSVs for dashboard

---

## Dashboard

Built in Tableau with four views:
- **Customer Segments** — RFM segment distribution
- **Funnel Performance** — Lead conversion by marketing channel
- **Revenue by Category** — Treemap of top product categories
- **Revenue by State** — Choropleth map of Brazil

---

*Dataset: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) + [Marketing Funnel by Olist](https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist)*
