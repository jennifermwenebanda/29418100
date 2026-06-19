standardise_names <- function(x) {
  x %>% stringr::str_trim() %>% stringr::str_to_title()
}

extract_first_name <- function(x) {
  stringr::str_extract(x, "^[^ ]+")
}

safe_rank <- function(x, ties.method = "min") {
  rank(-x, ties.method = ties.method)
}

calculate_growth_rate <- function(current, previous) {
  dplyr::if_else(
    is.na(previous) | previous == 0,
    NA_real_,
    (current - previous) / previous * 100
  )
}
