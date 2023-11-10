setwd("R:/Users/rsimpao/repo=rstudio/pokemon_index_project")

library(conflicted)
library(httr)
library(tidyverse)
library(jsonlite)
library(odbc)

tidy <- loadNamespace("tidyverse")
jsl <- loadNamespace("jsonlite")
pokemon_uri_list = read_csv("data/raw/api_pokemon.csv", col_types = "c") %>% head(1)

# to consider comparing
# abilities
# id
# location_area_encounters
# moves
# stats
# types
# height
# weight

print(pokemon_uri_list$url)

for(mon in pokemon_uri_list$url){
  response = httr::GET(mon)
  data = content(response, as = "text") %>% jsl$fromJSON()
  
  # data to collect
  print(data$abilities$ability$name)
  print(data$past_abilities)
  print(data$id)
  print(data$location_area_encounters)
  print(data$moves$move$name)
  print(data$stats$base_stat)
  print(data$stats$effort)
  print(data$stats$stat$name)
  print(data$types$type$name)
  print(data$past_types)
}