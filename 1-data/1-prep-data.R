################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 1-prep-data
# --------------------
# clean and manage GWAS data that will be used for MR analysis
# harmonize datasets
# to use this file, change own_harmonised_data variable to FALSE
################################################################################

rm(list=ls())
source(here("0-config.R"))

#-----------------------------------------------------------------------
# Import, clean data, select instruments
#-----------------------------------------------------------------------

# Hoffman exposure dataset
hoffman <- fread(here(hoffman_path))
exp.hoff <- hoffman %>% 
  mutate(exposure = "BMI_Hoffmann") %>%
  filter(P < 05e-08) %>%
  format_data(type="exposure",snps=NULL, phenotype_col="exposure", 
              snp_col="SNP", beta_col="BETA", se_col="SE", eaf_col="FRQ1",
              pval_col="P", effect_allele_col="A1", other_allele_col="A2", 
              samplesize_col="N", chr_col="CHR", pos_col="POS", min_pval=0)

# PAGE exposure dataset
page<-fread(here(page_path))
exp.page <- page %>% 
  mutate(exposure = "BMI_PAGE") %>%
  filter(`P-val` < 05e-08) %>%
  format_data(type="exposure", snps=NULL, phenotype_col="exposure", 
              snp_col="SNP", beta_col="Beta", se_col="SE", 
              eaf_col="Effect-allele-frequency", pval_col="P-val",
              effect_allele_col="Effect-allele", other_allele_col="Other-allele",
              samplesize_col="Sample-size", chr_col="Chr", 
              pos_col="Position_hg19",  min_pval=0)

# PAGE Hoffman replication exposure dataset
exp.page_hoff <- exp.hoff %>%
  mutate(beta.exposure = coalesce(page$beta.exposure[match(SNP, page$SNP)],
                                  beta.exposure),
         REP.PAGE = ifelse(SNP %in% page$SNP, 1, 0))
         

#-----------------------------------------------------------------------
# Clump data (ensure independence)
#-----------------------------------------------------------------------
exp.hoff.eur <- clump_data(exp.hoff, clump_r2 = 0.05, pop="EUR") %>% 
  mutate(exposure = "BMI_Hoffmann_LD_EUR")
exp.hoff.afr <- clump_data(exp.hoff, clump_r2 = 0.05, pop="AFR") %>% 
  mutate(exposure = "BMI_Hoffmann_LD_AFR")
exp.page.afr <- clump_data(exp.page, clump_r2 = 0.05, pop="AFR") %>% 
  mutate(exposure = "BMI_PAGE_LD_AFR")
exp.page_hoff.afr <- clump_data(exp.page_hoff, clump_r2 = 0.05, pop="AFR") %>%
  mutate(exposure = "BMI_PAGE_snp_hoffmann")


#-----------------------------------------------------------------------
# Harmonize datasets
#-----------------------------------------------------------------------

# PRACTICAL outcome dataset
practical <- fread(here(practical_path))
subset_harmonise <- function(exp.dat, practical) {
  ## subset prostate cancer GWAS only to relevant SNPs
  out.prac <- practical %>% 
    filter(SNP_Id %in% exp.dat$SNP) %>% 
    mutate(outcome = "prostate_cancer",
           total = Case_size + Control_size) %>% 
    mutate(NEA = ifelse(EA==Allele_1, Allele_2, Allele_1)) %>%
    format_data(type="outcome", snps=NULL, phenotype_col="outcome", 
                snp_co="SNP_Id", beta_col="Estimate_Effect", se_col="SE",
                pval_col = "P_value", eaf_col = "EAF_Control", 
                ncase_col = "Case_size", ncontrol_col = "Control_size",
                samplesize_col = "total", effect_allele_col="EA", 
                other_allele_col="NEA")
  harmonise_data(exposure_dat = exp.dat, outcome_dat = out.prac) %>% as_tibble
}

bmi.hoff.eur <- subset_harmonise(exp.hoff.eur, practical) %>% filter(mr_keep == T)
bmi.hoff.afr <- subset_harmonise(exp.hoff.afr, practical) %>% filter(mr_keep == T)
bmi.page.afr <- subset_harmonise(exp.page.afr, practical) %>% filter(mr_keep == T)
bmi.page_hoff <- subset_harmonise(exp.page_hoff.afr, practical) %>% filter(mr_keep == T)


#-----------------------------------------------------------------------
# Output harmonized datasets
#-----------------------------------------------------------------------
write.table(bmi.hoff.eur, here(harmonised_dir_prep, "bmi.hoff.eur"), 
            sep="\t", row.names = F, quote = F)
write.table(bmi.hoff.afr, here(harmonised_dir_prep, "bmi.hoff.afr"), 
            sep="\t", row.names = F, quote = F)
write.table(bmi.page.afr, here(harmonised_dir_prep, "bmi.page.afr"), 
            sep="\t", row.names = F, quote = F)
write.table(bmi.page_hoff, here(harmonised_dir_prep, "bmi.page_hoff"), 
            sep="\t", row.names = F, quote = F)

