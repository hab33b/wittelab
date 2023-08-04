################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 1-run-sensitivity
# --------------------
# run different MR methods on harmonised datasets
################################################################################

rm(list=ls())
source(here("0-config.R"))

harmonised_dats <- read_rds(here(harmonised_datas_path))

# rename exposure column
harmonised_dats <- replace_exp_column(harmonised_dats, "exposure")

het_all <- list()
pleio_all <- list()
singlesnp_all <- list()
loo_all <- list()

# Perform sensitivity analyses
for (dat in harmonised_dats) {
  num_dats <- length(het_all) + 1
  
  # Heterogeneity (Cochran's Q)
  het_all[[num_dats]] <- 
    mr_heterogeneity(dat, method_list = c(main_analysis, "mr_egger_regression"))
  
  # Horizontal pleiotropy
  pleio_all[[num_dats]] <- mr_pleiotropy_test(dat)
  
  # Single SNP analysis
  singlesnp_all[[num_dats]] <- mr_singlesnp(dat)
  
  # Leave-one-out analysis
  loo_all[[num_dats]] <- mr_leaveoneout(dat)
}

bind_rows(het_all)
bind_rows(pleio_all)
# bind_rows(singlesnp_all) # not as useful combined, better to graph
# bind_rows(loo_all)


