PREFERENCE_KEYWORDS <- c(
  "sweet", "chocolate", "aroma", "mouthfeel", "finish", "structure", "cup",
  "toned", "sweetly", "savory", "notes", "acidity", "syrupy", "deeply",
  "zest", "richly", "tart", "fruit", "crisp", "short"
)

count_keyword_matches <- function(text, keywords = PREFERENCE_KEYWORDS) {
  keywords %>%
    purrr::map_lgl(~stringr::str_detect(text, .x)) %>%
    sum()
}

score_flavour_match <- function(df, keywords = PREFERENCE_KEYWORDS) {
  df %>%
    dplyr::mutate(
      keyword_hits  = purrr::map_int(review_text, count_keyword_matches, keywords = keywords),
      flavour_score = keyword_hits / length(keywords)
    )
}

top_flavour_matches <- function(df, n = 20) {
  df %>%
    dplyr::arrange(dplyr::desc(flavour_score), dplyr::desc(rating)) %>%
    dplyr::slice_head(n = n)
}

keyword_frequency_table <- function(df, keywords = PREFERENCE_KEYWORDS) {
  keywords %>%
    purrr::map_dfr(function(kw) {
      matched <- df %>% dplyr::filter(stringr::str_detect(review_text, kw))
      tibble::tibble(
        keyword    = kw,
        matches    = nrow(matched),
        avg_rating = round(mean(matched$rating, na.rm = TRUE), 1)
      )
    }) %>%
    dplyr::arrange(dplyr::desc(matches))
}
