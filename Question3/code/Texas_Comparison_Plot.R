# Texas deep-dive figure: Texas vs. the national average, the highest-risk
# state and the lowest-risk state. Builds, saves
# (Question3_files/figures/texas_comparison.png) and returns the plot.
Texas_Comparison_Plot <- function(texas_summary){

  g <- texas_summary %>%
    dplyr::mutate(
      label = dplyr::if_else(is.na(state), metric, paste0(metric, " (", state, ")")),
      label = forcats::fct_reorder(label, default_rate)
    ) %>%
    ggplot2::ggplot(ggplot2::aes(x = label, y = default_rate, fill = metric == "Texas")) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::geom_text(ggplot2::aes(label = scales::percent(default_rate, accuracy = 0.1)),
                        hjust = -0.15, size = 4.2) +
    ggplot2::scale_fill_manual(values = c(`TRUE` = "#b2182b", `FALSE` = "#999999")) +
    ggplot2::scale_y_continuous(labels = scales::percent_format(),
                                 expand = ggplot2::expansion(mult = c(0, 0.25))) +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title    = "Texas Default Rate in National Context",
      subtitle = "Red bar = Texas; grey bars = national average and the highest-/lowest-risk states",
      x = NULL, y = "Default Rate",
      caption = "Source: Lending Club loan-level data, resolved loans only."
    ) +
    ggplot2::theme_minimal(base_size = 13) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"))

  ggplot2::ggsave("Question3_files/figures/texas_comparison.png", g, width = 9, height = 5.5, dpi = 300)

  g

}
