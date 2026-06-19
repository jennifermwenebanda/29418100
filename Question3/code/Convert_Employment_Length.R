# "< 1 year" -> 0, "n years" -> n, "10+ years" -> 10, "n/a" -> NA.
Convert_Employment_Length <- function(df){

  df %>%
    dplyr::mutate(
      emp_length_num = dplyr::case_when(
        emp_length == "< 1 year"  ~ 0,
        emp_length == "10+ years" ~ 10,
        emp_length == "n/a"       ~ NA_real_,
        is.na(emp_length)         ~ NA_real_,
        TRUE ~ as.numeric(stringr::str_extract(emp_length, "\\d+"))
      )
    )

}
