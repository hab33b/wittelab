## Adiposity and Risk of Prostate Cancer among those of African Ancestry Using Mendelian Randomization
THESIS

Habeeb Jimoh - Witte Lab 2023

Acknowledgements: Many thanks to Dr. Kachuri for providing alot of the resources in creating the code for this analysis

### Overview
We used Mendelian Randomization to validate if there is a causal relationship between BMI and prostate cancer in different ancestries.

### Directory
**`0-config.R`** : configuration file, loads required libraries, sets raw data directories & other paths, sources functions
**`1-run-all.R`**: run this file to run all scripts in all subdirectories


**`0-functions`** : folder containing function scripts
* `0-functions.R`: script containing general functions used across the analysis


**`1-data`** : folder containing data processing scripts. Run `0-run-data.R` to run all scripts in this subdirectory.
* `1-prep-data.R`: processes GWAS outcome and exposure data to process into a harmonized dataset. Must set `own_harmonised_data=F` to run this file.
* `2-collect-data.R`: qc & process harmonized dataset, collects harmonized samples into a list
  * `harmonised-data`: pre-processed harmonized datasets
  * `harmonised-data-prep`: harmonized datasets processed by `1-prep-data.R`


**`2-analysis`** : folder containing analysis scripts. Run `0-run-analysis.R` to rerun all scripts in this subdirectory.
* `1-run-MR.R`: run MR analysis
* `2-run-sensitiivity.R`: run MR diagnostic tests


**`3-figure-table-scripts`** : folder containing figure and table scripts. Run `0-run-results.R` to rerun all scripts in this subdirectory.
* `1-run-figures.R`: creates all MR plots (forest plot, scatter plot, funnel plot)
* `2-run-tables.R`: creates all tables


**`4-figures`** : folder containing figures. 


**`5-results`** : folder containing analysis results.
