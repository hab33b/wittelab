################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 2-collect-data
# --------------------
# perform qc on harmonized datasets and coalesce all studies into 1 list
################################################################################

# rm(list=ls())
source(here("0-config.R"))


#-----------------------------------------------------------------------
# Import: harmonised datasets
#-----------------------------------------------------------------------

# all harmonised datasets
bmi_hoff_eur  <- read_tsv(here(harmonised_dir, "mrdat_bmi_hoffmann_LD_EUR.txt"))
bmi_hoff_afr  <- read_tsv(here(harmonised_dir, "mrdat_bmi_hoffmann_LD_AFR.txt"))
bmi_page_afr  <- read_tsv(here(harmonised_dir, "mrdat_bmi_PAGE_LD_AFR.txt"))
bmi_page_hoff <- read_tsv(here(harmonised_dir, "mrdat_bmi_PAGE_snp_hoffmann.txt"))

# if using 1-prep-data.R
if (!own_harmonised_data) {
  bmi_hoff_eur  <- read_tsv(here(harmonised_dir_prep, "bmi.hoff.eur"))
  bmi_hoff_afr  <- read_tsv(here(harmonised_dir_prep, "bmi.hoff.afr"))
  bmi_page_afr  <- read_tsv(here(harmonised_dir_prep, "bmi.page.afr"))
  bmi_page_hoff <- read_tsv(here(harmonised_dir_prep, "bmi.page_hoff"))
}


#-----------------------------------------------------------------------
# PVE: estimate variation explained
#-----------------------------------------------------------------------
# Note: estimate will be inflated if 
#         - using betas from the discovery GWAS
#         - using EUR betas for SNPs clumped using AFR LD

calculate_pve(bmi_hoff_eur)
# calculate_pve(bmi_hoff_afr);   # pve will be inflated
calculate_pve(bmi_page_afr)
calculate_pve(bmi_page_hoff)


#-----------------------------------------------------------------------
# QC (quality control)
#-----------------------------------------------------------------------

# calculate exposure & outcome GWAS allele freq diff
quality_control <- function(harm.dat) {
  harm.dat <- harm.dat %>%
    mutate(eaf.diff = abs(eaf.exposure - eaf.outcome)) %>%
    # subset similar allele freq
    mutate(mr_keep = 
             if_else(!is.na(eaf.diff) & eaf.diff > 0.15, FALSE, mr_keep)) %>%
    mutate(mr_keep = if_else(REP.PAGE %in% 0, FALSE, mr_keep))
}

# only include replicating SNPs for PAGE_Hoffman
bmi_page_hoff <- quality_control(bmi_page_hoff)


#-----------------------------------------------------------------------
# Coalesce
#-----------------------------------------------------------------------
harmonised_dats <- list(
  Hoffman_EUR  = bmi_hoff_eur,
  Hoffman_AFR  = bmi_hoff_afr,
  PAGE_AFR     = bmi_page_afr,
  PAGE_Hoffman = bmi_page_hoff
)


#-----------------------------------------------------------------------
# Export harmonised data list
#-----------------------------------------------------------------------
write_rds(harmonised_dats, file = here(harmonised_datas_path))



