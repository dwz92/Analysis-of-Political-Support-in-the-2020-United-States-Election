#### Preamble ####
# Purpose: Download the raw  data
# Author: Qi Er (Emma) Teng
# Date: 19 March 2024
# Contact: e.teng@mail.utoronto.ca
# License: MIT

#### WORK PLACE SETUP #####
library(rstanarm)
library(broom.mixed)
library(modelsummary)

florida2020 <- read.csv(here::here("data/analysis_data/ces2020_clean.csv"))

florida2020 <-
  stan_glm(
    biden ~ lpop + propage + propwhi + prophis + propbla + propbid + proptru + prophig + propcol,
    data = florida2020,
    family = neg_binomial_2(link = "log"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 853
  )

saveRDS(
  florida2020,
  file = "models/florida2020.rds"
)

modelsummary(
  list(
    "florida elect" = florida2020
  )
)