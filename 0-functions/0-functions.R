################################################################################
# 0-functions
#
# run different MR methods on harmonised datasets
################################################################################


# goes through a named list of dataframes and replaces 
# a column with the associated list name
# dat = a list of dataframes
# orig_col = column to be replaced with list name
replace_exp_column <- function(dat, orig_col) {
  for (i in seq_along(dat)) {
    dat[[i]] <- 
      dat[[i]] %>%
      rename(!!paste0(orig_col, ".old") := {{orig_col}}) %>%
      mutate({{orig_col}} := names(harmonised_dats)[i])
  }
  return(dat)
}