# My DBT BigQuery Project

A data transformation project using DBT (Data Build Tool) and Google BigQuery for analytics on customer and order data.

## Project Overview

This project demonstrates:
- Data ingestion from CSV seeds
- Staging layer for data cleaning
- Business logic layer (marts) for analytics
- Data quality testing
- Documentation generation

## Project Structure
```
my_dbt_project/
├── models/
│   ├── staging/          # Clean and standardize raw data
│   │   ├── sources.yml
│   │   ├── schema.yml
│   │   ├── stg_customers.sql
│   │   └── stg_orders.sql
│   └── marts/            # Business logic and final analytics
│       ├── schema.yml
│       ├── dim_customers.sql
│       ├── fct_orders.sql
│       └── monthly_revenue.sql
├── seeds/                # Sample CSV data
│   ├── raw_customers.csv
│   └── raw_orders.csv
├── dbt_project.yml       # Project configuration
└── README.md
```

## Data Models

### Staging Layer
- **stg_customers**: Cleaned customer data with standardized formatting
- **stg_orders**: Filtered and cleaned order data (excludes cancelled orders)

### Marts Layer
- **dim_customers**: Customer dimension with lifetime metrics and segmentation
- **fct_orders**: Order fact table with customer denormalization
- **monthly_revenue**: Monthly revenue aggregations for reporting

## Setup Instructions

### Prerequisites
- Python 3.8+
- Google Cloud Platform account
- BigQuery API enabled
- Service account with BigQuery Admin role

### Installation

1. Clone this repository:
```bash
git clone https://github.com/YOUR-USERNAME/my-dbt-bigquery-project.git
cd my-dbt-bigquery-project
```

2. Install DBT:
```bash
pip install dbt-bigquery
```

3. Configure profiles.yml:
   - Create `~/.dbt/profiles.yml`
   - Add your BigQuery credentials
   - See `profiles.yml.example` for template

4. Test connection:
```bash
dbt debug
```

### Running the Project
```bash
# Load seed data
dbt seed

# Run all models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

### Running Specific Models
```bash
# Run only staging models
dbt run --select staging

# Run a specific model and downstream dependencies
dbt run --select dim_customers+

# Run a model and upstream dependencies
dbt run --select +fct_orders
```

## Data Quality

All models include data quality tests:
- **Unique tests**: Ensure primary keys are unique
- **Not null tests**: Ensure critical fields have values
- **Relationship tests**: Validate foreign key relationships
- **Accepted values tests**: Validate categorical fields

Run tests with:
```bash
dbt test
```

## Customer Segmentation

Customers are segmented based on order history:
- **VIP**: 3+ orders
- **Repeat**: 2 orders
- **One-time**: 1 order
- **Never Purchased**: 0 orders (signed up but never ordered)

## Documentation

View full documentation with lineage graphs:
```bash
dbt docs generate
dbt docs serve
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests: `dbt test`
4. Commit and push
5. Create a pull request

## License

This project is for educational purposes.

## Contact

Your Name - your.email@example.com
Project Link: https://github.com/YOUR-USERNAME/my-dbt-bigquery-project