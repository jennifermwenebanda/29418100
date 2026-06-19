# Default rate for each DTI band - shows how default risk changes as DTI
# increases.
DTI_Default_Rates <- function(df){

  df %>%
    Bucket_DTI() %>%
    dplyr::group_by(dti_bucket) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop")

}
