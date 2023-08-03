################################################################################
# 0-run-sensitivity
#
# run Mendelian Randomization method on harmonised datasets
################################################################################

rm(list=ls())
source(here("0-config.R"))

harmonised_datas <- readRDS(here(results_path, "harmonised-data.rds"))
mr_results <- readRDS(here(results_path, "mr_results.rds"))

het_all <- list()
pleio_all <- list()
singlesnp_all <- list()
loo_all <- list()

# Perform sensitivity analyses
for (dat in harmonised_datas) {
  
  # Heterogeneity (Cochran's Q)
  het_all[[length(het_all) + 1]] <- 
    mr_heterogeneity(dat, method_list = c("mr_egger_regression","mr_ivw"))
  
  # Horizontal pleiotropy
  pleio_all[[length(pleio_all) + 1]] <- mr_pleiotropy_test(dat)
  
  # Single SNP analysis
  singlesnp_all[[length(singlesnp_all) + 1]] <- mr_singlesnp(dat)
  
  # Leave-one-out analysis
  loo_all[[length(loo_all) + 1]] <- mr_leaveoneout(dat)
}

bind_rows(het_all)
bind_rows(pleio_all)
# generate_odds_ratios(bind_rows(mr_results))

saveRDS(singlesnp_all, here(results_path, "singlesnp_analysis.rds"))
