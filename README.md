# AE Insurance Analytics

Take-home implementation of an end-to-end **semantic layer** on synthetic
insurance data.

The dbt project lives in [`insurance_semantic_layer/`](insurance_semantic_layer/README.md),
which contains the full write-up: architecture, star schema, semantic layer
design, and MetricFlow query examples.

## Quick start

```bash
git clone <this repo>
cd ae_insurance_analytics

# Install Python dependencies (dbt-duckdb, dbt-metricflow, etc.)
uv sync

# Run the dbt project
source .venv/bin/activate
cd insurance_semantic_layer
dbt deps       # install dbt_utils
dbt build      # seeds + models + tests

# Optional: query metrics via MetricFlow
mf query --metrics loss_ratio --group-by policy__policy_type
```

See [`insurance_semantic_layer/README.md`](insurance_semantic_layer/README.md)
for the full documentation, design rationale, and answers to the business
questions.

## Repository layout

```
ae_insurance_analytics/
├── README.md                       ← you are here (index)
├── pyproject.toml                  ← Python project (uv-managed)
├── uv.lock
└── insurance_semantic_layer/       ← the dbt project (see its README)
    ├── README.md                   ← main documentation
    ├── dbt_project.yml
    ├── packages.yml
    ├── seeds/                      ← raw CSV data
    ├── models/
    │   ├── staging/                ← 4 stg_ views
    │   ├── marts/                  ← 2 dims + 4 facts (star schema + reporting mart)
    │   └── semantic/               ← MetricFlow YAML (2 semantic models, 8 metrics)
    ├── analyses/                   ← 4 sample SQL queries
    └── macros/
```
