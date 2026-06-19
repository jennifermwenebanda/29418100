# Master script - Question 3: Loans and Credit (Lending Club default analysis)
# Run from the Question3 project root: source("run_project.R")
# Sequentially sources every function, runs the full analysis, saves every
# table and figure into Question3_files, and leaves every result object in
# the global environment for the report to use.
#
# Deliberately lives OUTSIDE code/: code/ is globbed recursively below, so a
# copy of this script sitting inside code/ would re-source (and re-run)
# itself indefinitely.

gc()
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, lubridate, broom, scales)
# Note: the "maps" package is deliberately NOT attached via library()/p_load()
# here. maps::map() collides with purrr::map() on the search path and caused
# a runaway "infinite recursion" error when both were attached together.
# State_Default_Map.R calls ggplot2::map_data("state"), which uses maps::map()
# internally via explicit namespacing - maps only needs to be INSTALLED, not
# attached, for that to work.

# Source every function in code/ - one file, one function, as per project convention.
list.files("code/", full.names = TRUE, recursive = TRUE) %>%
  as.list() %>%
  purrr::walk(~source(.))

dir.create("Question3_files/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("Question3_files/tables",  recursive = TRUE, showWarnings = FALSE)
dir.create("Question3_files/report",  recursive = TRUE, showWarnings = FALSE)

# --- Load and clean ----------------------------------------------------------
raw_loans <- Load_Loans()
loans     <- Clean_Loans_Pipeline(raw_loans)
resolved  <- dplyr::filter(loans, is_resolved)

# --- Heuristic 1: Home ownership ---------------------------------------------
home_summary  <- Test_Homeownership_Heuristic(resolved)
home_adjusted <- Test_Homeownership_Adjusted(resolved)

# --- Heuristic 2: Employment length ------------------------------------------
emp_summary   <- Test_Employment_Heuristic(resolved)
emp_by_term   <- Test_Employment_By_Term(resolved)
emp_by_grade  <- Test_Employment_By_Grade(resolved)
emp_by_income <- Test_Employment_By_Income(resolved)

# --- Heuristic 3: State-level default culture, incl. Texas deep-dive --------
state_summary  <- Test_State_Heuristic(resolved)
texas_summary  <- Analyse_Texas(resolved, state_summary)
texas_sig      <- Test_Texas_Significance(resolved)
texas_dti_comp <- Texas_DTI_Comparison(resolved)

# --- Heuristic 4: Grade vs. age -----------------------------------------------
grade_age_summary <- Test_Grade_Age_Heuristic(resolved)
grade_monotonic   <- Check_Grade_Monotonicity(grade_age_summary)

# --- Heuristic 5: Interest-rate drivers ---------------------------------------
rate_model      <- Test_Interest_Rate_Heuristic(loans)
rate_importance <- Interest_Rate_Driver_Importance(rate_model)

# --- "Who actually defaults?" borrower profiles -------------------------------
delinq_summary        <- Default_Rate_By_Delinquency(resolved)
income_band_summary   <- Default_Rate_By_Income_Band(resolved)
verification_summary  <- Default_Rate_By_Verification(resolved)
risk_profiles          <- Build_Risk_Profiles(resolved)

# --- DTI hard-cap recommendations ---------------------------------------------
dti_summary <- DTI_Default_Rates(resolved)
dti_scen    <- DTI_Scenarios(resolved)

# --- Grading-system efficacy ---------------------------------------------------
grade_summary    <- Grade_Default_Rates(resolved)
subgrade_summary <- Subgrade_Default_Rates(resolved)
grade_ordering   <- Check_Grade_Ordering(grade_summary)
grade_auc        <- Evaluate_Grade_Predictive_Power(resolved)

# --- Key risk drivers: multivariate default model -----------------------------
risk_model     <- Fit_Default_Model(resolved)
var_importance <- Get_Variable_Importance(risk_model)
model_fit      <- Evaluate_Model_Fit(risk_model)

# --- Persist every analysis table ----------------------------------------------
write_csv(home_summary,         "Question3_files/tables/homeownership_summary.csv")
write_csv(home_adjusted,        "Question3_files/tables/homeownership_adjusted.csv")
write_csv(emp_summary,          "Question3_files/tables/employment_summary.csv")
write_csv(emp_by_term,          "Question3_files/tables/employment_by_term.csv")
write_csv(emp_by_grade,         "Question3_files/tables/employment_by_grade.csv")
write_csv(emp_by_income,        "Question3_files/tables/employment_by_income.csv")
write_csv(state_summary,        "Question3_files/tables/state_summary.csv")
write_csv(texas_summary,        "Question3_files/tables/texas_summary.csv")
write_csv(texas_sig,            "Question3_files/tables/texas_significance.csv")
write_csv(texas_dti_comp,       "Question3_files/tables/texas_dti_comparison.csv")
write_csv(grade_age_summary,    "Question3_files/tables/grade_age_summary.csv")
write_csv(grade_monotonic,      "Question3_files/tables/grade_age_monotonicity.csv")
write_csv(rate_importance,      "Question3_files/tables/interest_rate_drivers.csv")
write_csv(delinq_summary,       "Question3_files/tables/delinquency_summary.csv")
write_csv(income_band_summary,  "Question3_files/tables/income_band_summary.csv")
write_csv(verification_summary, "Question3_files/tables/verification_summary.csv")
write_csv(risk_profiles,        "Question3_files/tables/risk_profiles.csv")
write_csv(dti_summary,          "Question3_files/tables/dti_summary.csv")
write_csv(dti_scen,             "Question3_files/tables/dti_scenarios.csv")
write_csv(grade_summary,        "Question3_files/tables/grade_summary.csv")
write_csv(subgrade_summary,     "Question3_files/tables/subgrade_summary.csv")
write_csv(grade_ordering,       "Question3_files/tables/grade_ordering.csv")
write_csv(grade_auc,            "Question3_files/tables/grade_auc.csv")
write_csv(var_importance,       "Question3_files/tables/risk_driver_importance.csv")
write_csv(model_fit,            "Question3_files/tables/risk_model_fit.csv")

# --- Generate every figure (each call also saves its own PNG) -----------------
Homeownership_Default_Plot(home_summary)
Employment_Default_Plot(emp_summary)
State_Default_Map(state_summary)
Texas_Comparison_Plot(texas_summary)
DTI_Default_Plot(dti_summary)
Grade_Default_Plot(grade_summary, grade_auc$auc)
Risk_Driver_Plot(var_importance)
