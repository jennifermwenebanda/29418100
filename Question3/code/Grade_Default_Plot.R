# Grading-system efficacy figure: default rate by credit grade (A = best,
# G = worst), with the grade-only model's AUC annotated so the Director can
# see both the pattern and its overall discriminatory power in one figure.
# Builds, saves (Question3_files/figures/grade_default.png) and returns
# the plot.
Grade_Default_Plot <- function(grade_summary, grade_auc){

  g <- grade_summary %>%
    ggplot2::ggplot(ggplot2::aes(x = grade, y = default_rate, fill = grade)) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::geom_text(ggplot2::aes(label = scales::percent(default_rate, accuracy = 0.1)),
                        vjust = -0.5, size = 4) +
    ggplot2::scale_fill_brewer(palette = "RdYlGn", direction = -1) +
    ggplot2::scale_y_continuous(labels = scales::percent_format(),
                                 expand = ggplot2::expansion(mult = c(0, 0.15))) +
    ggplot2::labs(
      title    = "Default Rate Rises Consistently From Grade A to Grade G",
      subtitle = paste0("Grade alone discriminates Charged Off from Fully Paid with an AUC of ",
                         round(grade_auc, 3), " (1.0 = perfect, 0.5 = no better than chance)"),
      x = "Lending Club Credit Grade (A = best, G = worst)", y = "Default Rate",
      caption = "Source: Lending Club loan-level data, resolved loans only (n = 383,202)."
    ) +
    ggplot2::theme_minimal(base_size = 13) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"))

  ggplot2::ggsave("Question3_files/figures/grade_default.png", g, width = 9, height = 6, dpi = 300)

  g

}
