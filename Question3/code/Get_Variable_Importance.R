# Ranks the default model's predictors by absolute Wald t-statistic and
# reports odds ratios with 95% confidence intervals for interpretation.
Get_Variable_Importance <- function(model){

  broom::tidy(model, exponentiate = TRUE, conf.int = TRUE) %>%
    dplyr::filter(term != "(Intercept)") %>%
    dplyr::arrange(dplyr::desc(abs(statistic))) %>%
    dplyr::mutate(rank = dplyr::row_number())

}
