################################################################################
# 0-run-figures
#
# create figures from MR data
################################################################################

rm(list=ls())
source(here("0-config.R"))

harmonised_datas <- readRDS(here(results_path, "harmonised-data.rds"))
singlesnp_all <- readRDS(here(results_path, "singlesnp_analysis.rds"))

# rename exposure column
exposure.short <- names(harmonised_datas)
for (i in seq_along(harmonised_datas)) {
  harmonised_datas[[i]] <- 
    harmonised_datas[[i]] %>% 
    rename(exposure.long = exposure) %>%
    mutate(exposure = exposure.short[i])
}

# Scatter plot ----

# Perform MR analysis & specify lines
mr_res_dats <- list()
scatter_plots <- list()
forest_plots <- list()
method_list = c("mr_ivw_mre", "mr_egger_regression")

for (dat in harmonised_datas) {
  res <- as.tibble(mr(dat, method_list = method_list))

  # add scatter plots
  scatter_plots[[length(scatter_plots) + 1]] <- mr_scatter_plot(res, dat)
  
  # add forest plots
  forst_plots[[length(scatter_plots) + 1]] <- mr_forest_plot(mr_singlesnp(dat))
}



