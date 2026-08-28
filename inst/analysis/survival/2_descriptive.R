# ============================================================
# {{PROJECT_NAME}}
# Survival Analysis
# ============================================================

library(tidyverse)
library(survival)
library(ggplot2)
library(dplyr)
library(trcpetc)

load("1_data/derived/1_data_setup.RData")

# ============================================================
# Descriptive statistics
# ============================================================


# ============================================================
# Kaplan-Meier analysis
# ============================================================

# fit_km <- survfit(
#   Surv(time_to_event, event) ~ group,
#   data = analysis_data
# )

# Use trcpetc survival plotting functions here.


# ============================================================
# Cox proportional hazards model
# ============================================================

# cox_model <- coxph(
#   Surv(time_to_event, event) ~ group,
#   data = analysis_data
# )


# ============================================================
# Competing risks
# ============================================================

# Add competing-risk analysis here when applicable.


# ============================================================
# Save results
# ============================================================

save.image("1_data/derived/2_descriptive.RData")