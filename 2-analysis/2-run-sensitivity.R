################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 2-run-sensitivity
# --------------------
# run MR diagnostic tests on harmonised datasets
################################################################################

# rm(list=ls())
source(here("0-config.R"))

#-----------------------------------------------------------------------
# Import: harmonised data list
#-----------------------------------------------------------------------
harmonised_dats <- read_rds(here(harmonised_datas_path))

# rename exposure column
harmonised_dats <- replace_exp_column(harmonised_dats, "exposure")


#-----------------------------------------------------------------------
# Diagnostic tests
#-----------------------------------------------------------------------
het_all <- list()
pleio_all <- list()

# Perform sensitivity analyses
for (name in names(harmonised_dats)) {
  dat <- harmonised_dats[[name]]
  
  # Heterogeneity (Cochran's Q)
  het_all[[name]] <-
    mr_heterogeneity(dat, method_list =
                       c(main_analysis, "mr_egger_regression")) %>%
    mutate(method = recode(method,!!!mr_codes))
  
  # Horizontal pleiotropy
  pleio_all[[name]] <- mr_pleiotropy_test(dat)
}

#-----------------------------------------------------------------------
# Export
#-----------------------------------------------------------------------
write_rds(bind_rows(het_all), file = here(het_all_path))
write_rds(bind_rows(pleio_all), file = here(pleio_all_path))



