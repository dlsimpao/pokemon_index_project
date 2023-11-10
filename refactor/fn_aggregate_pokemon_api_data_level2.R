setwd("R:/Users/rsimpao/repo=rstudio/pokemon_index_project")

library(conflicted)
library(httr)
library(tidyverse)
library(jsonlite)
library(odbc)

stringify_list <- function(item_list) {
  return(paste(item_list, collapse = ","))
}

# to do
# get all pokemon's attributes
# get pokemon shape and merge

tidy <- loadNamespace("tidyverse")
jsl <- loadNamespace("jsonlite")
pokemon_uri_list = read_csv("data/raw/api_pokemon.csv", col_types = "c") %>% head(3)

pokemon_shape_list = read_csv("data/raw/api_pokeshape.csv", col_types = "c") %>% head(1)
# to consider comparing
# abilities
# id
# location_area_encounters
# moves
# stats
# types
# height
# weight
# shape

# base_stat_name = "hp,attack,defense,special-attack,special-defense,speed",
pokedex = data.frame(
  id = character(0),
  name = character(0),
  type_list = character(0),
  ability_list = character(0),
  moveset = character(0),
  stats = character(0),
  base_stats = character(0),
  height = character(0),
  weight = character(0),
  area_encounter = character(0)
)

for (mon in pokemon_uri_list$url) {
  tryCatch({
    response = httr::GET(mon)
    
    sink(
      "refactor/FN_aggregate_pokemon_api_level2_log.txt",
      type = "output",
      append = FALSE
    )
    message(paste0("CODE: ", response$status_code,
                   " : ", response$url))
    
    data = content(response, as = "text") %>% jsl$fromJSON()
    
    to_process = list(
      types = data$types$name,
      abiltiies = data$abilities$ability$name,
      moveset = data$moves$move$name,
      stats = data$stats$base_stat,
      base_stats = data$stats$effort
    )
    
    processed = lapply(to_process, function(col)
      stringify_list(col))
    
    new_record = data.frame(
      id = data$id,
      name = data$name,
      type_list = processed$types,
      ability_list = processed$abiltiies,
      moveset = processed$moveset,
      stats = processed$stats,
      base_stats = processed$base_stats,
      height = data$height,
      weight = data$weight,
      area_encounter = data$location_area_encounters
    )
    
    pokedex = rbind(pokedex, new_record)
    message(paste0("success: added ", data$name, " to pokedex"))
    
    gc()
  }, error = function(e) {
    message(paste0("ERROR processing ", mon))
    message(e)
  })
}

# for (mon in pokemon_uri_list$url) {
#   tryCatch({
#     response = httr::GET(mon)
#   },error = function(e){
#     message(e)
#   }
sink()

print(head(pokedex))