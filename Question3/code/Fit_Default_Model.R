# Full default-risk logistic regression. Logistic regression is used
# (rather than a black-box ML method) because its coefficients are directly
# interpretable as odds ratios for the Director. int_rate_num is
# deliberately excluded as a predictor: Lending Club prices the rate FROM
# the grade, so including both would be circular and the two are highly
# collinear; grade is kept as the more policy-relevant, interpretable
# variable. emp_title is excluded for the same high-cardinality reason
# given in Test_Interest_Rate_Heuristic.R.
Fit_Default_Model <- function(df){

  model_df <- df %>%
    Bucket_Employment_Length() %>%
    dplyr::filter(!is.na(defaulted), !is.na(grade), !is.na(dti_clean), !is.na(annual_inc),
                  !is.na(home_ownership_grp), !is.na(verification_status), !is.na(term_label),
                  !is.na(age_proxy), !is.na(emp_length_num))

  glm(
    defaulted ~ grade + dti_clean + log1p(annual_inc) + home_ownership_grp +
      verification_status + term_label + age_proxy + emp_length_num,
    data = model_df, family = binomial()
  )

}
