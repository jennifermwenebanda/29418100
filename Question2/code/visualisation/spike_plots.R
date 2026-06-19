plot_name_spikes_bubble <- function(spikes, highlight = c("Katina", "Whitney")) {
  spikes %>%
    dplyr::mutate(is_highlight = name %in% highlight) %>%
    ggplot2::ggplot(ggplot2::aes(
      x = forcats::fct_reorder(name, decade),
      y = decade,
      size = count_change,
      colour = is_highlight
    )) +
    ggplot2::geom_point(alpha = 0.8) +
    ggplot2::scale_size(range = c(3, 16), name = "Birth Count Increase") +
    ggplot2::scale_colour_manual(values = c(`TRUE` = "#D62828", `FALSE` = "gray60"), guide = "none") +
    ggplot2::scale_y_continuous(breaks = seq(1910, 2014, by = 10)) +
    ggplot2::labs(
      title    = "Year-on-Year Name Spikes (Top 50)",
      subtitle = paste("Highlighted:", paste(highlight, collapse = ", ")),
      x = "Name", y = "Decade"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
}

generate_spike_plots <- function(spikes) {
  save_plot(plot_name_spikes_bubble(spikes), "name_spikes_bubble.png", width = 10, height = 6)
  invisible(TRUE)
}
