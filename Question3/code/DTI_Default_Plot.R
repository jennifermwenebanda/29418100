# DTI policy figure: default rate by DTI band, with the conservative (5%),
# moderate (10%) and aggressive (15%) tolerance lines marked so the
# Director can read the recommended cap straight off the chart. Builds,
# saves (Question3_files/figures/dti_default.png) and returns the plot.
DTI_Default_Plot <- function(dti_summary){

  g <- dti_summary %>%
    ggplot2::ggplot(ggplot2::aes(x = dti_bucket, y = default_rate, group = 1)) +
    ggplot2::geom_col(fill = "#d6604d") +
    ggplot2::geom_line(colour = "#2166ac", linewidth = 1) +
    ggplot2::geom_point(colour = "#2166ac", size = 2.2) +
    ggplot2::geom_hline(yintercept = c(0.05, 0.10, 0.15), linetype = "dashed", colour = "grey40") +
    ggplot2::annotate("text", x = 1, y = c(0.05, 0.10, 0.15) + 0.012,
                       label = c("Conservative tolerance (5%)", "Moderate tolerance (10%)", "Aggressive tolerance (15%)"),
                       hjust = 0, size = 3.2, colour = "grey30") +
    ggplot2::scale_y_continuous(labels = scales::percent_format(),
                                 expand = ggplot2::expansion(mult = c(0, 0.12))) +
    ggplot2::labs(
      title    = "Default Rate Rises With Debt-to-Income Ratio",
      subtitle = "Bars = default rate per 5-point DTI band; dashed lines = Institute risk-tolerance scenarios",
      x = "Debt-to-Income Band (%)", y = "Default Rate",
      caption = "Source: Lending Club loan-level data. DTI values <0 or >=100 treated as data errors and excluded."
    ) +
    ggplot2::theme_minimal(base_size = 13) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"),
                   axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

  ggplot2::ggsave("Question3_files/figures/dti_default.png", g, width = 10, height = 6, dpi = 300)

  g

}
