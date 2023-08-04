################################################################################
# 0-config.R
#
# @Description
#  - goal is to reduce redundancy
#  - create an abstraction layer that allows changes in one place
#
#  - Every other file in the project will begin with source("0-config.R")
#  - file assume that users have opened the .Rproj file,
#  - which sets the directory to the top level of the project.
################################################################################


#--------------------------------------------
# load libraries
#--------------------------------------------
library(here)
library(tidyverse)
library(TwoSampleMR)

#--------------------------------------------
# load global variables
#--------------------------------------------
main_analysis = c("mr_ivw", "mr_ivw_mre")

#--------------------------------------------
# define harmonized data path
#--------------------------------------------
harmonised_path <- here::here("1-data/harmonised-data")

#--------------------------------------------
# define output paths
#--------------------------------------------
figures_path <- here::here("4-figures")
results_path <- here::here("5-results")
harmonised_datas_path <- here::here(results_path, "harmonised-all.rds")
