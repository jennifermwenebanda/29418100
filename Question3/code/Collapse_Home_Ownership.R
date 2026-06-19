# Collapses to RENT / OWN / MORTGAGE, with the rare "ANY" category (599 of
# 1,000,000 rows - undisclosed/ambiguous ownership) grouped into OTHER.
Collapse_Home_Ownership <- function(df){

  df %>%
    dplyr::mutate(
      home_ownership_grp = dplyr::case_when(
        home_ownership %in% c("RENT", "OWN", "MORTGAGE") ~ home_ownership,
        TRUE ~ "OTHER"
      )
    )

}
