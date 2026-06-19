# int_rate is already numeric in this extract (e.g. 13.56 = 13.56%), so no
# string parsing is required - it is simply renamed for a consistent,
# self-documenting column name. term is trimmed of stray whitespace.
# addr_state is already a clean, uppercase 2-letter code for all 1,000,000
# rows (50 distinct values: the 49 states Lending Club operated in, plus DC -
# Iowa (IA) is genuinely absent because Lending Club did not lend there), so
# standardisation here is a defensive trim/upper rather than a real fix.
Standardise_Rates_Term_State <- function(df){

  df %>%
    dplyr::mutate(
      int_rate_num = as.numeric(int_rate),
      term_label   = stringr::str_trim(as.character(term)),
      addr_state   = stringr::str_to_upper(stringr::str_trim(addr_state))
    )

}
