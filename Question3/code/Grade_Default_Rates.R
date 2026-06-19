# Default rate by Lending Club credit grade (A-G).
Grade_Default_Rates <- function(df){

  df %>%
    dplyr::filter(!is.na(grade)) %>%
    dplyr::group_by(grade) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop") %>%
    dplyr::arrange(grade)

}
