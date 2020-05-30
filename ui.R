ui <-
  fluidPage(
    theme = shinytheme("united"),

    # test
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "card.css")
    ),

    headerPanel("Poké Battle Matchup"),
    sidebarPanel(
      navbarPage("Trainers:",
        id = "tabs",
        tabPanel(
          "  You  ",
          helpText("Generation VIII not included."),
          textOutput("mytypes"),
          fluidRow(
            column(
              9,
              selectInput(
                "mon", "Pokemon",
                str_to_title(api_mons$name) %>%
                  gsub("-", " ", .), "Pikachu Phd"
              )
            ),
            column(3,
              style = "margin-top: 24px; width: auto",
              actionButton("mongo", "I choose you!")
            )
          ),
          br(),
          br(),

          selectInput("ability", "Ability", ""),
          textOutput("ability-info"),
          br(),

          selectInput("nature", "Nature", c("-", str_to_title(natures)), "-"),
          selectInput("item", "Held Item", c("-", str_to_title(usable_items$Name)), "-"),
          textOutput("item-info"),
          br(),

          helpText("Pokemon can learn at most 4 moves for battle."),
          selectizeInput("moves", "See Learnable Moves", "-",
            multiple = TRUE, options = list(maxItems = 4)
          ),
          actionButton("script", "Generate Pokémon File"),
          helpText(HTML("Generates a text file that stores Pokémon info in a specified format. <br>
                                                   Attributes included: Item, Ability, EVs, Nature, Moves <br>
                                                   (Websites like <a>Pokemon Showdown</a> can import this file.)")),

          br(),
          br(),
          br(),
          br(),

          h2("Effort Values (EVs)", align = "center"),
          helpText("Effort Values help raise your total base stats.", textOutput("ev")),

          sliderInput("hp", "HP", 0, 252, 0, step = 4),
          sliderInput("atk", "Attack", 0, 252, 0, step = 4),
          sliderInput("spatk", "Sp. Attack", 0, 252, 0, step = 4),
          sliderInput("def", "Defense", 0, 252, 0, step = 4),
          sliderInput("spdef", "Sp. Defense", 0, 252, 0, step = 4),
          sliderInput("spd", "Speed", 0, 252, 0, step = 4)
        ),
        tabPanel(
          "Rival",

          helpText("Generation VIII not included."),
          textOutput("opptypes"),
          fluidRow(
            column(
              9,
              selectInput(
                "mon2", "Pokemon",
                str_to_title(api_mons$name) %>%
                  gsub("-", " ", .), "Blissey"
              )
            ),
            column(3,
              style = "margin-top: 24px; width: auto",
              actionButton("mongo2", "I choose you!")
            )
          ),
          br(),
          br(),

          selectInput("ability2", "Ability", ""),
          textOutput("ability-info2"),
          br(),

          selectInput("nature2", "Nature", c("-", str_to_title(natures)), selected = "-"),
          selectInput("item2", "Held Item", c("-", str_to_title(usable_items$Name)), selected = "-"),
          textOutput("item-info2"),
          br(),

          helpText("Pokemon can learn at most 4 moves for battle."),
          selectizeInput("moves2", "See Learnable Moves", "-",
            multiple = TRUE, options = list(maxItems = 4)
          ),
          actionButton("script2", "Generate Pokémon File"),
          helpText(HTML("Generates a text file that stores Pokémon info in a specified format. <br>
                                                   Attributes included: Item, Ability, EVs, Nature, Moves <br>
                                                   (Websites like <a>Pokemon Showdown</a> can import this file.)")),

          br(),
          br(),
          br(),
          br(),


          h2("Effort Values (EVs)", align = "center"),
          helpText("Effort Values help raise your total base stats.", textOutput("ev2")),

          sliderInput("hp2", "HP", 0, 252, 0, step = 4),
          sliderInput("atk2", "Attack", 0, 252, 0, step = 4),
          sliderInput("spatk2", "Sp. Attack", 0, 252, 0, step = 4),
          sliderInput("def2", "Defense", 0, 252, 0, step = 4),
          sliderInput("spdef2", "Sp. Defense", 0, 252, 0, step = 4),
          sliderInput("spd2", "Speed", 0, 252, 0, step = 4)
        )
      )
    ),
    mainPanel(
      navbarPage(
        "",
        tabPanel(
          "Home",
          fluidRow(
            column(
              6,
              div(
                class = "card",
                tags$img(uiOutput("sprite1"), width = "auto")
              )
            ),
            column(
              6,
              div(
                class = "card",
                tags$img(uiOutput("sprite2"), width = "auto")
              )
            )
          ),
          br(),

          div(
            h2(textOutput("table-title"), align = "center"),

            tableOutput("like"),
            align = "center"
          ),
          br(),
          br(),
          br(),



          div(plotlyOutput("fullstats", width = 600, height = 600),
            align = "center",
            tags$i(textOutput("caption"), style = "font-size:25px", align = "center")
          ) # full stats at Lv. 100
        ),
        tabPanel(
          "Gtrends",
          h1("amazing graphs here")
        ),
        tabPanel(
          "About",
          h1("About Pokémon"),
          helpText("Taken from the Official Pokemon Website."),
          p("Pokémon are creatures of all shapes and sizes who live in the wild or alongside humans. 
                                      For the most part, Pokémon do not speak except to utter their names. Pokémon are raised and 
                                      commanded by their owners (called “Trainers”). During their adventures, Pokémon grow and become 
                                      more experienced and even, on occasion, evolve into stronger Pokémon. There are currently more 
                                      than 700 creatures that inhabit the Pokémon universe.", style = "font-size:25px")
        )
      )
    )
  )
