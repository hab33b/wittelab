library(remotes)
install_github("MRCIEU/TwoSampleMR")
library(TwoSampleMR)

# List available GWASs
ao <- available_outcomes()

# Get instruments
bmi_exp_dat <- extract_instruments(outcomes = 'ieu-a-2')

# Get effects of instruments on outcome
mm_out_dat <- extract_outcome_data(snps=bmi_exp_dat$SNP, outcomes = "ieu-b-4957")

dat <- harmonise_data(bmi_exp_dat, mm_out_dat)

# perform mr
mr(dat, method_list = c("mr_egger_regression", "mr_ivw"))


mr_heterogeneity(dat)
res_loo <- mr_leaveoneout(dat)

