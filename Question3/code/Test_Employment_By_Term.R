# Does the employment-length effect differ by loan term (36 vs 60 months)?
Test_Employment_By_Term <- function(df){

  df %>%
    Bucket_Employment_Length() %>%
    dplyr::filter(!is.na(emp_length_bucket), !is.na(term_label)) %>%
    dplyr::group_by(term_label, emp_length_bucket) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop")

}
