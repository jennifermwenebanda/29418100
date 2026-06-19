# Master script - Question 1: Coffee Hub Business Decision Analytics
# Run from the Question1 project root: source("code/run_project.R")

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, scales, janitor, forcats)

source("code/load_data.R")
source("code/clean_data.R")
source("code/flavour_matching.R")
source("code/supplier_analysis.R")
source("code/cost_analysis.R")
source("code/distance_analysis.R")
source("code/business_score.R")
source("code/visualisations.R")
source("code/ppt_report.R")

FIGURE_PATH <- "Question1_files/figures"
TABLE_PATH  <- "Question1_files/tables"
c(FIGURE_PATH, TABLE_PATH) %>%
  purrr::walk(~ dir.create(.x, recursive = TRUE, showWarnings = FALSE))

save_plot <- function(plot, filename, width = 8, height = 6, dpi = 300) {
  ggplot2::ggsave(filename = filename, plot = plot, path = FIGURE_PATH,
                   width = width, height = height, dpi = dpi)
  invisible(plot)
}

save_table <- function(data, filename) {
  readr::write_csv(data, file.path(TABLE_PATH, filename))
  invisible(data)
}

# 1. Load + clean ------------------------------------------------------------
coffee_raw   <- load_coffee()
coffee_clean <- clean_coffee(coffee_raw)

# 2. Flavour matching ----------------------------------------------------
coffee_scored <- score_flavour_match(coffee_clean)
keyword_freq  <- keyword_frequency_table(coffee_scored)

# 3. Distance + business score -----------------------------------------------
coffee_dist  <- add_distance_to_sa(coffee_scored)
coffee_final <- compute_business_score(coffee_dist)
ranked       <- rank_business_viability(coffee_final, n = 15)

# 4. Supplier comparison -------------------------------------------------
supplier_summary <- summarise_suppliers(coffee_scored)
suppliers_top    <- top_suppliers(supplier_summary, n = 10, min_coffees = 2)

# 5. Cost analysis ---------------------------------------------------------
cost_overall <- average_cost(coffee_clean)
price_bands  <- price_band_summary(coffee_scored)

top_matches      <- top_flavour_matches(coffee_scored, n = 20)
cost_top_matches <- average_cost(top_matches)

# 6. Distance / roastery-country analysis -------------------------------
dist_summary <- distance_summary(coffee_dist)

# 7. Recommendation table for the entrepreneur --------------------------
recommendation_table <- build_recommendation_table(ranked, n = 10)

# Save tables -----------------------------------------------------------
save_table(keyword_freq,          "keyword_frequency.csv")
save_table(supplier_summary,      "supplier_summary.csv")
save_table(suppliers_top,         "top_suppliers.csv")
save_table(cost_overall,          "cost_overall.csv")
save_table(price_bands,           "price_bands.csv")
save_table(cost_top_matches,      "cost_top_matches.csv")
save_table(dist_summary,          "distance_summary.csv")
save_table(recommendation_table,  "recommendation_table.csv")

# Save plots --------------------------------------------------------------
save_plot(plot_rating_by_roast(coffee_scored),                "rating_by_roast.png")
save_plot(plot_top_origins(coffee_scored, n = 10),             "top_origins.png")
save_plot(plot_flavour_match_top(coffee_scored, n = 15),       "flavour_match_top.png")
save_plot(plot_supplier_comparison(supplier_summary, n = 10),  "supplier_comparison.png")
save_plot(plot_price_band(price_bands),                        "price_band.png")
save_plot(plot_distance_vs_metrics(dist_summary),              "distance_vs_metrics.png")
save_plot(plot_business_score_ranked(ranked, n = 15),          "business_score_ranked.png")
