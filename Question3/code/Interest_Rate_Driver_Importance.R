# Ranks the interest-rate model's predictors by absolute Wald t-statistic -
# the variable Lending Club leans on most heavily when pricing risk.
Interest_Rate_Driver_Importance <- function(model){

  broom::tidy(model) %>%
    dplyr::filter(term != "(Intercept)") %>%
    dplyr::arrange(dplyr::desc(abs(statistic)))

}
