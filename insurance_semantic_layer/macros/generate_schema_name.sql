{#
  Override the default dbt schema-naming behavior.

  By default, dbt combines the target schema (e.g. "main") with any custom
  schema ("+schema: raw") to produce "main_raw". That prefixing is useful on
  shared warehouses where each developer namespaces their work, but it's noisy
  for a single-developer local DuckDB project.

  With this override:
    - If a model/seed sets +schema: raw   -> lands in schema "raw"
    - If a model/seed sets +schema: marts -> lands in schema "marts"
    - If no custom schema is set          -> falls back to the target schema
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
