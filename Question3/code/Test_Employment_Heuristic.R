# Heuristic 2 (employment length): default rate by employment-length band.
Test_Employment_Heuristic <- function(df){

  df %>%
    Bucket_Employment_Length() %>%
    dplyr::filter(!is.na(emp_length_bucket)) %>%
    dplyr::group_by(emp_length_bucket) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop")

}
