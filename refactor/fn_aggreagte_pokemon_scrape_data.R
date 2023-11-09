setwd("R:/Users/rsimpao/repo=rstudio/pokemon_index_project")

library(conflicted)
library(tidyverse)
library(rvest)

pokescrape_config <- list(
  mon=list(url="https://pokemondb.net/pokedex/all", outfile="scraped_pokemon"),
  itm=list(url="https://pokemondb.net/item/all", outfile="scraped_item"),
  abl=list(url="https://pokemondb.net/ability", outfile="scraped_ability"),
  mov=list(url="https://pokemondb.net/move/all",outfile="scraped_moves"),
  spr=list(url="https://pokemondb.net/pokedex/national", outfile="scraped_sprite")
)

# web crawl and save data
mon_html <- rvest::read_html(pokescrape_config$mon$url)
scraped_name = mon_html %>% 
  html_nodes("a.ent-name") %>% 
  html_text()

spr_html <- rvest::read_html(pokescrape_config$spr$url)
scraped_sprites = spr_html %>% 
  html_nodes("img.img-fixed.img-sprite") %>% 
  html_attr("src")

scraped_sprite_names = spr_html %>% 
  html_nodes("a.ent-name") %>% 
  html_text()

itm_html <- rvest::read_html(pokescrape_config$itm$url)
scraped_items = itm_html %>% 
  html_table("table.data-table.block-wide", header=TRUE)

abl_html <- rvest::read_html(pokescrape_config$abl$url)
scraped_abilities = abl_html %>% 
  html_table("table#abilities", header=TRUE)

mov_html <- rvest::read_html(pokescrape_config$mov$url)
scraped_moves = mov_html %>% 
  html_table("table#moves", header=TRUE)


# renaming each data source
sc_name = data.frame(scraped_name)

sc_name_w_sprites = data.frame(name=scraped_sprite_names, sprite_path=scraped_sprites)

sc_item = data.frame(scraped_items)

sc_ability = data.frame(scraped_abilities)

sc_moves = data.frame(scraped_moves)

# write each to csv
write.csv(sc_name, file=paste0("data/raw/",pokescrape_config$mon$outfile,".csv"), row.names=FALSE)

write.csv(sc_name_w_sprites, file=paste0("data/raw/",pokescrape_config$spr$outfile,".csv"), row.names=FALSE)

write.csv(sc_item, file=paste0("data/raw/",pokescrape_config$itm$outfile,".csv"), row.names=FALSE)

write.csv(sc_ability, file=paste0("data/raw/",pokescrape_config$abl$outfile,".csv"), row.names=FALSE)

write.csv(sc_moves, file=paste0("data/raw/",pokescrape_config$mov$outfile,".csv"), row.names=FALSE)

gc()