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


# coalesce all studies into 1 list
bmi_hoff_afr <- read_tsv(here(harmonised_path, "mrdat_bmi_hoffmann_LD_AFR.txt"))
bmi_hoff_eur <- read_tsv(here(harmonised_path, "mrdat_bmi_hoffmann_LD_EUR.txt"))
bmi_page_afr <- read_tsv(here(harmonised_path, "mrdat_bmi_PAGE_LD_AFR.txt"))
bmi_page_hoff_snp <- read_tsv(here(harmonised_path, "mrdat_bmi_PAGE_snp_hoffmann.txt"))

# only include replicating SNPs for PAGE_Hoffman
bmi_page_hoff_snp <- bmi_page_hoff_snp %>% filter(REP.PAGE == 1)
# TODO: need to update code w/ eaf.diff:
# # mr.dat$eaf.diff<-abs(mr.dat$eaf.exposure - mr.dat$eaf.outcome)
# #subset only to replicated SNPs 
# mr.dat$mr_keep[mr.dat$REP.PAGE==0]<-FALSE
# # subset to SNPs that have similar effect allele frequencies between populations
# mr.dat$mr_keep[mr.dat$eaf.diff>0.15]<-FALSE
# mr.dat %>% count(mr_keep)


#-----------------------------------------------------------------------
# Export harmonised datas
#-----------------------------------------------------------------------
harmonised_dats <- list(Hoffman_AFR = bmi_hoff_afr, 
                        Hoffman_EUR = bmi_hoff_eur,
                        PAGE_AFR = bmi_page_afr,
                        PAGE_Hoffman = bmi_page_hoff_snp)

write_rds(harmonised_dats, file = here(harmonised_datas_path))


