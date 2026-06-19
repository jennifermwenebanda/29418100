# Checks whether default risk increases consistently as credit grade
# declines from A to G.
Check_Grade_Ordering <- function(grade_summary){

  grade_summary %>%
    dplyr::arrange(grade) %>%
    dplyr::mutate(increase_from_prior = default_rate >= dplyr::lag(default_rate)) %>%
    dplyr::summarise(
      fully_monotonic = all(increase_from_prior[-1], na.rm = TRUE),
      n_violations    = sum(!increase_from_prior[-1], na.rm = TRUE)
    )

}
