library(shiny)
library(leaflet)

shinyUI(fluidPage(
    titlePanel("Airport Browser by Country"),

    sidebarLayout(
        sidebarPanel(
            helpText("Visualize airports within a country"),

            # The "control" control is generated on the server and inserted
            # here into the UI

            uiOutput("control")
        ),
        mainPanel(

            # This is where the generated map lives

            leafletOutput("map")
        )
    )
))