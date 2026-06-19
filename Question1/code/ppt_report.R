build_recommendation_table <- function(ranked_df, n = 10) {
  ranked_df %>%
    dplyr::slice_head(n = n) %>%
    dplyr::transmute(
      Rank                = dplyr::row_number(),
      Coffee              = stringr::str_trunc(name, 40),
      Roaster             = roaster,
      `Roastery Location` = loc_country,
      `Flavour Match`     = scales::percent(flavour_norm, accuracy = 1),
      Rating              = round(rating, 1),
      `Price/100g`        = scales::dollar(cost_per_100g),
      `Distance (km)`     = scales::comma(distance_km),
      `Viability Score`   = round(business_score, 2)
    )
}
