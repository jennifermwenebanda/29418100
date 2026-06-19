# Shared helper used by every employment-length analysis: collapses
# emp_length_num into 5 policy-relevant bands.
Bucket_Employment_Length <- function(df){

  df %>%
    dplyr::mutate(
      emp_length_bucket = dplyr::case_when(
        is.na(emp_length_num) ~ NA_character_,
        emp_length_num < 1    ~ "< 1 year",
        emp_length_num <= 3   ~ "1-3 years",
        emp_length_num <= 6   ~ "4-6 years",
        emp_length_num <= 9   ~ "7-9 years",
        TRUE                  ~ "10+ years"
      ),
      emp_length_bucket = factor(emp_length_bucket,
        levels = c("< 1 year", "1-3 years", "4-6 years", "7-9 years", "10+ years"))
    )

}
