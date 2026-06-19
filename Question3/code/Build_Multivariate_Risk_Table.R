# Multivariate strata (grade x DTI band x home ownership x verification x
# employment length), restricted to strata with at least 50 loans so rates
# are not driven by tiny cells. Feeds Build_Risk_Profiles().
Build_Multivariate_Risk_Table <- function(df){

  df %>%
    Bucket_Employment_Length() %>%
    dplyr::filter(!is.na(grade), !is.na(dti_clean), !is.na(emp_length_bucket),
                  !is.na(home_ownership_grp), !is.na(verification_status)) %>%
    dplyr::mutate(
      dti_band = cut(dti_clean, breaks = c(-Inf, 10, 20, 30, Inf),
                      labels = c("<10", "10-20", "20-30", "30+"))
    ) %>%
    dplyr::group_by(grade, dti_band, home_ownership_grp, verification_status, emp_length_bucket) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop") %>%
    dplyr::filter(n >= 50)

}
