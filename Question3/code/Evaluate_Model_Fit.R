# Reports the full default model's AUC, sample size, and deviance/AIC
# goodness-of-fit statistics.
Evaluate_Model_Fit <- function(model){

  predicted <- predict(model, type = "response")
  actual    <- model$model$defaulted

  tibble::tibble(
    auc                = Compute_AUC(actual, predicted),
    n                  = length(actual),
    aic                = AIC(model),
    null_deviance      = model$null.deviance,
    residual_deviance  = model$deviance
  )

}
