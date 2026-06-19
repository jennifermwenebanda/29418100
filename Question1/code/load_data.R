load_coffee <- function(filepath = "data/Coffee/Coffee.csv") {
  suppressMessages({
    df <- readr::read_csv(
      filepath,
      locale = readr::locale(encoding = "UTF-8"),
      show_col_types = FALSE
    )
  })

  if (any(is.na(df[[1]]))) {
    df <- readr::read_csv(
      filepath,
      locale = readr::locale(encoding = "latin1"),
      show_col_types = FALSE
    )
  }

  janitor::clean_names(df)
}
