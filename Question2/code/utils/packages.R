load_packages <- function() {
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, lubridate, ggplot2, purrr, stringr, patchwork, janitor, scales, forcats)
  invisible(TRUE)
}
