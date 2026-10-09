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
my_tab <- cardio_data %>%
  mutate(SurgeryType = factor_order(SurgeryType)) %>%
  table_one(
    group = Sex,
    datadic = cardio_data_dictionary,
    var_name = VariableName,
    var_desp = Label,
    # pvalue = TRUE, default is SMD
    include_overall = "all"
  )

# ============================================================
# Kaplan-Meier analysis
# ============================================================

survival_data <- construct_surv_cmprisk_var(
  cardio_data,
  patid = PatientID,
  idx_dt = SurgeryDate,
  evt_dt = DeathDate,
  end_dt = LastVisitDate,
  surv_varname= c("evt_time", "evt"),
  append = TRUE,
  units = "months",
  adm_cnr_time = 24 
)

args(estimate_cif_km)

km <- estimate_cif_km(survival_data, evt = evt, evt_time = evt_time,
                      group = Sex)

km %>%
    show_surv(x_lab = "Months since surgery", pvalue_pos = "bottomright")

km %>% summarize_km(time_lab = 'Months since surgery')

# ============================================================
# Competing risks analysis
# ============================================================

competing_risk_data <- construct_surv_cmprisk_var(
  cardio_data,
  patid = PatientID,
  idx_dt = SurgeryDate,
  evt_dt = TransplantDate,
  end_dt = LastVisitDate,
  death_dt = DeathDate,
  surv_varname = c('evt_time','evt'),
  append = TRUE,
  # adm_cnr_time = 24,
  units = "months"
)

cif <- estimate_cif_km(competing_risk_data, evt = evt, evt_time = evt_time, group = Sex)
                    


# ============================================================
# Cox proportional hazards model
# ============================================================

# cox_model <- coxph(
#   Surv(time_to_event, event) ~ group,
#   data = analysis_data
# )


# ============================================================
# Longitudinal plots with map apply (Steve version)
# ============================================================

full_plot = work_echo %>%
     select_at(c('PatID','ECHO_years_since_repair','Op_type','SVAS_Peak','SVAS_Mean','STJ_z')) %>% 
    reshape2::melt(id.vars= Cs(PatID, Op_type,ECHO_years_since_repair),
                   na.rm= TRUE) %>%
    group_by(variable) %>% 
    nest() %>% 
    left_join(datadic[,c(2:3)], by= c("variable"= "var_name")) %>% 
    mutate(data= map(data, 
                     function(df) {
                         # Fit a GEE model using geeglm
                         model <- geeglm(value ~ Op_type * ECHO_years_since_repair, 
                                         id = PatID, 
                                         data = df, 
                                         family = gaussian(), 
                                         corstr = "exchangeable")
                         
                         # Extract the p-value for the fixed effect of repair_type
                         p_value <- summary(model)$coefficients["Op_typeH-Repair:ECHO_years_since_repair", "Pr(>|W|)"]
                         df %>% mutate(p_value =format_pvalue(p_value))
                     }),
           
           profile= pmap(list(y_lab= var_desp,
                              df= data),
                         function(y_lab, df) {
                             ggplot(df,aes(ECHO_years_since_repair, value, color = Op_type)) +
                                 geom_point(shape = 1) +
                                 geom_line(aes(group= as.factor(PatID)) , linetype = 'dashed', alpha = 0.3) +    
                                 geom_smooth(
                                     method="loess",span=1,size=1,se=FALSE,aes(color = Op_type))+
                                 scale_x_continuous("Time from repair to echo (years)",
                                                    breaks = scales::pretty_breaks(8),
                                                    expand = c(0.01, 0)) +
                                 scale_y_continuous(y_lab,
                                                    breaks = scales::pretty_breaks(8),
                                                    expand = c(0.01, 0)) +
                                 labs(color = "SVAS repair strategy") +  # This changes the legend title
                                 # Customize the color of the lines using repair_type
                                 gcp_theme+ theme(axis.text=element_text(size=14))+
                                 geom_text(aes(x = 0.5, y = max(value), label = paste("p-value =", p_value)),
                                           hjust = 0, vjust = 1, col= 'black',size = 4, fontface = "plain")
                         }),
    )



# ============================================================
# Save results
# ============================================================

save.image("1_data/derived/2_descriptive.RData")