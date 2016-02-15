library(shiny)
library(leaflet)
library(plyr)

# This code runs exactly once. So we initialize some global variables
# in our server to hold the airports data.

airports <- read.csv("../../data/airports.dat", header = FALSE)
colnames(airports) <- c("ID", "name", "city", "country", "IATA_FAA", 
                        "ICAO", "lat", "lon", "altitude", "timezone", 
                        "DST", "Region")

# Generate a sorted list of countries. This demonstrates interesting 
# type conversion list of factors -> list of char -> vector of char

countries <- sort(unlist(lapply(unique(airports$country), as.character)))

# Read data from routes.dat, that contains flight routes for all
# airports. We will use this data to identify busy airports.

routes <- read.csv("../../data/routes.dat", header = FALSE)
colnames(routes) <- c("airline", "airlineID", "sourceAirport", 
                      "sourceAirportID", "destinationAirport", 
                      "destinationAirportID", "codeshare", "stops", 
                      "equipment")

# Extract a count of number of flights departing from an airport and create
# a new data frame, where "nrow" is the name of the column with the flight count

departures <- ddply(routes, .(sourceAirportID), "nrow")

# Rename the column to flights to better represent the semantics of the data

names(departures)[2] <- "departures"

# Merge the departures data set with the original data set that contains that lattitude
# and longitude of airports 

airports_with_departures <- merge(airports, departures, by.x = "ID", by.y = "sourceAirportID")

# Tooltip column contains tooltips for each airport that gives its name (code): departures

airports_with_departures$tooltip <- sprintf("%s (%s): %i",
                                            airports_with_departures$name,
                                            airports_with_departures$IATA_FAA,
                                            airports_with_departures$departures)

# Radius column is the square root of the number of departures

airports_with_departures$radius = sqrt(airports_with_departures$departures)

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
        country_data = subset(airports_with_departures, country == input$country)

        leaflet(data = country_data) %>%
            addTiles() %>%
            addCircleMarkers( ~ lon, ~ lat, popup = ~tooltip, radius = ~radius,
                             stroke = FALSE, fillOpacity = 0.5)
    })
})