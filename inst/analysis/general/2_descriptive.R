# ============================================================
# {{PROJECT_NAME}}
# Descriptive Analysis
# ============================================================

library(ggplot2)
library(tidyverse)
library(dplyr)
library(trcpetc)

load("1_data/derived/1_data_setup.RData")

# ============================================================
# Descriptive statistics
# ============================================================
my_tab <- work_d %>%
    select(-PatID) %>%
    table_one(df = ., 
              group = Op_type,
                datadic = datadic,
                var_name = var_name, 
                var_desp = var_desp,
                # pval = TRUE, default SMD
                include_overall = "all") 

# ============================================================
# Main analysis
# ============================================================


# ============================================================
# Save results
# ============================================================

save.image("1_data/derived/2_descriptive.RData")

## EOF

# disregard below this point
# space for earlier versions and notes
