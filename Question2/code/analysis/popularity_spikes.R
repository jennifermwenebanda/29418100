calculate_growth_rates <- function(yearly_counts) {
  yearly_counts %>%
    dplyr::group_by(name, gender) %>%
    dplyr::arrange(year, .by_group = TRUE) %>%
    dplyr::mutate(
      previous_count = dplyr::lag(count),
      count_change   = count - previous_count,
      growth_rate    = calculate_growth_rate(count, previous_count)
    ) %>%
    dplyr::ungroup()
}

identify_spikes <- function(baby_names, top_n = 50) {
  yearly <- baby_names %>%
    dplyr::group_by(year, name, gender) %>%
    dplyr::summarise(count = sum(count), .groups = "drop") %>%
    dplyr::group_by(year, gender) %>%
    dplyr::mutate(rank = safe_rank(count)) %>%
    dplyr::ungroup()

  yearly %>%
    calculate_growth_rates() %>%
    dplyr::group_by(name, gender) %>%
    dplyr::arrange(year, .by_group = TRUE) %>%
    dplyr::mutate(rank_change = dplyr::lag(rank) - rank) %>%
    dplyr::ungroup() %>%
    dplyr::filter(!is.na(growth_rate)) %>%
    dplyr::arrange(dplyr::desc(count_change)) %>%
    dplyr::slice_head(n = top_n) %>%
    dplyr::mutate(decade = floor(year / 10) * 10)
}
