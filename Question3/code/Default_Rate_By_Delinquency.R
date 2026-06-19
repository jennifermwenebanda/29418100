# "Who actually defaults?" - default rate split by prior delinquency
# history (any 30+ day past-due incidence in the last 2 years).
Default_Rate_By_Delinquency <- function(df){

  df %>%
    dplyr::filter(!is.na(delinq_2yrs)) %>%
    dplyr::mutate(delinq_flag = dplyr::if_else(delinq_2yrs > 0,
                                                "Prior Delinquency", "No Prior Delinquency")) %>%
    dplyr::group_by(delinq_flag) %>%
    dplyr::summarise(n = dplyr::n(), default_rate = mean(defaulted, na.rm = TRUE), .groups = "drop")

}
