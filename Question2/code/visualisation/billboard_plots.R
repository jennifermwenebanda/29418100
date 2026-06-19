plot_billboard_effects <- function(billboard_effect, top_n = 15) {
  billboard_effect %>%
    dplyr::slice_max(impact_ratio, n = top_n) %>%
    ggplot2::ggplot(ggplot2::aes(x = forcats::fct_reorder(first_name, impact_ratio), y = impact_ratio, fill = gender)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_manual(values = c(F = "#e91e63", M = "#3498db")) +
    ggplot2::labs(
      title    = "Billboard Artists with Strongest Baby-Name Impact",
      subtitle = "Ratio of post-release to pre-release births sharing the artist's first name",
      x = NULL, y = "Impact Ratio (Post / Pre Release)", fill = "Gender"
    ) +
    ggplot2::theme_minimal(base_size = 12)
}

generate_billboard_plots <- function(billboard_effect) {
  save_plot(plot_billboard_effects(billboard_effect), "billboard_effects.png")
  invisible(TRUE)
}
