# Checks whether default rate increases strictly from Grade A through G,
# separately for young and older borrowers.
Check_Grade_Monotonicity <- function(grade_age_summary){

  grade_age_summary %>%
    dplyr::group_by(young_borrower) %>%
    dplyr::arrange(grade, .by_group = TRUE) %>%
    dplyr::mutate(is_increase = default_rate >= dplyr::lag(default_rate)) %>%
    dplyr::summarise(monotonic = all(is_increase[-1], na.rm = TRUE), .groups = "drop")

}
