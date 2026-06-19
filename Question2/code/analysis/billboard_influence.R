extract_artist_names <- function(billboard) {
  billboard %>%
    dplyr::distinct(song, first_name, release_year)
}

extract_song_names <- function(billboard) {
  billboard %>%
    dplyr::distinct(song, artist, release_year)
}

match_names_to_billboard <- function(baby_names, billboard) {
  artists <- extract_artist_names(billboard)

  baby_names %>%
    dplyr::group_by(year, gender, name) %>%
    dplyr::summarise(count = sum(count), .groups = "drop") %>%
    dplyr::filter(count > 0) %>%
    dplyr::rename(first_name = name) %>%
    dplyr::inner_join(artists, by = "first_name", relationship = "many-to-many")
}

analyse_billboard_effect <- function(baby_names, billboard, window = 5) {
  match_names_to_billboard(baby_names, billboard) %>%
    dplyr::mutate(
      time_diff = year - release_year,
      period = dplyr::case_when(
        time_diff < 0 ~ "pre_release",
        time_diff >= 0 & time_diff <= window ~ "post_release",
        TRUE ~ "beyond_window"
      )
    ) %>%
    dplyr::group_by(first_name, gender, song, release_year) %>%
    dplyr::summarise(
      pre_release  = sum(count[period == "pre_release"]),
      post_release = sum(count[period == "post_release"]),
      impact_ratio = (post_release - pre_release) / (pre_release + 1),
      .groups = "drop"
    ) %>%
    dplyr::filter(pre_release < 100, post_release > 100) %>%
    dplyr::arrange(dplyr::desc(impact_ratio))
}
