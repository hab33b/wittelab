################################################################################
# Thesis - Mendelian Randomization
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
#
# 0-config
# --------------------
# Configuration file for loading variables and path specifications
#  - Every other file in the project will begin with source("0-config.R")
#  - file assume that users have opened the .Rproj file,
#  - which sets the directory to the top level of the project.
################################################################################

#-----------------------------------------------------------------------
# Load libraries
#-----------------------------------------------------------------------
library(here)
library(tidyverse)
library(TwoSampleMR)
library(gridExtra)
library(data.table)


#-----------------------------------------------------------------------
# Load Global variables
#-----------------------------------------------------------------------
mr_codes <- list(
  `Inverse variance weighted (fixed effects)`                 = "IVW (fe)",
  `Inverse variance weighted (multiplicative random effects)` = "IVW (mre)",
  `Maximum likelihood`                                        = "ML",
  `Robust adjusted profile score (RAPS)`                      = "RAPS",
  `Weighted median`                                           = "WME",
  `MR Egger`                                                  = "MR Egger"
)

main_analysis <- c("mr_ivw_fe", "mr_ivw_mre")

all_method_list = c(
  main_analysis,
  "mr_two_sample_ml",
  "mr_raps",
  "mr_weighted_median",
  "mr_egger_regression"
)


#-----------------------------------------------------------------------
# Define raw data paths
#-----------------------------------------------------------------------

# pre-made harmonised data ----
# if you are NOT using pre-made harmonized datasets that exist in the 
# "harmonised-data" folder then change own_harmonised_data to false
own_harmonised_data = T
harmonised_dir <- here("1-data/harmonised-data")

# preparing harmonised data from raw gwas data ----
if (!own_harmonised_data) {
  harmonised_dir_prep <- here("1-data/harmonised-data-prep")
  gwas_dir            <- here("../gwas")
  # exposure GWAS
  hoffman_path        <- here(gwas_dir, "BMI-GERA+GIANT-2018.tsv")
  page_path           <- here(gwas_dir, "invn_rbmi_alls.combined.page.out")
  # outcome GWAS
  practical_path      <- here(gwas_dir, "ELLIPSE_V2_META_AFRICAN_Results_012121.txt")
}


#-----------------------------------------------------------------------
# Define main output paths
#-----------------------------------------------------------------------
figures_dir           <- here("4-figures")
results_dir           <- here("5-results")

harmonised_datas_path <- here(results_dir, "harmonised_all.rds")
mr_res_path           <- here(results_dir, "mr_res_all.rds")
het_all_path          <- here(results_dir, "het_all.rds")
pleio_all_path        <- here(results_dir, "pleio_all.rds")


#-----------------------------------------------------------------------
# Load scripts
#-----------------------------------------------------------------------
source(here("0-functions/0-functions.R"))
