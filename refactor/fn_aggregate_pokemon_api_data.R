setwd("R:/Users/rsimpao/repo=rstudio/pokemon_index_project")

library(conflicted)
library(httr)
library(tidyverse)
library(jsonlite)


jsl <- loadNamespace("jsonlite")

# to do:
# unused # https://pokeapi.co/api/v2/pokemon/{id or name}/encounters

# functions
get_uri_list = function(uri, limit, outfile) {
  result <- tryCatch({
    response = httr::GET(uri, query = list(limit = limit, offset = 0))
    data = content(response, as = "text") %>% jsl$fromJSON()
    
    pk_df = as.data.frame(data$results)
    
    # write data frame to csv
    write.csv(pk_df,
              file = paste0("data/raw/api_", outfile, ".csv"),
              row.names = FALSE)
    message(paste0("Success handling ", uri))
  }, error = function(e) {
    message(paste0("Error handling uri ", uri, "\n", e$message))
    return(NA)
  })
}

# vector of api request configurations
berries_config <- list(
  bry=list(uri="https://pokeapi.co/api/v2/berry", limit=100, outfile="berries"),
  frm=list(uri="https://pokeapi.co/api/v2/berry-firmness", limit=100, outfile="berry_firmness"),
  fvr=list(uri="https://pokeapi.co/api/v2/berry-flavor", limit=100, outfile="berry_flavor")
)

contests_config <- list(
  cnt=list(uri="https://pokeapi.co/api/v2/contest-type", limit=100, outfile="contest"),
  eff=list(uri="https://pokeapi.co/api/v2/contest-effect", limit=100, outfile="contest_effect"),
  sef=list(uri="https://pokeapi.co/api/v2/super-contest-effect", limit=100, outfile="contest_super_effect")
)

encounter_config <- list(
  mtd=list(uri="https://pokeapi.co/api/v2/encounter-method", limit = 100, outfile="encounter_method"),
  cnd=list(uri="https://pokeapi.co/api/v2/encounter-condition", limit = 100, outfile="encounter_condition"),
  cnv=list(uri="https://pokeapi.co/api/v2/encounter-condition-value", limit = 100, outfile="encounter_cond_value")
)

evolution_config <- list(
  chn=list(uri="https://pokeapi.co/api/v2/evolution-chain", limit=100, outfile="evolution_chain"),
  trg=list(uri="https://pokeapi.co/api/v2/evolution-trigger", limit=100, outfile="evolution_trigger")
)

games_config <- list(
  gen=list(uri="https://pokeapi.co/api/v2/generation", limit=100, outfile="games_generation"),
  pok=list(uri="https://pokeapi.co/api/v2/pokedex", limit=100, outfile="games_pokedex"),
  ver=list(uri="https://pokeapi.co/api/v2/version", limit=100, outfile="games_version"),
  vgp=list(uri="https://pokeapi.co/api/v2/version-group", limit=100, outfile="games_version_group")
)

items_config <- list(
  itm=list(uri="https://pokeapi.co/api/v2/item", limit=100, outfile="item"),
  atr=list(uri="https://pokeapi.co/api/v2/item-attribute", limit=100, outfile="item_attribute"),
  cat=list(uri="https://pokeapi.co/api/v2/item-category", limit=100, outfile="item_category"),
  fli=list(uri="https://pokeapi.co/api/v2/item-fling-effect", limit=100, outfile="item_fling_effect"),
  pkt=list(uri="https://pokeapi.co/api/v2/item-pocket", limit=100, outfile="item_pocket")
)

locations_config <- list(
  loc=list(uri="https://pokeapi.co/api/v2/location", limit=100, outfile="location"),
  lca=list(uri="https://pokeapi.co/api/v2/location-area", limit=100, outfile="location_area"),
  ppa=list(uri="https://pokeapi.co/api/v2/pal-park-area", limit=100, outfile="location_pal_park_area"),
  reg=list(uri="https://pokeapi.co/api/v2/region", limit=100, outfile="location_region")
)

machines_config <- list(
  mac=list(uri="https://pokeapi.co/api/v2/machine", limit=1000, outfile="machine")
)

moves_config <- list(
  mov=list(uri="https://pokeapi.co/api/v2/move", limit=10000, outfile="moves"),
  ail=list(uri="https://pokeapi.co/api/v2/move-ailment", limit=10000, outfile="move_ailment"),
  bst=list(uri="https://pokeapi.co/api/v2/move-battle-style", limit=10000, outfile="move_battle_style"),
  cat=list(uri="https://pokeapi.co/api/v2/move-category", limit=10000, outfile="move_category"),
  mdc=list(uri="https://pokeapi.co/api/v2/move-damage-class", limit=10000, outfile="move_damage_class"),
  mlm=list(uri="https://pokeapi.co/api/v2/move-learn-method", limit=10000, outfile="move_learn_method"),
  trg=list(uri="https://pokeapi.co/api/v2/move-target", limit=10000, outfile="move_target")
)

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

# for granular execution
# ! to filter use !
# pokeapi_config = pokeapi_config[c(1)]
# 
# for(item in pokeapi_config){
#   get_uri_list(uri = item$uri, limit = item$limit, outfile=item$outfile)
# }
# 


super_config = c(berries_config,
                 contests_config,
                 encounter_config,
                 evolution_config,
                 games_config,
                 items_config,
                 locations_config,
                 machines_config,
                 moves_config,
                 pokeapi_config)

for(item in super_config){
  get_uri_list(uri = item$uri, limit=item$limit, outfile=item$outfile)
  gc()
}