#### Preamble ####
# Purpose: Download the raw  data
# Author: Qi Er (Emma) Teng
# Date: 19 March 2024
# Contact: e.teng@mail.utoronto.ca
# License: MIT
# Pre-requisite: Download 2020 Florida counties data from https://www.census.gov/data/tables/time-series/demo/popest/2020s-counties-total.html


#### Workspace setup ####
library(dataverse)
library(tidyverse)
library(dplyr)


#### Download Data ####
ces2020 <-
  get_dataframe_by_name(
    filename = "CES20_Common_OUTPUT_vv.csv",
    dataset = "10.7910/DVN/E9N6PH",
    server = "dataverse.harvard.edu",
    .f = read_csv
  ) |>
  select(countyname, educ, race, birthyr, CC20_410)

colnames(ces2020)

write_csv(ces2020, "data/raw_data/ces2020.csv")