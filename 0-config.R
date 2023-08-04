################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 0-config.R
# Configuration file for loading variables and path specifications
#  - Every other file in the project will begin with source("0-config.R")
#  - file assume that users have opened the .Rproj file,
#  - which sets the directory to the top level of the project.
################################################################################

# Load libraries
library(here)
library(tidyverse)

library(TwoSampleMR)


# Load global variables
main_analysis <- c("mr_ivw", "mr_ivw_mre")


# Define raw data paths
harmonised_path <- here::here("1-data/harmonised-data")


# Define output paths
figures_dir <- here::here("4-figures")
results_dir <- here::here("5-results")
harmonised_datas_path <- here::here(results_dir, "harmonised-all.rds")


# Load scripts
source(here("0-functions/0-functions.R"))

