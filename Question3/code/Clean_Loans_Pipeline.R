# Composes the single-purpose cleaning functions above into the full
# cleaning pipeline. This is the only function Question3.Rmd calls directly.
Clean_Loans_Pipeline <- function(df){

  df %>%
    Classify_Default() %>%
    Convert_Employment_Length() %>%
    Collapse_Home_Ownership() %>%
    Clean_DTI() %>%
    Standardise_Rates_Term_State() %>%
    Derive_Age_Proxy()

}
