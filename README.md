tidyNano <img src="man/figures/tidyNano.png" align="right" width = 150/>
========================================================================

tidyNano is a package that imports raw NanoSight data and provides the framework to clean, analyze, and visualize nanoparticle analysis data.

Installation
------------

The latest development version can be installed from github:

``` r
# install.packages("devtools")
devtools::install_github("nguyens7/tidyNano")
```

tidyNano Example
----------------

``` r
library(tidyNano)
library(tidyverse)

file <- system.file("extdata", "beads.csv", package = "tidyNano")

tidy_data <- nanoimport(file) %>% 
  nanotidy(2:13) %>% 
  separate(Sample, into = c("Sample", "Dilution", "filter", "injection", "Tech_rep"),
           sep = "_", convert = TRUE) %>% 
  mutate_at(vars(Sample,filter:Tech_rep), as.factor) %>% 
  mutate(True_count = Dilution * Count)

tidy_data
```

    ## # A tibble: 12,000 x 8
    ##    particle_size Sample Dilution filter injection Tech_rep Count
    ##            <dbl> <fct>     <int> <fct>  <fct>     <fct>    <dbl>
    ##  1         0.500 std       10000 yes    2         0           0.
    ##  2         1.50  std       10000 yes    2         0           0.
    ##  3         2.50  std       10000 yes    2         0           0.
    ##  4         3.50  std       10000 yes    2         0           0.
    ##  5         4.50  std       10000 yes    2         0           0.
    ##  6         5.50  std       10000 yes    2         0           0.
    ##  7         6.50  std       10000 yes    2         0           0.
    ##  8         7.50  std       10000 yes    2         0           0.
    ##  9         8.50  std       10000 yes    2         0           0.
    ## 10         9.50  std       10000 yes    2         0           0.
    ## # ... with 11,990 more rows, and 1 more variable: True_count <dbl>

``` r
tidy_data %>% 
  ggplot(aes(x = particle_size, y = True_count, color = Tech_rep)) +
  geom_line(size = 1) +
  facet_wrap(injection~filter)
```

![](README_files/figure-markdown_github/unnamed-chunk-2-1.png)
