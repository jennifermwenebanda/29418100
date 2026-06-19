# Lending Club does not collect borrower date of birth (US fair-lending law
# discourages age as an underwriting input), so no exact age exists in the
# data. We proxy financial maturity using credit history length = issue_d -
# earliest_cr_line (both stored as "Mon-Year" strings, parsed with
# lubridate::my()). age_proxy assumes a borrower opened their first credit
# line at age ASSUMED_AGE_AT_FIRST_CREDIT (20, a standard assumption in
# credit-risk literature) and adds the observed credit history length. This
# is an approximation, not a measured age, and is documented as such
# throughout the report. young_borrower flags age_proxy < 30.
ASSUMED_AGE_AT_FIRST_CREDIT <- 20

Derive_Age_Proxy <- function(df){

  df %>%
    dplyr::mutate(
      issue_date            = lubridate::my(issue_d),
      earliest_cr_dt        = lubridate::my(earliest_cr_line),
      credit_history_years  = as.numeric(issue_date - earliest_cr_dt) / 365.25,
      age_proxy             = ASSUMED_AGE_AT_FIRST_CREDIT + credit_history_years,
      young_borrower        = age_proxy < 30
    )

}
