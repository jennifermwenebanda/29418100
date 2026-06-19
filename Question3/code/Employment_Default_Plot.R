# Heuristic 2 figure: default rate by employment-length band. Builds,
# saves (Question3_files/figures/employment_default.png) and returns the
# plot.
Employment_Default_Plot <- function(emp_summary){

  g <- emp_summary %>%
    ggplot2::ggplot(ggplot2::aes(x = emp_length_bucket, y = default_rate, group = 1)) +
    ggplot2::geom_col(fill = "#4393c3") +
    ggplot2::geom_line(colour = "#b2182b", linewidth = 1) +
    ggplot2::geom_point(colour = "#b2182b", size = 2.5) +
    ggplot2::geom_text(ggplot2::aes(label = scales::percent(default_rate, accuracy = 0.1)),
                        vjust = -0.8, size = 4) +
    ggplot2::scale_y_continuous(labels = scales::percent_format(),
                                 expand = ggplot2::expansion(mult = c(0, 0.18))) +
    ggplot2::labs(
      title    = "Default Rate by Employment-Length Band",
      subtitle = "Bars = default rate per band; red line traces the trend from <1 year to 10+ years",
      x = "Employment Length", y = "Default Rate",
      caption = "Source: Lending Club loan-level data, resolved loans only (n = 383,202)."
    ) +
    ggplot2::theme_minimal(base_size = 13) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"))

  ggplot2::ggsave("Question3_files/figures/employment_default.png", g, width = 9, height = 6, dpi = 300)

  g

}
