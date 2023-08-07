################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 1-run-sensitivity
# --------------------
# run different MR methods on harmonised datasets
################################################################################

# rm(list=ls())
source(here("0-config.R"))

harmonised_dats <- read_rds(here(harmonised_datas_path))

# rename exposure column
harmonised_dats <- replace_exp_column(harmonised_dats, "exposure")

het_all <- list()
pleio_all <- list()
singlesnp_all <- list()
loo_all <- list()

# Perform sensitivity analyses
for (name in names(harmonised_dats)) {
  dat <- harmonised_dats[[name]]
  
  # Heterogeneity (Cochran's Q)
  het_all[[name]] <- 
    mr_heterogeneity(dat, method_list = 
                       c(main_analysis, "mr_egger_regression")) %>%
    mutate(method = recode(method, !!!mr_codes))
  
  # Horizontal pleiotropy
  pleio_all[[name]] <- mr_pleiotropy_test(dat)
  
  # Single SNP analysis
  singlesnp_all[[name]] <- mr_singlesnp(dat)
  
  # Leave-one-out analysis
  loo_all[[name]] <- mr_leaveoneout(dat)
}

write_rds(bind_rows(het_all), file = here(het_all_path))
write_rds(bind_rows(pleio_all), file = here(pleio_all_path))

# unused
directionality_test()


