plot_hbo_effects <- function(hbo_effect, top_n = 15) {
  hbo_effect %>%
    dplyr::slice_max(impact_ratio, n = top_n) %>%
    ggplot2::ggplot(ggplot2::aes(x = forcats::fct_reorder(first_name, impact_ratio), y = impact_ratio, fill = gender)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_manual(values = c(F = "#e91e63", M = "#3498db")) +
    ggplot2::labs(
      title    = "HBO Characters with Strongest Baby-Name Impact",
      subtitle = "Ratio of post-release to pre-release births sharing the character's first name",
      x = NULL, y = "Impact Ratio (Post / Pre Release)", fill = "Gender"
    ) +
    ggplot2::theme_minimal(base_size = 12)
}

generate_hbo_plots <- function(hbo_effect) {
  save_plot(plot_hbo_effects(hbo_effect), "hbo_effects.png")
  invisible(TRUE)
}
