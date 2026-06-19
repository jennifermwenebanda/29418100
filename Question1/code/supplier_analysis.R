summarise_suppliers <- function(df) {
  df %>%
    dplyr::group_by(roaster, loc_country) %>%
    dplyr::summarise(
      n_coffees   = dplyr::n(),
      avg_flavour = mean(flavour_score, na.rm = TRUE),
      avg_rating  = mean(rating, na.rm = TRUE),
      avg_price   = mean(cost_per_100g, na.rm = TRUE),
      .groups = "drop"
    )
}

top_suppliers <- function(supplier_summary, n = 10, min_coffees = 2) {
  supplier_summary %>%
    dplyr::filter(n_coffees >= min_coffees) %>%
    dplyr::arrange(dplyr::desc(avg_flavour), dplyr::desc(avg_rating)) %>%
    dplyr::slice_head(n = n)
}
