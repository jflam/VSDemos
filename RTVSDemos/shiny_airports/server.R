library(shiny)
library(leaflet)

# This code runs exactly once. So we initialize some global variables
# in our server to hold the airports data.

airports <- read.csv("../airports.dat", header = FALSE)
colnames(airports) <- c("ID", "name", "city", "country", "IATA_FAA", "ICAO", "lat", "lon", "altitude", "timezone", "DST", "Region")

# Generate a sorted list of countries. This demonstrates interesting 
# type conversion list of factors -> list of char -> vector of char

countries <- sort(unlist(lapply(unique(airports$country), as.character)))

shinyServer(function(input, output) {

    # We dynamically generate a listbox control for the client that 
    # contains the list of countries sorted alphabetically

    output$control <- renderUI({
        selectInput("country",
            label = "Select a country",
            choices = countries, 
            selected = "United States"
        )
    })

    # Here, we take the country input parameter as the argument
    # to filter the list for airports from that country

    output$map <- renderLeaflet({
        country_data = subset(airports, country == input$country)

        leaflet(data = country_data) %>%
            addTiles() %>% 
            addCircles( ~ lon, ~ lat, popup = ~name)
    })
})