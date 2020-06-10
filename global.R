# packages
packages <- c(
  "shiny", "shinythemes", "shinycssloaders", "shinyWidgets", 
  "tidyverse", "knitr", "ggfortify", "plotly", "FNN", "jsonlite", "lubridate", "httr",
  "rvest", "shinyjs", "gtrendsR"
)

# Inspired by https://github.com/ThiagoValentimMarques/The-ten-most-similar-players-Pro-Evolution-Soccer-2019

package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
  }
})



links <- data.frame(
  api_mon = "https://pokeapi.co/api/v2/pokemon",
  api_nat = "https://pokeapi.co/api/v2/nature",
  db_stats = "https://pokemondb.net/pokedex/all",
  db_spr = "https://pokemondb.net/pokedex/national",
  db_item = "https://pokemondb.net/item/all",
  db_ab = "https://pokemondb.net/ability",
  db_move = "https://pokemondb.net/move/all",
  stringsAsFactors = FALSE
)

# API Requests #
rname <- GET(links$api_mon, query = list(limit = 897))
rnat <- GET(links$api_nat, query = list(limit = 60))

stop_for_status(rname)
stop_for_status(rnat)

jname <- content(rname, as = "text") %>% fromJSON()
jnat <- content(rnat, as = "text") %>% fromJSON()

# df of names and url
api_mons <- as.data.frame(jname$results)

# all mons with hypenated names
hype_names <- api_mons[grepl("-", api_mons$name), ]

# list of natures
natures <- jnat$results$name

# Web Scraping #

# `html`: sprites
html <- read_html(links$db_spr)

# list of sprite pngs
sprites <- html %>%
  html_nodes("span.infocard-lg-img") %>%
  html_nodes(".img-fixed.img-sprite") %>%
  html_attr("data-src")

# names available in the PokeDB
dbnames <- html %>%
  html_nodes("a.ent-name") %>%
  html_text() %>%
  as.data.frame()

# rename columns to 'name'
colnames(dbnames) <- "name"

dbmon_sprites <- tibble(dbnames) %>% mutate(name = str_to_lower(name), sprite = sprites)

# add new sprites png (Nidoran, Mr. Mime, other Megas not matched)
dbsprites <- left_join(api_mons, dbmon_sprites, by = "name") %>%
  select(name, sprite) %>%
  filter(!is.na(sprite))


# More Web Scraping #
html2 <- read_html(links$db_item) # items
html3 <- read_html(links$db_ab) # abilities
html4 <- read_html(links$db_move) # moves
html5 <- read_html(links$db_stats) # stats

# `html2`: items
items <- html2 %>%
  html_nodes("table.data-table.block-wide") %>%
  html_table() %>%
  as.data.frame() %>%
  tibble()

# Table of item information - filtered on usable held items
usable_items <- items %>%
  filter(Category %in% c("Hold items", "Berries")) %>%
  arrange(Category)


# `html3`: abilities
ab_info <- html3 %>%
  html_nodes("table#abilities") %>%
  html_table() %>%
  as.data.frame() %>%
  tibble()

# Table of ability information
ab_info <- ab_info %>%
  select(Name, Description) %>%
  mutate(Name = sub("\\s", "-", .$Name))

# `html4`: attacks
atk_info <- html4 %>%
  html_nodes("table#moves") %>%
  html_table() %>%
  as.data.frame() %>%
  tibble()

# Table of attack information
atk_info <- atk_info %>%
  select(Name, Type, Power, `Acc.`, Effect)
# %>%  mutate(Name = sub(' +','-',.$Name))

# `html5`: stats

dbstats <- html5 %>%
  html_nodes("table#pokedex") %>%
  html_table() %>%
  as.data.frame() %>%
  tibble()

dbstats <- dbstats %>%
  select(`X.`, Name, Total, HP, Attack, Defense, `Sp..Atk`, `Sp..Def`, Speed) %>%
  mutate(Name = str_to_lower(Name))


# Modify dbstats names to match api_mons names
temp <- dbstats %>% mutate(Name = case_when(
  grepl("<U+2640>", Name) ~ gsub("<U+2640>", "-f", Name),
  grepl("<U+2642>", Name) ~ gsub("<U+2642>", "-m", Name),
  grepl("é", Name) ~ gsub("é", "e", Name),
  grepl("(meganium|yanmega)", Name) ~ Name, # <- important potential bug
  grepl("mimikyu", Name) ~ "mimikyu-disguised",
  grepl("(mega charizard )", Name) ~ gsub("(mega charizard )", "-mega-", Name),
  grepl("(mega mewtwo )", Name) ~ gsub("(mega mewtwo )", "-mega-", Name),
  grepl("(mega)", Name) ~ gsub("(mega).*", "-mega", Name),
  grepl("(\\. )", Name) ~ gsub("(. )", "-", Name),
  grepl("(\\: )", Name) ~ gsub("(. )", "-", Name),
  grepl("\\.$", Name) ~ gsub("\\.$", "", Name),
  grepl("( form).*", Name) ~ gsub("( form).*", "", Name),
  grepl(".(mode|cloak|kyogre|groudon|rotom|style|kyurem|size)$", Name) ~
  gsub(".(mode|cloak|kyogre|groudon|rotom|style|kyurem|size)$", "", Name),
  grepl("^hoopa", Name) ~ gsub("^hoopa", "", Name),
  TRUE ~ Name
))

temp <- temp %>% mutate(Name = case_when(
  grepl("(castform)[^-]", Name) ~ gsub("(castform)", "castform-", Name),
  grepl("(kyogre)[^-]", Name) ~ gsub("(kyogre)", "kyogre-", Name),
  grepl("(groudon)[^-]", Name) ~ gsub("(groudon)", "groudon-", Name),
  grepl("(deoxys)[^-]", Name) ~ gsub("(deoxys)", "deoxys-", Name),
  grepl("(wormadam)[^-]", Name) ~ gsub("(wormadam)", "wormadam-", Name),
  grepl("(rotom)[^-]", Name) ~ gsub("(rotom)", "rotom-", Name),
  grepl("(giratina)[^-]", Name) ~ gsub("(giratina)", "giratina-", Name),
  grepl("(basculin)[^-]", Name) ~ gsub("(basculin)", "basculin-", Name),
  grepl("(darmanitan)[^-]", Name) ~ gsub("(darmanitan)", "darmanitan-", Name),
  grepl("(tornadus)[^-]", Name) ~ gsub("(tornadus)", "tornadus-", Name),
  grepl("(landorus)[^-]", Name) ~ gsub("(landorus)", "landorus-", Name),
  grepl("(thundurus)[^-]", Name) ~ gsub("(thundurus)", "thundurus-", Name),
  grepl("(kyurem)[^-]", Name) ~ gsub("(kyurem)", "kyurem-", Name),
  grepl("(meloetta)[^-]", Name) ~ gsub("(meloetta)", "meloetta-", Name),
  grepl("(aegislash)[^-]", Name) ~ gsub("(aegislash)", "aegislash-", Name),
  grepl("(oricorio)[^-]", Name) ~ gsub("(oricorio)", "oricorio-", Name),
  grepl("(shaymin)[^-]", Name) ~ gsub("(shaymin)", "shaymin-", Name),
  grepl("(keldeo)[^-]", Name) ~ gsub("(keldeo)", "keldeo-", Name),
  grepl("(lycanroc)[^-]", Name) ~ gsub("(lycanroc)", "lycanroc-", Name),
  grepl("(wishiwashi)[^-]", Name) ~ gsub("(wishiwashi)", "wishiwashi-", Name),
  grepl("(gourgeist)[^-]", Name) ~ gsub("(gourgeist)", "gourgeist-", Name),
  grepl("(pumpkaboo)[^-]", Name) ~ gsub("(pumpkaboo)", "pumpkaboo-", Name),
  grepl("(meowstic)[^-]", Name) ~ gsub("(meowstic)", "meowstic-", Name),
  grepl("(indeedee)[^-]", Name) ~ gsub("(indeedee)", "indeedee-", Name),
  grepl("(minior)[^-]", Name) ~ gsub("(minior)", "minior-red-", Name),
  grepl(".(confined)", Name) ~ gsub(".(confined)", "", Name),
  grepl("(complete|ultra-necrozma)", Name) ~ gsub("(complete|ultra-necrozma)", "", Name),
  grepl("\\s", Name) ~ gsub("\\s", "-", Name),
  grepl(".{2}%", Name) ~ gsub(".{2}%", "", Name),
  grepl("'", Name) ~ gsub("'", "", Name),
  TRUE ~ Name
))

# LEFT JOIN with api_mons; Table of stats info
stat_info <- left_join(api_mons, temp, by = c("name" = "Name")) %>%
  select(name, Total, HP, Attack, Defense, `Sp..Atk`, `Sp..Def`, Speed) %>%
  drop_na()
