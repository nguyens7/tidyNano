## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message=FALSE, warning=FALSE---------------------------------------------
library(tidyNano)
library(ggplot2)
library(dplyr)
library(tidyr)

## -----------------------------------------------------------------------------
file <- system.file("extdata", "beads.csv", package = "tidyNano")

read.csv(file) %>% head()

## -----------------------------------------------------------------------------
data <- nanoimport(file) 

head(data)

## -----------------------------------------------------------------------------
file2 <- system.file("extdata", "beads2.csv", package = "tidyNano")

data2 <- nanoimport(file2, auto_name = TRUE)

head(data2)

## -----------------------------------------------------------------------------
custom_name_data2 <- nanoimport(file2, auto_name = TRUE, custom_name = "YourLabelHere")

head(custom_name_data2)

## -----------------------------------------------------------------------------
tidy_data <- nanoimport(file) %>% 
  nanotidy( sep_var = c("Sample", "Dilution","Filter",
                       "Injection","Tech_rep")) 

head(tidy_data)

## -----------------------------------------------------------------------------
tidy_data %>% 
  ggplot(aes(x = particle_size, y = True_count, color = Tech_rep)) +
  geom_line(size = 1) +
  facet_wrap(Injection ~ Filter)

## -----------------------------------------------------------------------------
Tech_avg_data <- tidy_data %>%
  nanolyze(particle_size, Sample, Dilution, Filter, Injection, 
           name = "Tech_rep",
           param_var = True_count)

head(Tech_avg_data)

## -----------------------------------------------------------------------------
Tech_avg_data %>% 
  ggplot(aes(x = particle_size, y = Tech_rep_mean, color = Injection)) +
  geom_line( size = 1) +
  facet_wrap(~ Filter) + theme_bw()

## -----------------------------------------------------------------------------
Injection_avg_data <- Tech_avg_data %>% 
  nanolyze(particle_size, Sample, Dilution, Filter, 
           name = "Injection",
           param_var = Tech_rep_mean)

head(Injection_avg_data)

## -----------------------------------------------------------------------------
Injection_avg_data %>% 
  ggplot(aes(x = particle_size, y = Injection_mean, color = Filter)) +
  geom_line( size = 1) +
  facet_wrap(~Filter)

## ---- fig.cap = "MY FIGURE CAPTION"-------------------------------------------
Injection_avg_data %>% 
  filter(particle_size <300) %>% 
  ggplot(aes(x = particle_size, y = Injection_mean, color = Filter)) +
  geom_line( size = 1) +
  facet_wrap(~Filter) 

## -----------------------------------------------------------------------------
Injection_avg_data %>%
  nanocount(Sample, Dilution, Filter, 
            param_var = Injection_mean)

## -----------------------------------------------------------------------------
Injection_avg_data %>%
  filter(particle_size < 100) %>% 
  nanocount(Sample, Dilution, Filter, 
            param_var = Injection_mean)

