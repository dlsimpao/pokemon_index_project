setwd("R:/Users/rsimpao/repo=rstudio/pokemon_index_project")

library(conflicted)
library(httr)
library(tidyverse)
library(jsonlite)


jsl <- loadNamespace("jsonlite")

# to do:
# unused # https://pokeapi.co/api/v2/pokemon/{id or name}/encounters

# functions
get_uri_list = function(uri, limit, outfile){
  response = httr::GET(uri, query = list(limit=limit, offset=0))
  print(response)
  data = content(response, as = "text") %>% jsl$fromJSON()
  
  pk_df = as.data.frame(data$results)
  
  # write data frame to csv
  write.csv(pk_df, file=paste0("data/raw/api_",outfile,".csv"), row.names=FALSE)
}

moveapi_config <- list(
  mov=list(uri="https://pokeapi.co/api/v2/move", limit=10000, outfile="moves"),
  ail=list(uri="https://pokeapi.co/api/v2/move-ailment", limit=10000, outfile="move_ailment"),
  bst=list(uri="https://pokeapi.co/api/v2/move-battle-style", limit=10000, outfile="move_battle_style"),
  cat=list(uri="https://pokeapi.co/api/v2/move-category", limit=10000, outfile="move_category"),
  mdc=list(uri="https://pokeapi.co/api/v2/move-damage-class", limit=10000, outfile="move_damage_class"),
  mlm=list(uri="https://pokeapi.co/api/v2/move-learn-method", limit=10000, outfile="move_learn_method"),
  trg=list(uri="https://pokeapi.co/api/v2/move-target", limit=10000, outfile="move_target")
  )

# vector of api request configurations
pokeapi_config <- list(
  mon=list(uri="https://pokeapi.co/api/v2/pokemon", limit=10000, outfile="pokemon"),
  abl=list(uri="https://pokeapi.co/api/v2/ability", limit=1000, outfile="ability"),
  nat=list(uri="https://pokeapi.co/api/v2/nature", limit=25, outfile="nature"),
  cha=list(uri="https://pokeapi.co/api/v2/characteristic", limit=35, outfile="characteristic"),
  egg=list(uri="https://pokeapi.co/api/v2/egg-group",limit=20, outfile="egg_group"),
  geb=list(uri="https://pokeapi.co/api/v2/gender",limit=3, outfile="gender"),
  grt=list(uri="https://pokeapi.co/api/v2/growth-rate",limit=10, outfile="growth_rate"),
  ath=list(uri="https://pokeapi.co/api/v2/pokeathlon-stat",limit=10, outfile="pokeathlon_stat"),
  col=list(uri="https://pokeapi.co/api/v2/pokemon-color",limit=20, outfile="pokecolor"),
  frm=list(uri="https://pokeapi.co/api/v2/pokemon-form",limit=10000, outfile="pokeform"),
  hbt=list(uri="https://pokeapi.co/api/v2/pokemon-habitat",limit=20, outfile="pokehabitat"),
  shp=list(uri="https://pokeapi.co/api/v2/pokemon-shape",limit=50, outfile="pokeshape"),
  sps=list(uri="https://pokeapi.co/api/v2/pokemon-species",limit=10000, outfile="pokespecies"),
  sta=list(uri="https://pokeapi.co/api/v2/stat",limit=10, outfile="stat"),
  typ=list(uri="https://pokeapi.co/api/v2/type",limit=100, outfile="type")
)

# ! to filter use !
pokeapi_config = pokeapi_config[c(1)]
# 
for(item in pokeapi_config){
  get_uri_list(uri = item$uri, limit = item$limit, outfile=item$outfile)
}

# for (item in moveapi_config){
#     get_uri_list(uri = item$uri, limit = item$limit, outfile=item$outfile)
# }

gc()