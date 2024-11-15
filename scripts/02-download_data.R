#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(readr)
# [...UPDATE THIS...]

#### Download data ####
analysis_data <- read_csv("/Users/sarahding/Downloads/ingredient_cost.csv")

#### Save data ####
write_csv(analysis_data, "data/02-analysis_data/analysis_data.csv")
         
