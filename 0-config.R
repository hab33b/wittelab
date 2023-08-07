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

# Load libraries
library(here)
library(tidyverse)
library(glue)
library(TwoSampleMR)
library(todor)
library(gridExtra)
# library(grid)
library(ggplot2)
library(gt)
library(patchwork)

# Load global variables
main_analysis <- c("mr_ivw", "mr_ivw_mre")
mr_codes <- list(
  `Inverse variance weighted` = "IVW",
  `Inverse variance weighted (multiplicative random effects)` = "IVW (mre)",
  `Maximum likelihood` = "ML", 
  `Robust adjusted profile score (RAPS)` = "RAPS", 
  `Weighted median` = "WM", 
  `MR Egger` = "MR Egger"
)
all_method_list = c(main_analysis,
                "mr_two_sample_ml",
                "mr_raps",
                "mr_weighted_median",
                "mr_egger_regression")


# Define raw data paths
harmonised_path <- here::here("1-data/harmonised-data")


# Define output paths
figures_dir <- here::here("4-figures")
results_dir <- here::here("5-results")
harmonised_datas_path <- here::here(results_dir, "harmonised-all.rds")
mr_res_path <- here::here(results_dir, "mr-res-all.rds")
het_all_path <- here::here(results_dir, "het_all.rds")
pleio_all_path <- here::here(results_dir, "pleio_all.rds")


# Load scripts
source(here("0-functions/0-functions.R"))

