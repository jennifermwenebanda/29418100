plot_persistence_trend <- function(persistence_panel) {
  persistence_panel %>%
    dplyr::mutate(lead = factor(lead, levels = 1:3, labels = c("t+1", "t+2", "t+3"))) %>%
    ggplot2::ggplot(ggplot2::aes(x = year, y = correlation, colour = lead)) +
    ggplot2::geom_point(alpha = 0.3, size = 1.2) +
    ggplot2::geom_smooth(method = "loess", span = 0.3, se = FALSE, linewidth = 1.1) +
    ggplot2::facet_wrap(~gender, labeller = ggplot2::labeller(gender = c(F = "Girls", M = "Boys"))) +
    ggplot2::scale_colour_manual(values = c("#E69F00", "#56B4E9", "#009E73")) +
    ggplot2::labs(
      title    = "Naming Persistence Through Time (1910-2014)",
      subtitle = "Spearman rank correlation between Top-25 names in year t and year t+lead",
      x = "Base Year", y = "Spearman Correlation", colour = "Lead"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(legend.position = "top")
}

plot_era_comparison <- function(persistence_panel) {
  persistence_panel %>%
    dplyr::mutate(
      era  = classify_era(year),
      lead = factor(lead, levels = 1:3, labels = c("t+1", "t+2", "t+3"))
    ) %>%
    ggplot2::ggplot(ggplot2::aes(x = era, y = correlation, fill = era)) +
    ggplot2::geom_boxplot(alpha = 0.8) +
    ggplot2::facet_grid(gender ~ lead, labeller = ggplot2::labeller(gender = c(F = "Girls", M = "Boys"))) +
    ggplot2::scale_fill_manual(values = c(Pre1990 = "#0072B2", Post1990 = "#D55E00")) +
    ggplot2::labs(
      title    = "Naming Persistence Has Declined Since 1990",
      subtitle = "Pre- vs Post-1990 Spearman correlations by lead and gender",
      x = NULL, y = "Spearman Correlation", fill = "Era"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(legend.position = "none")
}

generate_persistence_plots <- function(persistence_panel) {
  save_plot(plot_persistence_trend(persistence_panel), "persistence_trend.png")
  save_plot(plot_era_comparison(persistence_panel), "era_comparison.png")
  invisible(TRUE)
}
