# Shared helper: collapses dti_clean into 5-point bands for the DTI policy
# analysis.
Bucket_DTI <- function(df, breaks = seq(0, 60, by = 5)){

  df %>%
    dplyr::filter(!is.na(dti_clean)) %>%
    dplyr::mutate(
      dti_bucket = cut(dti_clean, breaks = c(breaks, Inf), include.lowest = TRUE,
                        labels = c(paste0(head(breaks, -1), "-", breaks[-1]), paste0(max(breaks), "+")))
    )

}
