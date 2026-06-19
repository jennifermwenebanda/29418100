# Does home ownership remain associated with default after controlling for
# income, debt burden (DTI) and credit grade? Reports odds ratios from a
# logistic regression so the Director can see whether the raw heuristic
# survives adjustment for the obvious confounders.
Test_Homeownership_Adjusted <- function(df){

  model_df <- df %>%
    dplyr::filter(!is.na(home_ownership_grp), !is.na(grade),
                  !is.na(dti_clean), !is.na(annual_inc))

  model <- glm(defaulted ~ home_ownership_grp + log1p(annual_inc) + dti_clean + grade,
               data = model_df, family = binomial())

  broom::tidy(model, exponentiate = TRUE, conf.int = TRUE) %>%
    dplyr::filter(stringr::str_detect(term, "home_ownership_grp"))

}
