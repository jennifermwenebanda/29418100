# "Who actually defaults?" - default rate by income quintile.
Default_Rate_By_Income_Band <- function(df, n_bands = 5){

  df %>%
    dplyr::filter(!is.na(annual_inc)) %>%
    dplyr::mutate(income_band = dplyr::ntile(annual_inc, n_bands)) %>%
    dplyr::group_by(income_band) %>%
    dplyr::summarise(
      n             = dplyr::n(),
      income_min    = min(annual_inc),
      income_max    = max(annual_inc),
      default_rate  = mean(defaulted, na.rm = TRUE),
      .groups = "drop"
    )

}
