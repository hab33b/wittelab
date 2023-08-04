################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 0-prep-data
# --------------------
# clean and manage data that will be used for MR analysis
################################################################################

rm(list=ls())
source(here("0-config.R"))

bmi_hoff_afr <- read_tsv(here(harmonised_path, "mrdat_bmi_hoffmann_LD_AFR.txt"))
bmi_hoff_eur <- read_tsv(here(harmonised_path, "mrdat_bmi_hoffmann_LD_EUR.txt"))
bmi_page_afr <- read_tsv(here(harmonised_path, "mrdat_bmi_PAGE_LD_AFR.txt"))
bmi_page_hoff_snp <- read_tsv(here(harmonised_path, "mrdat_bmi_PAGE_snp_hoffmann.txt"))

subsets <- list(bHa = bmi_hoff_afr, 
                 bHe = bmi_hoff_eur,
                 bPa = bmi_page_afr,
                 bPH = bmi_page_hoff_snp)

write_rds(subsets, file = here(harmonised_datas_path))
