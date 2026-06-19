# Constructs the high-risk and low-risk borrower archetypes the Director can
# use directly in underwriting policy, with quantified default probabilities.
Build_Risk_Profiles <- function(df){

  multivariate <- Build_Multivariate_Risk_Table(df)

  high_risk <- multivariate %>% dplyr::arrange(dplyr::desc(default_rate)) %>% dplyr::slice_head(n = 1)
  low_risk  <- multivariate %>% dplyr::arrange(default_rate) %>% dplyr::slice_head(n = 1)

  dplyr::bind_rows(
    dplyr::mutate(high_risk, profile = "High-Risk Archetype", .before = 1),
    dplyr::mutate(low_risk,  profile = "Low-Risk Archetype",  .before = 1)
  )

}
