# Fits default ~ grade alone and reports the AUC, i.e. how well grade alone
# discriminates eventual Charged Off from Fully Paid loans.
Evaluate_Grade_Predictive_Power <- function(df){

  model_df <- dplyr::filter(df, !is.na(grade), !is.na(defaulted))
  model    <- glm(defaulted ~ grade, data = model_df, family = binomial())

  predicted <- predict(model, type = "response")

  tibble::tibble(
    auc          = Compute_AUC(model_df$defaulted, predicted),
    n            = nrow(model_df),
    n_predictors = 1
  )

}
