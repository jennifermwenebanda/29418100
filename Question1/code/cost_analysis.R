average_cost <- function(df) {
  df %>%
    dplyr::summarise(
      avg_price    = round(mean(cost_per_100g, na.rm = TRUE), 2),
      median_price = round(median(cost_per_100g, na.rm = TRUE), 2),
      min_price    = round(min(cost_per_100g, na.rm = TRUE), 2),
      max_price    = round(max(cost_per_100g, na.rm = TRUE), 2),
      n            = dplyr::n()
    )
}

price_band_summary <- function(df, breaks = c(0, 10, 20, 30, 50, Inf)) {
  labels <- c("<$10", "$10-20", "$20-30", "$30-50", "$50+")
  df %>%
    dplyr::mutate(price_band = cut(cost_per_100g, breaks = breaks, labels = labels)) %>%
    dplyr::group_by(price_band) %>%
    dplyr::summarise(
      n           = dplyr::n(),
      avg_rating  = round(mean(rating, na.rm = TRUE), 1),
      avg_flavour = round(mean(flavour_score, na.rm = TRUE), 2),
      .groups = "drop"
    )
}
