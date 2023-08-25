# run all scripts in all directories

source(here("0-config.R"))
source(here("1-data/0-run-data.R"))
source(here("2-analysis/0-run-analysis.R"))
source(here("3-figure-table-scripts/0-run-results.R"))

# run 0-config.R file first to download all necessary libraries

# NOTE: if you want to create harmonised data from scractch & 
# run 1-prep-data.R from 1-data directory, 
# change own_harmonised_data to FALSE in 0-config.R file
