# Heuristic 4 (grading system among young borrowers): default rate by
# grade, split by young_borrower (age_proxy < 30) vs. older borrowers.
Test_Grade_Age_Heuristic <- function(df){

  df %>%
    dplyr::filter(!is.na(grade), !is.na(young_borrower)) %>%
    dplyr::group_by(young_borrower, grade) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop") %>%
    dplyr::arrange(young_borrower, grade)

}
