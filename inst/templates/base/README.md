# {{PROJECT_NAME}}

**Analyst:** {{ANALYST}}

**Analysis type:** {{ANALYSIS_TYPE}}

## Project structure

- `0_admin/` – administrative documents
- `1_data/raw/` – raw/source data; do not modify
- `1_data/derived/` – cleaned and analysis-ready datasets
- `2_programs/` – analysis code
- `3_results/tables/` – tables
- `3_results/figures/` – figures
- `4_report/` – Quarto report

## Workflow

1. Place/source raw data in `1_data/raw/`.
2. Run `2_programs/1_data_setup.R`.
3. Run `2_programs/2_descriptive.R`.
4. Save results in RData file and/or `3_results/`.
5. Render `4_report/preliminary_report.qmd` with `quarto render`; this creates `4_report/preliminary_report.html`.

## Reproducibility

This project is intended to run in the standard TRCP Docker environment.

The Docker environment is used for reproducibility of the R version,
packages, and computational environment.

## Session information

The following information was recorded when this project was created:

```text
{{SESSION_INFO}}
```