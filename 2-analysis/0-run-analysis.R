################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 0-run-analysis
# --------------------
# run Mendelian Randomization method on harmonised datasets
################################################################################

rm(list=ls())
source(here("0-config.R"))

harmonised_dats <- read_rds(here(harmonised_datas_path))

# rename exposure column
harmonised_dats <- replace_exp_column(harmonised_dats, "exposure")

# Perform MR
mr_res_all <- list()
method_list = c(main_analysis,
                "mr_two_sample_ml",
                "mr_raps",
                "mr_weighted_median",
                "mr_egger_regression")
for (dat in harmonised_dats) {
  mr_res_all[[length(mr_res_all) + 1]] <- mr(dat, method_list = method_list) %>%
                                          as.tibble()
}
names(mr_res_all) <- paste0("res_", names(harmonised_dats))

# generate_odds_ratios(bind_rows(mr_results))

