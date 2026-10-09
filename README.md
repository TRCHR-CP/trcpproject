# trcpproject

`trcpproject` creates a standardized TRCP analysis project with a ready-to-use
folder structure, analysis-specific R scripts, a Quarto report, and an
optional Git repository.

## Create a project

The package is included in our newest docker image ghcr.io/trchr-cp/r-trchr-public:latest

which you can pull with 
docker pull ghcr.io/trchr-cp/r-trchr-public:latest

If you do not use the Docker, you can install the package from GitHub, if needed:

```r
install.packages("remotes")
remotes::install_github("TRCHR-CP/trcpproject")
```

Then load the package and start the interactive setup:

```r
library(trcpproject)
create_project()
```

The setup guides you through choosing a parent folder (or an existing project
folder), project and report names, analyst name, analysis type, RStudio project
filename, and whether to initialize Git. The RStudio project filename defaults
to `programs.Rproj`.

You can also supply options directly. For example:

```r
create_project(
  path = "~/projects",
  main_folder_name = "valve-study",
  project_name = "Valve Study",
  analyst_name = "Analyst Name",
  analysis_type = "survival",
  git = TRUE,
  open = FALSE
)
```

Supported analysis types are `"general"`, `"survival"`, and `"prediction"`.
If an existing project folder is selected, the setup keeps its contents and
adds the standard project files.

## Generated project structure

| Folder | Contents |
| --- | --- |
| `0_documents/` | Project documents from the PI or study team, such as protocols, approvals, and data dictionaries |
| `1_data/raw/` | Original source data; keep raw files unchanged |
| `1_data/derived/` | Cleaned datasets and intermediate analysis data |
| `2_programs/` | Analysis scripts and reusable functions |
| `3_results/tables/` | Tables |
| `3_results/figures/` | Figures |
| `3_results/supplementary/` | Supplementary results |
| `4_report/` | Quarto report, stylesheet, and group logo |
| `5_manuscript/` | Manuscript drafts and related files |

The TRCP group logo is copied to `4_report/images/TRCP_Logo.png` and included
in the generated Quarto report.

## Typical workflow

1. Put source data in `1_data/raw/`. The starter data-setup scripts expect a
   file named `data.csv`; update the import code if your source data use another
   format or filename.
2. Open the generated `.Rproj` file in RStudio and use the standard TRCP
   Docker environment for reproducibility.
3. Run `2_programs/1_data_setup.R` to import and prepare the analysis data.
4. Run `2_programs/2_descriptive.R` to create descriptive results.
5. Render `4_report/preliminary_report.qmd` with `quarto render` from the
   project directory. The HTML report is written to `4_report/`.
6. Save final tables and figures in `3_results/`, and manuscript drafts in
   `5_manuscript/`.

The generated project README records the project and analyst names, creation
date, and R session information. Read it before beginning work in a generated
project.
