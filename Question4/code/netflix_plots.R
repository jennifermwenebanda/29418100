plot_genre_popularity <- function(titles_df, top_n = 12) {
  # genres may be a list-column or a bracket-enclosed string like "['drama', 'comedy']"
  genres_flat <- titles_df %>%
    dplyr::filter(!is.na(genres)) %>%
    dplyr::mutate(
      genres_str = purrr::map_chr(genres, function(g) {
        if (is.null(g) || length(g) == 0) return(NA_character_)
        paste(g, collapse = ", ")
      }),
      genres_str = stringr::str_remove_all(genres_str, "[\\[\\]\\']")
    ) %>%
    tidyr::separate_rows(genres_str, sep = ",") %>%
    dplyr::mutate(genre = stringr::str_trim(genres_str)) %>%
    dplyr::filter(nchar(genre) > 1)

  genres_flat %>%
    dplyr::count(genre, sort = TRUE) %>%
    dplyr::slice_head(n = top_n) %>%
    dplyr::left_join(
      genres_flat %>%
        dplyr::group_by(genre) %>%
        dplyr::summarise(avg_score = round(mean(tmdb_score, na.rm = TRUE), 2),
                         .groups = "drop"),
      by = "genre"
    ) %>%
    dplyr::mutate(genre = forcats::fct_reorder(genre, n)) %>%
    ggplot2::ggplot(ggplot2::aes(x = genre, y = n, fill = avg_score)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_gradient(low = "#f7c6c7", high = "#c0392b",
                                  na.value = "grey70") +
    ggplot2::labs(
      title = paste("Top", top_n, "Netflix Genres by Count"),
      x = NULL, y = "Number of Titles", fill = "Avg\nTMDb Score"
    ) +
    ggplot2::theme_minimal(base_size = 13)
}

plot_runtime_by_country <- function(titles_df, top_n = 12) {
  # runtime and production_countries are both in titles.rds
  titles_df %>%
    dplyr::filter(!is.na(production_countries), !is.na(runtime), runtime > 0) %>%
    dplyr::mutate(
      country = purrr::map_chr(production_countries, function(c) {
        if (is.null(c) || length(c) == 0) return(NA_character_)
        c[[1]]
      })
    ) %>%
    dplyr::filter(!is.na(country), nchar(country) > 0) %>%
    dplyr::group_by(country) %>%
    dplyr::summarise(
      n          = dplyr::n(),
      median_run = median(runtime, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    dplyr::filter(n >= 5) %>%
    dplyr::arrange(dplyr::desc(n)) %>%
    dplyr::slice_head(n = top_n) %>%
    dplyr::mutate(country = forcats::fct_reorder(country, median_run)) %>%
    ggplot2::ggplot(ggplot2::aes(x = country, y = median_run, fill = n)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_gradient(low = "#dde9f5", high = "#1a6bb5") +
    ggplot2::labs(
      title = paste("Median Runtime by Country (top", top_n, "by volume)"),
      x = NULL, y = "Median Runtime (minutes)", fill = "# Titles"
    ) +
    ggplot2::theme_minimal(base_size = 13)
}

plot_score_distribution <- function(titles_df) {
  titles_df %>%
    dplyr::filter(!is.na(tmdb_score), !is.na(type)) %>%
    ggplot2::ggplot(ggplot2::aes(x = tmdb_score, fill = type)) +
    ggplot2::geom_density(alpha = 0.55) +
    ggplot2::labs(
      title = "TMDb Score Distribution: Movies vs. TV Shows",
      x = "TMDb Score", y = "Density", fill = NULL
    ) +
    ggplot2::theme_minimal(base_size = 13)
}

plot_releases_over_time <- function(titles_df) {
  titles_df %>%
    dplyr::filter(!is.na(release_year), release_year >= 1990) %>%
    dplyr::count(release_year, type) %>%
    ggplot2::ggplot(ggplot2::aes(x = release_year, y = n, colour = type)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::labs(
      title = "Netflix Titles by Release Year",
      x = "Release Year", y = "Count", colour = NULL
    ) +
    ggplot2::theme_minimal(base_size = 13)
}
