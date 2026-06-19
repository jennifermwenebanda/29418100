# "Who actually defaults?" - default rate by income-verification status.
# Note for the report: "Verified" shows a HIGHER default rate than "Not
# Verified" in this book. This is a known selection effect in Lending Club
# data - loans get routed to verification precisely when they look risky
# (e.g. high loan amount relative to stated income), so verification status
# is correlated with being flagged as risky in the first place, not with
# verification itself causing default.
Default_Rate_By_Verification <- function(df){

  df %>%
    dplyr::filter(!is.na(verification_status)) %>%
    dplyr::group_by(verification_status) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop") %>%
    dplyr::arrange(dplyr::desc(default_rate))

}
