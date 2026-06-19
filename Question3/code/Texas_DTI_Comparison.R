# Compares the recommended DTI cap (see Recommend_DTI_Cap.R) for Texas
# against the national recommendation, at a given default-rate tolerance.
Texas_DTI_Comparison <- function(df, tolerance = 0.05){

  national_cap <- Recommend_DTI_Cap(df, tolerance)
  texas_cap    <- Recommend_DTI_Cap(dplyr::filter(df, addr_state == "TX"), tolerance)

  dplyr::bind_rows(
    dplyr::mutate(national_cap, region = "National", .before = 1),
    dplyr::mutate(texas_cap,    region = "Texas",    .before = 1)
  )

}
