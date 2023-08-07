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
for (name in names(harmonised_dats)) {
  dat <- harmonised_dats[[name]]
  mr_res_all[[name]] <- mr(dat, method_list = all_method_list) %>% as.tibble()
}

write_rds(mr_res_all, file = here(mr_res_path))

