plot_rating_by_roast <- function(df) {
  df %>%
    dplyr::filter(!is.na(roast), !is.na(rating)) %>%
    dplyr::mutate(roast = forcats::fct_reorder(roast, rating, .fun = median)) %>%
    ggplot2::ggplot(ggplot2::aes(x = roast, y = rating, fill = roast)) +
    ggplot2::geom_boxplot(show.legend = FALSE, alpha = 0.8) +
    ggplot2::coord_flip() +
    ggplot2::labs(title = "Rating Distribution by Roast Strength",
                  x = "Roast Strength", y = "Expert Rating (points)") +
    ggplot2::theme_minimal(base_size = 14)
}

plot_top_origins <- function(df, n = 10) {
  df %>%
    dplyr::filter(!is.na(origin_1)) %>%
    dplyr::count(origin_1, sort = TRUE) %>%
    dplyr::slice_head(n = n) %>%
    dplyr::mutate(origin_1 = forcats::fct_reorder(origin_1, n)) %>%
    ggplot2::ggplot(ggplot2::aes(x = origin_1, y = n, fill = n)) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_gradient(low = "#c8a97e", high = "#3b1f0a") +
    ggplot2::labs(title = paste("Top", n, "Coffee Origins by Listing Count"),
                  x = "Origin", y = "Number of Listings") +
    ggplot2::theme_minimal(base_size = 14)
}

plot_flavour_match_top <- function(df, n = 15) {
  df %>%
    top_flavour_matches(n = n) %>%
    dplyr::mutate(name = forcats::fct_reorder(stringr::str_trunc(name, 35), flavour_score)) %>%
    ggplot2::ggplot(ggplot2::aes(x = name, y = flavour_score, fill = rating)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_gradient(low = "#d9c5a0", high = "#3b1f0a") +
    ggplot2::labs(title = paste("Top", n, "Coffees by Flavour-Preference Match"),
                  x = NULL, y = "Flavour Match Score", fill = "Rating") +
    ggplot2::theme_minimal(base_size = 13)
}

plot_supplier_comparison <- function(supplier_summary, n = 10, min_coffees = 2) {
  supplier_summary %>%
    top_suppliers(n = n, min_coffees = min_coffees) %>%
    dplyr::mutate(roaster = forcats::fct_reorder(roaster, avg_flavour)) %>%
    ggplot2::ggplot(ggplot2::aes(x = roaster, y = avg_flavour, fill = avg_rating)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_gradient(low = "#d9c5a0", high = "#3b1f0a") +
    ggplot2::labs(title = paste("Top", n, "Suppliers by Average Flavour Match"),
                  x = NULL, y = "Average Flavour Match Score", fill = "Avg Rating") +
    ggplot2::theme_minimal(base_size = 13)
}

plot_price_band <- function(price_bands) {
  price_bands %>%
    ggplot2::ggplot(ggplot2::aes(x = price_band, y = n, fill = avg_rating)) +
    ggplot2::geom_col() +
    ggplot2::scale_fill_gradient(low = "#d9c5a0", high = "#3b1f0a") +
    ggplot2::labs(title = "Listings and Average Rating by Price Band",
                  x = "Price per 100g", y = "Number of Listings", fill = "Avg Rating") +
    ggplot2::theme_minimal(base_size = 13)
}

plot_distance_vs_metrics <- function(distance_summary_df) {
  distance_summary_df %>%
    dplyr::mutate(loc_country = forcats::fct_reorder(loc_country, distance_km)) %>%
    ggplot2::ggplot(ggplot2::aes(x = loc_country, y = distance_km, size = n, colour = avg_rating)) +
    ggplot2::geom_point() +
    ggplot2::coord_flip() +
    ggplot2::scale_colour_gradient(low = "#d9c5a0", high = "#3b1f0a") +
    ggplot2::labs(title = "Roastery Locations: Distance to Cape Town vs. Listings",
                  x = NULL, y = "Approx. Distance to Cape Town (km)",
                  size = "# Listings", colour = "Avg Rating") +
    ggplot2::theme_minimal(base_size = 13)
}

plot_business_score_ranked <- function(ranked_df, n = 15) {
  ranked_df %>%
    dplyr::slice_head(n = n) %>%
    dplyr::mutate(name = forcats::fct_reorder(stringr::str_trunc(name, 35), business_score)) %>%
    ggplot2::ggplot(ggplot2::aes(x = name, y = business_score, fill = business_score)) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_gradient(low = "#d9c5a0", high = "#3b1f0a") +
    ggplot2::labs(title = paste("Top", n, "Coffees by Business Viability Score"),
                  x = NULL, y = "Business Viability Score (0-1)") +
    ggplot2::theme_minimal(base_size = 13)
}
