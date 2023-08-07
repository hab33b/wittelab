################################################################################
# Thesis - Mendelian Randomization
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
#
# 0-run-figures
# --------------------
# create tables for paper
################################################################################

# rm(list=ls())
source(here("0-config.R"))

# load data
harmonised_dats <- read_rds(here(harmonised_datas_path))
mr_res_all <- read_rds(here(mr_res_path))
het_all <- read_rds(here(het_all_path)) # combined data frame
pleio_all <- read_rds(here(pleio_all_path)) # combined data frame


#-----------------------------------------------------------------------
# Table 2: Proportion of Variance Explained (PVE) Calculation 
#-----------------------------------------------------------------------
table2 <- tibble()

for (name in names(harmonised_dats)) {
  dat <- harmonised_dats[[name]]
  
  # calculate sum of PVE column
  PVE.tot <- dat %>% 
    mutate(
      VAR.1 = 2*beta.exposure^2*eaf.exposure*(1-eaf.exposure),
      VAR.2 = 2*se.exposure^2*samplesize.exposure*eaf.exposure*(1-eaf.exposure),
      PVE = VAR.1/(VAR.1 + VAR.2)) %>%
    select(PVE) %>%
    sum(na.rm = TRUE)
  
  # create table of PVE
  table2 <- table2 %>%
    bind_rows(tibble(Study=name, Nsnp=nrow(dat), "R^2 (%)"= PVE.tot * 100))
}

# prepare table
# values calculated using https://shiny.cnsgenomics.com/mRnd/
table2 <- table2 %>%
  mutate("OR (risk)" = c(1.15, 1.22, 1.37, 1.20)) %>%
  mutate("OR (protective)" = c(0.87, 0.81, 0.73, 0.83)) %>%
  mutate("F" = c(1815.06, 819.15, 321.79, 1004.87)) %>%
  mutate_if(is.numeric, round, 2)


#-----------------------------------------------------------------------
# Table 3: MR Results with OR and CI
#-----------------------------------------------------------------------

# convert b to OR 
table3 <- generate_odds_ratios(bind_rows(mr_res_all))  %>% 
  mutate(method = recode(method, !!!mr_codes)) %>%
  filter(method == "IVW") %>%    # TODO: switch out for main_analysis
  
  # add CI column
  mutate(CI = glue::glue("({sprintf('%.2f',or_lci95)}, \\
                         {sprintf('%.2f',or_uci95)})")) %>%
  select(c(exposure, nsnp, method, or, CI, pval)) %>%
  mutate_if(is.numeric, round, 2) %>%
  
  # add pleiotropy p_plt
  mutate(pleio_all %>% 
           select(egger_intercept, pval) %>% 
           rename("β0"= egger_intercept, p_plt = pval) %>%
           mutate(β0 = round(β0,4), p_plt = round(p_plt, 2))
         ) %>%
  
  # add heterogeneity p_het
  mutate(het_all %>% 
           filter(method == "IVW") %>%  # TODO: switch out for main_analysis
           select(Q_pval) %>% 
           rename(p_het = Q_pval) %>%
           mutate(p_het = round(p_het,2))
         ) 


#-----------------------------------------------------------------------
# Table 4: MR Sensitivity Analyses
#-----------------------------------------------------------------------
table4 <- generate_odds_ratios(bind_rows(mr_res_all))  %>% 
  mutate(method = recode(method, !!!mr_codes)) %>%
  
  # add CI column
  mutate(CI = glue::glue("({sprintf('%.2f',or_lci95)}, \\
                         {sprintf('%.2f',or_uci95)})")) %>%
  select(c(exposure, nsnp, method, or, CI, pval)) %>%
  mutate_if(is.numeric, round, 2) %>%
  filter(method != "MR Egger")



