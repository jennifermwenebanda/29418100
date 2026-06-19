# Default rate by Lending Club credit sub-grade (A1-G5).
Subgrade_Default_Rates <- function(df){

  df %>%
    dplyr::filter(!is.na(sub_grade)) %>%
    dplyr::group_by(sub_grade) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop") %>%
    dplyr::arrange(sub_grade)

}
