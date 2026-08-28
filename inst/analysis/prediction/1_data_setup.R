# ============================================================
# {{PROJECT_NAME}}
# Data Setup
# Analyst: {{ANALYST}}
# ============================================================

library(tidyverse)
library(rms)
library(pROC)
library(ggplot2)
library(dplyr)
library(trcpetc)

# ============================================================
# Import data
# ============================================================
rawdatafolder <- "1_data/raw/"
raw_d <- read.csv(paste0(rawdatafolder, "data.csv"))


# ============================================================
# Data cleaning
# ============================================================


# ============================================================
# Define outcome and candidate predictors
# ============================================================

# outcome <- ...
# predictors <- c(...)


# ============================================================
# Save analysis dataset
# ============================================================

# work_d <- ...


save.image("1_data/derived/1_data_setup.RData")