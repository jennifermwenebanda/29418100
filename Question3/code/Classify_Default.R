# Lending Club's loan_status has 7 raw values. Only "Fully Paid" and
# "Charged Off"/"Default" represent a FINAL, resolved outcome. "Current",
# "In Grace Period" and the two "Late" statuses are still active loans whose
# ultimate outcome is unknown (many "Late" loans cure back to Current). Per
# the brief, Current loans (and the other active statuses, for the same
# right-censoring reason) are excluded from the default-rate analysis - using
# them would silently treat ~62% of the book as "non-default" when their
# outcome is simply not yet known. is_resolved flags the loans usable for
# default analysis; defaulted is only meaningful when is_resolved is TRUE.
Classify_Default <- function(df){

  df %>%
    dplyr::mutate(
      loan_resolution = dplyr::case_when(
        loan_status == "Fully Paid"                  ~ "Fully Paid",
        loan_status %in% c("Charged Off", "Default")  ~ "Charged Off",
        TRUE                                          ~ "Active/Unresolved"
      ),
      is_resolved = loan_resolution %in% c("Fully Paid", "Charged Off"),
      defaulted   = dplyr::case_when(
        loan_resolution == "Charged Off" ~ TRUE,
        loan_resolution == "Fully Paid"  ~ FALSE,
        TRUE                             ~ NA
      )
    )

}
