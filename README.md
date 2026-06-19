# 29418100 — Data Science Practical Examination

**Author:** Jennifer Mwenebanda<br> **Student number:** 29418100<br>
**Date:** 19 June 2026<br> **Lecturer:** NF Katzke 

------------------------------------------------------------------------

## Purpose and Structure

The purpose of this README is to explain my reasoning and process for
answering each question in the Data Science Practical Exam, and to
document the project’s folder structure so that any question can be
opened and reproduced independently.

The raw data supplied for the exam lives in the Exam Folder’s top-level
`Data/` directory. None of it is copied: a Windows directory junction
(`mklink /J`) links the project’s root `data/` folder to `../Data/`, and
each question’s own `data/<dataset>` subfolder is in turn junctioned to
the relevant dataset inside `Data/`. This means every question is a
fully self-contained RStudio project (its own `.Rproj`, `.Rmd`, `code/`,
`Tex/`, `Template/`) without a single byte of data being duplicated on
disk.

All data wrangling, analysis and plotting logic lives in small,
single-purpose functions inside each question’s own `code/as required for this exam. Each
question’s `.Rmd` sources its functions (directly, or via a master
script) and only ever calls them; raw computation never appears in the
report body itself. Output (PowerPoint slides, paged HTML reports, and
any persisted figures/tables backing them) is written into that
question’s own `Question#_files/` folder.

------------------------------------------------------------------------

## Getting Started

The exam project and its four question sub-projects were created as
follows (run once, from the Exam Folder), mirroring the structure of the
supplied `Mock_Solution` template with `STUDENTNUMBER` replaced by
`29418100`:

``` r
library(tidyverse)

student_number <- "29418100"
exam_dir    <- "C:/Users/JENNIFER/OneDrive - Stellenbosch University/MCom 2026/First Semester/Data Science/Exam Folder"
project_dir <- file.path(exam_dir, student_number)

dir.create(project_dir, showWarnings = FALSE)

# Root .Rproj
writeLines(
  c("Version: 1.0", "RestoreWorkspace: Default", "SaveWorkspace: Default",
    "AlwaysSaveHistory: Default", "EnableCodeIndexing: Yes", "UseSpacesForTab: Yes",
    "NumSpacesForTab: 2", "Encoding: UTF-8", "RnwWeave: Sweave", "LaTeX: pdfLaTeX",
    paste0("ProjectName: ", student_number)),
  file.path(project_dir, paste0(student_number, ".Rproj"))
)

# Junction the root data/ folder to the Exam Folder's Data/ (no copy)
shell(sprintf('mklink /J "%s" "%s"',
              file.path(project_dir, "data"), file.path(exam_dir, "Data")))

# Each Question# folder mirrors Mock_Solution/Mock_Solution (.Rproj, .Rmd, code/,
# Tex/, Template/, Question#_files/), with its own data/<dataset> folder junctioned
# to the matching subfolder of Data/ — e.g. for Question 2 (US Baby Names):
shell(sprintf('mklink /J "%s" "%s"',
              file.path(project_dir, "Question2", "data", "US_Baby_names"),
              file.path(exam_dir, "Data", "US_Baby_names")))
```

------------------------------------------------------------------------

## Folder Structure

    29418100/
    ├── 29418100.Rproj
    ├── README.Rmd          ← this file (root summary)
    ├── .gitignore          ← excludes data/ and output artefacts
    ├── data/               ← junction to ../Data/ (not committed)
    │
    ├── Question1/          ← Coffee Hub (PowerPoint output)
    │   ├── Question1.Rmd
    │   ├── code/
    │   │   ├── load_coffee.R      (CSV loader with encoding fallback)
    │   │   └── plot_coffee.R      (rating, origin, price-vs-rating, top-roasters)
    │   ├── data/Coffee/           (junction — not committed)
    │   └── Tex/
    │
    ├── Question2/          ← US Baby Naming Trends (paged HTML) — UPDATED, see below
    │   ├── Question2.Rmd
    │   ├── code/
    │   │   ├── run_project.R          (master orchestrator — sourced by Question2.Rmd)
    │   │   ├── utils/                 (packages.R, paths.R, helpers.R, save_outputs.R)
    │   │   ├── data/                  (load_data.R, clean_data.R)
    │   │   ├── analysis/              (naming_persistence.R, era_comparison.R,
    │   │   │                            popularity_spikes.R, billboard_influence.R,
    │   │   │                            hbo_influence.R, one_hit_wonders.R)
    │   │   └── visualisation/         (persistence_plots.R, spike_plots.R,
    │   │                                billboard_plots.R, hbo_plots.R)
    │   ├── data/US_Baby_names/        (junction — not committed)
    │   ├── Question2_files/
    │   │   ├── figures/               (5 PNGs — persisted plot outputs)
    │   │   └── tables/                (6 CSVs — persisted analysis outputs)
    │   ├── Template/ and Tex/
    │
    ├── Question3/          ← Loans & Credit (HTML paged output)
    │   ├── Question3.Rmd
    │   ├── code/
    │   │   ├── clean_loans.R      (status classification, rate parsing)
    │   │   └── plot_loans.R       (grade, home ownership, DTI, state maps)
    │   ├── data/Loan_Cred/        (junction — not committed)
    │   ├── Template/ and Tex/
    │
    └── Question4/          ← Netflix (HTML paged output)
        ├── Question4.Rmd
        ├── code/
        │   └── netflix_plots.R    (genre, runtime, score dist, text analysis)
        ├── data/netflix/          (junction — not committed)
        ├── Template/ and Tex/

> **Status note:** Questions 1, 3 and 4 currently use the original
> single-file-per-concern `code/` layout shown above. Question 2 has
> been migrated to the fully modular, functional-programming structure
> described below, which is the standard the exam recommends; the other
> three questions will be updated to match in due course. This README
> will be expanded with their detailed approaches once that happens.

------------------------------------------------------------------------

## Question Summaries

### Question 1 — Coffee Hub (PowerPoint)

``` r
gc()
library(pacman)
p_load(tidyverse, scales, janitor, forcats)

list.files("Question1/code/", full.names = TRUE, recursive = TRUE) %>%
  as.list() %>% purrr::walk(~source(.))

coffee <- load_coffee("Question1/data/Coffee/Coffee.csv")
```

**Approach:**

-   Built a robust CSV loader (`load_coffee`) with UTF-8 / latin1
    encoding fallback and `janitor::clean_names()` to handle special
    characters in the data.
-   Produced four slides: (1) rating by roast, (2) top origins by
    listing count, (3) price vs. rating scatter, (4) top-rated roasters
    table.
-   Keyword-matched student survey terms against review text to surface
    locally relevant coffees.
-   **Key finding:** Light/medium roasts from Ethiopia and Colombia
    score highest and fall in the $15–$30 sweet spot.

------------------------------------------------------------------------

### Question 2 — US Baby Naming Trends (1910–2014)

**Brief:** A New York-based toy design agency wants to understand baby
naming trends in the United States between 1910 and 2014, to inform
character-naming decisions for new toy lines. They suspect naming trends
have become more short-lived since the 1990s, and want to know whether
music, television or celebrity culture measurably drives naming spikes.

This question has been rebuilt as a fully modular,
functional-programming pipeline: a master script (`code/run_project.R`)
sources four layers of small, single-purpose functions and runs the
whole analysis as a sequence of pure transformations — no `for`/`while`
loops anywhere, only `dplyr`/`purrr` pipelines.

``` r
gc()
setwd("Question2")           # each question is its own self-contained .Rproj
source("code/run_project.R") # also runs automatically from Question2.Rmd's setup chunk
```

Sourcing `run_project.R`:

1.  **`code/utils/`** — loads packages (`packages.R`); centralises every
    input/output path (`paths.R`: `data/US_Baby_names/`,
    `Question2_files/figures/`, `Question2_files/tables/`) and an
    `ensure_output_dirs()` helper; provides small pure helpers
    (`helpers.R`: `standardise_names()`, `extract_first_name()`,
    `safe_rank()`, `calculate_growth_rate()`) and saving wrappers
    (`save_outputs.R`: `save_plot()`, `save_table()`).
2.  **`code/data/`** — `load_data.R` reads the four raw `.rds` files
    (`Baby_Names_By_US_State.rds`, `charts.rds`, `HBO_titles.rds`,
    `HBO_credits.rds`) from the junctioned `data/US_Baby_names/` folder;
    `clean_data.R` standardises column names (`janitor::clean_names()`),
    drops missing values, and derives the `release_year` / `first_name`
    columns needed to later match Billboard/HBO records to baby names.
3.  **`code/analysis/`** — six modules, each a pure `dplyr`/`purrr`
    pipeline:
    -   `naming_persistence.R` ranks the Top-25 names per year/gender
        and computes the **Spearman rank correlation** between year *t*
        and years *t+1* to *t+3* (`purrr::pmap_dfr` over every base-year
        × lead × gender combination).
    -   `era_comparison.R` splits the persistence panel into Pre-1990 /
        Post-1990 and summarises mean/median/SD correlation by era.
    -   `popularity_spikes.R` computes year-on-year growth rates and
        keeps the 50 biggest absolute birth-count spikes.
    -   `billboard_influence.R` / `hbo_influence.R` match
        artist/character first names to baby names and compute a
        post-release vs. pre-release “impact ratio” within a 5-year
        window. Baby names are aggregated to (year, gender, name)
        **before** the many-to-many join against Billboard/HBO records —
        joining at the original per-state granularity caused a
        combinatorial explosion that hung the pipeline during testing
        (multi-GB memory growth with no progress); aggregating first
        fixed it.
    -   `one_hit_wonders.R` flags names that appear in only one year of
        the data.
4.  **`code/visualisation/`** — one module per analysis
    (`persistence_plots.R`, `spike_plots.R`, `billboard_plots.R`,
    `hbo_plots.R`), each builds a `ggplot2` object and saves it via
    `save_plot()`.

`run_project.R` runs every analysis and visualisation function in
sequence, writing 6 CSVs to `Question2_files/tables/` and 5 PNGs to
`Question2_files/figures/`. `Question2.Rmd` then only ever calls
`knitr::include_graphics()` or `readr::read_csv() %>% knitr::kable()`
against those persisted files — no analysis code runs inside the report
body itself.

**Note on output format:** `Question2.Rmd` sets `self_contained: FALSE`
(unlike the other three questions). `Question2_files` is also
rmarkdown’s reserved name for a document’s own “supporting files”
directory — with `self_contained: TRUE`, rmarkdown embeds every image
into the HTML as base64 and then deletes that whole folder, which
silently wiped out the persisted tables/figures this pipeline is
specifically designed to keep, on every render. `self_contained: FALSE`
keeps the HTML, figures and tables as separate, inspectable deliverables
instead.

**Approach and key findings:**

-   Boys’ names are consistently more persistent than girls’ names at
    every lead (1–3 years), and persistence for both genders has
    declined measurably since 1990 — most pronounced at the 3-year lead,
    where boys’ median Spearman ρ falls from 0.94 pre-1990 to 0.84
    post-1990 — confirming the agency’s suspicion.
-   The single largest year-on-year spike is **Linda**, up 89% in 1947,
    the year after Jack Lawrence’s hit song “Linda” (1946) — a clean
    example of a music-driven naming spike.
-   Billboard artists and HBO characters with **distinctive,
    previously-rare first names** (e.g. Sade, Rihanna, Jaheim; Zaria,
    Whitley, Zander) show by far the largest impact ratios, since any
    post-release uptake is large relative to their near-zero baseline.
-   Thousands of names appear in only a single year of the data — a long
    tail of fads that, individually, contribute far fewer births than
    the sustained classics.
-   **Recommendation for the agency:** blend a small core of
    historically persistent names (safe for flagship/legacy toy lines)
    with a rotating set of culturally-driven names sourced from current
    music/TV data (for limited-edition lines).

------------------------------------------------------------------------

### Question 3 — Loans & Credit (HTML)

``` r
gc()
library(pacman)
p_load(tidyverse, scales, janitor)

list.files("Question3/code/", full.names = TRUE, recursive = TRUE) %>%
  as.list() %>% purrr::walk(~source(.))

raw_loans <- readRDS("Question3/data/Loan_Cred/loan_data.rds")
loans     <- clean_loans(raw_loans)
```

**Approach:**

-   `clean_loans` standardises the loan_status variable into four
    categories (Fully Paid / Current / Charged Off / Collections) and
    creates a binary `defaulted` flag.
-   Analysed default rates by: credit grade, home ownership (short-term
    only), US state, and DTI level.
-   Tested all three Institute heuristics against the data — only
    credit-grade-as-predictor is strongly supported.
-   Provided a DTI hard-cap tolerance table for the Director.

------------------------------------------------------------------------

### Question 4 — Netflix (HTML)

``` r
gc()
library(pacman)
p_load(tidyverse, scales, tidytext)

list.files("Question4/code/", full.names = TRUE, recursive = TRUE) %>%
  as.list() %>% purrr::walk(~source(.))

titles     <- readRDS("Question4/data/netflix/titles.rds")
credits    <- readRDS("Question4/data/netflix/credits.rds")
movie_info <- readr::read_csv("Question4/data/netflix/netflix_movies.csv",
                               show_col_types = FALSE)
```

**Approach:**

-   Explored catalogue volume, genre distribution, and temporal growth.
-   Compared TMDb scores for movies vs. TV shows (shows score higher on
    average).
-   Analysed runtime and volume by country to identify international
    content patterns.
-   Used `tidytext` to extract the most frequent non-stop-words from
    title descriptions.
-   **Key recommendation:** Invest in TV dramas, documentaries, and
    Asian co-productions.

------------------------------------------------------------------------

## How to Reproduce

1.  Open `29418100.Rproj` in RStudio.
2.  Ensure the `data/` junction resolves (it points to `../Data/` — keep
    the folder structure intact).
3.  To knit each question: open the relevant `.Rmd` inside `Question#/`
    and click **Knit**. For Question 2, knitting (or running
    `source("code/run_project.R")` directly) also regenerates every
    figure/table in `Question2_files/`.
4.  To render this README: knit `README.Rmd` from the root.

> **Note:** The `data/` directories are excluded from git via
> `.gitignore` (`*data/`). Data files must be present locally for the
> `.Rmd` files to knit.
