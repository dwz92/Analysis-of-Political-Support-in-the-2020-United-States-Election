#### Preamble ####
# Purpose: Download the raw  data
# Author: Qi Er (Emma) Teng
# Date: 19 March 2024
# Contact: e.teng@mail.utoronto.ca
# License: MIT
# Pre-requisite: Download 2020 Florida counties data from https://www.census.gov/data/tables/time-series/demo/popest/2020s-counties-total.html

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(readxl)


#### Data Cleaning ####

### FLORIDA COUNTIES CLEAN ###

co_est2022_chg_12 <- read_excel("data/raw_data/co-est2022-chg-12.xlsx")

co_est2022_chg_12 <- co_est2022_chg_12[6:72,1:2]

co_est2022_chg_12 <- co_est2022_chg_12 |>
  rename("county" = "table with row headers in column A and column headers in rows 3 through 5 (leading dots indicate sub-parts)", "population" = "...2")

co_est2022_chg_12 <- co_est2022_chg_12 |>
  mutate(county = str_replace_all(county, " County, Florida", " FL"))

co_est2022_chg_12 <- co_est2022_chg_12 |>
  mutate(county = str_replace_all(county, "^\\.", ""))



write.csv(co_est2022_chg_12, "data/analysis_data/floridacount.csv")


### CES2020 CLEAN ###
ces2020 <-
  read_csv(
    "data/raw_data/ces2020.csv",
    col_types =
      cols(
        "countyname" = col_character(),
        "educ" = col_integer(),
        "race" = col_integer(),
        "birthyr" = col_integer(),
        "CC20_410" = col_integer()
      )
  )


ces2020 <- ces2020 |>
  filter(countyname %in% co_est2022_chg_12$county, CC20_410 %in% c(1, 2))
  
ces2020_summary <- ces2020 |>
  group_by(countyname) |>
  summarize(
    biden = sum(CC20_410 == 1, na.rm = TRUE),
    trump = sum(CC20_410 == 2, na.rm = TRUE),
    age65 = sum(birthyr <= 1955, na.rm = TRUE),
    white = sum(race == 1, na.rm = TRUE),
    black = sum(race == 2, na.rm = TRUE),
    hispa = sum(race == 3, na.rm = TRUE),
    high = sum(educ == 2, na.rm = TRUE),
    coll = sum(educ %in% c(3, 4, 5), na.rm = TRUE)
  ) %>%
  ungroup()

ces2020_clean <- co_est2022_chg_12 |>
  left_join(ces2020_summary, by = c("county" = "countyname"))

ces2020_clean <- ces2020_clean |>
  mutate(
    population = parse_number(as.character(population))
  ) |>
  mutate(
    lpop = log10(population),
    propage = age65/population,
    propwhi = white/population,
    prophis = hispa/lpop,
    propbla = black/lpop,
    propbid = biden/population,
    proptru = trump/population,
    prophig = high/population,
    propcol = coll/population
    
  )

write.csv(ces2020_clean, "data/analysis_data/ces2020_clean.csv")