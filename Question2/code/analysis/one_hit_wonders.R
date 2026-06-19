identify_one_hit_wonders <- function(baby_names, max_years = 1) {
  baby_names %>%
    dplyr::group_by(name, gender) %>%
    dplyr::summarise(
      total_years = dplyr::n_distinct(year),
      peak_year   = year[which.max(count)],
      peak_count  = max(count),
      .groups = "drop"
    ) %>%
    dplyr::filter(total_years <= max_years) %>%
    dplyr::mutate(decade = floor(peak_year / 10) * 10) %>%
    dplyr::arrange(peak_year)
}
