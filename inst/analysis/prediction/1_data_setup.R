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

gcp_theme <- theme_minimal(base_size = 12, base_family = "sans") +
  theme(
    text = element_text(colour = "#263238"),
    axis.title = element_text(size = 13, face = "bold"),
    axis.title.x = element_text(margin = margin(t = 10, unit = "pt")),
    axis.title.y = element_text(margin = margin(r = 10, unit = "pt")),
    axis.text = element_text(colour = "#455A64"),
    axis.ticks = element_line(colour = "#90A4AE", linewidth = 0.4),
    panel.grid.major.y = element_line(colour = "#E6EBEF", linewidth = 0.5),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", colour = "#263238"),
    strip.background = element_rect(fill = "#F1F4F6", colour = NA),
    legend.title = element_text(face = "bold"),
    legend.key = element_rect(fill = NA, colour = NA),
    legend.background = element_rect(fill = NA, colour = NA),
    plot.margin = margin(12, 14, 12, 14, unit = "pt")
  )

save.image("1_data/derived/1_data_setup.RData")