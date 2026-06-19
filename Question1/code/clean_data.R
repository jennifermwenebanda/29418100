standardise_loc_country <- function(loc_country) {
  dplyr::case_match(
    loc_country,
    "New Taiwan"               ~ "Taiwan",
    "United States And Floyd"  ~ "United States",
    .default = loc_country
  )
}

clean_coffee <- function(df) {
  df %>%
    dplyr::filter(!is.na(rating), !is.na(cost_per_100g), cost_per_100g > 0) %>%
    dplyr::mutate(
      roast       = stringr::str_trim(roast),
      loc_country = standardise_loc_country(loc_country),
      review_text = paste(desc_1, desc_2, desc_3, sep = " ") %>%
        stringr::str_to_lower() %>%
        tidyr::replace_na("")
    )
}
