## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message=FALSE, warning=FALSE----------------------------------------
library(tidyNano)
library(tidyverse)

## ------------------------------------------------------------------------
file <- system.file("extdata", "beads.csv", package = "tidyNano")

read.csv(file) %>% head()

## ------------------------------------------------------------------------
data <- nanoimport(file) 

data

## ------------------------------------------------------------------------
nanoimport(file) %>% 
  nanotidy(2:13) 

## ------------------------------------------------------------------------
tidy_data <- nanoimport(file) %>% 
  nanotidy(2:13) %>% 
  separate(Sample, into = c("Sample", "Dilution", "filter", "injection", "Tech_rep"),
           sep = "_", convert = TRUE) %>% 
  mutate_at(vars(Sample,filter:Tech_rep), as.factor) %>% 
  mutate(True_count = Dilution * Count)

tidy_data

## ------------------------------------------------------------------------
tidy_data %>% 
  ggplot(aes(x = particle_size, y = True_count, color = Tech_rep)) +
  geom_line(size = 1) +
  facet_wrap(injection~filter)

## ------------------------------------------------------------------------
Tech_avg_data <- tidy_data %>%
  nanolyze(particle_size, Sample, Dilution,filter, injection, 
           name = "Tech_rep",
           param_var = True_count)

Tech_avg_data

## ------------------------------------------------------------------------
Tech_avg_data %>% 
  ggplot(aes(x = particle_size, y = Tech_rep_mean, color = injection)) +
  geom_line( size = 1) +
  facet_wrap(~filter) + theme_bw()

## ------------------------------------------------------------------------
Injection_avg_data <- Tech_avg_data %>% 
  nanolyze(particle_size, Sample, Dilution, filter, 
           name = "Injection",
           param_var = Tech_rep_mean)

Injection_avg_data

## ------------------------------------------------------------------------
Injection_avg_data %>% 
  ggplot(aes(x = particle_size, y = Injection_mean, color = filter)) +
  geom_line( size = 1) +
  facet_wrap(~filter)

## ---- fig.cap = "MY FIGURE CAPTION"--------------------------------------
Injection_avg_data %>% 
  filter(particle_size <300) %>% 
  ggplot(aes(x = particle_size, y = Injection_mean, color = filter)) +
  geom_line( size = 1) +
  facet_wrap(~filter) 

## ------------------------------------------------------------------------
Injection_avg_data %>%
  nanocount(Sample, Dilution, filter, 
            param_var = Injection_mean)

## ------------------------------------------------------------------------
Injection_avg_data %>%
  filter(particle_size < 100) %>% 
  nanocount(Sample, Dilution, filter, 
            param_var = Injection_mean)

