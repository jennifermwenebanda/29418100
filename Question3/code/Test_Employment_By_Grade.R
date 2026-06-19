# Does the employment-length effect differ by credit grade?
Test_Employment_By_Grade <- function(df){

  df %>%
    Bucket_Employment_Length() %>%
    dplyr::filter(!is.na(emp_length_bucket), !is.na(grade)) %>%
    dplyr::group_by(grade, emp_length_bucket) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop")

}
