# Master script - Question 2: Baby Names Analysis (1910-2014)
# Run from the Question2 project root: source("code/run_project.R")

source("code/utils/packages.R")
source("code/utils/paths.R")
source("code/utils/helpers.R")
source("code/utils/save_outputs.R")

source("code/data/load_data.R")
source("code/data/clean_data.R")

source("code/analysis/naming_persistence.R")
source("code/analysis/era_comparison.R")
source("code/analysis/popularity_spikes.R")
source("code/analysis/billboard_influence.R")
source("code/analysis/hbo_influence.R")
source("code/analysis/one_hit_wonders.R")

source("code/visualisation/persistence_plots.R")
source("code/visualisation/spike_plots.R")
source("code/visualisation/billboard_plots.R")
source("code/visualisation/hbo_plots.R")

load_packages()
ensure_output_dirs()

raw_data   <- load_all_data()
clean_data <- clean_all_data(raw_data)

top25             <- get_top25_names(clean_data$baby_names)
persistence_panel <- build_persistence_panel(top25)
era_summary       <- compare_eras(persistence_panel)
name_spikes       <- identify_spikes(clean_data$baby_names)
billboard_effect  <- analyse_billboard_effect(clean_data$baby_names, clean_data$billboard)
hbo_effect        <- analyse_hbo_effect(clean_data$baby_names, clean_data$hbo_credits, clean_data$hbo_titles)
one_hit_wonders   <- identify_one_hit_wonders(clean_data$baby_names)

save_table(persistence_panel, "persistence_panel.csv")
save_table(era_summary,       "era_summary.csv")
save_table(name_spikes,       "name_spikes.csv")
save_table(billboard_effect,  "billboard_matches.csv")
save_table(hbo_effect,        "hbo_matches.csv")
save_table(one_hit_wonders,   "one_hit_wonders.csv")

generate_persistence_plots(persistence_panel)
generate_spike_plots(name_spikes)
generate_billboard_plots(billboard_effect)
generate_hbo_plots(hbo_effect)
