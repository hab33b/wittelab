################################################################################
# 0-run-analysis
#
# run Mendelian Randomization method on harmonised datasets
################################################################################

rm(list=ls())
source(here("0-config.R"))

datasets <- readRDS(here(results_path, "harmonised-data.rds"))


# rename exposure column
exposure.short <- names(datasets)
for (i in seq_along(datasets)) {
  datasets[[i]] <- 
    datasets[[i]] %>% 
    rename(exposure.long = exposure) %>%
    mutate(exposure = exposure.short[i])
}


# Perform MR
mr_res_dats <- list()
method_list = c("mr_ivw_mre",
                "mr_two_sample_ml",
                "mr_raps",
                "mr_weighted_median",
                "mr_egger_regression")
for (dat in datasets) {
  mr_res_dats[[length(mr_res_dats) + 1]] <- as.tibble(mr(dat, method_list = method_list))
}
names(mr_res_dats) <- paste0("res_", exposure.short)


# Save MR Results
saveRDS(mr_res_dats, file = here(results_path, "mr_results.rds"))

