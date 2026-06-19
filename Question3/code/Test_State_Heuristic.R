# Heuristic 3 (state-level default culture): default rate for every US
# state, ranked from highest to lowest.
Test_State_Heuristic <- function(df){

  df %>%
    dplyr::filter(!is.na(addr_state)) %>%
    dplyr::group_by(addr_state) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop") %>%
    dplyr::arrange(dplyr::desc(default_rate)) %>%
    dplyr::mutate(rank = dplyr::row_number())

}
