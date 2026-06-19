extract_actor_names <- function(hbo_credits) {
  hbo_credits %>%
    dplyr::filter(role == "ACTOR") %>%
    dplyr::distinct(id, name, first_name)
}

extract_character_names <- function(hbo_credits) {
  hbo_credits %>%
    dplyr::distinct(id, character, first_name)
}

match_hbo_names <- function(baby_names, hbo_credits, hbo_titles) {
  characters <- extract_character_names(hbo_credits) %>%
    dplyr::inner_join(hbo_titles, by = "id")

  baby_names %>%
    dplyr::group_by(year, gender, name) %>%
    dplyr::summarise(count = sum(count), .groups = "drop") %>%
    dplyr::filter(count > 0) %>%
    dplyr::rename(first_name = name) %>%
    dplyr::inner_join(characters, by = "first_name", relationship = "many-to-many")
}

analyse_hbo_effect <- function(baby_names, hbo_credits, hbo_titles, window = 5) {
  match_hbo_names(baby_names, hbo_credits, hbo_titles) %>%
    dplyr::mutate(
      time_diff = year - release_year,
      period = dplyr::case_when(
        time_diff < 0 ~ "pre_release",
        time_diff >= 0 & time_diff <= window ~ "post_release",
        TRUE ~ "beyond_window"
      )
    ) %>%
    dplyr::group_by(first_name, gender, title, release_year) %>%
    dplyr::summarise(
      pre_release  = sum(count[period == "pre_release"]),
      post_release = sum(count[period == "post_release"]),
      impact_ratio = (post_release - pre_release) / (pre_release + 1),
      .groups = "drop"
    ) %>%
    dplyr::filter(pre_release < 100, post_release > 100) %>%
    dplyr::arrange(dplyr::desc(impact_ratio))
}
