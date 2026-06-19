# Does the employment-length effect differ by income level (quartiles)?
Test_Employment_By_Income <- function(df){

  df %>%
    Bucket_Employment_Length() %>%
    dplyr::filter(!is.na(emp_length_bucket), !is.na(annual_inc)) %>%
    dplyr::mutate(income_band = dplyr::ntile(annual_inc, 4)) %>%
    dplyr::group_by(income_band, emp_length_bucket) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop")

}
