# Heuristic 3 flagship figure: a US choropleth of default rate by state.
# Pale pink = lowest default rate, deep red = highest, smooth gradient in
# between. Texas is outlined in black so the Director can locate it
# immediately. Builds, saves
# (Question3_files/figures/state_default_map.png) and returns the plot.
State_Default_Map <- function(state_summary){

  state_lookup <- tibble::tibble(addr_state = state.abb, region = tolower(state.name))

  map_states <- ggplot2::map_data("state")

  plot_df <- state_summary %>%
    dplyr::inner_join(state_lookup, by = "addr_state") %>%
    dplyr::right_join(map_states, by = "region")

  texas_outline <- dplyr::filter(map_states, region == "texas")

  g <- ggplot2::ggplot(plot_df, ggplot2::aes(x = long, y = lat, group = group, fill = default_rate)) +
    ggplot2::geom_polygon(colour = "white", linewidth = 0.15) +
    ggplot2::geom_polygon(data = texas_outline, ggplot2::aes(x = long, y = lat, group = group),
                           fill = NA, colour = "black", linewidth = 0.9, inherit.aes = FALSE) +
    ggplot2::coord_quickmap() +
    ggplot2::scale_fill_gradient(
      low = "#fde0dd", high = "#a50026",
      labels = scales::percent_format(accuracy = 1),
      name = "Default\nRate"
    ) +
    ggplot2::labs(
      title    = "Loan Default Rates Across the United States",
      subtitle = "Darker red = a higher share of resolved loans ending in Charged Off. Texas outlined in black.",
      x = NULL, y = NULL,
      caption = paste(
        "Source: Lending Club loan-level data (resolved loans only: Fully Paid vs. Charged Off/Default).",
        "Colour scale: pale pink = lowest default rate state, deep red = highest default rate state.",
        sep = "\n"
      )
    ) +
    ggplot2::theme_void(base_size = 13) +
    ggplot2::theme(
      plot.title    = ggplot2::element_text(face = "bold", size = 16),
      plot.subtitle = ggplot2::element_text(size = 11, colour = "grey30"),
      plot.caption  = ggplot2::element_text(size = 8, colour = "grey40", hjust = 0),
      legend.position = "right"
    )

  ggplot2::ggsave("Question3_files/figures/state_default_map.png", g, width = 11, height = 7, dpi = 300)

  g

}
