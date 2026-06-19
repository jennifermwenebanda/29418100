save_plot <- function(plot, filename, width = 8, height = 6, dpi = 300) {
  ggplot2::ggsave(
    filename = filename,
    plot     = plot,
    path     = FIGURE_PATH,
    width    = width,
    height   = height,
    dpi      = dpi
  )
  invisible(plot)
}

save_table <- function(data, filename) {
  readr::write_csv(data, file.path(TABLE_PATH, filename))
  invisible(data)
}
