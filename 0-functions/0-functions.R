################################################################################
# Thesis - Mendelian Randomization 
# Adiposity and Prostate Cancer in Men of African Ancestry
# 2023 Witte Lab
# 
# 0-functions
# --------------------
# Useful functions
################################################################################

# [TEMPLATE]
#-------------------------------------------------------------------------------
# function_name(param1, ...)
# description
# ----------
# args: 
#   - 
# returns: 
# output: 
#-------------------------------------------------------------------------------

################################################################################
################################################################################


#-------------------------------------------------------------------------------
# replace_exp_column(dat, orig_col)
# goes through a named list of dataframes and replaces a column with the 
# respective list name
# ----------
# args: 
#   - dat:        a list of dataframes
#   - orig_col:   column to be replaced with list name
# returns:        named list
# output:         ...
#-------------------------------------------------------------------------------

replace_exp_column <- function(dat, orig_col) {
  for (i in seq_along(dat)) {
    dat[[i]] <- 
      dat[[i]] %>%
      rename(!!paste0(orig_col, ".old") := {{orig_col}}) %>%
      mutate({{orig_col}} := names(harmonised_dats)[i])
  }
  return(dat)
}

################################################################################
################################################################################


#-------------------------------------------------------------------------------
# calculate_pve(dataset)
# calculate proportion variance explained (PVE) for GWAS dataset
# 
# args:   
#  - dataset: harmonized dataset
# returns:    ...
# outputs:    prints PVE
#-------------------------------------------------------------------------------

calculate_pve <- function(dataset) {
  pve <- dataset %>%
    mutate(
      VAR.1 = 2*beta.exposure^2*eaf.exposure*(1-eaf.exposure),
      VAR.2 = 2*se.exposure^2*samplesize.exposure*eaf.exposure*(1-eaf.exposure),
      PVE = VAR.1/(VAR.1 + VAR.2)
      ) %>%
    select(PVE) %>%
    sum(na.rm = TRUE)
}

################################################################################
################################################################################




