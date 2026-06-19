# Two-proportion z-test: is Texas's default rate statistically
# distinguishable from the rest of the book?
Test_Texas_Significance <- function(df){

  tx   <- dplyr::filter(df, addr_state == "TX", !is.na(defaulted))
  rest <- dplyr::filter(df, addr_state != "TX", !is.na(defaulted))

  test <- prop.test(
    x = c(sum(tx$defaulted), sum(rest$defaulted)),
    n = c(nrow(tx), nrow(rest))
  )

  tibble::tibble(
    tx_default_rate     = mean(tx$defaulted),
    rest_default_rate   = mean(rest$defaulted),
    p_value              = test$p.value,
    significant_at_5pct = test$p.value < 0.05
  )

}
