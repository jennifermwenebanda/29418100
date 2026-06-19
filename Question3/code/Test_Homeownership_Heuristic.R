# Heuristic 1 (home ownership): raw default rate by ownership category.
Test_Homeownership_Heuristic <- function(df){

  df %>%
    dplyr::filter(!is.na(home_ownership_grp)) %>%
    dplyr::group_by(home_ownership_grp) %>%
    dplyr::summarise(
      n              = dplyr::n(),
      default_rate   = mean(defaulted, na.rm = TRUE),
      median_income  = median(annual_inc, na.rm = TRUE),
      median_dti     = median(dti_clean, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    dplyr::arrange(default_rate)

}
