normalise_0_1 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  if (diff(rng) == 0) return(rep(0.5, length(x)))
  (x - rng[1]) / diff(rng)
}

compute_business_score <- function(df,
                                    weights = c(flavour = 0.35, rating = 0.30,
                                                price = 0.20, distance = 0.15)) {
  df %>%
    dplyr::mutate(
      flavour_norm   = normalise_0_1(flavour_score),
      rating_norm    = normalise_0_1(rating),
      price_norm     = 1 - normalise_0_1(cost_per_100g),
      distance_norm  = 1 - normalise_0_1(distance_km),
      business_score = weights["flavour"]  * flavour_norm +
                        weights["rating"]   * rating_norm +
                        weights["price"]    * price_norm +
                        weights["distance"] * distance_norm
    )
}

rank_business_viability <- function(df, n = 15) {
  df %>%
    dplyr::arrange(dplyr::desc(business_score)) %>%
    dplyr::slice_head(n = n)
}
