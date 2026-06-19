# Heuristic 5 (interest-rate drivers): regresses interest rate on grade,
# age proxy, DTI, income, verification status and employment length.
# emp_title is excluded: a free-text field with well over 100,000 unique
# values in the raw data - too high-cardinality for a regression predictor
# without NLP-based occupation clustering, which is out of scope here.
Test_Interest_Rate_Heuristic <- function(df){

  model_df <- df %>%
    dplyr::filter(!is.na(int_rate_num), !is.na(grade), !is.na(dti_clean),
                  !is.na(annual_inc), !is.na(age_proxy), !is.na(verification_status),
                  !is.na(emp_length_num))

  lm(int_rate_num ~ grade + age_proxy + dti_clean + log1p(annual_inc) +
       verification_status + emp_length_num, data = model_df)

}
