setwd("R:/Users/rsimpao/repo=rstudio/pokemon_index_project")

library(conflicted)
library(httr)
library(tidyverse)
library(jsonlite)

stringify_list <- function(item_list) {
  return(paste(item_list, collapse = ","))
}

# to do
# get sprites (future) as a separate dataframe
# get other ids

jsl <- loadNamespace("jsonlite")

pokemon_uri_list = read_csv("data/raw/api_pokemon.csv", col_types = "c")
pokemon_shape_list = read_csv("data/raw/api_pokeshape.csv", col_types = "c")

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

### schemas ###

# base_stat_name = "hp,attack,defense,special-attack,special-defense,speed",
pokedex = data.frame(
  id = character(0),
  name = character(0),
  type_list = character(0),
  ability_list = character(0),
  moveset = character(0),
  stats = character(0),
  ivs = character(0),
  forms = character(0),
  height = character(0),
  weight = character(0),
  area_encounter = character(0)
) 

pokeshapes = data.frame(
  id = character(0),
  name = character(0),
  pokemon = character(0)
)


sink(
  "refactor/LOG_aggregate_pokemon_api_level2.log",
  append = FALSE
)

### Inserting data ###
# print(paste0("-------------------- POKEDEX --------------------"))
# for (uri in pokemon_uri_list$url) {
# 
#   tryCatch({
#     response = httr::GET(uri)
#     print(paste0("CODE: ", response$status_code,
#                    " : ", response$url))
#     
#     pkm = content(response, as = "text") %>% jsl$fromJSON()
#     
#     to_process = list(
#       types = pkm$types$type$name,
#       abiltiies = pkm$abilities$ability$name,
#       moveset = pkm$moves$move$name,
#       stats = pkm$stats$base_stat,
#       ivs = pkm$stats$effort,
#       forms = pkm$forms$name
#     )
#     
#     processed = lapply(to_process, function(col)
#       stringify_list(col))
#     
#     new_record = data.frame(
#       id = pkm$id,
#       name = pkm$name,
#       type_list = processed$types,
#       ability_list = processed$abiltiies,
#       moveset = processed$moveset,
#       stats = processed$stats,
#       ivs = processed$base_stats,
#       forms = processed$forms,
#       height = pkm$height,
#       weight = pkm$weight,
#       area_encounter = pkm$location_area_encounters
#     )
#     
#     pokedex = rbind(pokedex, new_record)
#     print(paste0("success: added ", pkm$name, " to pokedex"))
#     message(paste0("success: added ", pkm$name, " to pokedex"))
#     gc()
#   }, error = function(e) {
#     print(paste0("ERROR processing ", uri))
#     print(e)
#   })
# }

# print(paste0("-------------------- SHAPES --------------------"))
# 
# for (uri in pokemon_shape_list$url) {
#   tryCatch({
#     response = httr::GET(uri)
#     shp = content(response, as="text") %>% jsl$fromJSON()
# 
#     to_process = list(
#       pokemon = shp$pokemon_species$name
#     )
# 
#     processed = lapply(to_process, function(col)
#       stringify_list(col))
# 
#     new_record = data.frame(
#       id = shp$id,
#       name= shp$name,
#       pokemon = processed$pokemon
#     )
# 
#     pokeshapes = rbind(pokeshapes, new_record)
#     print(paste0("success: added ", shp$name, " to pokeshapes table"))
# 
#     gc()
# 
#   },error = function(e){
#     print(paste0("ERROR processing ", uri))
#     print(e)
#   })
# }


write.csv(pokedex, "data/raw_level_2/pokedex.csv", row.names=FALSE)
# write.csv(pokeshapes, "data/raw_level_2/pokeshapes.csv", row.names=FALSE)

sink()