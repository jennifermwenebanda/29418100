# Heuristic 1 figure: default rate by home-ownership category. Builds,
# saves (Question3_files/figures/homeownership_default.png) and returns the
# plot, so it can also be displayed inline in a report chunk.
Homeownership_Default_Plot <- function(home_summary){

  g <- home_summary %>%
    dplyr::mutate(home_ownership_grp = forcats::fct_reorder(home_ownership_grp, default_rate)) %>%
    ggplot2::ggplot(ggplot2::aes(x = home_ownership_grp, y = default_rate, fill = home_ownership_grp)) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::geom_text(ggplot2::aes(label = scales::percent(default_rate, accuracy = 0.1)),
                        vjust = -0.5, size = 4.2) +
    ggplot2::scale_y_continuous(labels = scales::percent_format(),
                                 expand = ggplot2::expansion(mult = c(0, 0.15))) +
    ggplot2::scale_fill_manual(values = c(RENT = "#b2182b", OWN = "#ef8a62",
                                           MORTGAGE = "#67a9cf", OTHER = "#999999")) +
    ggplot2::labs(
      title    = "Default Rate by Home-Ownership Category",
      subtitle = "Resolved loans only (Fully Paid vs. Charged Off); bar colour shows ownership category",
      x = "Home Ownership Category", y = "Default Rate",
      caption = "Source: Lending Club loan-level data (n = 383,202 resolved loans).\nDefault rate = Charged Off / (Charged Off + Fully Paid)."
    ) +
    ggplot2::theme_minimal(base_size = 13) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"))

  ggplot2::ggsave("Question3_files/figures/homeownership_default.png", g, width = 9, height = 6, dpi = 300)

  g

}
