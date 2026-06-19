# Compares Texas directly against the national average, the highest-risk
# state and the lowest-risk state, using the state summary produced by
# Test_State_Heuristic().
Analyse_Texas <- function(df, state_summary){

  national_rate <- mean(df$defaulted, na.rm = TRUE)

  tx_row      <- dplyr::filter(state_summary, addr_state == "TX")
  highest_row <- dplyr::slice_max(state_summary, default_rate, n = 1)
  lowest_row  <- dplyr::slice_min(state_summary, default_rate, n = 1)

  tibble::tibble(
    metric       = c("Texas", "National Average", "Highest-Risk State", "Lowest-Risk State"),
    state        = c("TX", NA, highest_row$addr_state, lowest_row$addr_state),
    default_rate = c(tx_row$default_rate, national_rate, highest_row$default_rate, lowest_row$default_rate),
    n            = c(tx_row$n, nrow(df), highest_row$n, lowest_row$n)
  )

}
