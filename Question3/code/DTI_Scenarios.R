# Conservative (5%), moderate (10%) and aggressive (15%) risk-tolerance
# scenarios, run nationally.
DTI_Scenarios <- function(df){

  tolerances <- c(conservative = 0.05, moderate = 0.10, aggressive = 0.15)

  purrr::imap_dfr(tolerances, function(tol, label){
    Recommend_DTI_Cap(df, tol) %>% dplyr::mutate(scenario = label, .before = 1)
  })

}
