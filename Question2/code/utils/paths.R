DATA_PATH   <- "data/US_Baby_names"
OUTPUT_PATH <- "Question2_files"
FIGURE_PATH <- file.path(OUTPUT_PATH, "figures")
TABLE_PATH  <- file.path(OUTPUT_PATH, "tables")

ensure_output_dirs <- function() {
  c(FIGURE_PATH, TABLE_PATH) %>%
    purrr::walk(~ dir.create(.x, recursive = TRUE, showWarnings = FALSE))
  invisible(TRUE)
}
