get_top25_names <- function(baby_names) {
  baby_names %>%
    dplyr::group_by(year, gender, name) %>%
    dplyr::summarise(total_count = sum(count), .groups = "drop") %>%
    dplyr::arrange(year, gender, dplyr::desc(total_count)) %>%
    dplyr::group_by(year, gender) %>%
    dplyr::slice_head(n = 25) %>%
    dplyr::mutate(rank = dplyr::row_number()) %>%
    dplyr::ungroup()
}

calculate_spearman <- function(rank_a, rank_b) {
  if (length(rank_a) < 5) return(NA_real_)
  stats::cor(rank_a, rank_b, method = "spearman")
}

build_year_correlations <- function(top25, base_year, lead, gender_filter) {
  year_a <- top25 %>%
    dplyr::filter(year == base_year, gender == gender_filter) %>%
    dplyr::select(name, rank)

  year_b <- top25 %>%
    dplyr::filter(year == base_year + lead, gender == gender_filter) %>%
    dplyr::select(name, rank)

  merged      <- dplyr::inner_join(year_a, year_b, by = "name", suffix = c("_a", "_b"))
  correlation <- calculate_spearman(merged$rank_a, merged$rank_b)

  tibble::tibble(year = base_year, gender = gender_filter, lead = lead, correlation = correlation)
}

build_persistence_panel <- function(top25) {
  years      <- sort(unique(top25$year))
  genders    <- unique(top25$gender)
  base_years <- years[years <= max(years) - 3]

  combos <- tidyr::expand_grid(base_year = base_years, lead = 1:3, gender_filter = genders)

  purrr::pmap_dfr(
    combos,
    ~ build_year_correlations(top25, base_year = ..1, lead = ..2, gender_filter = ..3)
  ) %>%
    dplyr::filter(!is.na(correlation))
}
