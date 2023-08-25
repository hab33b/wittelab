################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 1-run-figures
# --------------------
# create figures from MR data for the thesis paper
################################################################################

# rm(list=ls())
source(here("0-config.R"))

#-----------------------------------------------------------------------
# Import: harmonised data list & mr data list
#-----------------------------------------------------------------------
harmonised_dats <- read_rds(here(harmonised_datas_path))
mr_res_all <- read_rds(here(mr_res_path))

# rename exposure column
harmonised_dats <- replace_exp_column(harmonised_dats, "exposure")

#-----------------------------------------------------------------------
# Create and aggregate all plots
#-----------------------------------------------------------------------
scatter_plots <- list()
forest_plots  <- list()
loo_plots     <- list()
funnel_plots  <- list()
method_list = c(main_analysis, "mr_egger_regression")

for (name in names(harmonised_dats)) {
  dat <- harmonised_dats[[name]]
  
  # add scatter plots
  mr_res <- mr(dat, method_list = all_method_list)
  scatter_plots[[name]] <- mr_scatter_plot(mr_res, dat)[[1]]
  
  # add funnel plots
  funnel_plots[[name]] <- mr_funnel_plot(
    mr_singlesnp(dat, all_method = 
                   c(main_analysis, "mr_ivw_fe","mr_egger_regression")))[[1]]
  
  # add forest plots
  forest_plots[[name]] <- mr_forest_plot(mr_singlesnp(dat))[[1]]
  
  # add leave-one-out plots
  loo_plots[[name]] <- mr_leaveoneout_plot(mr_leaveoneout(dat))[[1]]
}


#-----------------------------------------------------------------------
# defined palettes
#-----------------------------------------------------------------------
trait.col <- c(
  Hoffman_EUR    = "#ecf0f4",
  Hoffman_AFR    = "#F9FBFD",
  PAGE_AFR       = "#ecf0f4",
  PAGE_Hoffman   = "#F9FBFD"
)
method.col <- c(
  "IVW (fe)"     = "#F18F01",
  "IVW (mre)"    = "#6E32AD",
  "ML"           = "#b11b2e",
  "RAPS"         = "#606BBB",
  "WME"          = "#3FB3AE",
  "MR Egger"     = "#D6919B"
)
method.shape <- c(
  "IVW (fe)"     = 15,
  "IVW (mre)"    = 19,
  "ML"           = 17,
  "RAPS"         = 23,
  "WME"          = 25,
  "MR Egger"     = 10
)

tb <- generate_odds_ratios(bind_rows(mr_res_all))  %>% 
  mutate(method = recode(method, !!!mr_codes)) %>%
  select(-c(id.exposure,id.outcome, outcome, b, se, lo_ci, up_ci)) %>%
  mutate(CI = glue::glue("({sprintf('%.2f',or_lci95)}, \\
                         {sprintf('%.2f',or_uci95)})")) %>%
  mutate_if(is.numeric, round, 2)

#-----------------------------------------------------------------------
# Figure 3: forest plot (all analyses)
#-----------------------------------------------------------------------
tb2 <- tb %>%
  mutate(method = factor(method, levels = unique(method))) %>%
  mutate(exposure = factor(exposure, levels = unique(exposure)))

fig3 <- ggplot(tb2) +
  aes(x = or, y = fct_rev(method), color = method) +
  
  # graph design
  facet_grid(vars(exposure), switch = "y") +
  geom_rect(
    fill = trait.col[tb2$exposure],
    xmin = -Inf,
    xmax = Inf,
    ymin = -Inf,
    ymax = Inf,
    show_guide = F,
    color = NA
  ) +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    strip.background.y = element_blank(),
    strip.text.y.left = element_text(size = 12),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    panel.spacing = unit(0, "lines"),
    axis.text.x = element_text(margin = margin(4, 0, 10, 0, "pt")),
    legend.justification = "bottom",
    legend.key = element_blank(),
    legend.text = element_text(size = 12),
    legend.title = element_blank()
  ) +
  labs(x = "Odds Ratios (95% CI)", y = "") +
  
  # add lines and points
  geom_vline(xintercept = 1, size = 0.47, linetype = 2) +
  geom_errorbar(aes(xmin = or_lci95, xmax = or_uci95),
                size = 0.65,
                width = 0.25) +
  geom_point(aes(fill = method, shape = method),
             size = 2,
             stroke = .9) +
  scale_shape_manual(values = method.shape) +
  scale_fill_manual(values = method.col) +
  scale_color_manual(values = method.col)

ggsave(here(figures_dir, paste0(3, "-fig", ".png")), fig3, 
       width = 24, height = 32, units = "cm")

#-----------------------------------------------------------------------
# Figure 4-7: MR Plots (scatter plot, funnel plot)
#-----------------------------------------------------------------------

# edit all scatter plots
for (name in names(scatter_plots)) {
  plot <- scatter_plots[[name]]
  scatter_plots[[name]] <- plot + 
    ggtitle(paste0("a)")) + 
    ylab(paste0("SNP effect on prostate cancer")) +
    xlab(paste0("SNP effect on ", name, " BMI"))
}

# edit all funnel plots
for (name in names(funnel_plots)) {
  plot <- funnel_plots[[name]]
  funnel_plots[[name]] <- plot +
    ggtitle(paste0("b)"))
}

# group and output plots by samples
i = 4
for (name in names(scatter_plots)) {
  fig <- list()
  fig[["scatter"]] <- scatter_plots[[name]]
  fig[["funnel"]] <- funnel_plots[[name]]
  ggsave(here(figures_dir, paste0(i, "-fig", "-", name, ".png")), 
         arrangeGrob(grobs = fig, ncol = 2),
         width = 32, height = 18, units = "cm")
  i = i + 1
}


#-----------------------------------------------------------------------
# forest plot: MR analysis (not used)
#-----------------------------------------------------------------------

# forest plot of OR studies
tb1 <- tb %>%
  filter(method == "IVW (fe)") %>%
  select(-c()) %>%
  mutate(exposure = factor(exposure, levels = unique(exposure))) %>%
  mutate(pval = sprintf("%0.2f", pval))
  
p_mid <-
ggplot(tb1, aes(y = fct_rev(exposure))) +
  theme_classic() +
  geom_point(aes(x=or), shape=15, size=3) +
  geom_linerange(aes(xmin=or_lci95, xmax=or_uci95)) +
  geom_vline(xintercept=1, linetype="dashed") +
  labs(x = "Odds Ratio (95% CI)") +
  coord_cartesian(
    ylim=c(1, nrow(tb1)),
    xlim=c(1 - ceiling(max(1-min(tb1$or_lci95), max(tb1$or_uci95)-1)*10)/10,
           1 + ceiling(max(1-min(tb1$or_lci95), max(tb1$or_uci95)-1)*10)/10)
    ) +
  theme(
    axis.line.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.y = element_blank(),
    axis.title.y = element_blank()
  )

p_right <-
  ggplot(tb1, aes(y=fct_rev(exposure))) +
    geom_text(aes(x = 0, label = exposure), hjust = 0, fontface = "bold") +
    geom_text(aes(x = 1, label = CI), hjust = 0) +
    geom_text(aes(x = 2, y = fct_rev(exposure), label = pval), hjust = 0) +
    coord_cartesian( xlim = c(0, 3))+
  geom_hline(yintercept=4.6, size=2) + 
  ggtitle("Difference") +
    theme_void()
  

grid.arrange(p_mid, p_right, widths=c(2,1.5))


#-----------------------------------------------------------------------
# output other plots
#-----------------------------------------------------------------------
# ggsave(here(figures_dir, "scatter_plots.png"), 
#        arrangeGrob(grobs = scatter_plots, ncol = 2), 
#        width = 16, height = 16, units = "cm")
# ggsave(here(figures_dir, "funnel_plots.png"), 
#        arrangeGrob(grobs = funnel_plots, ncol = 2), 
#        width = 16, height = 16, units = "cm")
# ggsave(here(figures_dir, "loo_plots.png"), 
#        arrangeGrob(grobs = loo_plots, ncol = 2),
#        width = 16, height = 16, units = "cm")
