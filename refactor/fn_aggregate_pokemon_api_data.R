setwd("R:/Users/rsimpao/repo=rstudio/pokemon_index_project")

library(conflicted)
library(httr)
library(tidyverse)
library(jsonlite)
library(odbc)


jsl <- loadNamespace("jsonlite")

# functions
get_uri_list = function(uri, limit, outfile){
  response = httr::GET(uri, query = list(limit=limit, offset=0))
  print(response)
  data = content(response, as = "text") %>% jsl$fromJSON()
  
  pk_df = as.data.frame(data$results)
  
  # write data frame to csv
  write.csv(pk_df, file=paste0("api_data/raw/",outfile,".csv"), row.names=FALSE)
}

# https://pokeapi.co/api/v2/pokemon/{id or name}/encounters

# vector of api request configurations
pokeapi_config <- list(
  mon=list(uri="https://pokeapi.co/api/v2/pokemon", limit=1000, outfile="pokemon"),
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

for(item in pokeapi_config){
  get_uri_list(uri = item$uri, limit = item$limit, outfile=item$outfile)
}

gc()