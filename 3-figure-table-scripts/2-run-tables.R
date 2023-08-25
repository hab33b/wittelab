################################################################################
# Thesis - Mendelian Randomization
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
#
# 2-run-tables
# --------------------
# create tables from MR data for the thesis paper
################################################################################

# rm(list=ls())
source(here("0-config.R"))

#-----------------------------------------------------------------------
# Import
#-----------------------------------------------------------------------
harmonised_dats <- read_rds(here(harmonised_datas_path))
mr_res_all <- read_rds(here(mr_res_path))
het_all <- read_rds(here(het_all_path)) # combined data frame
pleio_all <- read_rds(here(pleio_all_path)) # combined data frame



#-----------------------------------------------------------------------
# Table 1: Exposure datasets
#-----------------------------------------------------------------------


dat <- tibble(
  Group = c(1, 2, 3, 4, 5),
  N = c(81278, 8322, 7290, 3069, 459),
  Male_N = c(33943, 3277, 3026, 1235, 270),
  Female_N = c(47335, 5045, 4264, 1834, 189),
  Mean_Age_Male = c(63.9, 59.1, 59.2, 61.6, 55.3),
  Mean_Age_Female = c(60.3, 52.9, 53.4, 56.5, 48.0),
  Mean_BMI_Male = c(28.0, 29.1, 26.1, 29.3, 25.8),
  Mean_BMI_Female = c(27.3, 28.6, 24.5, 30.8, 25.2)
)
# N
sum(dat$N)

# Hoffman Age average
dat %>% 
  mutate(Group_Mean_Age = (Male_N*Mean_Age_Male + Female_N*Mean_Age_Female)/N) %>% 
  summarise(y = sum(N*Group_Mean_Age)/sum(N))

# Hoffman BMI average
dat %>% 
  mutate(Group_Mean_Age = (Male_N*Mean_BMI_Male + Female_N*Mean_BMI_Female)/N) %>% 
  summarise(y = sum(N*Group_Mean_Age)/sum(N))

# PAGE BMI average
dat <- tibble(
  N = c(17127, 21955, 4647, 3936, 645, 1025),
  Mean_BMI = c(30.387, 29.527, 25.272, 29.001, 29.971, 26.855),
  SD_BMI = c(6.638, 6.065, 4.233, 5.900, 6.555, 5.849)
)

dat %>%
  summarise(weighted_avg_bmi = sum(N * Mean_BMI) / sum(N))



#-----------------------------------------------------------------------
# Table 2: Proportion of Variance Explained (PVE) Calculation 
#-----------------------------------------------------------------------
table2 <- tibble()

for (name in names(harmonised_dats)) {
  dat <- harmonised_dats[[name]]
  
  # calculate sum of PVE column
  PVE.tot <- calculate_pve(dat)
  
  # create table of PVE
  table2 <- table2 %>%
    bind_rows(tibble(Exposure=name, Nsnp=nrow(dat), "R^2 (%)"= PVE.tot * 100))
}

# prepare table
# values calculated using https://shiny.cnsgenomics.com/mRnd/
table2 <- table2 %>%
  mutate("OR (risk)" = c(1.15, 1.22, 1.37, 1.20)) %>%
  mutate("OR (protective)" = c(0.87, 0.81, 0.73, 0.83)) %>%
  mutate("F" = c(1815.06, 819.15, 321.79, 1004.87)) %>%
  mutate_if(is.numeric, round, 2) %>%
  filter(Exposure != "Hoffman_AFR")


#-----------------------------------------------------------------------
# Table 3: MR Results with OR and CI
#-----------------------------------------------------------------------

# convert b to OR 
table3 <- generate_odds_ratios(bind_rows(mr_res_all))  %>% 
  mutate(method = recode(method, !!!mr_codes)) %>%
  filter(method == c("IVW (fe)")) %>%
  
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
           filter(method == "IVW (fe)") %>%
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
  mutate_if(is.numeric, round, 2)


#-----------------------------------------------------------------------
# Export tables to results folder
#-----------------------------------------------------------------------
write_tsv(table2, here(results_dir, "2-table.tsv"))
write_tsv(table3, here(results_dir, "3-table.tsv"))
write_tsv(table4, here(results_dir, "4-table.tsv"))
