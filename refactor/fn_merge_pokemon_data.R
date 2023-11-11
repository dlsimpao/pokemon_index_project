setwd("R:/Users/rsimpao/repo=rstudio/pokemon_index_project")

library(conflicted)
library(tidyverse)
library(jsonlite)

# to do
# include pokemon area encounters
# 

pokedex = read_csv("data/raw_level_2/pokedex.csv", col_types = cols(.default = "c"))
pokeshapes = read_csv("data/raw_level_2/pokeshapes.csv", col_types = 'c')

# create list from comma separated values
split_mon = strsplit(pokeshapes$pokemon, ",")

# find count per grouping
count_mon = sapply(split_mon, length)


t_pokeshapes = data.frame(
  name = unlist(split_mon),
  id = rep(pokeshapes$id, count_mon),
  shape = rep(pokeshapes$name, count_mon)
)

# processing steps
# add shape info to master pokedex
merged_data = merge(pokedex, t_pokeshapes, by = "name", all.x=TRUE)


# separate values into columns except for moveset
# separate type_list
merged_data = separate(merged_data, "type_list", into = c("type_1","type_2"))

# separate ability_list
merged_data = separate(merged_data, "ability_list", into = c("ability_1","ability_2","ability_3"))

# separate stat list
merged_data = separate(merged_data, "stats", into = c("stat_hp", "stat_atk","stat_def",
                                                      "stat_sp_atk","stat_sp_def","stat_speed"))
# separate iv list
merged_data = separate(merged_data, "ivs", into = c("iv_hp", "iv_atk","iv_def",
                                                      "iv_sp_atk","iv_sp_def","iv_speed"))

merged_pokedata = merged_data %>% 
  select(id.x, name,
         type_1, type_2,
         ability_1, ability_2, ability_3,
         stat_hp, stat_atk, stat_def, stat_sp_atk, stat_sp_def, stat_speed,
         iv_hp, iv_atk, iv_def, iv_sp_atk, iv_sp_def, iv_speed,
         moveset, forms, height, weight, shape) %>% 
  rename(id = id.x)

write.csv(merged_pokedata, "data/processed/pokedex.csv")

gc()