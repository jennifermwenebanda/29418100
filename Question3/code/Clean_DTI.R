# dti ranges from -1 to 999 in the raw data. A single negative value is
# logically impossible. 1,708 rows sit at or above 100 (many exactly 999),
# which is almost certainly a sentinel/placeholder for a data-entry problem
# rather than a real debt-to-income ratio - no approved loan in this book has
# a genuine DTI anywhere near 100%. Both are set to NA rather than dropped,
# so the rows remain usable for analyses that do not need dti.
Clean_DTI <- function(df){

  df %>%
    dplyr::mutate(
      dti_clean = dplyr::if_else(dti < 0 | dti >= 100, NA_real_, dti)
    )

}
