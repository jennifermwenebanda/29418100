classify_era <- function(year, cutoff = 1990) {
  dplyr::if_else(year >= cutoff, "Post1990", "Pre1990") %>%
    factor(levels = c("Pre1990", "Post1990"))
}

compare_eras <- function(persistence_panel) {
  persistence_panel %>%
    dplyr::mutate(era = classify_era(year)) %>%
    dplyr::group_by(gender, lead, era) %>%
    dplyr::summarise(
      mean_correlation   = mean(correlation, na.rm = TRUE),
      median_correlation = median(correlation, na.rm = TRUE),
      sd_correlation      = sd(correlation, na.rm = TRUE),
      n = dplyr::n(),
      .groups = "drop"
    )
}
