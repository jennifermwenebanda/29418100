# Default-model predictor-importance figure: odds ratios with 95% CI for
# every predictor in the full default model, ranked by Wald statistic.
# Colour shows whether the predictor raises (red, OR > 1) or lowers (blue,
# OR < 1) the odds of default. Builds, saves
# (Question3_files/figures/risk_drivers.png) and returns the plot.
Risk_Driver_Plot <- function(var_importance){

  g <- var_importance %>%
    dplyr::mutate(
      direction = dplyr::if_else(estimate >= 1, "Increases default odds", "Decreases default odds"),
      term = forcats::fct_reorder(term, abs(statistic))
    ) %>%
    ggplot2::ggplot(ggplot2::aes(x = estimate, y = term, colour = direction)) +
    ggplot2::geom_vline(xintercept = 1, linetype = "dashed", colour = "grey50") +
    ggplot2::geom_pointrange(ggplot2::aes(xmin = conf.low, xmax = conf.high), linewidth = 0.8, size = 0.6) +
    ggplot2::scale_colour_manual(values = c("Increases default odds" = "#b2182b",
                                             "Decreases default odds" = "#2166ac"),
                                  name = "Effect on Default Risk") +
    ggplot2::scale_x_log10() +
    ggplot2::labs(
      title    = "Strongest Predictors of Loan Default",
      subtitle = "Odds ratios (95% CI) from the full logistic regression, ranked by statistical strength (top = strongest)",
      x = "Odds Ratio (log scale; dashed line = no effect)", y = NULL,
      caption = paste(
        "Source: Lending Club loan-level data, resolved loans only.",
        "Model: defaulted ~ grade + dti_clean + log1p(annual_inc) + home_ownership_grp +",
        "verification_status + term_label + age_proxy + emp_length_num.",
        sep = "\n"
      )
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"), legend.position = "top")

  ggplot2::ggsave("Question3_files/figures/risk_drivers.png", g, width = 10, height = 8, dpi = 300)

  g

}
