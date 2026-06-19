# Purpose

Illustrate workthrough of Question 3: Loans and Credit.

``` r
rm(list = ls())
gc()
```

    ##          used (Mb) gc trigger (Mb) max used (Mb)
    ## Ncells 491749 26.3    1054147 56.3   701700 37.5
    ## Vcells 909692  7.0    8388608 64.0  1927079 14.8

``` r
library(tidyverse)
```

    ## Warning: package 'readr' was built under R version 4.5.3

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.2.1     ✔ readr     2.2.0
    ## ✔ forcats   1.0.1     ✔ stringr   1.6.0
    ## ✔ ggplot2   4.0.2     ✔ tibble    3.3.1
    ## ✔ lubridate 1.9.5     ✔ tidyr     1.3.2
    ## ✔ purrr     1.2.1     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
# run_project.R sources every function in code/ (one file, one function),
# loads and cleans the loan book, runs every heuristic test, the borrower
# risk profiles, the Texas deep-dive, the DTI threshold scenarios, the
# grading-system evaluation and the full default model - and saves every
# resulting table to Question3_files/tables/ and every figure to
# Question3_files/figures/.
source("run_project.R")
```

    ## Loading required package: pacman

    ## Warning in n1 * n0: NAs produced by integer overflow

    ## Warning in n1 * n0: NAs produced by integer overflow

## Institute Heuristic 1: Home ownership

``` r
home_summary
```

    ## # A tibble: 4 × 5
    ##   home_ownership_grp      n default_rate median_income median_dti
    ##   <chr>               <int>        <dbl>         <dbl>      <dbl>
    ## 1 MORTGAGE           188163        0.188         75000       18.2
    ## 2 OTHER                  76        0.211         65000       19.9
    ## 3 OWN                 46761        0.228         61000       18.2
    ## 4 RENT               148202        0.270         58000       17.8

``` r
Homeownership_Default_Plot(home_summary)
```

![](C:\Users\JENNIFER\OneDrive%20-%20Stellenbosch%20University\MCom%202026\First%20Semester\Data%20Science\Exam%20Folder\29418100\Question3\README_files/figure-markdown_github/unnamed-chunk-2-1.png)

## Institute Heuristic 3: State-level default culture (flagship map)

``` r
State_Default_Map(state_summary)
```

![](C:\Users\JENNIFER\OneDrive%20-%20Stellenbosch%20University\MCom%202026\First%20Semester\Data%20Science\Exam%20Folder\29418100\Question3\README_files/figure-markdown_github/unnamed-chunk-3-1.png)

Texas in national context:

``` r
texas_summary
```

    ## # A tibble: 4 × 4
    ##   metric             state default_rate      n
    ##   <chr>              <chr>        <dbl>  <int>
    ## 1 Texas              TX           0.228  32383
    ## 2 National Average   <NA>         0.225 383202
    ## 3 Highest-Risk State AR           0.276   2860
    ## 4 Lowest-Risk State  DC           0.141    880

``` r
Texas_Comparison_Plot(texas_summary)
```

![](C:\Users\JENNIFER\OneDrive%20-%20Stellenbosch%20University\MCom%202026\First%20Semester\Data%20Science\Exam%20Folder\29418100\Question3\README_files/figure-markdown_github/unnamed-chunk-4-1.png)

## Institute Heuristic 4: Does the grading system hold up for young borrowers?

``` r
grade_age_summary
```

    ## # A tibble: 14 × 4
    ##    young_borrower grade     n default_rate
    ##    <lgl>          <chr> <int>        <dbl>
    ##  1 FALSE          A     60043       0.0684
    ##  2 FALSE          B     97196       0.155 
    ##  3 FALSE          C     91197       0.252 
    ##  4 FALSE          D     44297       0.343 
    ##  5 FALSE          E     19310       0.429 
    ##  6 FALSE          F      6805       0.521 
    ##  7 FALSE          G      1771       0.573 
    ##  8 TRUE           A      6843       0.0723
    ##  9 TRUE           B     17589       0.161 
    ## 10 TRUE           C     20257       0.259 
    ## 11 TRUE           D     10586       0.362 
    ## 12 TRUE           E      4992       0.438 
    ## 13 TRUE           F      1762       0.533 
    ## 14 TRUE           G       554       0.576

``` r
grade_monotonic
```

    ## # A tibble: 2 × 2
    ##   young_borrower monotonic
    ##   <lgl>          <lgl>    
    ## 1 FALSE          TRUE     
    ## 2 TRUE           TRUE

## DTI policy thresholds

``` r
dti_scen
```

    ## # A tibble: 3 × 5
    ##   scenario     tolerance dti_cap     n default_rate
    ##   <chr>            <dbl>   <dbl> <int>        <dbl>
    ## 1 conservative      0.05       5 19605        0.169
    ## 2 moderate          0.1        5 19605        0.169
    ## 3 aggressive        0.15       5 19605        0.169

## Grading-system efficacy

``` r
grade_summary
```

    ## # A tibble: 7 × 3
    ##   grade      n default_rate
    ##   <chr>  <int>        <dbl>
    ## 1 A      66886       0.0688
    ## 2 B     114785       0.156 
    ## 3 C     111454       0.253 
    ## 4 D      54883       0.346 
    ## 5 E      24302       0.431 
    ## 6 F       8567       0.524 
    ## 7 G       2325       0.573

``` r
grade_auc
```

    ## # A tibble: 1 × 3
    ##     auc      n n_predictors
    ##   <dbl>  <int>        <dbl>
    ## 1    NA 383202            1

``` r
Grade_Default_Plot(grade_summary, grade_auc$auc)
```

![](C:\Users\JENNIFER\OneDrive%20-%20Stellenbosch%20University\MCom%202026\First%20Semester\Data%20Science\Exam%20Folder\29418100\Question3\README_files/figure-markdown_github/unnamed-chunk-7-1.png)

## Strongest predictors of default

``` r
var_importance
```

    ## # A tibble: 16 × 8
    ##    term          estimate std.error statistic   p.value conf.low conf.high  rank
    ##    <chr>            <dbl>     <dbl>     <dbl>     <dbl>    <dbl>     <dbl> <int>
    ##  1 gradeD           5.32   0.0197      84.7   0            5.12      5.53      1
    ##  2 gradeE           6.76   0.0228      83.9   0            6.46      7.07      2
    ##  3 gradeF           8.98   0.0296      74.3   0            8.47      9.52      3
    ##  4 gradeC           3.67   0.0184      70.7   0            3.54      3.80      4
    ##  5 gradeG          10.4    0.0480      48.9   0            9.50     11.5       5
    ##  6 gradeB           2.23   0.0186      43.2   0            2.15      2.31      6
    ##  7 home_ownersh…    1.51   0.00958     43.1   0            1.48      1.54      7
    ##  8 term_label60…    1.51   0.0104      39.9   0            1.48      1.54      8
    ##  9 dti_clean        1.01   0.000492    28.8   3.60e-182    1.01      1.02      9
    ## 10 verification…    1.30   0.0120      21.6   9.52e-104    1.27      1.33     10
    ## 11 verification…    1.22   0.0111      17.7   7.03e- 70    1.19      1.24     11
    ## 12 home_ownersh…    1.22   0.0141      14.2   4.55e- 46    1.19      1.26     12
    ## 13 log1p(annual…    0.922  0.00909     -8.91  5.07e- 19    0.906     0.939    13
    ## 14 emp_length_n…    0.997  0.00119     -2.74  6.21e-  3    0.994     0.999    14
    ## 15 age_proxy        0.999  0.000641    -0.947 3.44e-  1    0.998     1.00     15
    ## 16 home_ownersh…    1.32   0.304        0.909 3.64e-  1    0.703     2.33     16

``` r
Risk_Driver_Plot(var_importance)
```

![](C:\Users\JENNIFER\OneDrive%20-%20Stellenbosch%20University\MCom%202026\First%20Semester\Data%20Science\Exam%20Folder\29418100\Question3\README_files/figure-markdown_github/unnamed-chunk-8-1.png)

See `Question3.Rmd` for the full Director-facing write-up, and
`Question3_files/tables/` and `Question3_files/figures/` for every
persisted result this script produces.
