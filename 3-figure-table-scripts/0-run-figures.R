################################################################################
# 0-run-figures
#
# create figures from MR data
################################################################################

rm(list=ls())
source(here("0-config.R"))
source(here("0-functions/0-functions.R"))

harmonised_dats <- readRDS(here(harmonised_datas_path))

# rename exposure column
harmonised_dats <- replace_exp_column(harmonised_dats, "exposure")

# Perform MR analysis & specify lines
scatter_plots <- list()
forest_plots <- list()
loo_plots <- list()
funnel_plots <- list()
method_list = c(main_analysis, "mr_egger_regression")

# Create and aggregate all plots
for (dat in harmonised_dats) {
  num_plot <- length(scatter_plots) + 1
  exposure <- names(harmonised_dats)[num_plot]
  
  # add scatter plots
  mr_res <- as.tibble(mr(dat, method_list = method_list))
  scatter_plots[[exposure]] <- mr_scatter_plot(mr_res, dat)
  
  # add forest plots
  forest_plots[[exposure]] <- mr_forest_plot(mr_singlesnp(dat))
  
  # add leave-one-out plots
  loo_plots[[exposure]] <- mr_leaveoneout_plot(mr_leaveoneout(dat))
  
  # add funnel plots
  funnel_plots[[exposure]] <- mr_funnel_plot(mr_singlesnp(dat))
}

# rename plots

# output plots


