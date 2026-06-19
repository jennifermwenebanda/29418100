# Approximate great-circle distance (km) from each roastery location's major
# city to Cape Town, South Africa - used to rank relative shipping/logistics
# favourability. Approximate by design: relative ranking, not route planning.
country_distance_lookup <- function() {
  tibble::tribble(
    ~loc_country,     ~distance_km,
    "Kenya",                  3340,
    "Uganda",                 3770,
    "Malaysia",                8650,
    "Belgium",                 9300,
    "England",                 9680,
    "Peru",                   10800,
    "Australia",              11040,
    "Hong Kong",              11300,
    "Taiwan",                 11800,
    "Canada",                 12500,
    "United States",          12400,
    "China",                  12900,
    "Honduras",               13200,
    "Guatemala",              13500,
    "Mexico",                 13800,
    "Japan",                  14700,
    "Hawai'i",                18400
  )
}

add_distance_to_sa <- function(df) {
  df %>% dplyr::left_join(country_distance_lookup(), by = "loc_country")
}

distance_summary <- function(df) {
  df %>%
    dplyr::group_by(loc_country) %>%
    dplyr::summarise(
      n          = dplyr::n(),
      avg_rating = round(mean(rating, na.rm = TRUE), 1),
      avg_price  = round(mean(cost_per_100g, na.rm = TRUE), 2),
      distance_km = dplyr::first(distance_km),
      .groups = "drop"
    ) %>%
    dplyr::arrange(distance_km)
}
