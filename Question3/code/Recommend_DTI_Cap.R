# Finds the most permissive DTI cap (largest dti value) such that the
# cumulative default rate for all loans AT OR BELOW that cap stays within
# the Institute's stated risk tolerance. Falls back to the tightest
# candidate cap if even the strictest cap cannot meet the tolerance.
Recommend_DTI_Cap <- function(df, tolerance, candidate_caps = seq(5, 60, by = 1)){

  df <- dplyr::filter(df, !is.na(dti_clean), !is.na(defaulted))

  results <- purrr::map_dfr(candidate_caps, function(cap){
    subset <- dplyr::filter(df, dti_clean <= cap)
    tibble::tibble(dti_cap = cap, n = nrow(subset), default_rate = mean(subset$defaulted))
  })

  feasible <- dplyr::filter(results, default_rate <= tolerance, n >= 100)

  if (nrow(feasible) == 0) {
    dplyr::slice_min(results, dti_cap, n = 1) %>% dplyr::mutate(tolerance = tolerance, .before = 1)
  } else {
    dplyr::slice_max(feasible, dti_cap, n = 1) %>% dplyr::mutate(tolerance = tolerance, .before = 1)
  }

}
