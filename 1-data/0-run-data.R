# run all scripts in 1-data folder

if(!own_harmonised_data) {
  source(here("1-data/1-prep-data.R"))
}
source(here("1-data/2-collect-data.R"))