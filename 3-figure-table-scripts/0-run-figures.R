################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 0-run-figures
# --------------------
# create figures from MR data
################################################################################

# rm(list=ls())
source(here("0-config.R"))

harmonised_dats <- read_rds(here(harmonised_datas_path))

# rename exposure column
harmonised_dats <- replace_exp_column(harmonised_dats, "exposure")

#-----------------------------------------------------------------------
# Create and aggregate all plots
#-----------------------------------------------------------------------
scatter_plots <- list()
forest_plots <- list()
loo_plots <- list()
funnel_plots <- list()
method_list = c(main_analysis, "mr_egger_regression") # TODO: check this 

for (name in names(harmonised_dats)) {
  dat <- harmonised_dats[[name]]
  
  # add scatter plots
  mr_res <- as_tibble(mr(dat, method_list = all_method_list))
  scatter_plots[[name]] <- mr_scatter_plot(mr_res, dat)[[1]]
  
  # add forest plots
  forest_plots[[name]] <- mr_forest_plot(mr_singlesnp(dat))[[1]]
  
  # add leave-one-out plots
  loo_plots[[name]] <- mr_leaveoneout_plot(mr_leaveoneout(dat))[[1]]
  
  # add funnel plots
  funnel_plots[[name]] <- mr_funnel_plot(
    mr_singlesnp(dat, all_method = method_list))[[1]]
}

#-----------------------------------------------------------------------
# funnel plots
#-----------------------------------------------------------------------
for (name in names(funnel_plots)) {
  plot <- funnel_plots[[name]]
  funnel_plots[[name]] <- plot + ggtitle(name)
}
grid.arrange(grobs = funnel_plots, ncol = 2) # visual

#-----------------------------------------------------------------------
# forest plots: https://www.khstats.com/blog/forest-plots/
#-----------------------------------------------------------------------
tb <- generate_odds_ratios(bind_rows(mr_res_all))  %>% 
  mutate(method = recode(method, !!!mr_codes)) %>%
  select(-c(id.exposure,id.outcome, outcome, b, se, lo_ci, up_ci)) %>%
  mutate(CI = glue::glue("({sprintf('%.2f',or_lci95)}, \\
                         {sprintf('%.2f',or_uci95)})")) %>%
  mutate_if(is.numeric, round, 2)

# forest plot of OR studies
tb1 <- tb %>% filter(method == "IVW")

p_mid <-
ggplot(tb1, aes(y = fct_rev(exposure))) + 
  theme_classic() +
  geom_point(aes(x=or), shape=15, size=3) +
  geom_linerange(aes(xmin=or_lci95, xmax=or_uci95)) +
  geom_vline(xintercept = 1, linetype="dashed") +
  labs(x="Odds Ratio (95% CI) per 1 kg/m^2 increase in BMI", y="") +
  coord_cartesian(ylim=c(NA, NA), xlim=c(0.6, 1.4)) +
  annotate("text", x = .8, y = 4.3, label = "BMI protective") +
  annotate("text", x = 1.2, y = 4.3, label = "BMI harmful") +
  theme(axis.line.y = element_blank(),
        axis.ticks.y= element_blank(),
        axis.text.y= element_blank(),
        axis.title.y= element_blank())

p_left <-
  ggplot(tb1, aes(y=fct_rev(exposure))) +
    geom_text(aes(x = 0, label = exposure), hjust = 0, fontface = "bold") +
    geom_text(
      aes(x = 1, label = CI),
      hjust = 0,
      fontface = ifelse(tb1$CI == "Hazard Ratio (95% CI)", "bold", "plain")
    ) +
    theme_void() +
    coord_cartesian(xlim = c(0, 2))

p_right <-
  ggplot(tb1) +

  geom_text(
    aes(x = 0, y = exposure, label = pval),
    hjust = 0,
    fontface = ifelse(tb1$pval == "p-value", "bold", "plain")
  ) +
  theme_void()
  
  layout <- c(
    area(t = 0, l = 0, b = 30, r = 3),
    area(t = 1, l = 4, b = 30, r = 9),
    area(t = 0, l = 9, b = 30, r = 11)
  )
  # final plot arrangement
  p_left + p_mid + p_right + plot_layout(design = layout)

  
# forest plot of all studies and sensetivity analyses
# TODO: ^^


  
#-----------------------------------------------------------------------
# scatter plots
#-----------------------------------------------------------------------
for (name in names(scatter_plots)) {
  plot <- scatter_plots[[name]]
  scatter_plots[[name]] <- plot + ggtitle(name)
}
grid.arrange(grobs = scatter_plots, ncol = 2) # visual

#-----------------------------------------------------------------------
# leave one out analysis
#-----------------------------------------------------------------------
for (name in names(funnel_plots)) {
  plot <- loo_plots[[name]]
  loo_plots[[name]] <- plot + ggtitle(name)
}
grid.arrange(grobs = loo_plots, ncol = 2)


#-----------------------------------------------------------------------
# output plots
#-----------------------------------------------------------------------
ggsave(here(figures_dir, "funnel_plots.png"), 
       arrangeGrob(grobs = funnel_plots, ncol = 2))
ggsave(here(figures_dir, "loo_plots.png"), 
       arrangeGrob(grobs = loo_plots, ncol = 2))


ggsave(here(figures_dir, "scatter_plots.png"), 
       arrangeGrob(grobs = scatter_plots, ncol = 2))


